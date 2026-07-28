import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/design/minddeck_theme.dart';
import 'package:minddeck/features/study/study_engine.dart';
import 'package:minddeck/features/study/study_screen.dart';

void main() {
  const deck = Deck(
    id: 'spanish',
    title: 'Spanish basics',
    cards: <MindCard>[
      MindCard(id: 'hola', front: 'Hola', back: 'Hello'),
      MindCard(id: 'adios', front: 'Adiós', back: 'Goodbye'),
    ],
  );
  final now = DateTime.utc(2026, 7, 29, 12);

  Widget app({
    Deck studyDeck = deck,
    ValueChanged<StudySessionSnapshot>? onSnapshotChanged,
    VoidCallback? onDone,
  }) {
    return MaterialApp(
      theme: MindDeckTheme.light(),
      home: StudyScreen(
        deck: studyDeck,
        now: () => now,
        randomSeed: 12,
        onSnapshotChanged: onSnapshotChanged,
        onDone: onDone,
      ),
    );
  }

  testWidgets('a card starts face-down and reveals before grading', (
    tester,
  ) async {
    await tester.pumpWidget(app());

    expect(find.byKey(const Key('reveal-hint')), findsOneWidget);
    expect(find.byKey(const Key('grade-controls')), findsNothing);
    expect(find.textContaining('Tap to reveal'), findsOneWidget);

    await tester.tap(find.byKey(const Key('study-card')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('reveal-hint')), findsNothing);
    expect(find.byKey(const Key('grade-controls')), findsOneWidget);
    expect(find.byKey(const Key('correct-button')), findsOneWidget);
    expect(find.byKey(const Key('wrong-button')), findsOneWidget);
  });

  testWidgets('correct button grades and advances to the next card', (
    tester,
  ) async {
    final snapshots = <StudySessionSnapshot>[];
    await tester.pumpWidget(app(onSnapshotChanged: snapshots.add));
    final firstFront = find
        .descendant(
          of: find.byKey(const Key('study-card')),
          matching: find.byType(Text),
        )
        .evaluate()
        .map((element) => (element.widget as Text).data)
        .whereType<String>()
        .first;

    await tester.tap(find.byKey(const Key('study-card')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('correct-button')));
    await tester.pumpAndSettle();

    expect(snapshots, hasLength(1));
    expect(snapshots.single.session.answers.single.correct, isTrue);
    expect(find.byKey(const Key('reveal-hint')), findsOneWidget);
    expect(
      find.text(firstFront),
      findsNothing,
      reason: 'The next card should be showing after grading.',
    );
  });

  testWidgets('a revealed card can be graded correct with a right swipe', (
    tester,
  ) async {
    final snapshots = <StudySessionSnapshot>[];
    await tester.pumpWidget(app(onSnapshotChanged: snapshots.add));
    await tester.tap(find.byKey(const Key('study-card')));
    await tester.pumpAndSettle();

    await tester.drag(
      find.byKey(const Key('study-card')),
      const Offset(130, 0),
    );
    await tester.pumpAndSettle();

    expect(snapshots, hasLength(1));
    expect(snapshots.single.session.answers.single.correct, isTrue);
  });

  testWidgets('keyboard reveal and grading lead to the missed-card summary', (
    tester,
  ) async {
    const oneCardDeck = Deck(
      id: 'single',
      title: 'Single card',
      cards: <MindCard>[MindCard(id: 'hola', front: 'Hola', back: 'Hello')],
    );
    var doneCalled = false;
    await tester.pumpWidget(
      app(studyDeck: oneCardDeck, onDone: () => doneCalled = true),
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.space);
    await tester.pump();
    expect(find.byKey(const Key('grade-controls')), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(find.byKey(const Key('reveal-hint')), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('session-summary')), findsOneWidget);
    expect(find.text('Nice work!'), findsOneWidget);
    expect(find.text('Review these cards'), findsOneWidget);
    expect(find.byKey(const Key('correct-count')), findsOneWidget);
    expect(find.byKey(const Key('review-count')), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('missed-hola:frontToBack')),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const Key('done-button')));
    expect(doneCalled, isTrue);
  });
}
