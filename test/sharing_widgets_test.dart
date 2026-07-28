import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/design/minddeck_theme.dart';
import 'package:minddeck/features/sharing/sharing.dart';

void main() {
  const deck = Deck(
    id: 'shared-deck',
    title: 'Spanish basics',
    studyBothDirections: true,
    cards: [
      MindCard(id: 'one', front: 'Hola', back: 'Hello'),
      MindCard(id: 'two', front: 'Gracias', back: 'Thank you'),
    ],
  );
  final codec = const MindDeckSnapshotCodec();
  final snapshot = codec.decodeFile(codec.encodeFile(deck));

  testWidgets('import preview writes nothing before explicit confirmation', (
    tester,
  ) async {
    var importCount = 0;
    DecodedMindDeckSnapshot? confirmedSnapshot;

    await tester.pumpWidget(
      MaterialApp(
        theme: MindDeckTheme.light(),
        home: ImportPreviewScreen(
          snapshot: snapshot,
          onImport: (value) {
            importCount++;
            confirmedSnapshot = value;
          },
        ),
      ),
    );

    expect(find.text('Spanish basics'), findsOneWidget);
    expect(find.text('2 cards · both directions'), findsOneWidget);
    expect(importCount, 0);
    expect(confirmedSnapshot, isNull);

    await tester.ensureVisible(find.byKey(const Key('confirm-import-button')));
    await tester.tap(find.byKey(const Key('confirm-import-button')));
    await tester.pump();

    expect(importCount, 1);
    expect(confirmedSnapshot, same(snapshot));
  });

  testWidgets('duplicate preview warns and still requires confirmation', (
    tester,
  ) async {
    var importCount = 0;
    final duplicate = ExactDuplicateMatch(
      existingDeckId: 'local-copy',
      metadata: ImportedSnapshotMetadata.fromSnapshot(snapshot.metadata),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: MindDeckTheme.light(),
        home: ImportPreviewScreen(
          snapshot: snapshot,
          duplicate: duplicate,
          onImport: (_) => importCount++,
        ),
      ),
    );

    expect(find.byKey(const Key('duplicate-snapshot-warning')), findsOneWidget);
    expect(importCount, 0);

    await tester.ensureVisible(find.byKey(const Key('confirm-import-button')));
    await tester.tap(find.byKey(const Key('confirm-import-button')));
    await tester.pump();
    expect(importCount, 1);
  });

  testWidgets('share screen opens gateway only after tapping share', (
    tester,
  ) async {
    final gateway = _RecordingGateway();
    final service = MindDeckSharingService(gateway: gateway);

    await tester.pumpWidget(
      MaterialApp(
        theme: MindDeckTheme.light(),
        home: ShareDeckScreen(
          deck: deck,
          linkBaseUri: Uri.parse('https://minddeck.app/open'),
          service: service,
        ),
      ),
    );

    expect(gateway.sharedLinks, isEmpty);
    await tester.ensureVisible(find.byKey(const Key('share-deck-button')));
    await tester.tap(find.byKey(const Key('share-deck-button')));
    await tester.pumpAndSettle();

    expect(gateway.sharedLinks, hasLength(1));
    expect(gateway.sharedLinks.single.fragment, startsWith('md1.'));
  });
}

class _RecordingGateway implements MindDeckShareGateway {
  final sharedLinks = <Uri>[];

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
  Future<void> shareLink(Uri link, String deckTitle) async {
    sharedLinks.add(link);
  }
}
