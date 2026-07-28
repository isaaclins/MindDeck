import 'package:flutter/foundation.dart';

import '../../core/models.dart';
import 'study_engine.dart';

typedef StudyNow = DateTime Function();

class StudyController extends ChangeNotifier {
  StudyController({
    required this.deck,
    Iterable<StudyCardProgress> initialProgress = const <StudyCardProgress>[],
    StudySessionSnapshot? restoredSession,
    StudyScheduler scheduler = const StudyScheduler(),
    StudyNow? now,
    int randomSeed = 0,
  }) : _scheduler = scheduler,
       _now = now ?? DateTime.now,
       _snapshot =
           restoredSession ??
           scheduler.startSession(
             deck: deck,
             progress: initialProgress,
             now: (now ?? DateTime.now)(),
             randomSeed: randomSeed,
           ) {
    if (_snapshot.session.deckId != deck.id) {
      throw ArgumentError.value(
        _snapshot.session.deckId,
        'restoredSession',
        'The restored session belongs to a different deck',
      );
    }
  }

  final Deck deck;
  final StudyScheduler _scheduler;
  final StudyNow _now;
  StudySessionSnapshot _snapshot;
  bool _isRevealed = false;
  bool _isGrading = false;

  StudySessionSnapshot get snapshot => _snapshot;
  StudySessionState get session => _snapshot.session;
  Map<String, StudyCardProgress> get progress => _snapshot.progress;
  StudyItem? get currentItem => session.currentItem;
  bool get isRevealed => _isRevealed;
  bool get isGrading => _isGrading;
  bool get isComplete => session.isComplete;

  int get displayPosition {
    if (session.initialItemCount == 0) {
      return 0;
    }
    return (session.uniqueItemsAnswered + 1).clamp(1, session.initialItemCount);
  }

  void reveal() {
    if (isComplete || _isRevealed) {
      return;
    }
    _isRevealed = true;
    notifyListeners();
  }

  void grade({required bool correct}) {
    if (isComplete || !_isRevealed || _isGrading) {
      return;
    }
    _isGrading = true;
    _snapshot = _scheduler.recordAnswer(
      snapshot: _snapshot,
      correct: correct,
      answeredAt: _now(),
    );
    _isRevealed = false;
    _isGrading = false;
    notifyListeners();
  }
}
