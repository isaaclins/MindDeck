import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/features/sharing/sharing.dart';

void main() {
  const deck = Deck(
    id: 'source-deck',
    title: 'German',
    cards: [MindCard(id: 'source-card', front: 'Hallo', back: 'Hello')],
  );

  test('small decks share as links and large decks fall back to files', () {
    final service = MindDeckSharingService(gateway: _FakeGateway());
    final small = service.prepareShare(
      deck: deck,
      linkBaseUri: Uri.parse('https://minddeck.app/open'),
    );
    expect(small.kind, MindDeckShareKind.link);
    expect(small.link?.fragment, startsWith('md1.'));

    final large = Deck(
      id: 'large',
      title: 'Large',
      cards: List.generate(
        300,
        (index) => MindCard(
          id: '$index',
          front: 'Front $index ${_noise(index)}',
          back: 'Back $index ${_noise(index + 300)}',
        ),
      ),
    );
    final preparedLarge = service.prepareShare(
      deck: large,
      linkBaseUri: Uri.parse('https://minddeck.app/open'),
    );
    expect(preparedLarge.kind, MindDeckShareKind.file);
    expect(preparedLarge.fileName, 'large.minddeck');
    expect(preparedLarge.fileBytes, isNotEmpty);
  });

  test('import creates an independent copy and retains duplicate metadata', () {
    final service = MindDeckSharingService(gateway: _FakeGateway());
    final codec = const MindDeckSnapshotCodec();
    final snapshot = codec.decodeFile(codec.encodeFile(deck));

    final candidate = service.createImportCandidate(snapshot);

    expect(candidate.deck.id, isNot(deck.id));
    expect(candidate.deck.cards.single.id, isNot(deck.cards.single.id));
    expect(candidate.deck.title, deck.title);
    expect(candidate.deck.cards.single.front, deck.cards.single.front);
    expect(candidate.source.digest, snapshot.metadata.digest);

    final duplicate = service.findExactDuplicate(snapshot.metadata, {
      'local-deck': candidate.source,
    });
    expect(duplicate?.existingDeckId, 'local-deck');
  });
}

String _noise(int seed) {
  var value = seed + 1;
  final output = StringBuffer();
  for (var index = 0; index < 64; index++) {
    value = (value * 1103515245 + 12345) & 0x7fffffff;
    output.writeCharCode(33 + (value % 90));
  }
  return output.toString();
}

class _FakeGateway implements MindDeckShareGateway {
  @override
  Future<Uint8List?> pickFile({required int maximumBytes}) async => null;

  @override
  Future<bool> saveFile(Uint8List bytes, String suggestedName) async => true;

  @override
  Future<void> shareFile(
    Uint8List bytes,
    String fileName,
    String deckTitle,
  ) async {}

  @override
  Future<void> shareLink(Uri link, String deckTitle) async {}
}
