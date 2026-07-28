import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/data/app_database.dart';
import 'package:minddeck/data/deck_repository.dart';

void main() {
  late AppDatabase database;
  late DeckRepository repository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    repository = DeckRepository(database);
  });

  tearDown(() => database.close());

  test('saves ordered cards and preserves deck settings', () async {
    const deck = Deck(
      id: 'deck-1',
      title: 'Spanish Basics',
      studyBothDirections: true,
      cards: [
        MindCard(id: 'card-1', front: 'Hola', back: 'Hello'),
        MindCard(id: 'card-2', front: 'Adiós', back: 'Goodbye'),
      ],
    );

    await repository.saveDeck(deck);
    final stored = await repository.getDeck(deck.id);

    expect(stored?.title, 'Spanish Basics');
    expect(stored?.studyBothDirections, isTrue);
    expect(
      stored?.cards.map((card) => card.front),
      orderedEquals(['Hola', 'Adiós']),
    );
  });

  test('editing card content resets its learning progress', () async {
    const original = Deck(
      id: 'deck-1',
      title: 'Spanish Basics',
      cards: [MindCard(id: 'card-1', front: 'Hola', back: 'Hello')],
    );
    await repository.saveDeck(original);
    await database
        .into(database.cardProgressRows)
        .insert(
          CardProgressRowsCompanion.insert(
            cardId: 'card-1',
            direction: 'frontToBack',
            contentRevision: 1,
          ),
        );

    await repository.saveDeck(
      original.copyWith(
        cards: const [MindCard(id: 'card-1', front: 'Hola', back: 'Hello!')],
      ),
    );

    expect(await database.select(database.cardProgressRows).get(), isEmpty);
  });

  test('import creates independent deck and card identifiers', () async {
    const source = Deck(
      id: 'source-deck',
      title: 'Spanish Basics',
      cards: [MindCard(id: 'source-card', front: 'Hola', back: 'Hello')],
    );

    final imported = await repository.importDeck(source);

    expect(imported.id, isNot(source.id));
    expect(imported.cards.single.id, isNot(source.cards.single.id));
    expect(imported.cards.single.front, source.cards.single.front);
  });
}
