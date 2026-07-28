import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:share_plus/share_plus.dart' as platform_share;
import 'package:uuid/uuid.dart';

import '../../core/models.dart';
import 'minddeck_snapshot_codec.dart';
import 'snapshot_models.dart';

/// Platform boundary used by [MindDeckSharingService].
abstract interface class MindDeckShareGateway {
  Future<void> shareLink(Uri link, String deckTitle);

  Future<void> shareFile(Uint8List bytes, String fileName, String deckTitle);

  Future<bool> saveFile(Uint8List bytes, String suggestedName);

  Future<Uint8List?> pickFile({required int maximumBytes});
}

class PlatformMindDeckShareGateway implements MindDeckShareGateway {
  const PlatformMindDeckShareGateway();

  static const _mindDeckType = XTypeGroup(
    label: 'MindDeck deck',
    extensions: ['minddeck'],
    mimeTypes: ['application/vnd.minddeck'],
    uniformTypeIdentifiers: ['app.minddeck.snapshot'],
  );

  @override
  Future<void> shareLink(Uri link, String deckTitle) async {
    await platform_share.SharePlus.instance.share(
      platform_share.ShareParams(
        text: link.toString(),
        subject: 'Study “$deckTitle” with MindDeck',
      ),
    );
  }

  @override
  Future<void> shareFile(
    Uint8List bytes,
    String fileName,
    String deckTitle,
  ) async {
    final file = XFile.fromData(
      bytes,
      mimeType: 'application/vnd.minddeck',
      name: fileName,
    );
    await platform_share.SharePlus.instance.share(
      platform_share.ShareParams(
        files: [file],
        fileNameOverrides: [fileName],
        subject: 'Study “$deckTitle” with MindDeck',
      ),
    );
  }

  @override
  Future<bool> saveFile(Uint8List bytes, String suggestedName) async {
    final location = await getSaveLocation(
      acceptedTypeGroups: const [_mindDeckType],
      suggestedName: suggestedName,
      confirmButtonText: 'Save deck',
    );
    if (location == null) {
      return false;
    }
    await XFile.fromData(
      bytes,
      mimeType: 'application/vnd.minddeck',
      name: suggestedName,
    ).saveTo(location.path);
    return true;
  }

  @override
  Future<Uint8List?> pickFile({required int maximumBytes}) async {
    final file = await openFile(
      acceptedTypeGroups: const [_mindDeckType],
      confirmButtonText: 'Preview deck',
    );
    if (file == null) {
      return null;
    }
    final length = await file.length();
    if (length > maximumBytes) {
      throw const MindDeckSnapshotException(
        MindDeckSnapshotErrorCode.payloadTooLarge,
        'This MindDeck file is too large.',
      );
    }
    return file.readAsBytes();
  }
}

/// Prepares, shares, and previews snapshots without ever writing deck data.
class MindDeckSharingService {
  MindDeckSharingService({
    this.codec = const MindDeckSnapshotCodec(),
    this.gateway = const PlatformMindDeckShareGateway(),
    this.uuid = const Uuid(),
  });

  final MindDeckSnapshotCodec codec;
  final MindDeckShareGateway gateway;
  final Uuid uuid;

  MindDeckSharePayload prepareShare({
    required Deck deck,
    required Uri linkBaseUri,
  }) {
    final metadata = codec.metadataFor(deck);
    final link = codec.encodeLink(deck, linkBaseUri);
    if (link.toString().length <= MindDeckSnapshotCodec.maximumLinkLength) {
      return MindDeckSharePayload.link(link: link, metadata: metadata);
    }
    return MindDeckSharePayload.file(
      fileBytes: codec.encodeFile(deck),
      fileName: fileNameFor(deck.title),
      metadata: metadata,
    );
  }

  Future<void> share(Deck deck, MindDeckSharePayload payload) async {
    switch (payload.kind) {
      case MindDeckShareKind.link:
        await gateway.shareLink(payload.link!, deck.title);
      case MindDeckShareKind.file:
        await gateway.shareFile(
          Uint8List.fromList(payload.fileBytes!),
          payload.fileName!,
          deck.title,
        );
    }
  }

  Future<bool> saveAsFile(Deck deck) {
    return gateway.saveFile(codec.encodeFile(deck), fileNameFor(deck.title));
  }

  DecodedMindDeckSnapshot previewLink(String linkOrFragment) {
    return codec.decodeLink(linkOrFragment);
  }

  DecodedMindDeckSnapshot previewFile(List<int> bytes) {
    return codec.decodeFile(bytes);
  }

  Future<DecodedMindDeckSnapshot?> pickFileForPreview() async {
    final bytes = await gateway.pickFile(
      maximumBytes: MindDeckSnapshotCodec.maximumEnvelopeBytes,
    );
    return bytes == null ? null : codec.decodeFile(bytes);
  }

  ExactDuplicateMatch? findExactDuplicate(
    SnapshotMetadata incoming,
    Map<String, ImportedSnapshotMetadata> metadataByDeckId,
  ) {
    for (final entry in metadataByDeckId.entries) {
      if (entry.value.digest == incoming.digest) {
        return ExactDuplicateMatch(
          existingDeckId: entry.key,
          metadata: entry.value,
        );
      }
    }
    return null;
  }

  /// Creates new local IDs so an import never establishes a live relationship
  /// with its source. Call this only after explicit user confirmation.
  MindDeckImportCandidate createImportCandidate(
    DecodedMindDeckSnapshot snapshot,
  ) {
    return MindDeckImportCandidate(
      deck: Deck(
        id: uuid.v4(),
        title: snapshot.deck.title,
        studyBothDirections: snapshot.deck.studyBothDirections,
        cards: snapshot.deck.cards
            .map(
              (card) =>
                  MindCard(id: uuid.v4(), front: card.front, back: card.back),
            )
            .toList(growable: false),
      ),
      source: ImportedSnapshotMetadata.fromSnapshot(snapshot.metadata),
    );
  }

  String fileNameFor(String title) {
    final safe = title
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');
    return '${safe.isEmpty ? 'minddeck-deck' : safe}.minddeck';
  }
}
