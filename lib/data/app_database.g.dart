// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $DeckRowsTable extends DeckRows with TableInfo<$DeckRowsTable, DeckRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _studyBothDirectionsMeta =
      const VerificationMeta('studyBothDirections');
  @override
  late final GeneratedColumn<bool> studyBothDirections = GeneratedColumn<bool>(
    'study_both_directions',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("study_both_directions" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    studyBothDirections,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeckRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('study_both_directions')) {
      context.handle(
        _studyBothDirectionsMeta,
        studyBothDirections.isAcceptableOrUnknown(
          data['study_both_directions']!,
          _studyBothDirectionsMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DeckRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      studyBothDirections: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}study_both_directions'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DeckRowsTable createAlias(String alias) {
    return $DeckRowsTable(attachedDatabase, alias);
  }
}

class DeckRow extends DataClass implements Insertable<DeckRow> {
  final String id;
  final String title;
  final bool studyBothDirections;
  final DateTime createdAt;
  final DateTime updatedAt;
  const DeckRow({
    required this.id,
    required this.title,
    required this.studyBothDirections,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['study_both_directions'] = Variable<bool>(studyBothDirections);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  DeckRowsCompanion toCompanion(bool nullToAbsent) {
    return DeckRowsCompanion(
      id: Value(id),
      title: Value(title),
      studyBothDirections: Value(studyBothDirections),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory DeckRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      studyBothDirections: serializer.fromJson<bool>(
        json['studyBothDirections'],
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'studyBothDirections': serializer.toJson<bool>(studyBothDirections),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  DeckRow copyWith({
    String? id,
    String? title,
    bool? studyBothDirections,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => DeckRow(
    id: id ?? this.id,
    title: title ?? this.title,
    studyBothDirections: studyBothDirections ?? this.studyBothDirections,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DeckRow copyWithCompanion(DeckRowsCompanion data) {
    return DeckRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      studyBothDirections: data.studyBothDirections.present
          ? data.studyBothDirections.value
          : this.studyBothDirections,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('studyBothDirections: $studyBothDirections, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, studyBothDirections, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.studyBothDirections == this.studyBothDirections &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class DeckRowsCompanion extends UpdateCompanion<DeckRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<bool> studyBothDirections;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const DeckRowsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.studyBothDirections = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeckRowsCompanion.insert({
    required String id,
    required String title,
    this.studyBothDirections = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<DeckRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<bool>? studyBothDirections,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (studyBothDirections != null)
        'study_both_directions': studyBothDirections,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeckRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<bool>? studyBothDirections,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return DeckRowsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      studyBothDirections: studyBothDirections ?? this.studyBothDirections,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (studyBothDirections.present) {
      map['study_both_directions'] = Variable<bool>(studyBothDirections.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckRowsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('studyBothDirections: $studyBothDirections, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardRowsTable extends CardRows with TableInfo<$CardRowsTable, CardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES deck_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _frontMeta = const VerificationMeta('front');
  @override
  late final GeneratedColumn<String> front = GeneratedColumn<String>(
    'front',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _backMeta = const VerificationMeta('back');
  @override
  late final GeneratedColumn<String> back = GeneratedColumn<String>(
    'back',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortIndexMeta = const VerificationMeta(
    'sortIndex',
  );
  @override
  late final GeneratedColumn<int> sortIndex = GeneratedColumn<int>(
    'sort_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentRevisionMeta = const VerificationMeta(
    'contentRevision',
  );
  @override
  late final GeneratedColumn<int> contentRevision = GeneratedColumn<int>(
    'content_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    deckId,
    front,
    back,
    sortIndex,
    contentRevision,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('front')) {
      context.handle(
        _frontMeta,
        front.isAcceptableOrUnknown(data['front']!, _frontMeta),
      );
    } else if (isInserting) {
      context.missing(_frontMeta);
    }
    if (data.containsKey('back')) {
      context.handle(
        _backMeta,
        back.isAcceptableOrUnknown(data['back']!, _backMeta),
      );
    } else if (isInserting) {
      context.missing(_backMeta);
    }
    if (data.containsKey('sort_index')) {
      context.handle(
        _sortIndexMeta,
        sortIndex.isAcceptableOrUnknown(data['sort_index']!, _sortIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_sortIndexMeta);
    }
    if (data.containsKey('content_revision')) {
      context.handle(
        _contentRevisionMeta,
        contentRevision.isAcceptableOrUnknown(
          data['content_revision']!,
          _contentRevisionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_id'],
      )!,
      front: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}front'],
      )!,
      back: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}back'],
      )!,
      sortIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_index'],
      )!,
      contentRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_revision'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CardRowsTable createAlias(String alias) {
    return $CardRowsTable(attachedDatabase, alias);
  }
}

class CardRow extends DataClass implements Insertable<CardRow> {
  final String id;
  final String deckId;
  final String front;
  final String back;
  final int sortIndex;
  final int contentRevision;
  final DateTime createdAt;
  final DateTime updatedAt;
  const CardRow({
    required this.id,
    required this.deckId,
    required this.front,
    required this.back,
    required this.sortIndex,
    required this.contentRevision,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['deck_id'] = Variable<String>(deckId);
    map['front'] = Variable<String>(front);
    map['back'] = Variable<String>(back);
    map['sort_index'] = Variable<int>(sortIndex);
    map['content_revision'] = Variable<int>(contentRevision);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CardRowsCompanion toCompanion(bool nullToAbsent) {
    return CardRowsCompanion(
      id: Value(id),
      deckId: Value(deckId),
      front: Value(front),
      back: Value(back),
      sortIndex: Value(sortIndex),
      contentRevision: Value(contentRevision),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory CardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardRow(
      id: serializer.fromJson<String>(json['id']),
      deckId: serializer.fromJson<String>(json['deckId']),
      front: serializer.fromJson<String>(json['front']),
      back: serializer.fromJson<String>(json['back']),
      sortIndex: serializer.fromJson<int>(json['sortIndex']),
      contentRevision: serializer.fromJson<int>(json['contentRevision']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'deckId': serializer.toJson<String>(deckId),
      'front': serializer.toJson<String>(front),
      'back': serializer.toJson<String>(back),
      'sortIndex': serializer.toJson<int>(sortIndex),
      'contentRevision': serializer.toJson<int>(contentRevision),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CardRow copyWith({
    String? id,
    String? deckId,
    String? front,
    String? back,
    int? sortIndex,
    int? contentRevision,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => CardRow(
    id: id ?? this.id,
    deckId: deckId ?? this.deckId,
    front: front ?? this.front,
    back: back ?? this.back,
    sortIndex: sortIndex ?? this.sortIndex,
    contentRevision: contentRevision ?? this.contentRevision,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CardRow copyWithCompanion(CardRowsCompanion data) {
    return CardRow(
      id: data.id.present ? data.id.value : this.id,
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      front: data.front.present ? data.front.value : this.front,
      back: data.back.present ? data.back.value : this.back,
      sortIndex: data.sortIndex.present ? data.sortIndex.value : this.sortIndex,
      contentRevision: data.contentRevision.present
          ? data.contentRevision.value
          : this.contentRevision,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardRow(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    deckId,
    front,
    back,
    sortIndex,
    contentRevision,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardRow &&
          other.id == this.id &&
          other.deckId == this.deckId &&
          other.front == this.front &&
          other.back == this.back &&
          other.sortIndex == this.sortIndex &&
          other.contentRevision == this.contentRevision &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class CardRowsCompanion extends UpdateCompanion<CardRow> {
  final Value<String> id;
  final Value<String> deckId;
  final Value<String> front;
  final Value<String> back;
  final Value<int> sortIndex;
  final Value<int> contentRevision;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CardRowsCompanion({
    this.id = const Value.absent(),
    this.deckId = const Value.absent(),
    this.front = const Value.absent(),
    this.back = const Value.absent(),
    this.sortIndex = const Value.absent(),
    this.contentRevision = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardRowsCompanion.insert({
    required String id,
    required String deckId,
    required String front,
    required String back,
    required int sortIndex,
    this.contentRevision = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       deckId = Value(deckId),
       front = Value(front),
       back = Value(back),
       sortIndex = Value(sortIndex),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<CardRow> custom({
    Expression<String>? id,
    Expression<String>? deckId,
    Expression<String>? front,
    Expression<String>? back,
    Expression<int>? sortIndex,
    Expression<int>? contentRevision,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (deckId != null) 'deck_id': deckId,
      if (front != null) 'front': front,
      if (back != null) 'back': back,
      if (sortIndex != null) 'sort_index': sortIndex,
      if (contentRevision != null) 'content_revision': contentRevision,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? deckId,
    Value<String>? front,
    Value<String>? back,
    Value<int>? sortIndex,
    Value<int>? contentRevision,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CardRowsCompanion(
      id: id ?? this.id,
      deckId: deckId ?? this.deckId,
      front: front ?? this.front,
      back: back ?? this.back,
      sortIndex: sortIndex ?? this.sortIndex,
      contentRevision: contentRevision ?? this.contentRevision,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (front.present) {
      map['front'] = Variable<String>(front.value);
    }
    if (back.present) {
      map['back'] = Variable<String>(back.value);
    }
    if (sortIndex.present) {
      map['sort_index'] = Variable<int>(sortIndex.value);
    }
    if (contentRevision.present) {
      map['content_revision'] = Variable<int>(contentRevision.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardRowsCompanion(')
          ..write('id: $id, ')
          ..write('deckId: $deckId, ')
          ..write('front: $front, ')
          ..write('back: $back, ')
          ..write('sortIndex: $sortIndex, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CardProgressRowsTable extends CardProgressRows
    with TableInfo<$CardProgressRowsTable, CardProgressRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CardProgressRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES card_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentRevisionMeta = const VerificationMeta(
    'contentRevision',
  );
  @override
  late final GeneratedColumn<int> contentRevision = GeneratedColumn<int>(
    'content_revision',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _consecutiveCorrectMeta =
      const VerificationMeta('consecutiveCorrect');
  @override
  late final GeneratedColumn<int> consecutiveCorrect = GeneratedColumn<int>(
    'consecutive_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lapseCountMeta = const VerificationMeta(
    'lapseCount',
  );
  @override
  late final GeneratedColumn<int> lapseCount = GeneratedColumn<int>(
    'lapse_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCorrectMeta = const VerificationMeta(
    'totalCorrect',
  );
  @override
  late final GeneratedColumn<int> totalCorrect = GeneratedColumn<int>(
    'total_correct',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalWrongMeta = const VerificationMeta(
    'totalWrong',
  );
  @override
  late final GeneratedColumn<int> totalWrong = GeneratedColumn<int>(
    'total_wrong',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _needsRecoveryMeta = const VerificationMeta(
    'needsRecovery',
  );
  @override
  late final GeneratedColumn<bool> needsRecovery = GeneratedColumn<bool>(
    'needs_recovery',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_recovery" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    cardId,
    direction,
    contentRevision,
    consecutiveCorrect,
    lapseCount,
    totalCorrect,
    totalWrong,
    dueAt,
    lastReviewedAt,
    needsRecovery,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'card_progress_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<CardProgressRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('content_revision')) {
      context.handle(
        _contentRevisionMeta,
        contentRevision.isAcceptableOrUnknown(
          data['content_revision']!,
          _contentRevisionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentRevisionMeta);
    }
    if (data.containsKey('consecutive_correct')) {
      context.handle(
        _consecutiveCorrectMeta,
        consecutiveCorrect.isAcceptableOrUnknown(
          data['consecutive_correct']!,
          _consecutiveCorrectMeta,
        ),
      );
    }
    if (data.containsKey('lapse_count')) {
      context.handle(
        _lapseCountMeta,
        lapseCount.isAcceptableOrUnknown(data['lapse_count']!, _lapseCountMeta),
      );
    }
    if (data.containsKey('total_correct')) {
      context.handle(
        _totalCorrectMeta,
        totalCorrect.isAcceptableOrUnknown(
          data['total_correct']!,
          _totalCorrectMeta,
        ),
      );
    }
    if (data.containsKey('total_wrong')) {
      context.handle(
        _totalWrongMeta,
        totalWrong.isAcceptableOrUnknown(data['total_wrong']!, _totalWrongMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    if (data.containsKey('needs_recovery')) {
      context.handle(
        _needsRecoveryMeta,
        needsRecovery.isAcceptableOrUnknown(
          data['needs_recovery']!,
          _needsRecoveryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {cardId, direction};
  @override
  CardProgressRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CardProgressRow(
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      contentRevision: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}content_revision'],
      )!,
      consecutiveCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutive_correct'],
      )!,
      lapseCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapse_count'],
      )!,
      totalCorrect: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_correct'],
      )!,
      totalWrong: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_wrong'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
      needsRecovery: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}needs_recovery'],
      )!,
    );
  }

  @override
  $CardProgressRowsTable createAlias(String alias) {
    return $CardProgressRowsTable(attachedDatabase, alias);
  }
}

class CardProgressRow extends DataClass implements Insertable<CardProgressRow> {
  final String cardId;
  final String direction;
  final int contentRevision;
  final int consecutiveCorrect;
  final int lapseCount;
  final int totalCorrect;
  final int totalWrong;
  final DateTime? dueAt;
  final DateTime? lastReviewedAt;
  final bool needsRecovery;
  const CardProgressRow({
    required this.cardId,
    required this.direction,
    required this.contentRevision,
    required this.consecutiveCorrect,
    required this.lapseCount,
    required this.totalCorrect,
    required this.totalWrong,
    this.dueAt,
    this.lastReviewedAt,
    required this.needsRecovery,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['card_id'] = Variable<String>(cardId);
    map['direction'] = Variable<String>(direction);
    map['content_revision'] = Variable<int>(contentRevision);
    map['consecutive_correct'] = Variable<int>(consecutiveCorrect);
    map['lapse_count'] = Variable<int>(lapseCount);
    map['total_correct'] = Variable<int>(totalCorrect);
    map['total_wrong'] = Variable<int>(totalWrong);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    map['needs_recovery'] = Variable<bool>(needsRecovery);
    return map;
  }

  CardProgressRowsCompanion toCompanion(bool nullToAbsent) {
    return CardProgressRowsCompanion(
      cardId: Value(cardId),
      direction: Value(direction),
      contentRevision: Value(contentRevision),
      consecutiveCorrect: Value(consecutiveCorrect),
      lapseCount: Value(lapseCount),
      totalCorrect: Value(totalCorrect),
      totalWrong: Value(totalWrong),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      needsRecovery: Value(needsRecovery),
    );
  }

  factory CardProgressRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CardProgressRow(
      cardId: serializer.fromJson<String>(json['cardId']),
      direction: serializer.fromJson<String>(json['direction']),
      contentRevision: serializer.fromJson<int>(json['contentRevision']),
      consecutiveCorrect: serializer.fromJson<int>(json['consecutiveCorrect']),
      lapseCount: serializer.fromJson<int>(json['lapseCount']),
      totalCorrect: serializer.fromJson<int>(json['totalCorrect']),
      totalWrong: serializer.fromJson<int>(json['totalWrong']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      needsRecovery: serializer.fromJson<bool>(json['needsRecovery']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'cardId': serializer.toJson<String>(cardId),
      'direction': serializer.toJson<String>(direction),
      'contentRevision': serializer.toJson<int>(contentRevision),
      'consecutiveCorrect': serializer.toJson<int>(consecutiveCorrect),
      'lapseCount': serializer.toJson<int>(lapseCount),
      'totalCorrect': serializer.toJson<int>(totalCorrect),
      'totalWrong': serializer.toJson<int>(totalWrong),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'needsRecovery': serializer.toJson<bool>(needsRecovery),
    };
  }

  CardProgressRow copyWith({
    String? cardId,
    String? direction,
    int? contentRevision,
    int? consecutiveCorrect,
    int? lapseCount,
    int? totalCorrect,
    int? totalWrong,
    Value<DateTime?> dueAt = const Value.absent(),
    Value<DateTime?> lastReviewedAt = const Value.absent(),
    bool? needsRecovery,
  }) => CardProgressRow(
    cardId: cardId ?? this.cardId,
    direction: direction ?? this.direction,
    contentRevision: contentRevision ?? this.contentRevision,
    consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
    lapseCount: lapseCount ?? this.lapseCount,
    totalCorrect: totalCorrect ?? this.totalCorrect,
    totalWrong: totalWrong ?? this.totalWrong,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
    needsRecovery: needsRecovery ?? this.needsRecovery,
  );
  CardProgressRow copyWithCompanion(CardProgressRowsCompanion data) {
    return CardProgressRow(
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      direction: data.direction.present ? data.direction.value : this.direction,
      contentRevision: data.contentRevision.present
          ? data.contentRevision.value
          : this.contentRevision,
      consecutiveCorrect: data.consecutiveCorrect.present
          ? data.consecutiveCorrect.value
          : this.consecutiveCorrect,
      lapseCount: data.lapseCount.present
          ? data.lapseCount.value
          : this.lapseCount,
      totalCorrect: data.totalCorrect.present
          ? data.totalCorrect.value
          : this.totalCorrect,
      totalWrong: data.totalWrong.present
          ? data.totalWrong.value
          : this.totalWrong,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      needsRecovery: data.needsRecovery.present
          ? data.needsRecovery.value
          : this.needsRecovery,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CardProgressRow(')
          ..write('cardId: $cardId, ')
          ..write('direction: $direction, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('consecutiveCorrect: $consecutiveCorrect, ')
          ..write('lapseCount: $lapseCount, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('totalWrong: $totalWrong, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('needsRecovery: $needsRecovery')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    cardId,
    direction,
    contentRevision,
    consecutiveCorrect,
    lapseCount,
    totalCorrect,
    totalWrong,
    dueAt,
    lastReviewedAt,
    needsRecovery,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CardProgressRow &&
          other.cardId == this.cardId &&
          other.direction == this.direction &&
          other.contentRevision == this.contentRevision &&
          other.consecutiveCorrect == this.consecutiveCorrect &&
          other.lapseCount == this.lapseCount &&
          other.totalCorrect == this.totalCorrect &&
          other.totalWrong == this.totalWrong &&
          other.dueAt == this.dueAt &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.needsRecovery == this.needsRecovery);
}

class CardProgressRowsCompanion extends UpdateCompanion<CardProgressRow> {
  final Value<String> cardId;
  final Value<String> direction;
  final Value<int> contentRevision;
  final Value<int> consecutiveCorrect;
  final Value<int> lapseCount;
  final Value<int> totalCorrect;
  final Value<int> totalWrong;
  final Value<DateTime?> dueAt;
  final Value<DateTime?> lastReviewedAt;
  final Value<bool> needsRecovery;
  final Value<int> rowid;
  const CardProgressRowsCompanion({
    this.cardId = const Value.absent(),
    this.direction = const Value.absent(),
    this.contentRevision = const Value.absent(),
    this.consecutiveCorrect = const Value.absent(),
    this.lapseCount = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.totalWrong = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.needsRecovery = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CardProgressRowsCompanion.insert({
    required String cardId,
    required String direction,
    required int contentRevision,
    this.consecutiveCorrect = const Value.absent(),
    this.lapseCount = const Value.absent(),
    this.totalCorrect = const Value.absent(),
    this.totalWrong = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.needsRecovery = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : cardId = Value(cardId),
       direction = Value(direction),
       contentRevision = Value(contentRevision);
  static Insertable<CardProgressRow> custom({
    Expression<String>? cardId,
    Expression<String>? direction,
    Expression<int>? contentRevision,
    Expression<int>? consecutiveCorrect,
    Expression<int>? lapseCount,
    Expression<int>? totalCorrect,
    Expression<int>? totalWrong,
    Expression<DateTime>? dueAt,
    Expression<DateTime>? lastReviewedAt,
    Expression<bool>? needsRecovery,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (cardId != null) 'card_id': cardId,
      if (direction != null) 'direction': direction,
      if (contentRevision != null) 'content_revision': contentRevision,
      if (consecutiveCorrect != null) 'consecutive_correct': consecutiveCorrect,
      if (lapseCount != null) 'lapse_count': lapseCount,
      if (totalCorrect != null) 'total_correct': totalCorrect,
      if (totalWrong != null) 'total_wrong': totalWrong,
      if (dueAt != null) 'due_at': dueAt,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (needsRecovery != null) 'needs_recovery': needsRecovery,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CardProgressRowsCompanion copyWith({
    Value<String>? cardId,
    Value<String>? direction,
    Value<int>? contentRevision,
    Value<int>? consecutiveCorrect,
    Value<int>? lapseCount,
    Value<int>? totalCorrect,
    Value<int>? totalWrong,
    Value<DateTime?>? dueAt,
    Value<DateTime?>? lastReviewedAt,
    Value<bool>? needsRecovery,
    Value<int>? rowid,
  }) {
    return CardProgressRowsCompanion(
      cardId: cardId ?? this.cardId,
      direction: direction ?? this.direction,
      contentRevision: contentRevision ?? this.contentRevision,
      consecutiveCorrect: consecutiveCorrect ?? this.consecutiveCorrect,
      lapseCount: lapseCount ?? this.lapseCount,
      totalCorrect: totalCorrect ?? this.totalCorrect,
      totalWrong: totalWrong ?? this.totalWrong,
      dueAt: dueAt ?? this.dueAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      needsRecovery: needsRecovery ?? this.needsRecovery,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (contentRevision.present) {
      map['content_revision'] = Variable<int>(contentRevision.value);
    }
    if (consecutiveCorrect.present) {
      map['consecutive_correct'] = Variable<int>(consecutiveCorrect.value);
    }
    if (lapseCount.present) {
      map['lapse_count'] = Variable<int>(lapseCount.value);
    }
    if (totalCorrect.present) {
      map['total_correct'] = Variable<int>(totalCorrect.value);
    }
    if (totalWrong.present) {
      map['total_wrong'] = Variable<int>(totalWrong.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (needsRecovery.present) {
      map['needs_recovery'] = Variable<bool>(needsRecovery.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CardProgressRowsCompanion(')
          ..write('cardId: $cardId, ')
          ..write('direction: $direction, ')
          ..write('contentRevision: $contentRevision, ')
          ..write('consecutiveCorrect: $consecutiveCorrect, ')
          ..write('lapseCount: $lapseCount, ')
          ..write('totalCorrect: $totalCorrect, ')
          ..write('totalWrong: $totalWrong, ')
          ..write('dueAt: $dueAt, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('needsRecovery: $needsRecovery, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ReviewEventRowsTable extends ReviewEventRows
    with TableInfo<$ReviewEventRowsTable, ReviewEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReviewEventRowsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cardIdMeta = const VerificationMeta('cardId');
  @override
  late final GeneratedColumn<String> cardId = GeneratedColumn<String>(
    'card_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES card_rows (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _directionMeta = const VerificationMeta(
    'direction',
  );
  @override
  late final GeneratedColumn<String> direction = GeneratedColumn<String>(
    'direction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gradeMeta = const VerificationMeta('grade');
  @override
  late final GeneratedColumn<String> grade = GeneratedColumn<String>(
    'grade',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isRetryMeta = const VerificationMeta(
    'isRetry',
  );
  @override
  late final GeneratedColumn<bool> isRetry = GeneratedColumn<bool>(
    'is_retry',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_retry" IN (0, 1))',
    ),
  );
  static const VerificationMeta _reviewedAtMeta = const VerificationMeta(
    'reviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> reviewedAt = GeneratedColumn<DateTime>(
    'reviewed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    cardId,
    direction,
    grade,
    isRetry,
    reviewedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'review_event_rows';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReviewEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('card_id')) {
      context.handle(
        _cardIdMeta,
        cardId.isAcceptableOrUnknown(data['card_id']!, _cardIdMeta),
      );
    } else if (isInserting) {
      context.missing(_cardIdMeta);
    }
    if (data.containsKey('direction')) {
      context.handle(
        _directionMeta,
        direction.isAcceptableOrUnknown(data['direction']!, _directionMeta),
      );
    } else if (isInserting) {
      context.missing(_directionMeta);
    }
    if (data.containsKey('grade')) {
      context.handle(
        _gradeMeta,
        grade.isAcceptableOrUnknown(data['grade']!, _gradeMeta),
      );
    } else if (isInserting) {
      context.missing(_gradeMeta);
    }
    if (data.containsKey('is_retry')) {
      context.handle(
        _isRetryMeta,
        isRetry.isAcceptableOrUnknown(data['is_retry']!, _isRetryMeta),
      );
    } else if (isInserting) {
      context.missing(_isRetryMeta);
    }
    if (data.containsKey('reviewed_at')) {
      context.handle(
        _reviewedAtMeta,
        reviewedAt.isAcceptableOrUnknown(data['reviewed_at']!, _reviewedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_reviewedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReviewEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReviewEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      cardId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}card_id'],
      )!,
      direction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}direction'],
      )!,
      grade: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grade'],
      )!,
      isRetry: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_retry'],
      )!,
      reviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}reviewed_at'],
      )!,
    );
  }

  @override
  $ReviewEventRowsTable createAlias(String alias) {
    return $ReviewEventRowsTable(attachedDatabase, alias);
  }
}

class ReviewEventRow extends DataClass implements Insertable<ReviewEventRow> {
  final String id;
  final String sessionId;
  final String cardId;
  final String direction;
  final String grade;
  final bool isRetry;
  final DateTime reviewedAt;
  const ReviewEventRow({
    required this.id,
    required this.sessionId,
    required this.cardId,
    required this.direction,
    required this.grade,
    required this.isRetry,
    required this.reviewedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['card_id'] = Variable<String>(cardId);
    map['direction'] = Variable<String>(direction);
    map['grade'] = Variable<String>(grade);
    map['is_retry'] = Variable<bool>(isRetry);
    map['reviewed_at'] = Variable<DateTime>(reviewedAt);
    return map;
  }

  ReviewEventRowsCompanion toCompanion(bool nullToAbsent) {
    return ReviewEventRowsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      cardId: Value(cardId),
      direction: Value(direction),
      grade: Value(grade),
      isRetry: Value(isRetry),
      reviewedAt: Value(reviewedAt),
    );
  }

  factory ReviewEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReviewEventRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      cardId: serializer.fromJson<String>(json['cardId']),
      direction: serializer.fromJson<String>(json['direction']),
      grade: serializer.fromJson<String>(json['grade']),
      isRetry: serializer.fromJson<bool>(json['isRetry']),
      reviewedAt: serializer.fromJson<DateTime>(json['reviewedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'cardId': serializer.toJson<String>(cardId),
      'direction': serializer.toJson<String>(direction),
      'grade': serializer.toJson<String>(grade),
      'isRetry': serializer.toJson<bool>(isRetry),
      'reviewedAt': serializer.toJson<DateTime>(reviewedAt),
    };
  }

  ReviewEventRow copyWith({
    String? id,
    String? sessionId,
    String? cardId,
    String? direction,
    String? grade,
    bool? isRetry,
    DateTime? reviewedAt,
  }) => ReviewEventRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    cardId: cardId ?? this.cardId,
    direction: direction ?? this.direction,
    grade: grade ?? this.grade,
    isRetry: isRetry ?? this.isRetry,
    reviewedAt: reviewedAt ?? this.reviewedAt,
  );
  ReviewEventRow copyWithCompanion(ReviewEventRowsCompanion data) {
    return ReviewEventRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      cardId: data.cardId.present ? data.cardId.value : this.cardId,
      direction: data.direction.present ? data.direction.value : this.direction,
      grade: data.grade.present ? data.grade.value : this.grade,
      isRetry: data.isRetry.present ? data.isRetry.value : this.isRetry,
      reviewedAt: data.reviewedAt.present
          ? data.reviewedAt.value
          : this.reviewedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReviewEventRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('cardId: $cardId, ')
          ..write('direction: $direction, ')
          ..write('grade: $grade, ')
          ..write('isRetry: $isRetry, ')
          ..write('reviewedAt: $reviewedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, cardId, direction, grade, isRetry, reviewedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReviewEventRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.cardId == this.cardId &&
          other.direction == this.direction &&
          other.grade == this.grade &&
          other.isRetry == this.isRetry &&
          other.reviewedAt == this.reviewedAt);
}

class ReviewEventRowsCompanion extends UpdateCompanion<ReviewEventRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String> cardId;
  final Value<String> direction;
  final Value<String> grade;
  final Value<bool> isRetry;
  final Value<DateTime> reviewedAt;
  final Value<int> rowid;
  const ReviewEventRowsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.cardId = const Value.absent(),
    this.direction = const Value.absent(),
    this.grade = const Value.absent(),
    this.isRetry = const Value.absent(),
    this.reviewedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReviewEventRowsCompanion.insert({
    required String id,
    required String sessionId,
    required String cardId,
    required String direction,
    required String grade,
    required bool isRetry,
    required DateTime reviewedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       cardId = Value(cardId),
       direction = Value(direction),
       grade = Value(grade),
       isRetry = Value(isRetry),
       reviewedAt = Value(reviewedAt);
  static Insertable<ReviewEventRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? cardId,
    Expression<String>? direction,
    Expression<String>? grade,
    Expression<bool>? isRetry,
    Expression<DateTime>? reviewedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (cardId != null) 'card_id': cardId,
      if (direction != null) 'direction': direction,
      if (grade != null) 'grade': grade,
      if (isRetry != null) 'is_retry': isRetry,
      if (reviewedAt != null) 'reviewed_at': reviewedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReviewEventRowsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String>? cardId,
    Value<String>? direction,
    Value<String>? grade,
    Value<bool>? isRetry,
    Value<DateTime>? reviewedAt,
    Value<int>? rowid,
  }) {
    return ReviewEventRowsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      cardId: cardId ?? this.cardId,
      direction: direction ?? this.direction,
      grade: grade ?? this.grade,
      isRetry: isRetry ?? this.isRetry,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (cardId.present) {
      map['card_id'] = Variable<String>(cardId.value);
    }
    if (direction.present) {
      map['direction'] = Variable<String>(direction.value);
    }
    if (grade.present) {
      map['grade'] = Variable<String>(grade.value);
    }
    if (isRetry.present) {
      map['is_retry'] = Variable<bool>(isRetry.value);
    }
    if (reviewedAt.present) {
      map['reviewed_at'] = Variable<DateTime>(reviewedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReviewEventRowsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('cardId: $cardId, ')
          ..write('direction: $direction, ')
          ..write('grade: $grade, ')
          ..write('isRetry: $isRetry, ')
          ..write('reviewedAt: $reviewedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $DeckRowsTable deckRows = $DeckRowsTable(this);
  late final $CardRowsTable cardRows = $CardRowsTable(this);
  late final $CardProgressRowsTable cardProgressRows = $CardProgressRowsTable(
    this,
  );
  late final $ReviewEventRowsTable reviewEventRows = $ReviewEventRowsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    deckRows,
    cardRows,
    cardProgressRows,
    reviewEventRows,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'deck_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('card_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'card_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('card_progress_rows', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'card_rows',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('review_event_rows', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$DeckRowsTableCreateCompanionBuilder =
    DeckRowsCompanion Function({
      required String id,
      required String title,
      Value<bool> studyBothDirections,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$DeckRowsTableUpdateCompanionBuilder =
    DeckRowsCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<bool> studyBothDirections,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$DeckRowsTableReferences
    extends BaseReferences<_$AppDatabase, $DeckRowsTable, DeckRow> {
  $$DeckRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$CardRowsTable, List<CardRow>> _cardRowsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.cardRows,
    aliasName: 'deck_rows__id__card_rows__deck_id',
  );

  $$CardRowsTableProcessedTableManager get cardRowsRefs {
    final manager = $$CardRowsTableTableManager(
      $_db,
      $_db.cardRows,
    ).filter((f) => f.deckId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_cardRowsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DeckRowsTableFilterComposer
    extends Composer<_$AppDatabase, $DeckRowsTable> {
  $$DeckRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get studyBothDirections => $composableBuilder(
    column: $table.studyBothDirections,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cardRowsRefs(
    Expression<bool> Function($$CardRowsTableFilterComposer f) f,
  ) {
    final $$CardRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardRows,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardRowsTableFilterComposer(
            $db: $db,
            $table: $db.cardRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeckRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeckRowsTable> {
  $$DeckRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get studyBothDirections => $composableBuilder(
    column: $table.studyBothDirections,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeckRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeckRowsTable> {
  $$DeckRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get studyBothDirections => $composableBuilder(
    column: $table.studyBothDirections,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> cardRowsRefs<T extends Object>(
    Expression<T> Function($$CardRowsTableAnnotationComposer a) f,
  ) {
    final $$CardRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardRows,
      getReferencedColumn: (t) => t.deckId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DeckRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeckRowsTable,
          DeckRow,
          $$DeckRowsTableFilterComposer,
          $$DeckRowsTableOrderingComposer,
          $$DeckRowsTableAnnotationComposer,
          $$DeckRowsTableCreateCompanionBuilder,
          $$DeckRowsTableUpdateCompanionBuilder,
          (DeckRow, $$DeckRowsTableReferences),
          DeckRow,
          PrefetchHooks Function({bool cardRowsRefs})
        > {
  $$DeckRowsTableTableManager(_$AppDatabase db, $DeckRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeckRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeckRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeckRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> studyBothDirections = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeckRowsCompanion(
                id: id,
                title: title,
                studyBothDirections: studyBothDirections,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                Value<bool> studyBothDirections = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DeckRowsCompanion.insert(
                id: id,
                title: title,
                studyBothDirections: studyBothDirections,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DeckRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardRowsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (cardRowsRefs) db.cardRows],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cardRowsRefs)
                    await $_getPrefetchedData<DeckRow, $DeckRowsTable, CardRow>(
                      currentTable: table,
                      referencedTable: $$DeckRowsTableReferences
                          ._cardRowsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DeckRowsTableReferences(db, table, p0).cardRowsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.deckId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DeckRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeckRowsTable,
      DeckRow,
      $$DeckRowsTableFilterComposer,
      $$DeckRowsTableOrderingComposer,
      $$DeckRowsTableAnnotationComposer,
      $$DeckRowsTableCreateCompanionBuilder,
      $$DeckRowsTableUpdateCompanionBuilder,
      (DeckRow, $$DeckRowsTableReferences),
      DeckRow,
      PrefetchHooks Function({bool cardRowsRefs})
    >;
typedef $$CardRowsTableCreateCompanionBuilder =
    CardRowsCompanion Function({
      required String id,
      required String deckId,
      required String front,
      required String back,
      required int sortIndex,
      Value<int> contentRevision,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CardRowsTableUpdateCompanionBuilder =
    CardRowsCompanion Function({
      Value<String> id,
      Value<String> deckId,
      Value<String> front,
      Value<String> back,
      Value<int> sortIndex,
      Value<int> contentRevision,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CardRowsTableReferences
    extends BaseReferences<_$AppDatabase, $CardRowsTable, CardRow> {
  $$CardRowsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DeckRowsTable _deckIdTable(_$AppDatabase db) =>
      db.deckRows.createAlias('card_rows__deck_id__deck_rows__id');

  $$DeckRowsTableProcessedTableManager get deckId {
    final $_column = $_itemColumn<String>('deck_id')!;

    final manager = $$DeckRowsTableTableManager(
      $_db,
      $_db.deckRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_deckIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$CardProgressRowsTable, List<CardProgressRow>>
  _cardProgressRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.cardProgressRows,
    aliasName: 'card_rows__id__card_progress_rows__card_id',
  );

  $$CardProgressRowsTableProcessedTableManager get cardProgressRowsRefs {
    final manager = $$CardProgressRowsTableTableManager(
      $_db,
      $_db.cardProgressRows,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cardProgressRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ReviewEventRowsTable, List<ReviewEventRow>>
  _reviewEventRowsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.reviewEventRows,
    aliasName: 'card_rows__id__review_event_rows__card_id',
  );

  $$ReviewEventRowsTableProcessedTableManager get reviewEventRowsRefs {
    final manager = $$ReviewEventRowsTableTableManager(
      $_db,
      $_db.reviewEventRows,
    ).filter((f) => f.cardId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _reviewEventRowsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CardRowsTableFilterComposer
    extends Composer<_$AppDatabase, $CardRowsTable> {
  $$CardRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$DeckRowsTableFilterComposer get deckId {
    final $$DeckRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.deckRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckRowsTableFilterComposer(
            $db: $db,
            $table: $db.deckRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> cardProgressRowsRefs(
    Expression<bool> Function($$CardProgressRowsTableFilterComposer f) f,
  ) {
    final $$CardProgressRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardProgressRows,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardProgressRowsTableFilterComposer(
            $db: $db,
            $table: $db.cardProgressRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> reviewEventRowsRefs(
    Expression<bool> Function($$ReviewEventRowsTableFilterComposer f) f,
  ) {
    final $$ReviewEventRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewEventRows,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewEventRowsTableFilterComposer(
            $db: $db,
            $table: $db.reviewEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardRowsTable> {
  $$CardRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get front => $composableBuilder(
    column: $table.front,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get back => $composableBuilder(
    column: $table.back,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortIndex => $composableBuilder(
    column: $table.sortIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$DeckRowsTableOrderingComposer get deckId {
    final $$DeckRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.deckRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckRowsTableOrderingComposer(
            $db: $db,
            $table: $db.deckRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardRowsTable> {
  $$CardRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get front =>
      $composableBuilder(column: $table.front, builder: (column) => column);

  GeneratedColumn<String> get back =>
      $composableBuilder(column: $table.back, builder: (column) => column);

  GeneratedColumn<int> get sortIndex =>
      $composableBuilder(column: $table.sortIndex, builder: (column) => column);

  GeneratedColumn<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$DeckRowsTableAnnotationComposer get deckId {
    final $$DeckRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.deckId,
      referencedTable: $db.deckRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DeckRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.deckRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> cardProgressRowsRefs<T extends Object>(
    Expression<T> Function($$CardProgressRowsTableAnnotationComposer a) f,
  ) {
    final $$CardProgressRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cardProgressRows,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardProgressRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardProgressRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> reviewEventRowsRefs<T extends Object>(
    Expression<T> Function($$ReviewEventRowsTableAnnotationComposer a) f,
  ) {
    final $$ReviewEventRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.reviewEventRows,
      getReferencedColumn: (t) => t.cardId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ReviewEventRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.reviewEventRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CardRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardRowsTable,
          CardRow,
          $$CardRowsTableFilterComposer,
          $$CardRowsTableOrderingComposer,
          $$CardRowsTableAnnotationComposer,
          $$CardRowsTableCreateCompanionBuilder,
          $$CardRowsTableUpdateCompanionBuilder,
          (CardRow, $$CardRowsTableReferences),
          CardRow,
          PrefetchHooks Function({
            bool deckId,
            bool cardProgressRowsRefs,
            bool reviewEventRowsRefs,
          })
        > {
  $$CardRowsTableTableManager(_$AppDatabase db, $CardRowsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> deckId = const Value.absent(),
                Value<String> front = const Value.absent(),
                Value<String> back = const Value.absent(),
                Value<int> sortIndex = const Value.absent(),
                Value<int> contentRevision = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardRowsCompanion(
                id: id,
                deckId: deckId,
                front: front,
                back: back,
                sortIndex: sortIndex,
                contentRevision: contentRevision,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String deckId,
                required String front,
                required String back,
                required int sortIndex,
                Value<int> contentRevision = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CardRowsCompanion.insert(
                id: id,
                deckId: deckId,
                front: front,
                back: back,
                sortIndex: sortIndex,
                contentRevision: contentRevision,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                deckId = false,
                cardProgressRowsRefs = false,
                reviewEventRowsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (cardProgressRowsRefs) db.cardProgressRows,
                    if (reviewEventRowsRefs) db.reviewEventRows,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (deckId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.deckId,
                                    referencedTable: $$CardRowsTableReferences
                                        ._deckIdTable(db),
                                    referencedColumn: $$CardRowsTableReferences
                                        ._deckIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (cardProgressRowsRefs)
                        await $_getPrefetchedData<
                          CardRow,
                          $CardRowsTable,
                          CardProgressRow
                        >(
                          currentTable: table,
                          referencedTable: $$CardRowsTableReferences
                              ._cardProgressRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).cardProgressRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (reviewEventRowsRefs)
                        await $_getPrefetchedData<
                          CardRow,
                          $CardRowsTable,
                          ReviewEventRow
                        >(
                          currentTable: table,
                          referencedTable: $$CardRowsTableReferences
                              ._reviewEventRowsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CardRowsTableReferences(
                                db,
                                table,
                                p0,
                              ).reviewEventRowsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.cardId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CardRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardRowsTable,
      CardRow,
      $$CardRowsTableFilterComposer,
      $$CardRowsTableOrderingComposer,
      $$CardRowsTableAnnotationComposer,
      $$CardRowsTableCreateCompanionBuilder,
      $$CardRowsTableUpdateCompanionBuilder,
      (CardRow, $$CardRowsTableReferences),
      CardRow,
      PrefetchHooks Function({
        bool deckId,
        bool cardProgressRowsRefs,
        bool reviewEventRowsRefs,
      })
    >;
typedef $$CardProgressRowsTableCreateCompanionBuilder =
    CardProgressRowsCompanion Function({
      required String cardId,
      required String direction,
      required int contentRevision,
      Value<int> consecutiveCorrect,
      Value<int> lapseCount,
      Value<int> totalCorrect,
      Value<int> totalWrong,
      Value<DateTime?> dueAt,
      Value<DateTime?> lastReviewedAt,
      Value<bool> needsRecovery,
      Value<int> rowid,
    });
typedef $$CardProgressRowsTableUpdateCompanionBuilder =
    CardProgressRowsCompanion Function({
      Value<String> cardId,
      Value<String> direction,
      Value<int> contentRevision,
      Value<int> consecutiveCorrect,
      Value<int> lapseCount,
      Value<int> totalCorrect,
      Value<int> totalWrong,
      Value<DateTime?> dueAt,
      Value<DateTime?> lastReviewedAt,
      Value<bool> needsRecovery,
      Value<int> rowid,
    });

final class $$CardProgressRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $CardProgressRowsTable, CardProgressRow> {
  $$CardProgressRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CardRowsTable _cardIdTable(_$AppDatabase db) =>
      db.cardRows.createAlias('card_progress_rows__card_id__card_rows__id');

  $$CardRowsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$CardRowsTableTableManager(
      $_db,
      $_db.cardRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CardProgressRowsTableFilterComposer
    extends Composer<_$AppDatabase, $CardProgressRowsTable> {
  $$CardProgressRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutiveCorrect => $composableBuilder(
    column: $table.consecutiveCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapseCount => $composableBuilder(
    column: $table.lapseCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalWrong => $composableBuilder(
    column: $table.totalWrong,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsRecovery => $composableBuilder(
    column: $table.needsRecovery,
    builder: (column) => ColumnFilters(column),
  );

  $$CardRowsTableFilterComposer get cardId {
    final $$CardRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cardRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardRowsTableFilterComposer(
            $db: $db,
            $table: $db.cardRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardProgressRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $CardProgressRowsTable> {
  $$CardProgressRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutiveCorrect => $composableBuilder(
    column: $table.consecutiveCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapseCount => $composableBuilder(
    column: $table.lapseCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalWrong => $composableBuilder(
    column: $table.totalWrong,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsRecovery => $composableBuilder(
    column: $table.needsRecovery,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardRowsTableOrderingComposer get cardId {
    final $$CardRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cardRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardRowsTableOrderingComposer(
            $db: $db,
            $table: $db.cardRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardProgressRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CardProgressRowsTable> {
  $$CardProgressRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<int> get contentRevision => $composableBuilder(
    column: $table.contentRevision,
    builder: (column) => column,
  );

  GeneratedColumn<int> get consecutiveCorrect => $composableBuilder(
    column: $table.consecutiveCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lapseCount => $composableBuilder(
    column: $table.lapseCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCorrect => $composableBuilder(
    column: $table.totalCorrect,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalWrong => $composableBuilder(
    column: $table.totalWrong,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsRecovery => $composableBuilder(
    column: $table.needsRecovery,
    builder: (column) => column,
  );

  $$CardRowsTableAnnotationComposer get cardId {
    final $$CardRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cardRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CardProgressRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CardProgressRowsTable,
          CardProgressRow,
          $$CardProgressRowsTableFilterComposer,
          $$CardProgressRowsTableOrderingComposer,
          $$CardProgressRowsTableAnnotationComposer,
          $$CardProgressRowsTableCreateCompanionBuilder,
          $$CardProgressRowsTableUpdateCompanionBuilder,
          (CardProgressRow, $$CardProgressRowsTableReferences),
          CardProgressRow,
          PrefetchHooks Function({bool cardId})
        > {
  $$CardProgressRowsTableTableManager(
    _$AppDatabase db,
    $CardProgressRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CardProgressRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CardProgressRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CardProgressRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> cardId = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<int> contentRevision = const Value.absent(),
                Value<int> consecutiveCorrect = const Value.absent(),
                Value<int> lapseCount = const Value.absent(),
                Value<int> totalCorrect = const Value.absent(),
                Value<int> totalWrong = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<bool> needsRecovery = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardProgressRowsCompanion(
                cardId: cardId,
                direction: direction,
                contentRevision: contentRevision,
                consecutiveCorrect: consecutiveCorrect,
                lapseCount: lapseCount,
                totalCorrect: totalCorrect,
                totalWrong: totalWrong,
                dueAt: dueAt,
                lastReviewedAt: lastReviewedAt,
                needsRecovery: needsRecovery,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String cardId,
                required String direction,
                required int contentRevision,
                Value<int> consecutiveCorrect = const Value.absent(),
                Value<int> lapseCount = const Value.absent(),
                Value<int> totalCorrect = const Value.absent(),
                Value<int> totalWrong = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<bool> needsRecovery = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CardProgressRowsCompanion.insert(
                cardId: cardId,
                direction: direction,
                contentRevision: contentRevision,
                consecutiveCorrect: consecutiveCorrect,
                lapseCount: lapseCount,
                totalCorrect: totalCorrect,
                totalWrong: totalWrong,
                dueAt: dueAt,
                lastReviewedAt: lastReviewedAt,
                needsRecovery: needsRecovery,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CardProgressRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cardId,
                                referencedTable:
                                    $$CardProgressRowsTableReferences
                                        ._cardIdTable(db),
                                referencedColumn:
                                    $$CardProgressRowsTableReferences
                                        ._cardIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CardProgressRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CardProgressRowsTable,
      CardProgressRow,
      $$CardProgressRowsTableFilterComposer,
      $$CardProgressRowsTableOrderingComposer,
      $$CardProgressRowsTableAnnotationComposer,
      $$CardProgressRowsTableCreateCompanionBuilder,
      $$CardProgressRowsTableUpdateCompanionBuilder,
      (CardProgressRow, $$CardProgressRowsTableReferences),
      CardProgressRow,
      PrefetchHooks Function({bool cardId})
    >;
typedef $$ReviewEventRowsTableCreateCompanionBuilder =
    ReviewEventRowsCompanion Function({
      required String id,
      required String sessionId,
      required String cardId,
      required String direction,
      required String grade,
      required bool isRetry,
      required DateTime reviewedAt,
      Value<int> rowid,
    });
typedef $$ReviewEventRowsTableUpdateCompanionBuilder =
    ReviewEventRowsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String> cardId,
      Value<String> direction,
      Value<String> grade,
      Value<bool> isRetry,
      Value<DateTime> reviewedAt,
      Value<int> rowid,
    });

final class $$ReviewEventRowsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ReviewEventRowsTable, ReviewEventRow> {
  $$ReviewEventRowsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CardRowsTable _cardIdTable(_$AppDatabase db) =>
      db.cardRows.createAlias('review_event_rows__card_id__card_rows__id');

  $$CardRowsTableProcessedTableManager get cardId {
    final $_column = $_itemColumn<String>('card_id')!;

    final manager = $$CardRowsTableTableManager(
      $_db,
      $_db.cardRows,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cardIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ReviewEventRowsTableFilterComposer
    extends Composer<_$AppDatabase, $ReviewEventRowsTable> {
  $$ReviewEventRowsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isRetry => $composableBuilder(
    column: $table.isRetry,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CardRowsTableFilterComposer get cardId {
    final $$CardRowsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cardRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardRowsTableFilterComposer(
            $db: $db,
            $table: $db.cardRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewEventRowsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReviewEventRowsTable> {
  $$ReviewEventRowsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get direction => $composableBuilder(
    column: $table.direction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grade => $composableBuilder(
    column: $table.grade,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isRetry => $composableBuilder(
    column: $table.isRetry,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CardRowsTableOrderingComposer get cardId {
    final $$CardRowsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cardRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardRowsTableOrderingComposer(
            $db: $db,
            $table: $db.cardRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewEventRowsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReviewEventRowsTable> {
  $$ReviewEventRowsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get direction =>
      $composableBuilder(column: $table.direction, builder: (column) => column);

  GeneratedColumn<String> get grade =>
      $composableBuilder(column: $table.grade, builder: (column) => column);

  GeneratedColumn<bool> get isRetry =>
      $composableBuilder(column: $table.isRetry, builder: (column) => column);

  GeneratedColumn<DateTime> get reviewedAt => $composableBuilder(
    column: $table.reviewedAt,
    builder: (column) => column,
  );

  $$CardRowsTableAnnotationComposer get cardId {
    final $$CardRowsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cardId,
      referencedTable: $db.cardRows,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CardRowsTableAnnotationComposer(
            $db: $db,
            $table: $db.cardRows,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ReviewEventRowsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReviewEventRowsTable,
          ReviewEventRow,
          $$ReviewEventRowsTableFilterComposer,
          $$ReviewEventRowsTableOrderingComposer,
          $$ReviewEventRowsTableAnnotationComposer,
          $$ReviewEventRowsTableCreateCompanionBuilder,
          $$ReviewEventRowsTableUpdateCompanionBuilder,
          (ReviewEventRow, $$ReviewEventRowsTableReferences),
          ReviewEventRow,
          PrefetchHooks Function({bool cardId})
        > {
  $$ReviewEventRowsTableTableManager(
    _$AppDatabase db,
    $ReviewEventRowsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReviewEventRowsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReviewEventRowsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReviewEventRowsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String> cardId = const Value.absent(),
                Value<String> direction = const Value.absent(),
                Value<String> grade = const Value.absent(),
                Value<bool> isRetry = const Value.absent(),
                Value<DateTime> reviewedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReviewEventRowsCompanion(
                id: id,
                sessionId: sessionId,
                cardId: cardId,
                direction: direction,
                grade: grade,
                isRetry: isRetry,
                reviewedAt: reviewedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required String cardId,
                required String direction,
                required String grade,
                required bool isRetry,
                required DateTime reviewedAt,
                Value<int> rowid = const Value.absent(),
              }) => ReviewEventRowsCompanion.insert(
                id: id,
                sessionId: sessionId,
                cardId: cardId,
                direction: direction,
                grade: grade,
                isRetry: isRetry,
                reviewedAt: reviewedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ReviewEventRowsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cardId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (cardId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.cardId,
                                referencedTable:
                                    $$ReviewEventRowsTableReferences
                                        ._cardIdTable(db),
                                referencedColumn:
                                    $$ReviewEventRowsTableReferences
                                        ._cardIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ReviewEventRowsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReviewEventRowsTable,
      ReviewEventRow,
      $$ReviewEventRowsTableFilterComposer,
      $$ReviewEventRowsTableOrderingComposer,
      $$ReviewEventRowsTableAnnotationComposer,
      $$ReviewEventRowsTableCreateCompanionBuilder,
      $$ReviewEventRowsTableUpdateCompanionBuilder,
      (ReviewEventRow, $$ReviewEventRowsTableReferences),
      ReviewEventRow,
      PrefetchHooks Function({bool cardId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$DeckRowsTableTableManager get deckRows =>
      $$DeckRowsTableTableManager(_db, _db.deckRows);
  $$CardRowsTableTableManager get cardRows =>
      $$CardRowsTableTableManager(_db, _db.cardRows);
  $$CardProgressRowsTableTableManager get cardProgressRows =>
      $$CardProgressRowsTableTableManager(_db, _db.cardProgressRows);
  $$ReviewEventRowsTableTableManager get reviewEventRows =>
      $$ReviewEventRowsTableTableManager(_db, _db.reviewEventRows);
}
