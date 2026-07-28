import 'dart:async';

import 'package:flutter/foundation.dart';

import '../core/models.dart';
import '../core/sample_data.dart';
import '../data/app_database.dart';
import '../data/deck_repository.dart';
import '../data/study_progress_repository.dart';
import '../features/decks/decks_controller.dart';
import '../features/study/study_engine.dart';
import '../platform/widgets/widgets.dart';

class PersistentDecksStore extends ChangeNotifier {
  PersistentDecksStore._({
    required this._database,
    required this._repository,
    required this._studyProgressRepository,
    required this.controller,
  }) {
    controller.addListener(_handleDecksChanged);
  }

  final AppDatabase _database;
  final DeckRepository _repository;
  final StudyProgressRepository _studyProgressRepository;
  final DecksController controller;
  Future<void> _pendingSave = Future.value();
  Set<String> _persistedIds = const {};
  Map<String, DeckStudyStats> _statsByDeckId = const {};
  Object? _lastSaveError;
  bool _isDisposed = false;

  Object? get lastSaveError => _lastSaveError;

  DeckStudyStats statsForDeck(Deck deck) {
    return _statsByDeckId[deck.id] ??
        DeckStudyStats(
          dueCount: deck.cards.length,
          studiedCount: 0,
          totalCount: deck.cards.length,
        );
  }

  static Future<PersistentDecksStore> open() async {
    final database = AppDatabase();
    final repository = DeckRepository(database);
    final studyProgressRepository = StudyProgressRepository(database);
    var decks = await repository.getDecks();

    if (decks.isEmpty) {
      for (final deck in sampleDecks) {
        await repository.saveDeck(deck);
      }
      decks = await repository.getDecks();
    }

    final store = PersistentDecksStore._(
      database: database,
      repository: repository,
      studyProgressRepository: studyProgressRepository,
      controller: DecksController(initialDecks: decks),
    );
    store._persistedIds = decks.map((deck) => deck.id).toSet();
    await store._refreshProgressSurfaces();
    return store;
  }

  Future<Deck> importDeck(Deck deck) async {
    final imported = await _repository.importDeck(deck);
    controller.addDeck(imported);
    await _refreshProgressSurfaces();
    return imported;
  }

  Future<List<StudyCardProgress>> loadStudyProgress(String deckId) {
    return _studyProgressRepository.loadForDeck(deckId);
  }

  Future<void> saveStudySnapshot(StudySessionSnapshot snapshot) async {
    await _studyProgressRepository.saveSnapshot(snapshot);
    await _refreshProgressSurfaces();
  }

  Future<void> flush() => _pendingSave;

  void _handleDecksChanged() {
    final snapshot = List<Deck>.of(controller.decks);
    _pendingSave = _pendingSave.then((_) => _persist(snapshot)).onError((
      error,
      stackTrace,
    ) {
      _lastSaveError = error;
      _notifyIfActive();
    });
  }

  Future<void> _persist(List<Deck> decks) async {
    final currentIds = decks.map((deck) => deck.id).toSet();
    for (final deletedId in _persistedIds.difference(currentIds)) {
      await _repository.deleteDeck(deletedId);
    }
    for (final deck in decks) {
      await _repository.saveDeck(deck);
    }
    _persistedIds = currentIds;
    _lastSaveError = null;
    await _refreshProgressSurfaces(decks);
  }

  Future<void> _refreshProgressSurfaces([List<Deck>? deckSnapshot]) async {
    final decks = deckSnapshot ?? List<Deck>.of(controller.decks);
    final candidates = <({Deck deck, int dueCount, String prompt})>[];
    final refreshedStats = <String, DeckStudyStats>{};
    final now = DateTime.now();

    for (final deck in decks) {
      final progress = await _studyProgressRepository.loadForDeck(deck.id);
      final progressByKey = {for (final item in progress) item.item.key: item};
      var dueCount = 0;
      var studiedCount = 0;
      String? prompt;

      for (final card in deck.cards) {
        final directions = deck.studyBothDirections
            ? StudyDirection.values
            : const [StudyDirection.frontToBack];
        for (final direction in directions) {
          final item = StudyItem(cardId: card.id, direction: direction);
          final cardProgress = progressByKey[item.key];
          if (cardProgress != null && !cardProgress.isUnseen) {
            studiedCount++;
          }
          final isDue =
              cardProgress == null ||
              cardProgress.isUnseen ||
              cardProgress.lastAnswerWasCorrect == false ||
              cardProgress.isDueAt(now);
          if (!isDue) continue;

          dueCount++;
          prompt ??= direction == StudyDirection.frontToBack
              ? card.front
              : card.back;
        }
      }

      refreshedStats[deck.id] = DeckStudyStats(
        dueCount: dueCount,
        studiedCount: studiedCount,
        totalCount: deck.cards.length * (deck.studyBothDirections ? 2 : 1),
      );
      if (deck.cards.isNotEmpty) {
        candidates.add((
          deck: deck,
          dueCount: dueCount,
          prompt: prompt ?? deck.cards.first.front,
        ));
      }
    }

    _statsByDeckId = refreshedStats;
    _notifyIfActive();

    if (!MindDeckWidgetBridge.isSupported) return;
    if (candidates.isEmpty) {
      await MindDeckWidgetBridge.clear();
      return;
    }

    candidates.sort((left, right) {
      final byDue = right.dueCount.compareTo(left.dueCount);
      if (byDue != 0) return byDue;
      return left.deck.title.compareTo(right.deck.title);
    });
    final selected = candidates.first;
    await MindDeckWidgetBridge.update(
      MindDeckWidgetSnapshot(
        deckId: selected.deck.id,
        deckTitle: selected.deck.title,
        dueCardCount: selected.dueCount,
        samplePrompt: selected.prompt,
      ),
    );
  }

  @override
  void dispose() {
    _isDisposed = true;
    controller.removeListener(_handleDecksChanged);
    controller.dispose();
    unawaited(_pendingSave.whenComplete(_database.close));
    super.dispose();
  }

  void _notifyIfActive() {
    if (!_isDisposed) notifyListeners();
  }
}
