import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';

import '../../core/models.dart';
import 'snapshot_models.dart';

/// Encodes and validates the complete, backend-free MindDeck interchange format.
///
/// Link fragments use `md1.<decoded-size>.<sha256>.<gzip-base64url>`.
/// Files use an `MDK1` binary header followed by the same deterministic gzip
/// payload. Both envelopes authenticate the canonical JSON with SHA-256.
class MindDeckSnapshotCodec {
  const MindDeckSnapshotCodec();

  static const int schemaVersion = 1;
  static const String linkEnvelope = 'md1';
  static const String fileMagic = 'MDK1';

  static const int maximumLinkLength = 7500;
  static const int maximumEnvelopeBytes = 4 * 1024 * 1024;
  static const int maximumDecodedBytes = 2 * 1024 * 1024;
  static const int maximumCards = 5000;
  static const int maximumTitleCharacters = 200;
  static const int maximumCardSideCharacters = 20000;
  static const int maximumTotalTextCharacters = 1500000;

  static const int _fileHeaderLength = 45;
  static const int _gzipFlag = 1;

  Uint8List encodeCanonicalJson(Deck deck) {
    _validateDeck(deck);
    final document = <String, Object>{
      'schema': 'minddeck',
      'version': schemaVersion,
      'deck': <String, Object>{
        'id': deck.id,
        'title': deck.title,
        'studyBothDirections': deck.studyBothDirections,
        'cards': deck.cards
            .map(
              (card) => <String, String>{
                'id': card.id,
                'front': card.front,
                'back': card.back,
              },
            )
            .toList(growable: false),
      },
    };
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(document)));
    if (bytes.length > maximumDecodedBytes) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This deck is too large to share.',
      );
    }
    return bytes;
  }

  String encodeLinkFragment(Deck deck) {
    final canonicalBytes = encodeCanonicalJson(deck);
    final digestBytes = _digest(canonicalBytes);
    final compressed = _gzip(canonicalBytes);
    return '$linkEnvelope.${canonicalBytes.length}.'
        '${_base64Url(digestBytes)}.${_base64Url(compressed)}';
  }

  Uri encodeLink(Deck deck, Uri baseUri) {
    return baseUri.replace(fragment: encodeLinkFragment(deck));
  }

  Uint8List encodeFile(Deck deck) {
    final canonicalBytes = encodeCanonicalJson(deck);
    final compressed = _gzip(canonicalBytes);
    final digestBytes = _digest(canonicalBytes);
    final output = BytesBuilder(copy: false)
      ..add(ascii.encode(fileMagic))
      ..addByte(_gzipFlag)
      ..add(_uint32(canonicalBytes.length))
      ..add(_uint32(compressed.length))
      ..add(digestBytes)
      ..add(compressed);
    final fileBytes = output.takeBytes();
    if (fileBytes.length > maximumEnvelopeBytes) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This deck is too large to share.',
      );
    }
    return fileBytes;
  }

  DecodedMindDeckSnapshot decodeLink(String linkOrFragment) {
    var fragment = linkOrFragment.trim();
    final hashIndex = fragment.indexOf('#');
    if (hashIndex >= 0) {
      fragment = fragment.substring(hashIndex + 1);
    }
    if (fragment.length > maximumEnvelopeBytes * 2) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This shared link is too large.',
      );
    }

    final parts = fragment.split('.');
    if (parts.isEmpty || parts.first != linkEnvelope) {
      if (parts.isNotEmpty && parts.first.startsWith('md')) {
        throw const MindDeckSnapshotException(
          MindDeckSnapshotErrorCode.unsupportedVersion,
          'This link was created by an unsupported MindDeck version.',
        );
      }
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'This is not a MindDeck share link.',
      );
    }
    if (parts.length != 4) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'The MindDeck share link is incomplete.',
      );
    }

    final declaredSize = int.tryParse(parts[1]);
    if (declaredSize == null || declaredSize < 0) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'The MindDeck share link has an invalid size.',
      );
    }
    _checkDeclaredDecodedSize(declaredSize);

    final expectedDigest = _decodeBase64(parts[2], digest: true);
    final compressed = _decodeBase64(parts[3]);
    _checkEnvelopeSize(compressed.length);
    return _decodePayload(
      compressed: compressed,
      expectedDigest: expectedDigest,
      declaredSize: declaredSize,
    );
  }

  DecodedMindDeckSnapshot decodeFile(List<int> input) {
    if (input.length > maximumEnvelopeBytes) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This MindDeck file is too large.',
      );
    }
    if (input.length < _fileHeaderLength) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'This MindDeck file is incomplete.',
      );
    }

    final bytes = Uint8List.fromList(input);
    final magic = ascii.decode(bytes.sublist(0, 4), allowInvalid: true);
    if (magic != fileMagic) {
      if (magic.startsWith('MDK')) {
        throw const MindDeckSnapshotException(
          MindDeckSnapshotErrorCode.unsupportedVersion,
          'This file was created by an unsupported MindDeck version.',
        );
      }
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'This is not a MindDeck file.',
      );
    }
    if (bytes[4] != _gzipFlag) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.unsupportedVersion,
        'This MindDeck file uses an unsupported compression format.',
      );
    }

    final declaredSize = _readUint32(bytes, 5);
    final compressedSize = _readUint32(bytes, 9);
    _checkDeclaredDecodedSize(declaredSize);
    if (compressedSize != bytes.length - _fileHeaderLength) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'The MindDeck file has been truncated or altered.',
      );
    }

    return _decodePayload(
      compressed: bytes.sublist(_fileHeaderLength),
      expectedDigest: bytes.sublist(13, 45),
      declaredSize: declaredSize,
    );
  }

  SnapshotMetadata metadataFor(Deck deck) {
    final canonicalBytes = encodeCanonicalJson(deck);
    return SnapshotMetadata(
      schemaVersion: schemaVersion,
      digest: _hex(_digest(canonicalBytes)),
      sourceDeckId: deck.id,
      cardCount: deck.cards.length,
      decodedByteCount: canonicalBytes.length,
    );
  }

  DecodedMindDeckSnapshot _decodePayload({
    required Uint8List compressed,
    required Uint8List expectedDigest,
    required int declaredSize,
  }) {
    if (expectedDigest.length != 32) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'The MindDeck payload has an invalid checksum.',
      );
    }

    if (compressed.length < 18) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.corruptPayload,
        'The shared deck is damaged and could not be opened.',
      );
    }
    final gzipDeclaredSize = ByteData.sublistView(
      compressed,
      compressed.length - 4,
    ).getUint32(0, Endian.little);
    if (gzipDeclaredSize != declaredSize) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.corruptPayload,
        'The shared deck size does not match its contents.',
      );
    }

    late final Uint8List decoded;
    try {
      final output = _CappedOutputMemoryStream(declaredSize);
      GZipDecoderWeb().decodeStream(
        InputMemoryStream(compressed),
        output,
        verify: true,
      );
      decoded = Uint8List.fromList(output.getBytes());
    } on _DecodedSizeLimitExceeded {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This shared deck expands beyond its declared safe size.',
      );
    } on Object {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.corruptPayload,
        'The shared deck is damaged and could not be opened.',
      );
    }
    if (decoded.length != declaredSize) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.corruptPayload,
        'The shared deck size does not match its contents.',
      );
    }
    _checkDeclaredDecodedSize(decoded.length);

    final actualDigest = _digest(decoded);
    if (!_constantTimeEquals(expectedDigest, actualDigest)) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.corruptPayload,
        'The shared deck has been altered or damaged.',
      );
    }

    final deck = _parseCanonicalJson(decoded);
    final canonicalAgain = encodeCanonicalJson(deck);
    if (!_constantTimeEquals(decoded, canonicalAgain)) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.nonCanonicalPayload,
        'The shared deck is not in canonical MindDeck format.',
      );
    }
    return DecodedMindDeckSnapshot(
      deck: deck,
      metadata: SnapshotMetadata(
        schemaVersion: schemaVersion,
        digest: _hex(actualDigest),
        sourceDeckId: deck.id,
        cardCount: deck.cards.length,
        decodedByteCount: decoded.length,
      ),
    );
  }

  Deck _parseCanonicalJson(Uint8List bytes) {
    late final Object? decoded;
    try {
      decoded = jsonDecode(utf8.decode(bytes));
    } on Object {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.invalidPayload,
        'The shared deck contains invalid data.',
      );
    }
    if (decoded is! Map<String, dynamic>) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.invalidPayload,
        'The shared deck has an invalid document.',
      );
    }
    if (decoded['schema'] != 'minddeck') {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.invalidPayload,
        'The shared file is not a MindDeck snapshot.',
      );
    }
    final version = decoded['version'];
    if (version != schemaVersion) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.unsupportedVersion,
        'This deck was created by an unsupported MindDeck version.',
      );
    }

    final deckJson = decoded['deck'];
    if (deckJson is! Map<String, dynamic>) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.invalidPayload,
        'The shared deck is missing its content.',
      );
    }
    final id = deckJson['id'];
    final title = deckJson['title'];
    final studyBothDirections = deckJson['studyBothDirections'];
    final cardsJson = deckJson['cards'];
    if (id is! String ||
        title is! String ||
        studyBothDirections is! bool ||
        cardsJson is! List) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.invalidPayload,
        'The shared deck contains invalid fields.',
      );
    }
    if (cardsJson.length > maximumCards) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This deck contains too many cards.',
      );
    }

    final cards = <MindCard>[];
    for (final cardJson in cardsJson) {
      if (cardJson is! Map<String, dynamic>) {
        throw const MindDeckSnapshotException(
          MindDeckSnapshotErrorCode.invalidPayload,
          'The shared deck contains an invalid card.',
        );
      }
      final cardId = cardJson['id'];
      final front = cardJson['front'];
      final back = cardJson['back'];
      if (cardId is! String || front is! String || back is! String) {
        throw const MindDeckSnapshotException(
          MindDeckSnapshotErrorCode.invalidPayload,
          'The shared deck contains an invalid card.',
        );
      }
      cards.add(MindCard(id: cardId, front: front, back: back));
    }

    final deck = Deck(
      id: id,
      title: title,
      cards: List.unmodifiable(cards),
      studyBothDirections: studyBothDirections,
    );
    _validateDeck(deck);
    return deck;
  }

  void _validateDeck(Deck deck) {
    if (!_validIdentifier(deck.id)) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.invalidPayload,
        'The deck has an invalid identifier.',
      );
    }
    if (deck.title.trim().isEmpty ||
        deck.title.runes.length > maximumTitleCharacters) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.invalidPayload,
        'The deck title is empty or too long.',
      );
    }
    if (deck.cards.length > maximumCards) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This deck contains too many cards.',
      );
    }

    var totalCharacters = deck.title.runes.length;
    final ids = <String>{};
    for (final card in deck.cards) {
      if (!_validIdentifier(card.id) || !ids.add(card.id)) {
        throw const MindDeckSnapshotException(
          MindDeckSnapshotErrorCode.invalidPayload,
          'The deck contains an invalid or duplicate card identifier.',
        );
      }
      final frontLength = card.front.runes.length;
      final backLength = card.back.runes.length;
      if (card.front.trim().isEmpty ||
          card.back.trim().isEmpty ||
          frontLength > maximumCardSideCharacters ||
          backLength > maximumCardSideCharacters) {
        throw const MindDeckSnapshotException(
          MindDeckSnapshotErrorCode.invalidPayload,
          'A card side is empty or too long.',
        );
      }
      totalCharacters += frontLength + backLength;
      if (totalCharacters > maximumTotalTextCharacters) {
        throw const MindDeckSnapshotException(
          MindDeckSnapshotErrorCode.payloadTooLarge,
          'This deck contains too much text to share.',
        );
      }
    }
  }

  bool _validIdentifier(String value) {
    return value.isNotEmpty && value.length <= 128 && !value.contains('\u0000');
  }

  Uint8List _gzip(Uint8List input) {
    final compressed = GZipEncoder().encodeBytes(input, level: 6);
    // RFC 1952 bytes 4 through 7 are MTIME. Keeping them at zero ensures
    // identical content produces identical envelopes on every platform.
    if (compressed.length >= 10) {
      compressed.setRange(4, 8, const [0, 0, 0, 0]);
    }
    return compressed;
  }

  Uint8List _digest(List<int> input) {
    return Uint8List.fromList(sha256.convert(input).bytes);
  }

  Uint8List _decodeBase64(String value, {bool digest = false}) {
    if (value.isEmpty ||
        !RegExp(r'^[A-Za-z0-9_-]+$').hasMatch(value) ||
        (digest && value.length != 43)) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'The MindDeck payload contains invalid encoding.',
      );
    }
    try {
      return Uint8List.fromList(base64Url.decode(base64Url.normalize(value)));
    } on Object {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.malformedEnvelope,
        'The MindDeck payload contains invalid encoding.',
      );
    }
  }

  String _base64Url(List<int> input) {
    return base64Url.encode(input).replaceAll('=', '');
  }

  Uint8List _uint32(int value) {
    final data = ByteData(4)..setUint32(0, value, Endian.big);
    return data.buffer.asUint8List();
  }

  int _readUint32(Uint8List input, int offset) {
    return ByteData.sublistView(
      input,
      offset,
      offset + 4,
    ).getUint32(0, Endian.big);
  }

  void _checkDeclaredDecodedSize(int size) {
    if (size > maximumDecodedBytes) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This shared deck is too large to open safely.',
      );
    }
  }

  void _checkEnvelopeSize(int size) {
    if (size > maximumEnvelopeBytes) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This shared deck is too large to open safely.',
      );
    }
  }

  bool _constantTimeEquals(List<int> left, List<int> right) {
    if (left.length != right.length) {
      return false;
    }
    var difference = 0;
    for (var index = 0; index < left.length; index++) {
      difference |= left[index] ^ right[index];
    }
    return difference == 0;
  }

  String _hex(List<int> bytes) {
    final buffer = StringBuffer();
    for (final byte in bytes) {
      buffer.write(byte.toRadixString(16).padLeft(2, '0'));
    }
    return buffer.toString();
  }
}

class _DecodedSizeLimitExceeded implements Exception {
  const _DecodedSizeLimitExceeded();
}

class _CappedOutputMemoryStream extends OutputMemoryStream {
  _CappedOutputMemoryStream(this.maximumLength);

  final int maximumLength;

  void _checkAdditionalLength(int additionalLength) {
    if (length + additionalLength > maximumLength) {
      throw const _DecodedSizeLimitExceeded();
    }
  }

  @override
  void writeByte(int value) {
    _checkAdditionalLength(1);
    super.writeByte(value);
  }

  @override
  void writeBytes(List<int> bytes, {int? length}) {
    final writeLength = length ?? bytes.length;
    _checkAdditionalLength(writeLength);
    super.writeBytes(bytes, length: writeLength);
  }

  @override
  void writeStream(InputStream stream) {
    _checkAdditionalLength(stream.length);
    super.writeStream(stream);
  }
}
