import 'package:flutter_test/flutter_test.dart';
import 'package:minddeck/core/models.dart';
import 'package:minddeck/features/study/study_engine.dart';

void main() {
  final now = DateTime.utc(2026, 7, 29, 12);

  Deck deckWithCards(int count, {bool bothDirections = false}) {
    return Deck(
      id: 'deck',
      title: 'Deck',
      studyBothDirections: bothDirections,
      cards: List<MindCard>.generate(
        count,
        (index) => MindCard(
          id: 'card-$index',
          front: 'Front $index',
          back: 'Back $index',
        ),
      ),
    );
  }

  StudyCardProgress progressFor(
    String cardId, {
    StudyDirection direction = StudyDirection.frontToBack,
    int successfulReviews = 1,
    int totalReviews = 1,
    int wrongReviews = 0,
    bool? lastAnswerWasCorrect = true,
    DateTime? dueAt,
  }) {
    return StudyCardProgress(
      item: StudyItem(cardId: cardId, direction: direction),
      successfulReviews: successfulReviews,
      totalReviews: totalReviews,
      wrongReviews: wrongReviews,
      lastAnswerWasCorrect: lastAnswerWasCorrect,
      lastReviewedAt: now.subtract(const Duration(days: 1)),
      dueAt: dueAt,
    );
  }

  group('StudyScheduler selection', () {
    test(
      'prioritizes previous mistakes, then due cards, then unseen cards',
      () {
        final deck = deckWithCards(5);
        final progress = <StudyCardProgress>[
          progressFor(
            'card-0',
            lastAnswerWasCorrect: false,
            dueAt: now.add(const Duration(days: 8)),
          ),
          progressFor(
            'card-1',
            dueAt: now.subtract(const Duration(minutes: 1)),
          ),
          progressFor('card-2', dueAt: now.add(const Duration(days: 2))),
        ];

        final snapshot = const StudyScheduler().startSession(
          deck: deck,
          progress: progress,
          now: now,
          randomSeed: 42,
        );

        expect(
          snapshot.session.pendingItems.map((item) => item.cardId),
          <String>['card-0', 'card-1', 'card-3', 'card-4'],
        );
      },
    );

    test('caps a session at twenty items', () {
      final snapshot = const StudyScheduler().startSession(
        deck: deckWithCards(30),
        progress: const <StudyCardProgress>[],
        now: now,
      );

      expect(snapshot.session.initialItemCount, 20);
      expect(snapshot.session.pendingItems, hasLength(20));
    });

    test('creates independent items for both study directions', () {
      final snapshot = const StudyScheduler().startSession(
        deck: deckWithCards(2, bothDirections: true),
        progress: const <StudyCardProgress>[],
        now: now,
      );

      expect(snapshot.session.pendingItems, hasLength(4));
      expect(
        snapshot.session.pendingItems
            .where((item) => item.direction == StudyDirection.frontToBack)
            .length,
        2,
      );
      expect(
        snapshot.session.pendingItems
            .where((item) => item.direction == StudyDirection.backToFront)
            .length,
        2,
      );
    });

    test('excludes seen cards that are not due', () {
      final snapshot = const StudyScheduler().startSession(
        deck: deckWithCards(1),
        progress: <StudyCardProgress>[
          progressFor('card-0', dueAt: now.add(const Duration(days: 1))),
        ],
        now: now,
      );

      expect(snapshot.session.isComplete, isTrue);
    });

    test('uses a stable seed-based order', () {
      final scheduler = const StudyScheduler();
      final first = scheduler.startSession(
        deck: deckWithCards(10),
        progress: const <StudyCardProgress>[],
        now: now,
        randomSeed: 812,
      );
      final second = scheduler.startSession(
        deck: deckWithCards(10),
        progress: const <StudyCardProgress>[],
        now: now,
        randomSeed: 812,
      );

      expect(first.session.pendingItems, second.session.pendingItems);
    });
  });

  group('Study progress', () {
    test('uses the complete correct-answer interval sequence', () {
      var progress = const StudyCardProgress(
        item: StudyItem(cardId: 'card', direction: StudyDirection.frontToBack),
      );

      for (var index = 0; index < studyIntervalsInDays.length; index++) {
        progress = progress.recordAnswer(correct: true, answeredAt: now);
        expect(
          progress.dueAt,
          now.add(Duration(days: studyIntervalsInDays[index])),
        );
      }

      progress = progress.recordAnswer(correct: true, answeredAt: now);
      expect(progress.dueAt, now.add(const Duration(days: 120)));
    });

    test('a wrong answer resets the interval and remains due', () {
      final progress = progressFor(
        'card-0',
        successfulReviews: 5,
        dueAt: now,
      ).recordAnswer(correct: false, answeredAt: now);

      expect(progress.successfulReviews, 0);
      expect(progress.lastAnswerWasCorrect, isFalse);
      expect(progress.dueAt, now);

      final corrected = progress.recordAnswer(correct: true, answeredAt: now);
      expect(corrected.dueAt, now.add(const Duration(days: 1)));
    });

    test('tracks progress separately by direction', () {
      final scheduler = const StudyScheduler();
      final started = scheduler.startSession(
        deck: deckWithCards(1, bothDirections: true),
        progress: const <StudyCardProgress>[],
        now: now,
      );
      final firstDirection = started.session.currentItem!;
      final answered = scheduler.recordAnswer(
        snapshot: started,
        correct: true,
        answeredAt: now,
      );

      expect(answered.progress[firstDirection.key]!.totalReviews, 1);
      final otherDirection = answered.session.currentItem!;
      expect(answered.progress[otherDirection.key], isNull);
    });
  });

  group('Study session behavior', () {
    test('wrong items return after three intervening presentations', () {
      const scheduler = StudyScheduler();
      var snapshot = scheduler.startSession(
        deck: deckWithCards(5),
        progress: const <StudyCardProgress>[],
        now: now,
        randomSeed: 7,
      );
      final missedItem = snapshot.session.currentItem!;

      snapshot = scheduler.recordAnswer(
        snapshot: snapshot,
        correct: false,
        answeredAt: now,
      );

      expect(snapshot.session.pendingItems[3], missedItem);
      for (var index = 0; index < 3; index++) {
        expect(snapshot.session.currentItem, isNot(missedItem));
        snapshot = scheduler.recordAnswer(
          snapshot: snapshot,
          correct: true,
          answeredAt: now,
        );
      }
      expect(snapshot.session.currentItem, missedItem);
    });

    test(
      'wrong items return after all remaining items when fewer than three',
      () {
        const scheduler = StudyScheduler();
        var snapshot = scheduler.startSession(
          deck: deckWithCards(2),
          progress: const <StudyCardProgress>[],
          now: now,
        );
        final missedItem = snapshot.session.currentItem!;

        snapshot = scheduler.recordAnswer(
          snapshot: snapshot,
          correct: false,
          answeredAt: now,
        );

        expect(snapshot.session.pendingItems.last, missedItem);
      },
    );

    test('summary counts first-attempt outcomes and unique missed items', () {
      const scheduler = StudyScheduler();
      var snapshot = scheduler.startSession(
        deck: deckWithCards(2),
        progress: const <StudyCardProgress>[],
        now: now,
      );
      final missed = snapshot.session.currentItem!;
      snapshot = scheduler.recordAnswer(
        snapshot: snapshot,
        correct: false,
        answeredAt: now,
      );
      snapshot = scheduler.recordAnswer(
        snapshot: snapshot,
        correct: true,
        answeredAt: now,
      );
      snapshot = scheduler.recordAnswer(
        snapshot: snapshot,
        correct: true,
        answeredAt: now,
      );

      expect(snapshot.session.isComplete, isTrue);
      expect(snapshot.session.firstTryCorrectCount, 1);
      expect(snapshot.session.missedItems, <StudyItem>[missed]);
    });

    test('a snapshot round trip resumes the exact queue and progress', () {
      const scheduler = StudyScheduler();
      var snapshot = scheduler.startSession(
        deck: deckWithCards(4),
        progress: const <StudyCardProgress>[],
        now: now,
        randomSeed: 18,
      );
      snapshot = scheduler.recordAnswer(
        snapshot: snapshot,
        correct: false,
        answeredAt: now,
      );

      final restored = StudySessionSnapshot.fromJson(snapshot.toJson());

      expect(restored.session.pendingItems, snapshot.session.pendingItems);
      expect(restored.session.answers.single.correct, isFalse);
      expect(restored.progress.keys, snapshot.progress.keys);
      expect(
        restored.progress.values.single.dueAt,
        snapshot.progress.values.single.dueAt,
      );
    });
  });
}
