import 'dart:collection';

import 'package:flutter/foundation.dart';

import '../../core/models.dart';

/// Owns the in-memory deck editing behavior.
///
/// Persistence can subscribe to [addListener] and write [decks] after each
/// mutation. Keeping storage outside this controller lets every screen remain
/// testable and allows the app shell to choose its local database strategy.
class DecksController extends ChangeNotifier {
  DecksController({Iterable<Deck> initialDecks = const []})
    : _decks = List<Deck>.from(initialDecks);

  final List<Deck> _decks;
  var _nextLocalId = 0;

  UnmodifiableListView<Deck> get decks => UnmodifiableListView(_decks);

  Deck? deckById(String deckId) {
    for (final deck in _decks) {
      if (deck.id == deckId) return deck;
    }
    return null;
  }

  Deck createDeck({String title = 'Untitled deck'}) {
    final cleanedTitle = _cleanRequired(title, fallback: 'Untitled deck');
    final deck = Deck(id: _newId('deck'), title: cleanedTitle, cards: const []);
    _decks.add(deck);
    notifyListeners();
    return deck;
  }

  /// Inserts a deck provided by the local import pipeline.
  void addDeck(Deck deck) {
    _decks.add(deck);
    notifyListeners();
  }

  void deleteDeck(String deckId) {
    final previousLength = _decks.length;
    _decks.removeWhere((deck) => deck.id == deckId);
    if (_decks.length != previousLength) notifyListeners();
  }

  void renameDeck(String deckId, String title) {
    final deckIndex = _indexOfDeck(deckId);
    if (deckIndex == -1) return;
    final cleanedTitle = _cleanRequired(
      title,
      fallback: _decks[deckIndex].title,
    );
    if (_decks[deckIndex].title == cleanedTitle) return;
    _decks[deckIndex] = _decks[deckIndex].copyWith(title: cleanedTitle);
    notifyListeners();
  }

  void setStudyBothDirections(String deckId, bool enabled) {
    final deckIndex = _indexOfDeck(deckId);
    if (deckIndex == -1) return;
    final deck = _decks[deckIndex];
    if (deck.studyBothDirections == enabled) return;
    _decks[deckIndex] = deck.copyWith(studyBothDirections: enabled);
    notifyListeners();
  }

  MindCard addCard({
    required String deckId,
    required String front,
    required String back,
  }) {
    final deckIndex = _requireDeckIndex(deckId);
    final card = MindCard(
      id: _newId('card'),
      front: _cleanRequired(front),
      back: _cleanRequired(back),
    );
    final deck = _decks[deckIndex];
    _decks[deckIndex] = deck.copyWith(cards: [...deck.cards, card]);
    notifyListeners();
    return card;
  }

  void updateCard({
    required String deckId,
    required String cardId,
    required String front,
    required String back,
  }) {
    final deckIndex = _requireDeckIndex(deckId);
    final deck = _decks[deckIndex];
    final cardIndex = deck.cards.indexWhere((card) => card.id == cardId);
    if (cardIndex == -1) return;

    final updatedCard = deck.cards[cardIndex].copyWith(
      front: _cleanRequired(front),
      back: _cleanRequired(back),
    );
    final cards = [...deck.cards]..[cardIndex] = updatedCard;
    _decks[deckIndex] = deck.copyWith(cards: cards);
    notifyListeners();
  }

  void deleteCard({required String deckId, required String cardId}) {
    final deckIndex = _indexOfDeck(deckId);
    if (deckIndex == -1) return;
    final deck = _decks[deckIndex];
    final cards = deck.cards.where((card) => card.id != cardId).toList();
    if (cards.length == deck.cards.length) return;
    _decks[deckIndex] = deck.copyWith(cards: cards);
    notifyListeners();
  }

  void reorderCard({
    required String deckId,
    required int oldIndex,
    required int newIndex,
  }) {
    final deckIndex = _requireDeckIndex(deckId);
    final deck = _decks[deckIndex];
    if (oldIndex < 0 || oldIndex >= deck.cards.length) return;
    var adjustedNewIndex = newIndex;
    if (adjustedNewIndex > oldIndex) adjustedNewIndex -= 1;
    adjustedNewIndex = adjustedNewIndex.clamp(0, deck.cards.length - 1);
    if (oldIndex == adjustedNewIndex) return;

    final cards = [...deck.cards];
    final card = cards.removeAt(oldIndex);
    cards.insert(adjustedNewIndex, card);
    _decks[deckIndex] = deck.copyWith(cards: cards);
    notifyListeners();
  }

  /// Moves a card when [newIndex] is already adjusted for the removed item.
  ///
  /// This matches Flutter's current `onReorderItem` callback contract.
  void moveCard({
    required String deckId,
    required int oldIndex,
    required int newIndex,
  }) {
    final deckIndex = _requireDeckIndex(deckId);
    final deck = _decks[deckIndex];
    if (oldIndex < 0 || oldIndex >= deck.cards.length) return;
    final targetIndex = newIndex.clamp(0, deck.cards.length - 1);
    if (oldIndex == targetIndex) return;

    final cards = [...deck.cards];
    final card = cards.removeAt(oldIndex);
    cards.insert(targetIndex, card);
    _decks[deckIndex] = deck.copyWith(cards: cards);
    notifyListeners();
  }

  int _indexOfDeck(String deckId) {
    return _decks.indexWhere((deck) => deck.id == deckId);
  }

  int _requireDeckIndex(String deckId) {
    final deckIndex = _indexOfDeck(deckId);
    if (deckIndex == -1) {
      throw ArgumentError.value(deckId, 'deckId', 'Deck does not exist');
    }
    return deckIndex;
  }

  String _newId(String prefix) {
    _nextLocalId += 1;
    return '$prefix-${DateTime.now().microsecondsSinceEpoch}-$_nextLocalId';
  }

  static String _cleanRequired(String value, {String? fallback}) {
    final cleaned = value.trim();
    if (cleaned.isNotEmpty) return cleaned;
    if (fallback != null) return fallback;
    throw const FormatException('Both sides of a card need text.');
  }
}
