import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class DeckRows extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  BoolColumn get studyBothDirections =>
      boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CardRows extends Table {
  TextColumn get id => text()();
  TextColumn get deckId =>
      text().references(DeckRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get front => text()();
  TextColumn get back => text()();
  IntColumn get sortIndex => integer()();
  IntColumn get contentRevision => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CardProgressRows extends Table {
  TextColumn get cardId =>
      text().references(CardRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get direction => text()();
  IntColumn get contentRevision => integer()();
  IntColumn get consecutiveCorrect =>
      integer().withDefault(const Constant(0))();
  IntColumn get lapseCount => integer().withDefault(const Constant(0))();
  IntColumn get totalCorrect => integer().withDefault(const Constant(0))();
  IntColumn get totalWrong => integer().withDefault(const Constant(0))();
  DateTimeColumn get dueAt => dateTime().nullable()();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  BoolColumn get needsRecovery =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {cardId, direction};
}

class ReviewEventRows extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text()();
  TextColumn get cardId =>
      text().references(CardRows, #id, onDelete: KeyAction.cascade)();
  TextColumn get direction => text()();
  TextColumn get grade => text()();
  BoolColumn get isRetry => boolean()();
  DateTimeColumn get reviewedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(tables: [DeckRows, CardRows, CardProgressRows, ReviewEventRows])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
    : super(executor ?? driftDatabase(name: 'minddeck'));

  @override
  int get schemaVersion => 1;
}
