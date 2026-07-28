import 'models.dart';

const sampleDecks = <Deck>[
  Deck(
    id: 'spanish-basics',
    title: 'Spanish Basics',
    studyBothDirections: true,
    cards: [
      MindCard(id: 'hola', front: 'Hola', back: 'Hello'),
      MindCard(id: 'adios', front: 'Adiós', back: 'Goodbye'),
      MindCard(id: 'gracias', front: 'Gracias', back: 'Thank you'),
      MindCard(id: 'por-favor', front: 'Por favor', back: 'Please'),
      MindCard(id: 'como-estas', front: '¿Cómo estás?', back: 'How are you?'),
    ],
  ),
  Deck(
    id: 'biology',
    title: 'Biology',
    cards: [
      MindCard(id: 'cell', front: 'Smallest unit of life', back: 'Cell'),
      MindCard(
        id: 'photosynthesis',
        front: 'How plants turn light into energy',
        back: 'Photosynthesis',
      ),
    ],
  ),
  Deck(
    id: 'design-terms',
    title: 'Design Terms',
    cards: [
      MindCard(
        id: 'hierarchy',
        front: 'Visual arrangement that signals importance',
        back: 'Hierarchy',
      ),
    ],
  ),
];
