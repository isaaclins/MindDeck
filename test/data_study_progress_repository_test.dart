import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/data/app_database.dart';
import 'package:minddeck/data/deck_repository.dart';
import 'package:minddeck/data/study_progress_repository.dart';
import 'package:minddeck/features/study/study_engine.dart';

void main() {
  late AppDatabase database;
  late DeckRepository deckRepository;
  late StudyProgressRepository progressRepository;

  setUp(() {
    database = AppDatabase(NativeDatabase.memory());
    deckRepository = DeckRepository(database);
    progressRepository = StudyProgressRepository(database);
  });

  tearDown(() => database.close());

  test('round trips progress independently for each direction', () async {
    const deck = Deck(
      id: 'deck-1',
      title: 'Spanish',
      studyBothDirections: true,
      cards: [MindCard(id: 'card-1', front: 'Hola', back: 'Hello')],
    );
    await deckRepository.saveDeck(deck);

    final reviewedAt = DateTime.utc(2026, 7, 29, 12);
    final snapshot = StudySessionSnapshot(
      session: StudySessionState(
        deckId: deck.id,
        startedAt: reviewedAt,
        initialItemCount: 1,
        pendingItems: const [],
      ),
      progress: {
        'card-1:frontToBack': StudyCardProgress(
          item: const StudyItem(
            cardId: 'card-1',
            direction: StudyDirection.frontToBack,
          ),
          successfulReviews: 2,
          totalReviews: 3,
          wrongReviews: 1,
          lastAnswerWasCorrect: true,
          lastReviewedAt: reviewedAt,
          dueAt: reviewedAt.add(const Duration(days: 3)),
        ),
        'card-1:backToFront': StudyCardProgress(
          item: const StudyItem(
            cardId: 'card-1',
            direction: StudyDirection.backToFront,
          ),
          totalReviews: 1,
          wrongReviews: 1,
          lastAnswerWasCorrect: false,
          lastReviewedAt: reviewedAt,
          dueAt: reviewedAt,
        ),
      },
    );

    await progressRepository.saveSnapshot(snapshot);
    final stored = await progressRepository.loadForDeck(deck.id);

    expect(stored, hasLength(2));
    final forward = stored.singleWhere(
      (progress) => progress.item.direction == StudyDirection.frontToBack,
    );
    final reverse = stored.singleWhere(
      (progress) => progress.item.direction == StudyDirection.backToFront,
    );
    expect(forward.successfulReviews, 2);
    expect(forward.wrongReviews, 1);
    expect(forward.lastAnswerWasCorrect, isTrue);
    expect(reverse.lastAnswerWasCorrect, isFalse);
  });
}
