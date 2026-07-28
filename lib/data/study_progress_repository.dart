import 'package:drift/drift.dart';

import '../core/models.dart';
import '../features/study/study_engine.dart';
import 'app_database.dart';

class StudyProgressRepository {
  const StudyProgressRepository(this._database);

  final AppDatabase _database;

  Future<List<StudyCardProgress>> loadForDeck(String deckId) async {
    final cards = await (_database.select(
      _database.cardRows,
    )..where((card) => card.deckId.equals(deckId))).get();
    if (cards.isEmpty) return const [];

    final cardIds = cards.map((card) => card.id).toList();
    final rows = await (_database.select(
      _database.cardProgressRows,
    )..where((progress) => progress.cardId.isIn(cardIds))).get();

    return [
      for (final row in rows)
        StudyCardProgress(
          item: StudyItem(
            cardId: row.cardId,
            direction: StudyDirection.values.byName(row.direction),
          ),
          successfulReviews: row.consecutiveCorrect,
          totalReviews: row.totalCorrect + row.totalWrong,
          wrongReviews: row.totalWrong,
          lastAnswerWasCorrect: row.lastReviewedAt == null
              ? null
              : !row.needsRecovery,
          lastReviewedAt: row.lastReviewedAt,
          dueAt: row.dueAt,
        ),
    ];
  }

  Future<void> saveSnapshot(StudySessionSnapshot snapshot) async {
    await _database.transaction(() async {
      for (final progress in snapshot.progress.values) {
        final card =
            await (_database.select(_database.cardRows)
                  ..where((row) => row.id.equals(progress.item.cardId)))
                .getSingleOrNull();
        if (card == null) continue;

        await _database
            .into(_database.cardProgressRows)
            .insertOnConflictUpdate(
              CardProgressRowsCompanion.insert(
                cardId: progress.item.cardId,
                direction: progress.item.direction.name,
                contentRevision: card.contentRevision,
                consecutiveCorrect: Value(progress.successfulReviews),
                lapseCount: Value(progress.wrongReviews),
                totalCorrect: Value(
                  progress.totalReviews - progress.wrongReviews,
                ),
                totalWrong: Value(progress.wrongReviews),
                dueAt: Value(progress.dueAt),
                lastReviewedAt: Value(progress.lastReviewedAt),
                needsRecovery: Value(progress.lastAnswerWasCorrect == false),
              ),
            );
      }
    });
  }
}
