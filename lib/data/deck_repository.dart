import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../core/models.dart';
import 'app_database.dart';

class DeckRepository {
  DeckRepository(this._database, {this.uuidFactory = const Uuid()});

  final AppDatabase _database;
  final Uuid uuidFactory;

  Stream<List<Deck>> watchDecks() {
    final query = _database.select(_database.deckRows)
      ..orderBy([(deck) => OrderingTerm.desc(deck.updatedAt)]);

    return query.watch().asyncMap((rows) async {
      final decks = <Deck>[];
      for (final row in rows) {
        decks.add(await _deckFromRow(row));
      }
      return decks;
    });
  }

  Future<List<Deck>> getDecks() async {
    final rows = await (_database.select(
      _database.deckRows,
    )..orderBy([(deck) => OrderingTerm.desc(deck.updatedAt)])).get();
    return Future.wait(rows.map(_deckFromRow));
  }

  Future<Deck?> getDeck(String id) async {
    final row = await (_database.select(
      _database.deckRows,
    )..where((deck) => deck.id.equals(id))).getSingleOrNull();
    return row == null ? null : _deckFromRow(row);
  }

  Future<Deck> createDeck({
    required String title,
    bool studyBothDirections = false,
  }) async {
    final normalizedTitle = title.trim();
    if (normalizedTitle.isEmpty) {
      throw const FormatException('A deck title is required.');
    }

    final now = DateTime.now();
    final deck = Deck(
      id: uuidFactory.v4(),
      title: normalizedTitle,
      cards: const [],
      studyBothDirections: studyBothDirections,
    );

    await _database
        .into(_database.deckRows)
        .insert(
          DeckRowsCompanion.insert(
            id: deck.id,
            title: deck.title,
            studyBothDirections: Value(deck.studyBothDirections),
            createdAt: now,
            updatedAt: now,
          ),
        );
    return deck;
  }

  Future<void> saveDeck(Deck deck) async {
    final normalizedTitle = deck.title.trim();
    if (normalizedTitle.isEmpty) {
      throw const FormatException('A deck title is required.');
    }

    final now = DateTime.now();
    await _database.transaction(() async {
      final existingCards = await (_database.select(
        _database.cardRows,
      )..where((card) => card.deckId.equals(deck.id))).get();
      final existingById = {for (final card in existingCards) card.id: card};
      final incomingIds = deck.cards.map((card) => card.id).toSet();

      await _database
          .into(_database.deckRows)
          .insertOnConflictUpdate(
            DeckRowsCompanion.insert(
              id: deck.id,
              title: normalizedTitle,
              studyBothDirections: Value(deck.studyBothDirections),
              createdAt: now,
              updatedAt: now,
            ),
          );

      for (var index = 0; index < deck.cards.length; index++) {
        final card = deck.cards[index];
        final front = card.front.trim();
        final back = card.back.trim();
        if (front.isEmpty || back.isEmpty) {
          throw const FormatException('Every card needs a front and a back.');
        }

        final existing = existingById[card.id];
        final contentChanged =
            existing != null &&
            (existing.front != front || existing.back != back);
        final revision = existing == null
            ? 1
            : existing.contentRevision + (contentChanged ? 1 : 0);

        await _database
            .into(_database.cardRows)
            .insertOnConflictUpdate(
              CardRowsCompanion.insert(
                id: card.id,
                deckId: deck.id,
                front: front,
                back: back,
                sortIndex: index,
                contentRevision: Value(revision),
                createdAt: existing?.createdAt ?? now,
                updatedAt: now,
              ),
            );

        if (contentChanged) {
          await (_database.delete(
            _database.cardProgressRows,
          )..where((progress) => progress.cardId.equals(card.id))).go();
        }
      }

      for (final existing in existingCards) {
        if (!incomingIds.contains(existing.id)) {
          await (_database.delete(
            _database.cardRows,
          )..where((card) => card.id.equals(existing.id))).go();
        }
      }
    });
  }

  Future<void> deleteDeck(String id) {
    return (_database.delete(
      _database.deckRows,
    )..where((deck) => deck.id.equals(id))).go();
  }

  Future<Deck> importDeck(Deck deck) async {
    final imported = Deck(
      id: uuidFactory.v4(),
      title: deck.title.trim(),
      studyBothDirections: deck.studyBothDirections,
      cards: [
        for (final card in deck.cards)
          MindCard(id: uuidFactory.v4(), front: card.front, back: card.back),
      ],
    );
    await saveDeck(imported);
    return imported;
  }

  Future<Deck> _deckFromRow(DeckRow row) async {
    final cardRows =
        await (_database.select(_database.cardRows)
              ..where((card) => card.deckId.equals(row.id))
              ..orderBy([(card) => OrderingTerm.asc(card.sortIndex)]))
            .get();
    return Deck(
      id: row.id,
      title: row.title,
      studyBothDirections: row.studyBothDirections,
      cards: [
        for (final card in cardRows)
          MindCard(id: card.id, front: card.front, back: card.back),
      ],
    );
  }
}
