import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/design/minddeck_theme.dart';
import 'package:minddeck/features/decks/card_editor_screen.dart';
import 'package:minddeck/features/decks/deck_detail_screen.dart';
import 'package:minddeck/features/decks/deck_library_screen.dart';
import 'package:minddeck/features/decks/decks_controller.dart';

void main() {
  const deck = Deck(
    id: 'spanish',
    title: 'Spanish basics',
    cards: [
      MindCard(id: 'hola', front: 'Hola', back: 'Hello'),
      MindCard(id: 'adios', front: 'Adiós', back: 'Goodbye'),
    ],
  );

  Widget testApp(Widget home) {
    return MaterialApp(theme: MindDeckTheme.light(), home: home);
  }

  testWidgets('library shows a useful empty state and creates a deck', (
    tester,
  ) async {
    final controller = DecksController();
    String? openedDeckId;
    await tester.pumpWidget(
      testApp(
        DeckLibraryScreen(
          controller: controller,
          onOpenDeck: (deckId) => openedDeckId = deckId,
        ),
      ),
    );

    expect(find.text('Your first deck starts here'), findsOneWidget);
    await tester.tap(find.byKey(const Key('empty-create-deck-button')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('new-deck-title-field')),
      'Chemistry',
    );
    await tester.tap(find.byKey(const Key('confirm-new-deck-button')));
    await tester.pumpAndSettle();

    expect(controller.decks.single.title, 'Chemistry');
    expect(openedDeckId, controller.decks.single.id);
  });

  testWidgets('library adapts to desktop and exposes deck details', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = DecksController(initialDecks: const [deck]);
    String? openedDeckId;

    await tester.pumpWidget(
      testApp(
        DeckLibraryScreen(
          controller: controller,
          onOpenDeck: (deckId) => openedDeckId = deckId,
          statsForDeck: (_) =>
              const DeckStudyStats(dueCount: 2, studiedCount: 1, totalCount: 2),
        ),
      ),
    );

    expect(find.text('Spanish basics'), findsOneWidget);
    expect(find.text('2 due'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('deck-tile-spanish')));
    expect(openedDeckId, 'spanish');
  });

  testWidgets('deck detail edits the title and both-directions setting', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(700, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = DecksController(initialDecks: const [deck]);

    await tester.pumpWidget(
      testApp(DeckDetailScreen(controller: controller, deckId: deck.id)),
    );

    final titleField = find.byKey(const Key('deck-title-field'));
    await tester.enterText(titleField, 'Everyday Spanish');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(controller.deckById(deck.id)!.title, 'Everyday Spanish');

    await tester.tap(find.byKey(const Key('both-directions-toggle')));
    await tester.pump();
    expect(controller.deckById(deck.id)!.studyBothDirections, isTrue);
    expect(find.text('Hola'), findsOneWidget);
    expect(find.text('Hello'), findsOneWidget);
  });

  testWidgets('card editor validates and saves both text sides', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(430, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final controller = DecksController(
      initialDecks: const [Deck(id: 'empty', title: 'Empty', cards: [])],
    );
    var closed = false;

    await tester.pumpWidget(
      testApp(
        CardEditorScreen(
          controller: controller,
          deckId: 'empty',
          onClose: () => closed = true,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('save-card-button')));
    await tester.pump();
    expect(find.text('Add some text to this side.'), findsNWidgets(2));

    await tester.enterText(
      find.byKey(const ValueKey('front-card-field')),
      'Hola',
    );
    await tester.enterText(
      find.byKey(const ValueKey('back-card-field')),
      'Hello',
    );
    await tester.tap(find.byKey(const Key('save-card-button')));
    await tester.pump();

    expect(controller.deckById('empty')!.cards.single.front, 'Hola');
    expect(controller.deckById('empty')!.cards.single.back, 'Hello');
    expect(closed, isTrue);
  });
}
