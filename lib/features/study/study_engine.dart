import '../../core/models.dart';

const List<int> studyIntervalsInDays = <int>[1, 3, 7, 14, 30, 60, 120];

class StudyItem {
  const StudyItem({required this.cardId, required this.direction});

  final String cardId;
  final StudyDirection direction;

  String get key => '$cardId:${direction.name}';

  Map<String, Object?> toJson() => <String, Object?>{
    'cardId': cardId,
    'direction': direction.name,
  };

  factory StudyItem.fromJson(Map<String, Object?> json) {
    return StudyItem(
      cardId: json['cardId']! as String,
      direction: StudyDirection.values.byName(json['direction']! as String),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is StudyItem &&
        cardId == other.cardId &&
        direction == other.direction;
  }

  @override
  int get hashCode => Object.hash(cardId, direction);
}

class StudyCardProgress {
  const StudyCardProgress({
    required this.item,
    this.successfulReviews = 0,
    this.totalReviews = 0,
    this.wrongReviews = 0,
    this.lastAnswerWasCorrect,
    this.lastReviewedAt,
    this.dueAt,
  });

  final StudyItem item;
  final int successfulReviews;
  final int totalReviews;
  final int wrongReviews;
  final bool? lastAnswerWasCorrect;
  final DateTime? lastReviewedAt;
  final DateTime? dueAt;

  bool get isUnseen => totalReviews == 0;

  bool isDueAt(DateTime now) {
    final dueDate = dueAt;
    return dueDate != null && !dueDate.isAfter(now);
  }

  StudyCardProgress recordAnswer({
    required bool correct,
    required DateTime answeredAt,
  }) {
    if (!correct) {
      return StudyCardProgress(
        item: item,
        successfulReviews: 0,
        totalReviews: totalReviews + 1,
        wrongReviews: wrongReviews + 1,
        lastAnswerWasCorrect: false,
        lastReviewedAt: answeredAt,
        dueAt: answeredAt,
      );
    }

    final intervalIndex = successfulReviews.clamp(
      0,
      studyIntervalsInDays.length - 1,
    );
    final interval = Duration(days: studyIntervalsInDays[intervalIndex]);
    return StudyCardProgress(
      item: item,
      successfulReviews: (successfulReviews + 1).clamp(
        0,
        studyIntervalsInDays.length,
      ),
      totalReviews: totalReviews + 1,
      wrongReviews: wrongReviews,
      lastAnswerWasCorrect: true,
      lastReviewedAt: answeredAt,
      dueAt: answeredAt.add(interval),
    );
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'item': item.toJson(),
    'successfulReviews': successfulReviews,
    'totalReviews': totalReviews,
    'wrongReviews': wrongReviews,
    'lastAnswerWasCorrect': lastAnswerWasCorrect,
    'lastReviewedAt': lastReviewedAt?.toIso8601String(),
    'dueAt': dueAt?.toIso8601String(),
  };

  factory StudyCardProgress.fromJson(Map<String, Object?> json) {
    return StudyCardProgress(
      item: StudyItem.fromJson(Map<String, Object?>.from(json['item']! as Map)),
      successfulReviews: json['successfulReviews']! as int,
      totalReviews: json['totalReviews']! as int,
      wrongReviews: json['wrongReviews']! as int,
      lastAnswerWasCorrect: json['lastAnswerWasCorrect'] as bool?,
      lastReviewedAt: _dateFromJson(json['lastReviewedAt']),
      dueAt: _dateFromJson(json['dueAt']),
    );
  }
}

class StudyAnswer {
  const StudyAnswer({
    required this.item,
    required this.correct,
    required this.answeredAt,
  });

  final StudyItem item;
  final bool correct;
  final DateTime answeredAt;

  Map<String, Object?> toJson() => <String, Object?>{
    'item': item.toJson(),
    'correct': correct,
    'answeredAt': answeredAt.toIso8601String(),
  };

  factory StudyAnswer.fromJson(Map<String, Object?> json) {
    return StudyAnswer(
      item: StudyItem.fromJson(Map<String, Object?>.from(json['item']! as Map)),
      correct: json['correct']! as bool,
      answeredAt: DateTime.parse(json['answeredAt']! as String),
    );
  }
}

class StudySessionState {
  const StudySessionState({
    required this.deckId,
    required this.startedAt,
    required this.initialItemCount,
    required this.pendingItems,
    this.answers = const <StudyAnswer>[],
  });

  final String deckId;
  final DateTime startedAt;
  final int initialItemCount;
  final List<StudyItem> pendingItems;
  final List<StudyAnswer> answers;

  StudyItem? get currentItem =>
      pendingItems.isEmpty ? null : pendingItems.first;

  bool get isComplete => pendingItems.isEmpty;

  int get uniqueItemsAnswered =>
      answers.map((answer) => answer.item.key).toSet().length;

  int get firstTryCorrectCount {
    final firstAnswers = <String, bool>{};
    for (final answer in answers) {
      firstAnswers.putIfAbsent(answer.item.key, () => answer.correct);
    }
    return firstAnswers.values.where((correct) => correct).length;
  }

  List<StudyItem> get missedItems {
    final missed = <String, StudyItem>{};
    for (final answer in answers) {
      if (!answer.correct) {
        missed.putIfAbsent(answer.item.key, () => answer.item);
      }
    }
    return List<StudyItem>.unmodifiable(missed.values);
  }

  Map<String, Object?> toJson() => <String, Object?>{
    'deckId': deckId,
    'startedAt': startedAt.toIso8601String(),
    'initialItemCount': initialItemCount,
    'pendingItems': pendingItems.map((item) => item.toJson()).toList(),
    'answers': answers.map((answer) => answer.toJson()).toList(),
  };

  factory StudySessionState.fromJson(Map<String, Object?> json) {
    return StudySessionState(
      deckId: json['deckId']! as String,
      startedAt: DateTime.parse(json['startedAt']! as String),
      initialItemCount: json['initialItemCount']! as int,
      pendingItems: (json['pendingItems']! as List)
          .map(
            (item) =>
                StudyItem.fromJson(Map<String, Object?>.from(item as Map)),
          )
          .toList(growable: false),
      answers: (json['answers']! as List)
          .map(
            (answer) =>
                StudyAnswer.fromJson(Map<String, Object?>.from(answer as Map)),
          )
          .toList(growable: false),
    );
  }
}

class StudySessionSnapshot {
  const StudySessionSnapshot({required this.session, required this.progress});

  final StudySessionState session;
  final Map<String, StudyCardProgress> progress;

  Map<String, Object?> toJson() => <String, Object?>{
    'version': 1,
    'session': session.toJson(),
    'progress': progress.values.map((value) => value.toJson()).toList(),
  };

  factory StudySessionSnapshot.fromJson(Map<String, Object?> json) {
    if (json['version'] != 1) {
      throw const FormatException('Unsupported study session version');
    }
    final decodedProgress = (json['progress']! as List)
        .map(
          (value) => StudyCardProgress.fromJson(
            Map<String, Object?>.from(value as Map),
          ),
        )
        .toList(growable: false);
    return StudySessionSnapshot(
      session: StudySessionState.fromJson(
        Map<String, Object?>.from(json['session']! as Map),
      ),
      progress: <String, StudyCardProgress>{
        for (final value in decodedProgress) value.item.key: value,
      },
    );
  }
}

class StudyScheduler {
  const StudyScheduler({this.sessionLimit = 20, this.wrongAnswerSpacing = 3});

  final int sessionLimit;
  final int wrongAnswerSpacing;

  StudySessionSnapshot startSession({
    required Deck deck,
    required Iterable<StudyCardProgress> progress,
    required DateTime now,
    int randomSeed = 0,
  }) {
    final progressByKey = <String, StudyCardProgress>{
      for (final value in progress) value.item.key: value,
    };
    final rankedItems =
        _allItems(deck)
            .map(
              (item) => (
                item: item,
                priority: _priority(progressByKey[item.key], now),
                tieBreaker: _stableShuffleValue(item.key, randomSeed),
              ),
            )
            .where((candidate) => candidate.priority < 3)
            .toList()
          ..sort((left, right) {
            final byPriority = left.priority.compareTo(right.priority);
            if (byPriority != 0) {
              return byPriority;
            }
            final byShuffle = left.tieBreaker.compareTo(right.tieBreaker);
            if (byShuffle != 0) {
              return byShuffle;
            }
            return left.item.key.compareTo(right.item.key);
          });

    final pending = rankedItems
        .take(sessionLimit)
        .map((candidate) => candidate.item)
        .toList(growable: false);
    return StudySessionSnapshot(
      session: StudySessionState(
        deckId: deck.id,
        startedAt: now,
        initialItemCount: pending.length,
        pendingItems: pending,
      ),
      progress: progressByKey,
    );
  }

  StudySessionSnapshot recordAnswer({
    required StudySessionSnapshot snapshot,
    required bool correct,
    required DateTime answeredAt,
  }) {
    final current = snapshot.session.currentItem;
    if (current == null) {
      return snapshot;
    }

    final pending = snapshot.session.pendingItems.skip(1).toList();
    if (!correct) {
      final insertionIndex = wrongAnswerSpacing.clamp(0, pending.length);
      pending.insert(insertionIndex, current);
    }

    final previousProgress =
        snapshot.progress[current.key] ?? StudyCardProgress(item: current);
    final nextProgress = previousProgress.recordAnswer(
      correct: correct,
      answeredAt: answeredAt,
    );
    final nextProgressMap = Map<String, StudyCardProgress>.of(snapshot.progress)
      ..[current.key] = nextProgress;
    return StudySessionSnapshot(
      session: StudySessionState(
        deckId: snapshot.session.deckId,
        startedAt: snapshot.session.startedAt,
        initialItemCount: snapshot.session.initialItemCount,
        pendingItems: List<StudyItem>.unmodifiable(pending),
        answers: <StudyAnswer>[
          ...snapshot.session.answers,
          StudyAnswer(item: current, correct: correct, answeredAt: answeredAt),
        ],
      ),
      progress: Map<String, StudyCardProgress>.unmodifiable(nextProgressMap),
    );
  }

  Iterable<StudyItem> _allItems(Deck deck) sync* {
    for (final card in deck.cards) {
      yield StudyItem(cardId: card.id, direction: StudyDirection.frontToBack);
      if (deck.studyBothDirections) {
        yield StudyItem(cardId: card.id, direction: StudyDirection.backToFront);
      }
    }
  }

  int _priority(StudyCardProgress? progress, DateTime now) {
    if (progress != null && progress.lastAnswerWasCorrect == false) {
      return 0;
    }
    if (progress != null && progress.isDueAt(now)) {
      return 1;
    }
    if (progress == null || progress.isUnseen) {
      return 2;
    }
    return 3;
  }
}

int _stableShuffleValue(String value, int seed) {
  var hash = (2166136261 ^ seed) & 0x7fffffff;
  for (final codeUnit in value.codeUnits) {
    hash ^= codeUnit;
    hash = (hash * 16777619) & 0x7fffffff;
  }
  return hash;
}

DateTime? _dateFromJson(Object? value) {
  return value == null ? null : DateTime.parse(value as String);
}

extension StudyItemCard on StudyItem {
  MindCard resolveCard(Deck deck) {
    return deck.cards.firstWhere(
      (card) => card.id == cardId,
      orElse: () => throw StateError('Card $cardId is not in deck ${deck.id}'),
    );
  }

  String frontText(Deck deck) {
    final card = resolveCard(deck);
    return direction == StudyDirection.frontToBack ? card.front : card.back;
  }

  String backText(Deck deck) {
    final card = resolveCard(deck);
    return direction == StudyDirection.frontToBack ? card.back : card.front;
  }
}
