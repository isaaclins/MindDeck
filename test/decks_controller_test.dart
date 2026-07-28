import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/features/decks/decks_controller.dart';

void main() {
  const deck = Deck(
    id: 'languages',
    title: 'Languages',
    cards: [
      MindCard(id: 'one', front: 'Hola', back: 'Hello'),
      MindCard(id: 'two', front: 'Adiós', back: 'Goodbye'),
    ],
  );

  test('supports the complete local deck editing flow', () {
    final controller = DecksController(initialDecks: const [deck]);
    var notifications = 0;
    controller.addListener(() => notifications += 1);

    controller.renameDeck(deck.id, 'Spanish basics');
    controller.setStudyBothDirections(deck.id, true);
    final newCard = controller.addCard(
      deckId: deck.id,
      front: 'Gracias',
      back: 'Thank you',
    );
    controller.updateCard(
      deckId: deck.id,
      cardId: newCard.id,
      front: 'Muchas gracias',
      back: 'Thank you very much',
    );

    final updatedDeck = controller.deckById(deck.id)!;
    expect(updatedDeck.title, 'Spanish basics');
    expect(updatedDeck.studyBothDirections, isTrue);
    expect(updatedDeck.cards.last.front, 'Muchas gracias');
    expect(notifications, 4);
  });

  test('reorders and removes cards', () {
    final controller = DecksController(initialDecks: const [deck]);

    controller.reorderCard(deckId: deck.id, oldIndex: 0, newIndex: 2);
    expect(controller.deckById(deck.id)!.cards.map((card) => card.id), [
      'two',
      'one',
    ]);

    controller.deleteCard(deckId: deck.id, cardId: 'two');
    expect(controller.deckById(deck.id)!.cards.single.id, 'one');
  });

  test('adds an imported deck and notifies persistence listeners', () {
    final controller = DecksController();
    var notifications = 0;
    controller.addListener(() => notifications += 1);

    controller.addDeck(deck);

    expect(controller.decks, [deck]);
    expect(notifications, 1);
  });
}
