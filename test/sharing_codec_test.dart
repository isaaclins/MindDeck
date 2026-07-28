import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/features/sharing/sharing.dart';

void main() {
  const codec = MindDeckSnapshotCodec();
  const deck = Deck(
    id: 'deck-spanish-basics',
    title: 'Spanish basics',
    studyBothDirections: true,
    cards: [
      MindCard(id: 'hola', front: 'Hola', back: 'Hello'),
      MindCard(id: 'gracias', front: 'Gracias', back: 'Thank you'),
    ],
  );

  group('MindDeckSnapshotCodec', () {
    test('link and file round trips preserve content only', () {
      final fragment = codec.encodeLinkFragment(deck);
      final fromLink = codec.decodeLink('https://minddeck.app/open#$fragment');
      final fromFile = codec.decodeFile(codec.encodeFile(deck));

      for (final snapshot in [fromLink, fromFile]) {
        expect(snapshot.deck.id, deck.id);
        expect(snapshot.deck.title, deck.title);
        expect(snapshot.deck.studyBothDirections, deck.studyBothDirections);
        expect(
          snapshot.deck.cards.map((card) => [card.id, card.front, card.back]),
          deck.cards.map((card) => [card.id, card.front, card.back]),
        );
        expect(snapshot.metadata.digest, hasLength(64));
        expect(snapshot.metadata.cardCount, 2);
      }
      expect(fromLink.metadata.digest, fromFile.metadata.digest);
    });

    test('encoding is deterministic and canonical', () {
      expect(codec.encodeCanonicalJson(deck), codec.encodeCanonicalJson(deck));
      expect(codec.encodeLinkFragment(deck), codec.encodeLinkFragment(deck));
      expect(codec.encodeFile(deck), codec.encodeFile(deck));

      final json = utf8.decode(codec.encodeCanonicalJson(deck));
      expect(
        json,
        '{"schema":"minddeck","version":1,"deck":{"id":'
        '"deck-spanish-basics","title":"Spanish basics",'
        '"studyBothDirections":true,"cards":[{"id":"hola","front":'
        '"Hola","back":"Hello"},{"id":"gracias","front":"Gracias",'
        '"back":"Thank you"}]}}',
      );
    });

    test('detects corruption before returning a preview', () {
      final bytes = codec.encodeFile(deck);
      bytes[bytes.length - 1] ^= 0xff;

      expect(
        () => codec.decodeFile(bytes),
        throwsA(
          isA<MindDeckSnapshotException>().having(
            (error) => error.code,
            'code',
            MindDeckSnapshotErrorCode.corruptPayload,
          ),
        ),
      );
    });

    test('rejects unsupported link and file envelope versions', () {
      expect(
        () => codec.decodeLink('md2.1.A.A'),
        throwsA(
          isA<MindDeckSnapshotException>().having(
            (error) => error.code,
            'code',
            MindDeckSnapshotErrorCode.unsupportedVersion,
          ),
        ),
      );

      final bytes = codec.encodeFile(deck);
      bytes[3] = ascii.encode('2').single;
      expect(
        () => codec.decodeFile(bytes),
        throwsA(
          isA<MindDeckSnapshotException>().having(
            (error) => error.code,
            'code',
            MindDeckSnapshotErrorCode.unsupportedVersion,
          ),
        ),
      );
    });

    test('rejects oversized declared payload before decompression', () {
      final digest = base64Url.encode(Uint8List(32)).replaceAll('=', '');
      final fragment =
          'md1.'
          '${MindDeckSnapshotCodec.maximumDecodedBytes + 1}.'
          '$digest.H4sIAAAAAAAA';

      expect(
        () => codec.decodeLink(fragment),
        throwsA(
          isA<MindDeckSnapshotException>().having(
            (error) => error.code,
            'code',
            MindDeckSnapshotErrorCode.payloadTooLarge,
          ),
        ),
      );
    });

    test('rejects invalid card and text limits on encode', () {
      final longText = List.filled(
        MindDeckSnapshotCodec.maximumCardSideCharacters + 1,
        'a',
      ).join();
      final oversized = Deck(
        id: 'deck',
        title: 'Oversized',
        cards: [MindCard(id: 'card', front: longText, back: 'Answer')],
      );

      expect(
        () => codec.encodeFile(oversized),
        throwsA(
          isA<MindDeckSnapshotException>().having(
            (error) => error.code,
            'code',
            MindDeckSnapshotErrorCode.invalidPayload,
          ),
        ),
      );
    });
  });
}
