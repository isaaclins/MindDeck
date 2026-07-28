enum StudyDirection { frontToBack, backToFront }

class MindCard {
  const MindCard({required this.id, required this.front, required this.back});

  final String id;
  final String front;
  final String back;

  MindCard copyWith({String? id, String? front, String? back}) {
    return MindCard(
      id: id ?? this.id,
      front: front ?? this.front,
      back: back ?? this.back,
    );
  }
}

class Deck {
  const Deck({
    required this.id,
    required this.title,
    required this.cards,
    this.studyBothDirections = false,
  });

  final String id;
  final String title;
  final List<MindCard> cards;
  final bool studyBothDirections;

  Deck copyWith({
    String? id,
    String? title,
    List<MindCard>? cards,
    bool? studyBothDirections,
  }) {
    return Deck(
      id: id ?? this.id,
      title: title ?? this.title,
      cards: cards ?? this.cards,
      studyBothDirections: studyBothDirections ?? this.studyBothDirections,
    );
  }
}

class DeckStudyStats {
  const DeckStudyStats({
    required this.dueCount,
    required this.studiedCount,
    required this.totalCount,
  });

  final int dueCount;
  final int studiedCount;
  final int totalCount;

  double get completion => totalCount == 0 ? 0 : studiedCount / totalCount;
}
