// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $MembersTable extends Members with TableInfo<$MembersTable, Member> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pausedMeta = const VerificationMeta('paused');
  @override
  late final GeneratedColumn<bool> paused = GeneratedColumn<bool>(
    'paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    name,
    color,
    paused,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'members';
  @override
  VerificationContext validateIntegrity(
    Insertable<Member> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('paused')) {
      context.handle(
        _pausedMeta,
        paused.isAcceptableOrUnknown(data['paused']!, _pausedMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Member map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Member(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      paused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paused'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $MembersTable createAlias(String alias) {
    return $MembersTable(attachedDatabase, alias);
  }
}

class Member extends DataClass implements Insertable<Member> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String name;
  final int color;

  /// Pausiert (Urlaub): wird bei „reihum“ übersprungen.
  final bool paused;
  final int sortOrder;
  const Member({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.name,
    required this.color,
    required this.paused,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['paused'] = Variable<bool>(paused);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  MembersCompanion toCompanion(bool nullToAbsent) {
    return MembersCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      name: Value(name),
      color: Value(color),
      paused: Value(paused),
      sortOrder: Value(sortOrder),
    );
  }

  factory Member.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Member(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      paused: serializer.fromJson<bool>(json['paused']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'paused': serializer.toJson<bool>(paused),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Member copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? name,
    int? color,
    bool? paused,
    int? sortOrder,
  }) => Member(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    color: color ?? this.color,
    paused: paused ?? this.paused,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Member copyWithCompanion(MembersCompanion data) {
    return Member(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      paused: data.paused.present ? data.paused.value : this.paused,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Member(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('paused: $paused, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, seq, deleted, name, color, paused, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Member &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.color == this.color &&
          other.paused == this.paused &&
          other.sortOrder == this.sortOrder);
}

class MembersCompanion extends UpdateCompanion<Member> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<int> color;
  final Value<bool> paused;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const MembersCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.paused = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MembersCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String name,
    required int color,
    this.paused = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       name = Value(name),
       color = Value(color);
  static Insertable<Member> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<int>? color,
    Expression<bool>? paused,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (paused != null) 'paused': paused,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MembersCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? name,
    Value<int>? color,
    Value<bool>? paused,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return MembersCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      color: color ?? this.color,
      paused: paused ?? this.paused,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (paused.present) {
      map['paused'] = Variable<bool>(paused.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MembersCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('paused: $paused, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoresTable extends Stores with TableInfo<$StoresTable, Store> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    name,
    color,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Store> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Store map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Store(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $StoresTable createAlias(String alias) {
    return $StoresTable(attachedDatabase, alias);
  }
}

class Store extends DataClass implements Insertable<Store> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String name;
  final int color;
  final int sortOrder;
  const Store({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.name,
    required this.color,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  StoresCompanion toCompanion(bool nullToAbsent) {
    return StoresCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      name: Value(name),
      color: Value(color),
      sortOrder: Value(sortOrder),
    );
  }

  factory Store.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Store(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Store copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? name,
    int? color,
    int? sortOrder,
  }) => Store(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    color: color ?? this.color,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Store copyWithCompanion(StoresCompanion data) {
    return Store(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Store(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, seq, deleted, name, color, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Store &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.color == this.color &&
          other.sortOrder == this.sortOrder);
}

class StoresCompanion extends UpdateCompanion<Store> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<int> color;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const StoresCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoresCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String name,
    required int color,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       name = Value(name),
       color = Value(color);
  static Insertable<Store> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoresCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? name,
    Value<int>? color,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return StoresCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      color: color ?? this.color,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoresCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DepartmentsTable extends Departments
    with TableInfo<$DepartmentsTable, Department> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DepartmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    name,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'departments';
  @override
  VerificationContext validateIntegrity(
    Insertable<Department> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Department map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Department(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DepartmentsTable createAlias(String alias) {
    return $DepartmentsTable(attachedDatabase, alias);
  }
}

class Department extends DataClass implements Insertable<Department> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;

  /// `null` bei eingebauten Abteilungen → Name aus der Übersetzung.
  final String? name;
  final int sortOrder;
  const Department({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DepartmentsCompanion toCompanion(bool nullToAbsent) {
    return DepartmentsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory Department.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Department(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String?>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String?>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Department copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    Value<String?> name = const Value.absent(),
    int? sortOrder,
  }) => Department(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    name: name.present ? name.value : this.name,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Department copyWithCompanion(DepartmentsCompanion data) {
    return Department(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Department(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, updatedAt, seq, deleted, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Department &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class DepartmentsCompanion extends UpdateCompanion<Department> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String?> name;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DepartmentsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DepartmentsCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq);
  static Insertable<Department> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DepartmentsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String?>? name,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DepartmentsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DepartmentsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StoreDepartmentOrdersTable extends StoreDepartmentOrders
    with TableInfo<$StoreDepartmentOrdersTable, StoreDepartmentOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StoreDepartmentOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _storeIdMeta = const VerificationMeta(
    'storeId',
  );
  @override
  late final GeneratedColumn<String> storeId = GeneratedColumn<String>(
    'store_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<double> position = GeneratedColumn<double>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    storeId,
    departmentId,
    position,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'store_department_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<StoreDepartmentOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('store_id')) {
      context.handle(
        _storeIdMeta,
        storeId.isAcceptableOrUnknown(data['store_id']!, _storeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_storeIdMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StoreDepartmentOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StoreDepartmentOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      storeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_id'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}position'],
      )!,
    );
  }

  @override
  $StoreDepartmentOrdersTable createAlias(String alias) {
    return $StoreDepartmentOrdersTable(attachedDatabase, alias);
  }
}

class StoreDepartmentOrder extends DataClass
    implements Insertable<StoreDepartmentOrder> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String storeId;
  final String departmentId;
  final double position;
  const StoreDepartmentOrder({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.storeId,
    required this.departmentId,
    required this.position,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['store_id'] = Variable<String>(storeId);
    map['department_id'] = Variable<String>(departmentId);
    map['position'] = Variable<double>(position);
    return map;
  }

  StoreDepartmentOrdersCompanion toCompanion(bool nullToAbsent) {
    return StoreDepartmentOrdersCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      storeId: Value(storeId),
      departmentId: Value(departmentId),
      position: Value(position),
    );
  }

  factory StoreDepartmentOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StoreDepartmentOrder(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      storeId: serializer.fromJson<String>(json['storeId']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      position: serializer.fromJson<double>(json['position']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'storeId': serializer.toJson<String>(storeId),
      'departmentId': serializer.toJson<String>(departmentId),
      'position': serializer.toJson<double>(position),
    };
  }

  StoreDepartmentOrder copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? storeId,
    String? departmentId,
    double? position,
  }) => StoreDepartmentOrder(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    storeId: storeId ?? this.storeId,
    departmentId: departmentId ?? this.departmentId,
    position: position ?? this.position,
  );
  StoreDepartmentOrder copyWithCompanion(StoreDepartmentOrdersCompanion data) {
    return StoreDepartmentOrder(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      storeId: data.storeId.present ? data.storeId.value : this.storeId,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      position: data.position.present ? data.position.value : this.position,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StoreDepartmentOrder(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('storeId: $storeId, ')
          ..write('departmentId: $departmentId, ')
          ..write('position: $position')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, seq, deleted, storeId, departmentId, position);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StoreDepartmentOrder &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.storeId == this.storeId &&
          other.departmentId == this.departmentId &&
          other.position == this.position);
}

class StoreDepartmentOrdersCompanion
    extends UpdateCompanion<StoreDepartmentOrder> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> storeId;
  final Value<String> departmentId;
  final Value<double> position;
  final Value<int> rowid;
  const StoreDepartmentOrdersCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.storeId = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.position = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StoreDepartmentOrdersCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String storeId,
    required String departmentId,
    required double position,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       storeId = Value(storeId),
       departmentId = Value(departmentId),
       position = Value(position);
  static Insertable<StoreDepartmentOrder> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? storeId,
    Expression<String>? departmentId,
    Expression<double>? position,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (storeId != null) 'store_id': storeId,
      if (departmentId != null) 'department_id': departmentId,
      if (position != null) 'position': position,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StoreDepartmentOrdersCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? storeId,
    Value<String>? departmentId,
    Value<double>? position,
    Value<int>? rowid,
  }) {
    return StoreDepartmentOrdersCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      storeId: storeId ?? this.storeId,
      departmentId: departmentId ?? this.departmentId,
      position: position ?? this.position,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (storeId.present) {
      map['store_id'] = Variable<String>(storeId.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (position.present) {
      map['position'] = Variable<double>(position.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StoreDepartmentOrdersCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('storeId: $storeId, ')
          ..write('departmentId: $departmentId, ')
          ..write('position: $position, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _normalizedMeta = const VerificationMeta(
    'normalized',
  );
  @override
  late final GeneratedColumn<String> normalized = GeneratedColumn<String>(
    'normalized',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeIdsMeta = const VerificationMeta(
    'storeIds',
  );
  @override
  late final GeneratedColumn<String> storeIds = GeneratedColumn<String>(
    'store_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<int> status = GeneratedColumn<int>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _addedByMeta = const VerificationMeta(
    'addedBy',
  );
  @override
  late final GeneratedColumn<String> addedBy = GeneratedColumn<String>(
    'added_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<int> doneAt = GeneratedColumn<int>(
    'done_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneStoreIdMeta = const VerificationMeta(
    'doneStoreId',
  );
  @override
  late final GeneratedColumn<String> doneStoreId = GeneratedColumn<String>(
    'done_store_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    name,
    normalized,
    amount,
    unit,
    note,
    departmentId,
    storeIds,
    status,
    addedBy,
    source,
    createdAt,
    doneAt,
    doneStoreId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('normalized')) {
      context.handle(
        _normalizedMeta,
        normalized.isAcceptableOrUnknown(data['normalized']!, _normalizedMeta),
      );
    } else if (isInserting) {
      context.missing(_normalizedMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('store_ids')) {
      context.handle(
        _storeIdsMeta,
        storeIds.isAcceptableOrUnknown(data['store_ids']!, _storeIdsMeta),
      );
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('added_by')) {
      context.handle(
        _addedByMeta,
        addedBy.isAcceptableOrUnknown(data['added_by']!, _addedByMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
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
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    }
    if (data.containsKey('done_store_id')) {
      context.handle(
        _doneStoreIdMeta,
        doneStoreId.isAcceptableOrUnknown(
          data['done_store_id']!,
          _doneStoreIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      normalized: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}normalized'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      ),
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      storeIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_ids'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}status'],
      )!,
      addedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}added_by'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_at'],
      ),
      doneStoreId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}done_store_id'],
      ),
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String name;

  /// `TextNorm.key(name)` — für Zusammenführen und Historie.
  final String normalized;
  final double? amount;
  final String? unit;
  final String? note;
  final String departmentId;

  /// Kommagetrennte Laden-IDs; leer = egal.
  final String storeIds;

  /// `ItemStatus`-Index (offen, erledigt, gab's nicht).
  final int status;
  final String? addedBy;

  /// Herkunft, z. B. „Lasagne (Do)“, wenn aus einem Rezept.
  final String? source;
  final int createdAt;
  final int? doneAt;
  final String? doneStoreId;
  const ShoppingItem({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.name,
    required this.normalized,
    this.amount,
    this.unit,
    this.note,
    required this.departmentId,
    required this.storeIds,
    required this.status,
    this.addedBy,
    this.source,
    required this.createdAt,
    this.doneAt,
    this.doneStoreId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['normalized'] = Variable<String>(normalized);
    if (!nullToAbsent || amount != null) {
      map['amount'] = Variable<double>(amount);
    }
    if (!nullToAbsent || unit != null) {
      map['unit'] = Variable<String>(unit);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['department_id'] = Variable<String>(departmentId);
    map['store_ids'] = Variable<String>(storeIds);
    map['status'] = Variable<int>(status);
    if (!nullToAbsent || addedBy != null) {
      map['added_by'] = Variable<String>(addedBy);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || doneAt != null) {
      map['done_at'] = Variable<int>(doneAt);
    }
    if (!nullToAbsent || doneStoreId != null) {
      map['done_store_id'] = Variable<String>(doneStoreId);
    }
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      name: Value(name),
      normalized: Value(normalized),
      amount: amount == null && nullToAbsent
          ? const Value.absent()
          : Value(amount),
      unit: unit == null && nullToAbsent ? const Value.absent() : Value(unit),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      departmentId: Value(departmentId),
      storeIds: Value(storeIds),
      status: Value(status),
      addedBy: addedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(addedBy),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      createdAt: Value(createdAt),
      doneAt: doneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(doneAt),
      doneStoreId: doneStoreId == null && nullToAbsent
          ? const Value.absent()
          : Value(doneStoreId),
    );
  }

  factory ShoppingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      normalized: serializer.fromJson<String>(json['normalized']),
      amount: serializer.fromJson<double?>(json['amount']),
      unit: serializer.fromJson<String?>(json['unit']),
      note: serializer.fromJson<String?>(json['note']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      storeIds: serializer.fromJson<String>(json['storeIds']),
      status: serializer.fromJson<int>(json['status']),
      addedBy: serializer.fromJson<String?>(json['addedBy']),
      source: serializer.fromJson<String?>(json['source']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      doneAt: serializer.fromJson<int?>(json['doneAt']),
      doneStoreId: serializer.fromJson<String?>(json['doneStoreId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'normalized': serializer.toJson<String>(normalized),
      'amount': serializer.toJson<double?>(amount),
      'unit': serializer.toJson<String?>(unit),
      'note': serializer.toJson<String?>(note),
      'departmentId': serializer.toJson<String>(departmentId),
      'storeIds': serializer.toJson<String>(storeIds),
      'status': serializer.toJson<int>(status),
      'addedBy': serializer.toJson<String?>(addedBy),
      'source': serializer.toJson<String?>(source),
      'createdAt': serializer.toJson<int>(createdAt),
      'doneAt': serializer.toJson<int?>(doneAt),
      'doneStoreId': serializer.toJson<String?>(doneStoreId),
    };
  }

  ShoppingItem copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? name,
    String? normalized,
    Value<double?> amount = const Value.absent(),
    Value<String?> unit = const Value.absent(),
    Value<String?> note = const Value.absent(),
    String? departmentId,
    String? storeIds,
    int? status,
    Value<String?> addedBy = const Value.absent(),
    Value<String?> source = const Value.absent(),
    int? createdAt,
    Value<int?> doneAt = const Value.absent(),
    Value<String?> doneStoreId = const Value.absent(),
  }) => ShoppingItem(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    normalized: normalized ?? this.normalized,
    amount: amount.present ? amount.value : this.amount,
    unit: unit.present ? unit.value : this.unit,
    note: note.present ? note.value : this.note,
    departmentId: departmentId ?? this.departmentId,
    storeIds: storeIds ?? this.storeIds,
    status: status ?? this.status,
    addedBy: addedBy.present ? addedBy.value : this.addedBy,
    source: source.present ? source.value : this.source,
    createdAt: createdAt ?? this.createdAt,
    doneAt: doneAt.present ? doneAt.value : this.doneAt,
    doneStoreId: doneStoreId.present ? doneStoreId.value : this.doneStoreId,
  );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      normalized: data.normalized.present
          ? data.normalized.value
          : this.normalized,
      amount: data.amount.present ? data.amount.value : this.amount,
      unit: data.unit.present ? data.unit.value : this.unit,
      note: data.note.present ? data.note.value : this.note,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      storeIds: data.storeIds.present ? data.storeIds.value : this.storeIds,
      status: data.status.present ? data.status.value : this.status,
      addedBy: data.addedBy.present ? data.addedBy.value : this.addedBy,
      source: data.source.present ? data.source.value : this.source,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      doneStoreId: data.doneStoreId.present
          ? data.doneStoreId.value
          : this.doneStoreId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('normalized: $normalized, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('departmentId: $departmentId, ')
          ..write('storeIds: $storeIds, ')
          ..write('status: $status, ')
          ..write('addedBy: $addedBy, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('doneAt: $doneAt, ')
          ..write('doneStoreId: $doneStoreId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    seq,
    deleted,
    name,
    normalized,
    amount,
    unit,
    note,
    departmentId,
    storeIds,
    status,
    addedBy,
    source,
    createdAt,
    doneAt,
    doneStoreId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.normalized == this.normalized &&
          other.amount == this.amount &&
          other.unit == this.unit &&
          other.note == this.note &&
          other.departmentId == this.departmentId &&
          other.storeIds == this.storeIds &&
          other.status == this.status &&
          other.addedBy == this.addedBy &&
          other.source == this.source &&
          other.createdAt == this.createdAt &&
          other.doneAt == this.doneAt &&
          other.doneStoreId == this.doneStoreId);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<String> normalized;
  final Value<double?> amount;
  final Value<String?> unit;
  final Value<String?> note;
  final Value<String> departmentId;
  final Value<String> storeIds;
  final Value<int> status;
  final Value<String?> addedBy;
  final Value<String?> source;
  final Value<int> createdAt;
  final Value<int?> doneAt;
  final Value<String?> doneStoreId;
  final Value<int> rowid;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.normalized = const Value.absent(),
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.storeIds = const Value.absent(),
    this.status = const Value.absent(),
    this.addedBy = const Value.absent(),
    this.source = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.doneStoreId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String name,
    required String normalized,
    this.amount = const Value.absent(),
    this.unit = const Value.absent(),
    this.note = const Value.absent(),
    required String departmentId,
    this.storeIds = const Value.absent(),
    this.status = const Value.absent(),
    this.addedBy = const Value.absent(),
    this.source = const Value.absent(),
    required int createdAt,
    this.doneAt = const Value.absent(),
    this.doneStoreId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       name = Value(name),
       normalized = Value(normalized),
       departmentId = Value(departmentId),
       createdAt = Value(createdAt);
  static Insertable<ShoppingItem> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<String>? normalized,
    Expression<double>? amount,
    Expression<String>? unit,
    Expression<String>? note,
    Expression<String>? departmentId,
    Expression<String>? storeIds,
    Expression<int>? status,
    Expression<String>? addedBy,
    Expression<String>? source,
    Expression<int>? createdAt,
    Expression<int>? doneAt,
    Expression<String>? doneStoreId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (normalized != null) 'normalized': normalized,
      if (amount != null) 'amount': amount,
      if (unit != null) 'unit': unit,
      if (note != null) 'note': note,
      if (departmentId != null) 'department_id': departmentId,
      if (storeIds != null) 'store_ids': storeIds,
      if (status != null) 'status': status,
      if (addedBy != null) 'added_by': addedBy,
      if (source != null) 'source': source,
      if (createdAt != null) 'created_at': createdAt,
      if (doneAt != null) 'done_at': doneAt,
      if (doneStoreId != null) 'done_store_id': doneStoreId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ShoppingItemsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? name,
    Value<String>? normalized,
    Value<double?>? amount,
    Value<String?>? unit,
    Value<String?>? note,
    Value<String>? departmentId,
    Value<String>? storeIds,
    Value<int>? status,
    Value<String?>? addedBy,
    Value<String?>? source,
    Value<int>? createdAt,
    Value<int?>? doneAt,
    Value<String?>? doneStoreId,
    Value<int>? rowid,
  }) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      normalized: normalized ?? this.normalized,
      amount: amount ?? this.amount,
      unit: unit ?? this.unit,
      note: note ?? this.note,
      departmentId: departmentId ?? this.departmentId,
      storeIds: storeIds ?? this.storeIds,
      status: status ?? this.status,
      addedBy: addedBy ?? this.addedBy,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      doneAt: doneAt ?? this.doneAt,
      doneStoreId: doneStoreId ?? this.doneStoreId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (normalized.present) {
      map['normalized'] = Variable<String>(normalized.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (storeIds.present) {
      map['store_ids'] = Variable<String>(storeIds.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(status.value);
    }
    if (addedBy.present) {
      map['added_by'] = Variable<String>(addedBy.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<int>(doneAt.value);
    }
    if (doneStoreId.present) {
      map['done_store_id'] = Variable<String>(doneStoreId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('normalized: $normalized, ')
          ..write('amount: $amount, ')
          ..write('unit: $unit, ')
          ..write('note: $note, ')
          ..write('departmentId: $departmentId, ')
          ..write('storeIds: $storeIds, ')
          ..write('status: $status, ')
          ..write('addedBy: $addedBy, ')
          ..write('source: $source, ')
          ..write('createdAt: $createdAt, ')
          ..write('doneAt: $doneAt, ')
          ..write('doneStoreId: $doneStoreId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProductMemoriesTable extends ProductMemories
    with TableInfo<$ProductMemoriesTable, ProductMemory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProductMemoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _departmentIdMeta = const VerificationMeta(
    'departmentId',
  );
  @override
  late final GeneratedColumn<String> departmentId = GeneratedColumn<String>(
    'department_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _storeCountsMeta = const VerificationMeta(
    'storeCounts',
  );
  @override
  late final GeneratedColumn<String> storeCounts = GeneratedColumn<String>(
    'store_counts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _usageCountMeta = const VerificationMeta(
    'usageCount',
  );
  @override
  late final GeneratedColumn<int> usageCount = GeneratedColumn<int>(
    'usage_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastBoughtAtMeta = const VerificationMeta(
    'lastBoughtAt',
  );
  @override
  late final GeneratedColumn<int> lastBoughtAt = GeneratedColumn<int>(
    'last_bought_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgIntervalDaysMeta = const VerificationMeta(
    'avgIntervalDays',
  );
  @override
  late final GeneratedColumn<double> avgIntervalDays = GeneratedColumn<double>(
    'avg_interval_days',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stapleMeta = const VerificationMeta('staple');
  @override
  late final GeneratedColumn<bool> staple = GeneratedColumn<bool>(
    'staple',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("staple" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    name,
    departmentId,
    storeCounts,
    usageCount,
    lastBoughtAt,
    avgIntervalDays,
    staple,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'product_memories';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProductMemory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('department_id')) {
      context.handle(
        _departmentIdMeta,
        departmentId.isAcceptableOrUnknown(
          data['department_id']!,
          _departmentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_departmentIdMeta);
    }
    if (data.containsKey('store_counts')) {
      context.handle(
        _storeCountsMeta,
        storeCounts.isAcceptableOrUnknown(
          data['store_counts']!,
          _storeCountsMeta,
        ),
      );
    }
    if (data.containsKey('usage_count')) {
      context.handle(
        _usageCountMeta,
        usageCount.isAcceptableOrUnknown(data['usage_count']!, _usageCountMeta),
      );
    }
    if (data.containsKey('last_bought_at')) {
      context.handle(
        _lastBoughtAtMeta,
        lastBoughtAt.isAcceptableOrUnknown(
          data['last_bought_at']!,
          _lastBoughtAtMeta,
        ),
      );
    }
    if (data.containsKey('avg_interval_days')) {
      context.handle(
        _avgIntervalDaysMeta,
        avgIntervalDays.isAcceptableOrUnknown(
          data['avg_interval_days']!,
          _avgIntervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('staple')) {
      context.handle(
        _stapleMeta,
        staple.isAcceptableOrUnknown(data['staple']!, _stapleMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProductMemory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProductMemory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      departmentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}department_id'],
      )!,
      storeCounts: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}store_counts'],
      )!,
      usageCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}usage_count'],
      )!,
      lastBoughtAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_bought_at'],
      ),
      avgIntervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_interval_days'],
      ),
      staple: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}staple'],
      )!,
    );
  }

  @override
  $ProductMemoriesTable createAlias(String alias) {
    return $ProductMemoriesTable(attachedDatabase, alias);
  }
}

class ProductMemory extends DataClass implements Insertable<ProductMemory> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String name;
  final String departmentId;

  /// Laden-ID → Anzahl Käufe dort, als `id:n,id:n`.
  final String storeCounts;
  final int usageCount;
  final int? lastBoughtAt;

  /// Gleitender Mittelwert der Tage zwischen zwei Käufen.
  final double? avgIntervalDays;

  /// „Immer da haben“ (Vorrat) — Vorschlag, wenn lange nicht gekauft.
  final bool staple;
  const ProductMemory({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.name,
    required this.departmentId,
    required this.storeCounts,
    required this.usageCount,
    this.lastBoughtAt,
    this.avgIntervalDays,
    required this.staple,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['department_id'] = Variable<String>(departmentId);
    map['store_counts'] = Variable<String>(storeCounts);
    map['usage_count'] = Variable<int>(usageCount);
    if (!nullToAbsent || lastBoughtAt != null) {
      map['last_bought_at'] = Variable<int>(lastBoughtAt);
    }
    if (!nullToAbsent || avgIntervalDays != null) {
      map['avg_interval_days'] = Variable<double>(avgIntervalDays);
    }
    map['staple'] = Variable<bool>(staple);
    return map;
  }

  ProductMemoriesCompanion toCompanion(bool nullToAbsent) {
    return ProductMemoriesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      name: Value(name),
      departmentId: Value(departmentId),
      storeCounts: Value(storeCounts),
      usageCount: Value(usageCount),
      lastBoughtAt: lastBoughtAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBoughtAt),
      avgIntervalDays: avgIntervalDays == null && nullToAbsent
          ? const Value.absent()
          : Value(avgIntervalDays),
      staple: Value(staple),
    );
  }

  factory ProductMemory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProductMemory(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      departmentId: serializer.fromJson<String>(json['departmentId']),
      storeCounts: serializer.fromJson<String>(json['storeCounts']),
      usageCount: serializer.fromJson<int>(json['usageCount']),
      lastBoughtAt: serializer.fromJson<int?>(json['lastBoughtAt']),
      avgIntervalDays: serializer.fromJson<double?>(json['avgIntervalDays']),
      staple: serializer.fromJson<bool>(json['staple']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'departmentId': serializer.toJson<String>(departmentId),
      'storeCounts': serializer.toJson<String>(storeCounts),
      'usageCount': serializer.toJson<int>(usageCount),
      'lastBoughtAt': serializer.toJson<int?>(lastBoughtAt),
      'avgIntervalDays': serializer.toJson<double?>(avgIntervalDays),
      'staple': serializer.toJson<bool>(staple),
    };
  }

  ProductMemory copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? name,
    String? departmentId,
    String? storeCounts,
    int? usageCount,
    Value<int?> lastBoughtAt = const Value.absent(),
    Value<double?> avgIntervalDays = const Value.absent(),
    bool? staple,
  }) => ProductMemory(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    departmentId: departmentId ?? this.departmentId,
    storeCounts: storeCounts ?? this.storeCounts,
    usageCount: usageCount ?? this.usageCount,
    lastBoughtAt: lastBoughtAt.present ? lastBoughtAt.value : this.lastBoughtAt,
    avgIntervalDays: avgIntervalDays.present
        ? avgIntervalDays.value
        : this.avgIntervalDays,
    staple: staple ?? this.staple,
  );
  ProductMemory copyWithCompanion(ProductMemoriesCompanion data) {
    return ProductMemory(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      departmentId: data.departmentId.present
          ? data.departmentId.value
          : this.departmentId,
      storeCounts: data.storeCounts.present
          ? data.storeCounts.value
          : this.storeCounts,
      usageCount: data.usageCount.present
          ? data.usageCount.value
          : this.usageCount,
      lastBoughtAt: data.lastBoughtAt.present
          ? data.lastBoughtAt.value
          : this.lastBoughtAt,
      avgIntervalDays: data.avgIntervalDays.present
          ? data.avgIntervalDays.value
          : this.avgIntervalDays,
      staple: data.staple.present ? data.staple.value : this.staple,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProductMemory(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('departmentId: $departmentId, ')
          ..write('storeCounts: $storeCounts, ')
          ..write('usageCount: $usageCount, ')
          ..write('lastBoughtAt: $lastBoughtAt, ')
          ..write('avgIntervalDays: $avgIntervalDays, ')
          ..write('staple: $staple')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    seq,
    deleted,
    name,
    departmentId,
    storeCounts,
    usageCount,
    lastBoughtAt,
    avgIntervalDays,
    staple,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProductMemory &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.departmentId == this.departmentId &&
          other.storeCounts == this.storeCounts &&
          other.usageCount == this.usageCount &&
          other.lastBoughtAt == this.lastBoughtAt &&
          other.avgIntervalDays == this.avgIntervalDays &&
          other.staple == this.staple);
}

class ProductMemoriesCompanion extends UpdateCompanion<ProductMemory> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<String> departmentId;
  final Value<String> storeCounts;
  final Value<int> usageCount;
  final Value<int?> lastBoughtAt;
  final Value<double?> avgIntervalDays;
  final Value<bool> staple;
  final Value<int> rowid;
  const ProductMemoriesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.departmentId = const Value.absent(),
    this.storeCounts = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.lastBoughtAt = const Value.absent(),
    this.avgIntervalDays = const Value.absent(),
    this.staple = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProductMemoriesCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String name,
    required String departmentId,
    this.storeCounts = const Value.absent(),
    this.usageCount = const Value.absent(),
    this.lastBoughtAt = const Value.absent(),
    this.avgIntervalDays = const Value.absent(),
    this.staple = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       name = Value(name),
       departmentId = Value(departmentId);
  static Insertable<ProductMemory> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<String>? departmentId,
    Expression<String>? storeCounts,
    Expression<int>? usageCount,
    Expression<int>? lastBoughtAt,
    Expression<double>? avgIntervalDays,
    Expression<bool>? staple,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (departmentId != null) 'department_id': departmentId,
      if (storeCounts != null) 'store_counts': storeCounts,
      if (usageCount != null) 'usage_count': usageCount,
      if (lastBoughtAt != null) 'last_bought_at': lastBoughtAt,
      if (avgIntervalDays != null) 'avg_interval_days': avgIntervalDays,
      if (staple != null) 'staple': staple,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProductMemoriesCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? name,
    Value<String>? departmentId,
    Value<String>? storeCounts,
    Value<int>? usageCount,
    Value<int?>? lastBoughtAt,
    Value<double?>? avgIntervalDays,
    Value<bool>? staple,
    Value<int>? rowid,
  }) {
    return ProductMemoriesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      departmentId: departmentId ?? this.departmentId,
      storeCounts: storeCounts ?? this.storeCounts,
      usageCount: usageCount ?? this.usageCount,
      lastBoughtAt: lastBoughtAt ?? this.lastBoughtAt,
      avgIntervalDays: avgIntervalDays ?? this.avgIntervalDays,
      staple: staple ?? this.staple,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (departmentId.present) {
      map['department_id'] = Variable<String>(departmentId.value);
    }
    if (storeCounts.present) {
      map['store_counts'] = Variable<String>(storeCounts.value);
    }
    if (usageCount.present) {
      map['usage_count'] = Variable<int>(usageCount.value);
    }
    if (lastBoughtAt.present) {
      map['last_bought_at'] = Variable<int>(lastBoughtAt.value);
    }
    if (avgIntervalDays.present) {
      map['avg_interval_days'] = Variable<double>(avgIntervalDays.value);
    }
    if (staple.present) {
      map['staple'] = Variable<bool>(staple.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProductMemoriesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('departmentId: $departmentId, ')
          ..write('storeCounts: $storeCounts, ')
          ..write('usageCount: $usageCount, ')
          ..write('lastBoughtAt: $lastBoughtAt, ')
          ..write('avgIntervalDays: $avgIntervalDays, ')
          ..write('staple: $staple, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AreasTable extends Areas with TableInfo<$AreasTable, Area> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AreasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    name,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'areas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Area> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Area map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Area(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $AreasTable createAlias(String alias) {
    return $AreasTable(attachedDatabase, alias);
  }
}

class Area extends DataClass implements Insertable<Area> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String? name;
  final int sortOrder;
  const Area({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    if (!nullToAbsent || name != null) {
      map['name'] = Variable<String>(name);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  AreasCompanion toCompanion(bool nullToAbsent) {
    return AreasCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      name: name == null && nullToAbsent ? const Value.absent() : Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory Area.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Area(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String?>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String?>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Area copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    Value<String?> name = const Value.absent(),
    int? sortOrder,
  }) => Area(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    name: name.present ? name.value : this.name,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  Area copyWithCompanion(AreasCompanion data) {
    return Area(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Area(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, updatedAt, seq, deleted, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Area &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class AreasCompanion extends UpdateCompanion<Area> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String?> name;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const AreasCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AreasCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq);
  static Insertable<Area> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AreasCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String?>? name,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return AreasCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AreasCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChoresTable extends Chores with TableInfo<$ChoresTable, Chore> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChoresTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _areaIdMeta = const VerificationMeta('areaId');
  @override
  late final GeneratedColumn<String> areaId = GeneratedColumn<String>(
    'area_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effortMinutesMeta = const VerificationMeta(
    'effortMinutes',
  );
  @override
  late final GeneratedColumn<int> effortMinutes = GeneratedColumn<int>(
    'effort_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _recurrenceMeta = const VerificationMeta(
    'recurrence',
  );
  @override
  late final GeneratedColumn<int> recurrence = GeneratedColumn<int>(
    'recurrence',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _weekdaysMeta = const VerificationMeta(
    'weekdays',
  );
  @override
  late final GeneratedColumn<int> weekdays = GeneratedColumn<int>(
    'weekdays',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _dueDateMeta = const VerificationMeta(
    'dueDate',
  );
  @override
  late final GeneratedColumn<int> dueDate = GeneratedColumn<int>(
    'due_date',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignmentMeta = const VerificationMeta(
    'assignment',
  );
  @override
  late final GeneratedColumn<int> assignment = GeneratedColumn<int>(
    'assignment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _assigneeIdMeta = const VerificationMeta(
    'assigneeId',
  );
  @override
  late final GeneratedColumn<String> assigneeId = GeneratedColumn<String>(
    'assignee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDoneAtMeta = const VerificationMeta(
    'lastDoneAt',
  );
  @override
  late final GeneratedColumn<int> lastDoneAt = GeneratedColumn<int>(
    'last_done_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastDoneByMeta = const VerificationMeta(
    'lastDoneBy',
  );
  @override
  late final GeneratedColumn<String> lastDoneBy = GeneratedColumn<String>(
    'last_done_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _snoozedUntilMeta = const VerificationMeta(
    'snoozedUntil',
  );
  @override
  late final GeneratedColumn<int> snoozedUntil = GeneratedColumn<int>(
    'snoozed_until',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _remindMeta = const VerificationMeta('remind');
  @override
  late final GeneratedColumn<bool> remind = GeneratedColumn<bool>(
    'remind',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("remind" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    name,
    areaId,
    effortMinutes,
    recurrence,
    intervalDays,
    weekdays,
    dueDate,
    assignment,
    assigneeId,
    lastDoneAt,
    lastDoneBy,
    snoozedUntil,
    remind,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chores';
  @override
  VerificationContext validateIntegrity(
    Insertable<Chore> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('area_id')) {
      context.handle(
        _areaIdMeta,
        areaId.isAcceptableOrUnknown(data['area_id']!, _areaIdMeta),
      );
    } else if (isInserting) {
      context.missing(_areaIdMeta);
    }
    if (data.containsKey('effort_minutes')) {
      context.handle(
        _effortMinutesMeta,
        effortMinutes.isAcceptableOrUnknown(
          data['effort_minutes']!,
          _effortMinutesMeta,
        ),
      );
    }
    if (data.containsKey('recurrence')) {
      context.handle(
        _recurrenceMeta,
        recurrence.isAcceptableOrUnknown(data['recurrence']!, _recurrenceMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('weekdays')) {
      context.handle(
        _weekdaysMeta,
        weekdays.isAcceptableOrUnknown(data['weekdays']!, _weekdaysMeta),
      );
    }
    if (data.containsKey('due_date')) {
      context.handle(
        _dueDateMeta,
        dueDate.isAcceptableOrUnknown(data['due_date']!, _dueDateMeta),
      );
    }
    if (data.containsKey('assignment')) {
      context.handle(
        _assignmentMeta,
        assignment.isAcceptableOrUnknown(data['assignment']!, _assignmentMeta),
      );
    }
    if (data.containsKey('assignee_id')) {
      context.handle(
        _assigneeIdMeta,
        assigneeId.isAcceptableOrUnknown(data['assignee_id']!, _assigneeIdMeta),
      );
    }
    if (data.containsKey('last_done_at')) {
      context.handle(
        _lastDoneAtMeta,
        lastDoneAt.isAcceptableOrUnknown(
          data['last_done_at']!,
          _lastDoneAtMeta,
        ),
      );
    }
    if (data.containsKey('last_done_by')) {
      context.handle(
        _lastDoneByMeta,
        lastDoneBy.isAcceptableOrUnknown(
          data['last_done_by']!,
          _lastDoneByMeta,
        ),
      );
    }
    if (data.containsKey('snoozed_until')) {
      context.handle(
        _snoozedUntilMeta,
        snoozedUntil.isAcceptableOrUnknown(
          data['snoozed_until']!,
          _snoozedUntilMeta,
        ),
      );
    }
    if (data.containsKey('remind')) {
      context.handle(
        _remindMeta,
        remind.isAcceptableOrUnknown(data['remind']!, _remindMeta),
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Chore map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Chore(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      areaId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}area_id'],
      )!,
      effortMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effort_minutes'],
      )!,
      recurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recurrence'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      weekdays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekdays'],
      )!,
      dueDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_date'],
      ),
      assignment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assignment'],
      )!,
      assigneeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assignee_id'],
      ),
      lastDoneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_done_at'],
      ),
      lastDoneBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_done_by'],
      ),
      snoozedUntil: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}snoozed_until'],
      ),
      remind: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}remind'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ChoresTable createAlias(String alias) {
    return $ChoresTable(attachedDatabase, alias);
  }
}

class Chore extends DataClass implements Insertable<Chore> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String name;
  final String areaId;
  final int effortMinutes;

  /// `Recurrence`-Index.
  final int recurrence;
  final int intervalDays;
  final int weekdays;
  final int? dueDate;

  /// `Assignment`-Index: niemand, Person, reihum.
  final int assignment;
  final String? assigneeId;
  final int? lastDoneAt;
  final String? lastDoneBy;
  final int? snoozedUntil;
  final bool remind;
  final int createdAt;
  const Chore({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.name,
    required this.areaId,
    required this.effortMinutes,
    required this.recurrence,
    required this.intervalDays,
    required this.weekdays,
    this.dueDate,
    required this.assignment,
    this.assigneeId,
    this.lastDoneAt,
    this.lastDoneBy,
    this.snoozedUntil,
    required this.remind,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['area_id'] = Variable<String>(areaId);
    map['effort_minutes'] = Variable<int>(effortMinutes);
    map['recurrence'] = Variable<int>(recurrence);
    map['interval_days'] = Variable<int>(intervalDays);
    map['weekdays'] = Variable<int>(weekdays);
    if (!nullToAbsent || dueDate != null) {
      map['due_date'] = Variable<int>(dueDate);
    }
    map['assignment'] = Variable<int>(assignment);
    if (!nullToAbsent || assigneeId != null) {
      map['assignee_id'] = Variable<String>(assigneeId);
    }
    if (!nullToAbsent || lastDoneAt != null) {
      map['last_done_at'] = Variable<int>(lastDoneAt);
    }
    if (!nullToAbsent || lastDoneBy != null) {
      map['last_done_by'] = Variable<String>(lastDoneBy);
    }
    if (!nullToAbsent || snoozedUntil != null) {
      map['snoozed_until'] = Variable<int>(snoozedUntil);
    }
    map['remind'] = Variable<bool>(remind);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  ChoresCompanion toCompanion(bool nullToAbsent) {
    return ChoresCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      name: Value(name),
      areaId: Value(areaId),
      effortMinutes: Value(effortMinutes),
      recurrence: Value(recurrence),
      intervalDays: Value(intervalDays),
      weekdays: Value(weekdays),
      dueDate: dueDate == null && nullToAbsent
          ? const Value.absent()
          : Value(dueDate),
      assignment: Value(assignment),
      assigneeId: assigneeId == null && nullToAbsent
          ? const Value.absent()
          : Value(assigneeId),
      lastDoneAt: lastDoneAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneAt),
      lastDoneBy: lastDoneBy == null && nullToAbsent
          ? const Value.absent()
          : Value(lastDoneBy),
      snoozedUntil: snoozedUntil == null && nullToAbsent
          ? const Value.absent()
          : Value(snoozedUntil),
      remind: Value(remind),
      createdAt: Value(createdAt),
    );
  }

  factory Chore.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Chore(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      areaId: serializer.fromJson<String>(json['areaId']),
      effortMinutes: serializer.fromJson<int>(json['effortMinutes']),
      recurrence: serializer.fromJson<int>(json['recurrence']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      weekdays: serializer.fromJson<int>(json['weekdays']),
      dueDate: serializer.fromJson<int?>(json['dueDate']),
      assignment: serializer.fromJson<int>(json['assignment']),
      assigneeId: serializer.fromJson<String?>(json['assigneeId']),
      lastDoneAt: serializer.fromJson<int?>(json['lastDoneAt']),
      lastDoneBy: serializer.fromJson<String?>(json['lastDoneBy']),
      snoozedUntil: serializer.fromJson<int?>(json['snoozedUntil']),
      remind: serializer.fromJson<bool>(json['remind']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'areaId': serializer.toJson<String>(areaId),
      'effortMinutes': serializer.toJson<int>(effortMinutes),
      'recurrence': serializer.toJson<int>(recurrence),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'weekdays': serializer.toJson<int>(weekdays),
      'dueDate': serializer.toJson<int?>(dueDate),
      'assignment': serializer.toJson<int>(assignment),
      'assigneeId': serializer.toJson<String?>(assigneeId),
      'lastDoneAt': serializer.toJson<int?>(lastDoneAt),
      'lastDoneBy': serializer.toJson<String?>(lastDoneBy),
      'snoozedUntil': serializer.toJson<int?>(snoozedUntil),
      'remind': serializer.toJson<bool>(remind),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  Chore copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? name,
    String? areaId,
    int? effortMinutes,
    int? recurrence,
    int? intervalDays,
    int? weekdays,
    Value<int?> dueDate = const Value.absent(),
    int? assignment,
    Value<String?> assigneeId = const Value.absent(),
    Value<int?> lastDoneAt = const Value.absent(),
    Value<String?> lastDoneBy = const Value.absent(),
    Value<int?> snoozedUntil = const Value.absent(),
    bool? remind,
    int? createdAt,
  }) => Chore(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    areaId: areaId ?? this.areaId,
    effortMinutes: effortMinutes ?? this.effortMinutes,
    recurrence: recurrence ?? this.recurrence,
    intervalDays: intervalDays ?? this.intervalDays,
    weekdays: weekdays ?? this.weekdays,
    dueDate: dueDate.present ? dueDate.value : this.dueDate,
    assignment: assignment ?? this.assignment,
    assigneeId: assigneeId.present ? assigneeId.value : this.assigneeId,
    lastDoneAt: lastDoneAt.present ? lastDoneAt.value : this.lastDoneAt,
    lastDoneBy: lastDoneBy.present ? lastDoneBy.value : this.lastDoneBy,
    snoozedUntil: snoozedUntil.present ? snoozedUntil.value : this.snoozedUntil,
    remind: remind ?? this.remind,
    createdAt: createdAt ?? this.createdAt,
  );
  Chore copyWithCompanion(ChoresCompanion data) {
    return Chore(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      areaId: data.areaId.present ? data.areaId.value : this.areaId,
      effortMinutes: data.effortMinutes.present
          ? data.effortMinutes.value
          : this.effortMinutes,
      recurrence: data.recurrence.present
          ? data.recurrence.value
          : this.recurrence,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      weekdays: data.weekdays.present ? data.weekdays.value : this.weekdays,
      dueDate: data.dueDate.present ? data.dueDate.value : this.dueDate,
      assignment: data.assignment.present
          ? data.assignment.value
          : this.assignment,
      assigneeId: data.assigneeId.present
          ? data.assigneeId.value
          : this.assigneeId,
      lastDoneAt: data.lastDoneAt.present
          ? data.lastDoneAt.value
          : this.lastDoneAt,
      lastDoneBy: data.lastDoneBy.present
          ? data.lastDoneBy.value
          : this.lastDoneBy,
      snoozedUntil: data.snoozedUntil.present
          ? data.snoozedUntil.value
          : this.snoozedUntil,
      remind: data.remind.present ? data.remind.value : this.remind,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Chore(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('areaId: $areaId, ')
          ..write('effortMinutes: $effortMinutes, ')
          ..write('recurrence: $recurrence, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('weekdays: $weekdays, ')
          ..write('dueDate: $dueDate, ')
          ..write('assignment: $assignment, ')
          ..write('assigneeId: $assigneeId, ')
          ..write('lastDoneAt: $lastDoneAt, ')
          ..write('lastDoneBy: $lastDoneBy, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('remind: $remind, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    seq,
    deleted,
    name,
    areaId,
    effortMinutes,
    recurrence,
    intervalDays,
    weekdays,
    dueDate,
    assignment,
    assigneeId,
    lastDoneAt,
    lastDoneBy,
    snoozedUntil,
    remind,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Chore &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.areaId == this.areaId &&
          other.effortMinutes == this.effortMinutes &&
          other.recurrence == this.recurrence &&
          other.intervalDays == this.intervalDays &&
          other.weekdays == this.weekdays &&
          other.dueDate == this.dueDate &&
          other.assignment == this.assignment &&
          other.assigneeId == this.assigneeId &&
          other.lastDoneAt == this.lastDoneAt &&
          other.lastDoneBy == this.lastDoneBy &&
          other.snoozedUntil == this.snoozedUntil &&
          other.remind == this.remind &&
          other.createdAt == this.createdAt);
}

class ChoresCompanion extends UpdateCompanion<Chore> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<String> areaId;
  final Value<int> effortMinutes;
  final Value<int> recurrence;
  final Value<int> intervalDays;
  final Value<int> weekdays;
  final Value<int?> dueDate;
  final Value<int> assignment;
  final Value<String?> assigneeId;
  final Value<int?> lastDoneAt;
  final Value<String?> lastDoneBy;
  final Value<int?> snoozedUntil;
  final Value<bool> remind;
  final Value<int> createdAt;
  final Value<int> rowid;
  const ChoresCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.areaId = const Value.absent(),
    this.effortMinutes = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.assignment = const Value.absent(),
    this.assigneeId = const Value.absent(),
    this.lastDoneAt = const Value.absent(),
    this.lastDoneBy = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.remind = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChoresCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String name,
    required String areaId,
    this.effortMinutes = const Value.absent(),
    this.recurrence = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.weekdays = const Value.absent(),
    this.dueDate = const Value.absent(),
    this.assignment = const Value.absent(),
    this.assigneeId = const Value.absent(),
    this.lastDoneAt = const Value.absent(),
    this.lastDoneBy = const Value.absent(),
    this.snoozedUntil = const Value.absent(),
    this.remind = const Value.absent(),
    required int createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       name = Value(name),
       areaId = Value(areaId),
       createdAt = Value(createdAt);
  static Insertable<Chore> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<String>? areaId,
    Expression<int>? effortMinutes,
    Expression<int>? recurrence,
    Expression<int>? intervalDays,
    Expression<int>? weekdays,
    Expression<int>? dueDate,
    Expression<int>? assignment,
    Expression<String>? assigneeId,
    Expression<int>? lastDoneAt,
    Expression<String>? lastDoneBy,
    Expression<int>? snoozedUntil,
    Expression<bool>? remind,
    Expression<int>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (areaId != null) 'area_id': areaId,
      if (effortMinutes != null) 'effort_minutes': effortMinutes,
      if (recurrence != null) 'recurrence': recurrence,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (weekdays != null) 'weekdays': weekdays,
      if (dueDate != null) 'due_date': dueDate,
      if (assignment != null) 'assignment': assignment,
      if (assigneeId != null) 'assignee_id': assigneeId,
      if (lastDoneAt != null) 'last_done_at': lastDoneAt,
      if (lastDoneBy != null) 'last_done_by': lastDoneBy,
      if (snoozedUntil != null) 'snoozed_until': snoozedUntil,
      if (remind != null) 'remind': remind,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChoresCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? name,
    Value<String>? areaId,
    Value<int>? effortMinutes,
    Value<int>? recurrence,
    Value<int>? intervalDays,
    Value<int>? weekdays,
    Value<int?>? dueDate,
    Value<int>? assignment,
    Value<String?>? assigneeId,
    Value<int?>? lastDoneAt,
    Value<String?>? lastDoneBy,
    Value<int?>? snoozedUntil,
    Value<bool>? remind,
    Value<int>? createdAt,
    Value<int>? rowid,
  }) {
    return ChoresCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      areaId: areaId ?? this.areaId,
      effortMinutes: effortMinutes ?? this.effortMinutes,
      recurrence: recurrence ?? this.recurrence,
      intervalDays: intervalDays ?? this.intervalDays,
      weekdays: weekdays ?? this.weekdays,
      dueDate: dueDate ?? this.dueDate,
      assignment: assignment ?? this.assignment,
      assigneeId: assigneeId ?? this.assigneeId,
      lastDoneAt: lastDoneAt ?? this.lastDoneAt,
      lastDoneBy: lastDoneBy ?? this.lastDoneBy,
      snoozedUntil: snoozedUntil ?? this.snoozedUntil,
      remind: remind ?? this.remind,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (areaId.present) {
      map['area_id'] = Variable<String>(areaId.value);
    }
    if (effortMinutes.present) {
      map['effort_minutes'] = Variable<int>(effortMinutes.value);
    }
    if (recurrence.present) {
      map['recurrence'] = Variable<int>(recurrence.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (weekdays.present) {
      map['weekdays'] = Variable<int>(weekdays.value);
    }
    if (dueDate.present) {
      map['due_date'] = Variable<int>(dueDate.value);
    }
    if (assignment.present) {
      map['assignment'] = Variable<int>(assignment.value);
    }
    if (assigneeId.present) {
      map['assignee_id'] = Variable<String>(assigneeId.value);
    }
    if (lastDoneAt.present) {
      map['last_done_at'] = Variable<int>(lastDoneAt.value);
    }
    if (lastDoneBy.present) {
      map['last_done_by'] = Variable<String>(lastDoneBy.value);
    }
    if (snoozedUntil.present) {
      map['snoozed_until'] = Variable<int>(snoozedUntil.value);
    }
    if (remind.present) {
      map['remind'] = Variable<bool>(remind.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChoresCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('areaId: $areaId, ')
          ..write('effortMinutes: $effortMinutes, ')
          ..write('recurrence: $recurrence, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('weekdays: $weekdays, ')
          ..write('dueDate: $dueDate, ')
          ..write('assignment: $assignment, ')
          ..write('assigneeId: $assigneeId, ')
          ..write('lastDoneAt: $lastDoneAt, ')
          ..write('lastDoneBy: $lastDoneBy, ')
          ..write('snoozedUntil: $snoozedUntil, ')
          ..write('remind: $remind, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChoreCompletionsTable extends ChoreCompletions
    with TableInfo<$ChoreCompletionsTable, ChoreCompletion> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChoreCompletionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _choreIdMeta = const VerificationMeta(
    'choreId',
  );
  @override
  late final GeneratedColumn<String> choreId = GeneratedColumn<String>(
    'chore_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _memberIdMeta = const VerificationMeta(
    'memberId',
  );
  @override
  late final GeneratedColumn<String> memberId = GeneratedColumn<String>(
    'member_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _doneAtMeta = const VerificationMeta('doneAt');
  @override
  late final GeneratedColumn<int> doneAt = GeneratedColumn<int>(
    'done_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _effortMinutesMeta = const VerificationMeta(
    'effortMinutes',
  );
  @override
  late final GeneratedColumn<int> effortMinutes = GeneratedColumn<int>(
    'effort_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    choreId,
    memberId,
    doneAt,
    effortMinutes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'chore_completions';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChoreCompletion> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('chore_id')) {
      context.handle(
        _choreIdMeta,
        choreId.isAcceptableOrUnknown(data['chore_id']!, _choreIdMeta),
      );
    } else if (isInserting) {
      context.missing(_choreIdMeta);
    }
    if (data.containsKey('member_id')) {
      context.handle(
        _memberIdMeta,
        memberId.isAcceptableOrUnknown(data['member_id']!, _memberIdMeta),
      );
    }
    if (data.containsKey('done_at')) {
      context.handle(
        _doneAtMeta,
        doneAt.isAcceptableOrUnknown(data['done_at']!, _doneAtMeta),
      );
    } else if (isInserting) {
      context.missing(_doneAtMeta);
    }
    if (data.containsKey('effort_minutes')) {
      context.handle(
        _effortMinutesMeta,
        effortMinutes.isAcceptableOrUnknown(
          data['effort_minutes']!,
          _effortMinutesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ChoreCompletion map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChoreCompletion(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      choreId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chore_id'],
      )!,
      memberId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}member_id'],
      ),
      doneAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}done_at'],
      )!,
      effortMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}effort_minutes'],
      )!,
    );
  }

  @override
  $ChoreCompletionsTable createAlias(String alias) {
    return $ChoreCompletionsTable(attachedDatabase, alias);
  }
}

class ChoreCompletion extends DataClass implements Insertable<ChoreCompletion> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String choreId;
  final String? memberId;
  final int doneAt;
  final int effortMinutes;
  const ChoreCompletion({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.choreId,
    this.memberId,
    required this.doneAt,
    required this.effortMinutes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['chore_id'] = Variable<String>(choreId);
    if (!nullToAbsent || memberId != null) {
      map['member_id'] = Variable<String>(memberId);
    }
    map['done_at'] = Variable<int>(doneAt);
    map['effort_minutes'] = Variable<int>(effortMinutes);
    return map;
  }

  ChoreCompletionsCompanion toCompanion(bool nullToAbsent) {
    return ChoreCompletionsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      choreId: Value(choreId),
      memberId: memberId == null && nullToAbsent
          ? const Value.absent()
          : Value(memberId),
      doneAt: Value(doneAt),
      effortMinutes: Value(effortMinutes),
    );
  }

  factory ChoreCompletion.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChoreCompletion(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      choreId: serializer.fromJson<String>(json['choreId']),
      memberId: serializer.fromJson<String?>(json['memberId']),
      doneAt: serializer.fromJson<int>(json['doneAt']),
      effortMinutes: serializer.fromJson<int>(json['effortMinutes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'choreId': serializer.toJson<String>(choreId),
      'memberId': serializer.toJson<String?>(memberId),
      'doneAt': serializer.toJson<int>(doneAt),
      'effortMinutes': serializer.toJson<int>(effortMinutes),
    };
  }

  ChoreCompletion copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? choreId,
    Value<String?> memberId = const Value.absent(),
    int? doneAt,
    int? effortMinutes,
  }) => ChoreCompletion(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    choreId: choreId ?? this.choreId,
    memberId: memberId.present ? memberId.value : this.memberId,
    doneAt: doneAt ?? this.doneAt,
    effortMinutes: effortMinutes ?? this.effortMinutes,
  );
  ChoreCompletion copyWithCompanion(ChoreCompletionsCompanion data) {
    return ChoreCompletion(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      choreId: data.choreId.present ? data.choreId.value : this.choreId,
      memberId: data.memberId.present ? data.memberId.value : this.memberId,
      doneAt: data.doneAt.present ? data.doneAt.value : this.doneAt,
      effortMinutes: data.effortMinutes.present
          ? data.effortMinutes.value
          : this.effortMinutes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChoreCompletion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('choreId: $choreId, ')
          ..write('memberId: $memberId, ')
          ..write('doneAt: $doneAt, ')
          ..write('effortMinutes: $effortMinutes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    seq,
    deleted,
    choreId,
    memberId,
    doneAt,
    effortMinutes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChoreCompletion &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.choreId == this.choreId &&
          other.memberId == this.memberId &&
          other.doneAt == this.doneAt &&
          other.effortMinutes == this.effortMinutes);
}

class ChoreCompletionsCompanion extends UpdateCompanion<ChoreCompletion> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> choreId;
  final Value<String?> memberId;
  final Value<int> doneAt;
  final Value<int> effortMinutes;
  final Value<int> rowid;
  const ChoreCompletionsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.choreId = const Value.absent(),
    this.memberId = const Value.absent(),
    this.doneAt = const Value.absent(),
    this.effortMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChoreCompletionsCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String choreId,
    this.memberId = const Value.absent(),
    required int doneAt,
    this.effortMinutes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       choreId = Value(choreId),
       doneAt = Value(doneAt);
  static Insertable<ChoreCompletion> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? choreId,
    Expression<String>? memberId,
    Expression<int>? doneAt,
    Expression<int>? effortMinutes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (choreId != null) 'chore_id': choreId,
      if (memberId != null) 'member_id': memberId,
      if (doneAt != null) 'done_at': doneAt,
      if (effortMinutes != null) 'effort_minutes': effortMinutes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChoreCompletionsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? choreId,
    Value<String?>? memberId,
    Value<int>? doneAt,
    Value<int>? effortMinutes,
    Value<int>? rowid,
  }) {
    return ChoreCompletionsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      choreId: choreId ?? this.choreId,
      memberId: memberId ?? this.memberId,
      doneAt: doneAt ?? this.doneAt,
      effortMinutes: effortMinutes ?? this.effortMinutes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (choreId.present) {
      map['chore_id'] = Variable<String>(choreId.value);
    }
    if (memberId.present) {
      map['member_id'] = Variable<String>(memberId.value);
    }
    if (doneAt.present) {
      map['done_at'] = Variable<int>(doneAt.value);
    }
    if (effortMinutes.present) {
      map['effort_minutes'] = Variable<int>(effortMinutes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChoreCompletionsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('choreId: $choreId, ')
          ..write('memberId: $memberId, ')
          ..write('doneAt: $doneAt, ')
          ..write('effortMinutes: $effortMinutes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WastePickupsTable extends WastePickups
    with TableInfo<$WastePickupsTable, WastePickup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WastePickupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<int> type = GeneratedColumn<int>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assigneeIdMeta = const VerificationMeta(
    'assigneeId',
  );
  @override
  late final GeneratedColumn<String> assigneeId = GeneratedColumn<String>(
    'assignee_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    type,
    day,
    assigneeId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'waste_pickups';
  @override
  VerificationContext validateIntegrity(
    Insertable<WastePickup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('assignee_id')) {
      context.handle(
        _assigneeIdMeta,
        assigneeId.isAcceptableOrUnknown(data['assignee_id']!, _assigneeIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WastePickup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WastePickup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}type'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      assigneeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}assignee_id'],
      ),
    );
  }

  @override
  $WastePickupsTable createAlias(String alias) {
    return $WastePickupsTable(attachedDatabase, alias);
  }
}

class WastePickup extends DataClass implements Insertable<WastePickup> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;

  /// `WasteType`-Index.
  final int type;

  /// Tag als `yyyy-MM-dd`.
  final String day;
  final String? assigneeId;
  const WastePickup({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.type,
    required this.day,
    this.assigneeId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['type'] = Variable<int>(type);
    map['day'] = Variable<String>(day);
    if (!nullToAbsent || assigneeId != null) {
      map['assignee_id'] = Variable<String>(assigneeId);
    }
    return map;
  }

  WastePickupsCompanion toCompanion(bool nullToAbsent) {
    return WastePickupsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      type: Value(type),
      day: Value(day),
      assigneeId: assigneeId == null && nullToAbsent
          ? const Value.absent()
          : Value(assigneeId),
    );
  }

  factory WastePickup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WastePickup(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      type: serializer.fromJson<int>(json['type']),
      day: serializer.fromJson<String>(json['day']),
      assigneeId: serializer.fromJson<String?>(json['assigneeId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'type': serializer.toJson<int>(type),
      'day': serializer.toJson<String>(day),
      'assigneeId': serializer.toJson<String?>(assigneeId),
    };
  }

  WastePickup copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    int? type,
    String? day,
    Value<String?> assigneeId = const Value.absent(),
  }) => WastePickup(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    type: type ?? this.type,
    day: day ?? this.day,
    assigneeId: assigneeId.present ? assigneeId.value : this.assigneeId,
  );
  WastePickup copyWithCompanion(WastePickupsCompanion data) {
    return WastePickup(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      type: data.type.present ? data.type.value : this.type,
      day: data.day.present ? data.day.value : this.day,
      assigneeId: data.assigneeId.present
          ? data.assigneeId.value
          : this.assigneeId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WastePickup(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('type: $type, ')
          ..write('day: $day, ')
          ..write('assigneeId: $assigneeId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, updatedAt, seq, deleted, type, day, assigneeId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WastePickup &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.type == this.type &&
          other.day == this.day &&
          other.assigneeId == this.assigneeId);
}

class WastePickupsCompanion extends UpdateCompanion<WastePickup> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<int> type;
  final Value<String> day;
  final Value<String?> assigneeId;
  final Value<int> rowid;
  const WastePickupsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.type = const Value.absent(),
    this.day = const Value.absent(),
    this.assigneeId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WastePickupsCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required int type,
    required String day,
    this.assigneeId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       type = Value(type),
       day = Value(day);
  static Insertable<WastePickup> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<int>? type,
    Expression<String>? day,
    Expression<String>? assigneeId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (type != null) 'type': type,
      if (day != null) 'day': day,
      if (assigneeId != null) 'assignee_id': assigneeId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WastePickupsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<int>? type,
    Value<String>? day,
    Value<String?>? assigneeId,
    Value<int>? rowid,
  }) {
    return WastePickupsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      type: type ?? this.type,
      day: day ?? this.day,
      assigneeId: assigneeId ?? this.assigneeId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(type.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (assigneeId.present) {
      map['assignee_id'] = Variable<String>(assigneeId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WastePickupsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('type: $type, ')
          ..write('day: $day, ')
          ..write('assigneeId: $assigneeId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
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
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _prepMinutesMeta = const VerificationMeta(
    'prepMinutes',
  );
  @override
  late final GeneratedColumn<int> prepMinutes = GeneratedColumn<int>(
    'prep_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookMinutesMeta = const VerificationMeta(
    'cookMinutes',
  );
  @override
  late final GeneratedColumn<int> cookMinutes = GeneratedColumn<int>(
    'cook_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restMinutesMeta = const VerificationMeta(
    'restMinutes',
  );
  @override
  late final GeneratedColumn<int> restMinutes = GeneratedColumn<int>(
    'rest_minutes',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ingredientsMeta = const VerificationMeta(
    'ingredients',
  );
  @override
  late final GeneratedColumn<String> ingredients = GeneratedColumn<String>(
    'ingredients',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _stepsMeta = const VerificationMeta('steps');
  @override
  late final GeneratedColumn<String> steps = GeneratedColumn<String>(
    'steps',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _tipsMeta = const VerificationMeta('tips');
  @override
  late final GeneratedColumn<String> tips = GeneratedColumn<String>(
    'tips',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _storyMeta = const VerificationMeta('story');
  @override
  late final GeneratedColumn<String> story = GeneratedColumn<String>(
    'story',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _collectionIdsMeta = const VerificationMeta(
    'collectionIds',
  );
  @override
  late final GeneratedColumn<String> collectionIds = GeneratedColumn<String>(
    'collection_ids',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _favoriteMeta = const VerificationMeta(
    'favorite',
  );
  @override
  late final GeneratedColumn<bool> favorite = GeneratedColumn<bool>(
    'favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastCookedAtMeta = const VerificationMeta(
    'lastCookedAt',
  );
  @override
  late final GeneratedColumn<int> lastCookedAt = GeneratedColumn<int>(
    'last_cooked_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    title,
    servings,
    prepMinutes,
    cookMinutes,
    restMinutes,
    difficulty,
    ingredients,
    steps,
    tips,
    story,
    source,
    tags,
    collectionIds,
    favorite,
    createdBy,
    createdAt,
    lastCookedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('prep_minutes')) {
      context.handle(
        _prepMinutesMeta,
        prepMinutes.isAcceptableOrUnknown(
          data['prep_minutes']!,
          _prepMinutesMeta,
        ),
      );
    }
    if (data.containsKey('cook_minutes')) {
      context.handle(
        _cookMinutesMeta,
        cookMinutes.isAcceptableOrUnknown(
          data['cook_minutes']!,
          _cookMinutesMeta,
        ),
      );
    }
    if (data.containsKey('rest_minutes')) {
      context.handle(
        _restMinutesMeta,
        restMinutes.isAcceptableOrUnknown(
          data['rest_minutes']!,
          _restMinutesMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('ingredients')) {
      context.handle(
        _ingredientsMeta,
        ingredients.isAcceptableOrUnknown(
          data['ingredients']!,
          _ingredientsMeta,
        ),
      );
    }
    if (data.containsKey('steps')) {
      context.handle(
        _stepsMeta,
        steps.isAcceptableOrUnknown(data['steps']!, _stepsMeta),
      );
    }
    if (data.containsKey('tips')) {
      context.handle(
        _tipsMeta,
        tips.isAcceptableOrUnknown(data['tips']!, _tipsMeta),
      );
    }
    if (data.containsKey('story')) {
      context.handle(
        _storyMeta,
        story.isAcceptableOrUnknown(data['story']!, _storyMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    if (data.containsKey('collection_ids')) {
      context.handle(
        _collectionIdsMeta,
        collectionIds.isAcceptableOrUnknown(
          data['collection_ids']!,
          _collectionIdsMeta,
        ),
      );
    }
    if (data.containsKey('favorite')) {
      context.handle(
        _favoriteMeta,
        favorite.isAcceptableOrUnknown(data['favorite']!, _favoriteMeta),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
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
    if (data.containsKey('last_cooked_at')) {
      context.handle(
        _lastCookedAtMeta,
        lastCookedAt.isAcceptableOrUnknown(
          data['last_cooked_at']!,
          _lastCookedAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      )!,
      prepMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_minutes'],
      ),
      cookMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_minutes'],
      ),
      restMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_minutes'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      )!,
      ingredients: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}ingredients'],
      )!,
      steps: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}steps'],
      )!,
      tips: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tips'],
      ),
      story: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}story'],
      ),
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      )!,
      collectionIds: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}collection_ids'],
      )!,
      favorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}favorite'],
      )!,
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
      lastCookedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_cooked_at'],
      ),
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String title;
  final int servings;
  final int? prepMinutes;
  final int? cookMinutes;
  final int? restMinutes;

  /// 0 = keine Angabe, 1 leicht, 2 mittel, 3 anspruchsvoll.
  final int difficulty;

  /// Eine Zutat pro Zeile („200 g Mehl“), Reihenfolge der Verwendung.
  final String ingredients;

  /// Schritte, durch Leerzeile getrennt.
  final String steps;
  final String? tips;

  /// Anekdote / Familiengeschichte (steht am Ende des Rezepts).
  final String? story;
  final String? source;

  /// Kommagetrennte Schlagworte.
  final String tags;

  /// Kommagetrennte Sammlungs-IDs.
  final String collectionIds;
  final bool favorite;
  final String? createdBy;
  final int createdAt;
  final int? lastCookedAt;
  const Recipe({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.title,
    required this.servings,
    this.prepMinutes,
    this.cookMinutes,
    this.restMinutes,
    required this.difficulty,
    required this.ingredients,
    required this.steps,
    this.tips,
    this.story,
    this.source,
    required this.tags,
    required this.collectionIds,
    required this.favorite,
    this.createdBy,
    required this.createdAt,
    this.lastCookedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['title'] = Variable<String>(title);
    map['servings'] = Variable<int>(servings);
    if (!nullToAbsent || prepMinutes != null) {
      map['prep_minutes'] = Variable<int>(prepMinutes);
    }
    if (!nullToAbsent || cookMinutes != null) {
      map['cook_minutes'] = Variable<int>(cookMinutes);
    }
    if (!nullToAbsent || restMinutes != null) {
      map['rest_minutes'] = Variable<int>(restMinutes);
    }
    map['difficulty'] = Variable<int>(difficulty);
    map['ingredients'] = Variable<String>(ingredients);
    map['steps'] = Variable<String>(steps);
    if (!nullToAbsent || tips != null) {
      map['tips'] = Variable<String>(tips);
    }
    if (!nullToAbsent || story != null) {
      map['story'] = Variable<String>(story);
    }
    if (!nullToAbsent || source != null) {
      map['source'] = Variable<String>(source);
    }
    map['tags'] = Variable<String>(tags);
    map['collection_ids'] = Variable<String>(collectionIds);
    map['favorite'] = Variable<bool>(favorite);
    if (!nullToAbsent || createdBy != null) {
      map['created_by'] = Variable<String>(createdBy);
    }
    map['created_at'] = Variable<int>(createdAt);
    if (!nullToAbsent || lastCookedAt != null) {
      map['last_cooked_at'] = Variable<int>(lastCookedAt);
    }
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      title: Value(title),
      servings: Value(servings),
      prepMinutes: prepMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(prepMinutes),
      cookMinutes: cookMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(cookMinutes),
      restMinutes: restMinutes == null && nullToAbsent
          ? const Value.absent()
          : Value(restMinutes),
      difficulty: Value(difficulty),
      ingredients: Value(ingredients),
      steps: Value(steps),
      tips: tips == null && nullToAbsent ? const Value.absent() : Value(tips),
      story: story == null && nullToAbsent
          ? const Value.absent()
          : Value(story),
      source: source == null && nullToAbsent
          ? const Value.absent()
          : Value(source),
      tags: Value(tags),
      collectionIds: Value(collectionIds),
      favorite: Value(favorite),
      createdBy: createdBy == null && nullToAbsent
          ? const Value.absent()
          : Value(createdBy),
      createdAt: Value(createdAt),
      lastCookedAt: lastCookedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCookedAt),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      title: serializer.fromJson<String>(json['title']),
      servings: serializer.fromJson<int>(json['servings']),
      prepMinutes: serializer.fromJson<int?>(json['prepMinutes']),
      cookMinutes: serializer.fromJson<int?>(json['cookMinutes']),
      restMinutes: serializer.fromJson<int?>(json['restMinutes']),
      difficulty: serializer.fromJson<int>(json['difficulty']),
      ingredients: serializer.fromJson<String>(json['ingredients']),
      steps: serializer.fromJson<String>(json['steps']),
      tips: serializer.fromJson<String?>(json['tips']),
      story: serializer.fromJson<String?>(json['story']),
      source: serializer.fromJson<String?>(json['source']),
      tags: serializer.fromJson<String>(json['tags']),
      collectionIds: serializer.fromJson<String>(json['collectionIds']),
      favorite: serializer.fromJson<bool>(json['favorite']),
      createdBy: serializer.fromJson<String?>(json['createdBy']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
      lastCookedAt: serializer.fromJson<int?>(json['lastCookedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'title': serializer.toJson<String>(title),
      'servings': serializer.toJson<int>(servings),
      'prepMinutes': serializer.toJson<int?>(prepMinutes),
      'cookMinutes': serializer.toJson<int?>(cookMinutes),
      'restMinutes': serializer.toJson<int?>(restMinutes),
      'difficulty': serializer.toJson<int>(difficulty),
      'ingredients': serializer.toJson<String>(ingredients),
      'steps': serializer.toJson<String>(steps),
      'tips': serializer.toJson<String?>(tips),
      'story': serializer.toJson<String?>(story),
      'source': serializer.toJson<String?>(source),
      'tags': serializer.toJson<String>(tags),
      'collectionIds': serializer.toJson<String>(collectionIds),
      'favorite': serializer.toJson<bool>(favorite),
      'createdBy': serializer.toJson<String?>(createdBy),
      'createdAt': serializer.toJson<int>(createdAt),
      'lastCookedAt': serializer.toJson<int?>(lastCookedAt),
    };
  }

  Recipe copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? title,
    int? servings,
    Value<int?> prepMinutes = const Value.absent(),
    Value<int?> cookMinutes = const Value.absent(),
    Value<int?> restMinutes = const Value.absent(),
    int? difficulty,
    String? ingredients,
    String? steps,
    Value<String?> tips = const Value.absent(),
    Value<String?> story = const Value.absent(),
    Value<String?> source = const Value.absent(),
    String? tags,
    String? collectionIds,
    bool? favorite,
    Value<String?> createdBy = const Value.absent(),
    int? createdAt,
    Value<int?> lastCookedAt = const Value.absent(),
  }) => Recipe(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    title: title ?? this.title,
    servings: servings ?? this.servings,
    prepMinutes: prepMinutes.present ? prepMinutes.value : this.prepMinutes,
    cookMinutes: cookMinutes.present ? cookMinutes.value : this.cookMinutes,
    restMinutes: restMinutes.present ? restMinutes.value : this.restMinutes,
    difficulty: difficulty ?? this.difficulty,
    ingredients: ingredients ?? this.ingredients,
    steps: steps ?? this.steps,
    tips: tips.present ? tips.value : this.tips,
    story: story.present ? story.value : this.story,
    source: source.present ? source.value : this.source,
    tags: tags ?? this.tags,
    collectionIds: collectionIds ?? this.collectionIds,
    favorite: favorite ?? this.favorite,
    createdBy: createdBy.present ? createdBy.value : this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    lastCookedAt: lastCookedAt.present ? lastCookedAt.value : this.lastCookedAt,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      title: data.title.present ? data.title.value : this.title,
      servings: data.servings.present ? data.servings.value : this.servings,
      prepMinutes: data.prepMinutes.present
          ? data.prepMinutes.value
          : this.prepMinutes,
      cookMinutes: data.cookMinutes.present
          ? data.cookMinutes.value
          : this.cookMinutes,
      restMinutes: data.restMinutes.present
          ? data.restMinutes.value
          : this.restMinutes,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      ingredients: data.ingredients.present
          ? data.ingredients.value
          : this.ingredients,
      steps: data.steps.present ? data.steps.value : this.steps,
      tips: data.tips.present ? data.tips.value : this.tips,
      story: data.story.present ? data.story.value : this.story,
      source: data.source.present ? data.source.value : this.source,
      tags: data.tags.present ? data.tags.value : this.tags,
      collectionIds: data.collectionIds.present
          ? data.collectionIds.value
          : this.collectionIds,
      favorite: data.favorite.present ? data.favorite.value : this.favorite,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      lastCookedAt: data.lastCookedAt.present
          ? data.lastCookedAt.value
          : this.lastCookedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('title: $title, ')
          ..write('servings: $servings, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('cookMinutes: $cookMinutes, ')
          ..write('restMinutes: $restMinutes, ')
          ..write('difficulty: $difficulty, ')
          ..write('ingredients: $ingredients, ')
          ..write('steps: $steps, ')
          ..write('tips: $tips, ')
          ..write('story: $story, ')
          ..write('source: $source, ')
          ..write('tags: $tags, ')
          ..write('collectionIds: $collectionIds, ')
          ..write('favorite: $favorite, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastCookedAt: $lastCookedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    updatedAt,
    seq,
    deleted,
    title,
    servings,
    prepMinutes,
    cookMinutes,
    restMinutes,
    difficulty,
    ingredients,
    steps,
    tips,
    story,
    source,
    tags,
    collectionIds,
    favorite,
    createdBy,
    createdAt,
    lastCookedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.title == this.title &&
          other.servings == this.servings &&
          other.prepMinutes == this.prepMinutes &&
          other.cookMinutes == this.cookMinutes &&
          other.restMinutes == this.restMinutes &&
          other.difficulty == this.difficulty &&
          other.ingredients == this.ingredients &&
          other.steps == this.steps &&
          other.tips == this.tips &&
          other.story == this.story &&
          other.source == this.source &&
          other.tags == this.tags &&
          other.collectionIds == this.collectionIds &&
          other.favorite == this.favorite &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.lastCookedAt == this.lastCookedAt);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> title;
  final Value<int> servings;
  final Value<int?> prepMinutes;
  final Value<int?> cookMinutes;
  final Value<int?> restMinutes;
  final Value<int> difficulty;
  final Value<String> ingredients;
  final Value<String> steps;
  final Value<String?> tips;
  final Value<String?> story;
  final Value<String?> source;
  final Value<String> tags;
  final Value<String> collectionIds;
  final Value<bool> favorite;
  final Value<String?> createdBy;
  final Value<int> createdAt;
  final Value<int?> lastCookedAt;
  final Value<int> rowid;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.title = const Value.absent(),
    this.servings = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.cookMinutes = const Value.absent(),
    this.restMinutes = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.steps = const Value.absent(),
    this.tips = const Value.absent(),
    this.story = const Value.absent(),
    this.source = const Value.absent(),
    this.tags = const Value.absent(),
    this.collectionIds = const Value.absent(),
    this.favorite = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.lastCookedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipesCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String title,
    this.servings = const Value.absent(),
    this.prepMinutes = const Value.absent(),
    this.cookMinutes = const Value.absent(),
    this.restMinutes = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.ingredients = const Value.absent(),
    this.steps = const Value.absent(),
    this.tips = const Value.absent(),
    this.story = const Value.absent(),
    this.source = const Value.absent(),
    this.tags = const Value.absent(),
    this.collectionIds = const Value.absent(),
    this.favorite = const Value.absent(),
    this.createdBy = const Value.absent(),
    required int createdAt,
    this.lastCookedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       title = Value(title),
       createdAt = Value(createdAt);
  static Insertable<Recipe> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? title,
    Expression<int>? servings,
    Expression<int>? prepMinutes,
    Expression<int>? cookMinutes,
    Expression<int>? restMinutes,
    Expression<int>? difficulty,
    Expression<String>? ingredients,
    Expression<String>? steps,
    Expression<String>? tips,
    Expression<String>? story,
    Expression<String>? source,
    Expression<String>? tags,
    Expression<String>? collectionIds,
    Expression<bool>? favorite,
    Expression<String>? createdBy,
    Expression<int>? createdAt,
    Expression<int>? lastCookedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (title != null) 'title': title,
      if (servings != null) 'servings': servings,
      if (prepMinutes != null) 'prep_minutes': prepMinutes,
      if (cookMinutes != null) 'cook_minutes': cookMinutes,
      if (restMinutes != null) 'rest_minutes': restMinutes,
      if (difficulty != null) 'difficulty': difficulty,
      if (ingredients != null) 'ingredients': ingredients,
      if (steps != null) 'steps': steps,
      if (tips != null) 'tips': tips,
      if (story != null) 'story': story,
      if (source != null) 'source': source,
      if (tags != null) 'tags': tags,
      if (collectionIds != null) 'collection_ids': collectionIds,
      if (favorite != null) 'favorite': favorite,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (lastCookedAt != null) 'last_cooked_at': lastCookedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipesCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? title,
    Value<int>? servings,
    Value<int?>? prepMinutes,
    Value<int?>? cookMinutes,
    Value<int?>? restMinutes,
    Value<int>? difficulty,
    Value<String>? ingredients,
    Value<String>? steps,
    Value<String?>? tips,
    Value<String?>? story,
    Value<String?>? source,
    Value<String>? tags,
    Value<String>? collectionIds,
    Value<bool>? favorite,
    Value<String?>? createdBy,
    Value<int>? createdAt,
    Value<int?>? lastCookedAt,
    Value<int>? rowid,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      title: title ?? this.title,
      servings: servings ?? this.servings,
      prepMinutes: prepMinutes ?? this.prepMinutes,
      cookMinutes: cookMinutes ?? this.cookMinutes,
      restMinutes: restMinutes ?? this.restMinutes,
      difficulty: difficulty ?? this.difficulty,
      ingredients: ingredients ?? this.ingredients,
      steps: steps ?? this.steps,
      tips: tips ?? this.tips,
      story: story ?? this.story,
      source: source ?? this.source,
      tags: tags ?? this.tags,
      collectionIds: collectionIds ?? this.collectionIds,
      favorite: favorite ?? this.favorite,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      lastCookedAt: lastCookedAt ?? this.lastCookedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (prepMinutes.present) {
      map['prep_minutes'] = Variable<int>(prepMinutes.value);
    }
    if (cookMinutes.present) {
      map['cook_minutes'] = Variable<int>(cookMinutes.value);
    }
    if (restMinutes.present) {
      map['rest_minutes'] = Variable<int>(restMinutes.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (ingredients.present) {
      map['ingredients'] = Variable<String>(ingredients.value);
    }
    if (steps.present) {
      map['steps'] = Variable<String>(steps.value);
    }
    if (tips.present) {
      map['tips'] = Variable<String>(tips.value);
    }
    if (story.present) {
      map['story'] = Variable<String>(story.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (collectionIds.present) {
      map['collection_ids'] = Variable<String>(collectionIds.value);
    }
    if (favorite.present) {
      map['favorite'] = Variable<bool>(favorite.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    if (lastCookedAt.present) {
      map['last_cooked_at'] = Variable<int>(lastCookedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('title: $title, ')
          ..write('servings: $servings, ')
          ..write('prepMinutes: $prepMinutes, ')
          ..write('cookMinutes: $cookMinutes, ')
          ..write('restMinutes: $restMinutes, ')
          ..write('difficulty: $difficulty, ')
          ..write('ingredients: $ingredients, ')
          ..write('steps: $steps, ')
          ..write('tips: $tips, ')
          ..write('story: $story, ')
          ..write('source: $source, ')
          ..write('tags: $tags, ')
          ..write('collectionIds: $collectionIds, ')
          ..write('favorite: $favorite, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('lastCookedAt: $lastCookedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecipeCollectionsTable extends RecipeCollections
    with TableInfo<$RecipeCollectionsTable, RecipeCollection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeCollectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    name,
    color,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_collections';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeCollection> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeCollection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeCollection(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $RecipeCollectionsTable createAlias(String alias) {
    return $RecipeCollectionsTable(attachedDatabase, alias);
  }
}

class RecipeCollection extends DataClass
    implements Insertable<RecipeCollection> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String name;
  final int color;
  const RecipeCollection({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.name,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    return map;
  }

  RecipeCollectionsCompanion toCompanion(bool nullToAbsent) {
    return RecipeCollectionsCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      name: Value(name),
      color: Value(color),
    );
  }

  factory RecipeCollection.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeCollection(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
    };
  }

  RecipeCollection copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? name,
    int? color,
  }) => RecipeCollection(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    name: name ?? this.name,
    color: color ?? this.color,
  );
  RecipeCollection copyWithCompanion(RecipeCollectionsCompanion data) {
    return RecipeCollection(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeCollection(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, updatedAt, seq, deleted, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeCollection &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.name == this.name &&
          other.color == this.color);
}

class RecipeCollectionsCompanion extends UpdateCompanion<RecipeCollection> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> name;
  final Value<int> color;
  final Value<int> rowid;
  const RecipeCollectionsCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecipeCollectionsCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String name,
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       name = Value(name);
  static Insertable<RecipeCollection> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecipeCollectionsCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? name,
    Value<int>? color,
    Value<int>? rowid,
  }) {
    return RecipeCollectionsCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      name: name ?? this.name,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeCollectionsCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MealPlanEntriesTable extends MealPlanEntries
    with TableInfo<$MealPlanEntriesTable, MealPlanEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealPlanEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedMeta = const VerificationMeta(
    'deleted',
  );
  @override
  late final GeneratedColumn<bool> deleted = GeneratedColumn<bool>(
    'deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _dayMeta = const VerificationMeta('day');
  @override
  late final GeneratedColumn<String> day = GeneratedColumn<String>(
    'day',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<String> recipeId = GeneratedColumn<String>(
    'recipe_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _cookIdMeta = const VerificationMeta('cookId');
  @override
  late final GeneratedColumn<String> cookId = GeneratedColumn<String>(
    'cook_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    updatedAt,
    seq,
    deleted,
    day,
    recipeId,
    title,
    servings,
    cookId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meal_plan_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<MealPlanEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    } else if (isInserting) {
      context.missing(_seqMeta);
    }
    if (data.containsKey('deleted')) {
      context.handle(
        _deletedMeta,
        deleted.isAcceptableOrUnknown(data['deleted']!, _deletedMeta),
      );
    }
    if (data.containsKey('day')) {
      context.handle(
        _dayMeta,
        day.isAcceptableOrUnknown(data['day']!, _dayMeta),
      );
    } else if (isInserting) {
      context.missing(_dayMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('cook_id')) {
      context.handle(
        _cookIdMeta,
        cookId.isAcceptableOrUnknown(data['cook_id']!, _cookIdMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MealPlanEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MealPlanEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      deleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}deleted'],
      )!,
      day: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}day'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recipe_id'],
      ),
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      ),
      cookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cook_id'],
      ),
    );
  }

  @override
  $MealPlanEntriesTable createAlias(String alias) {
    return $MealPlanEntriesTable(attachedDatabase, alias);
  }
}

class MealPlanEntry extends DataClass implements Insertable<MealPlanEntry> {
  final String id;
  final int updatedAt;
  final int seq;
  final bool deleted;
  final String day;
  final String? recipeId;
  final String title;
  final int? servings;
  final String? cookId;
  const MealPlanEntry({
    required this.id,
    required this.updatedAt,
    required this.seq,
    required this.deleted,
    required this.day,
    this.recipeId,
    required this.title,
    this.servings,
    this.cookId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['updated_at'] = Variable<int>(updatedAt);
    map['seq'] = Variable<int>(seq);
    map['deleted'] = Variable<bool>(deleted);
    map['day'] = Variable<String>(day);
    if (!nullToAbsent || recipeId != null) {
      map['recipe_id'] = Variable<String>(recipeId);
    }
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || servings != null) {
      map['servings'] = Variable<int>(servings);
    }
    if (!nullToAbsent || cookId != null) {
      map['cook_id'] = Variable<String>(cookId);
    }
    return map;
  }

  MealPlanEntriesCompanion toCompanion(bool nullToAbsent) {
    return MealPlanEntriesCompanion(
      id: Value(id),
      updatedAt: Value(updatedAt),
      seq: Value(seq),
      deleted: Value(deleted),
      day: Value(day),
      recipeId: recipeId == null && nullToAbsent
          ? const Value.absent()
          : Value(recipeId),
      title: Value(title),
      servings: servings == null && nullToAbsent
          ? const Value.absent()
          : Value(servings),
      cookId: cookId == null && nullToAbsent
          ? const Value.absent()
          : Value(cookId),
    );
  }

  factory MealPlanEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MealPlanEntry(
      id: serializer.fromJson<String>(json['id']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      seq: serializer.fromJson<int>(json['seq']),
      deleted: serializer.fromJson<bool>(json['deleted']),
      day: serializer.fromJson<String>(json['day']),
      recipeId: serializer.fromJson<String?>(json['recipeId']),
      title: serializer.fromJson<String>(json['title']),
      servings: serializer.fromJson<int?>(json['servings']),
      cookId: serializer.fromJson<String?>(json['cookId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'seq': serializer.toJson<int>(seq),
      'deleted': serializer.toJson<bool>(deleted),
      'day': serializer.toJson<String>(day),
      'recipeId': serializer.toJson<String?>(recipeId),
      'title': serializer.toJson<String>(title),
      'servings': serializer.toJson<int?>(servings),
      'cookId': serializer.toJson<String?>(cookId),
    };
  }

  MealPlanEntry copyWith({
    String? id,
    int? updatedAt,
    int? seq,
    bool? deleted,
    String? day,
    Value<String?> recipeId = const Value.absent(),
    String? title,
    Value<int?> servings = const Value.absent(),
    Value<String?> cookId = const Value.absent(),
  }) => MealPlanEntry(
    id: id ?? this.id,
    updatedAt: updatedAt ?? this.updatedAt,
    seq: seq ?? this.seq,
    deleted: deleted ?? this.deleted,
    day: day ?? this.day,
    recipeId: recipeId.present ? recipeId.value : this.recipeId,
    title: title ?? this.title,
    servings: servings.present ? servings.value : this.servings,
    cookId: cookId.present ? cookId.value : this.cookId,
  );
  MealPlanEntry copyWithCompanion(MealPlanEntriesCompanion data) {
    return MealPlanEntry(
      id: data.id.present ? data.id.value : this.id,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      seq: data.seq.present ? data.seq.value : this.seq,
      deleted: data.deleted.present ? data.deleted.value : this.deleted,
      day: data.day.present ? data.day.value : this.day,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      title: data.title.present ? data.title.value : this.title,
      servings: data.servings.present ? data.servings.value : this.servings,
      cookId: data.cookId.present ? data.cookId.value : this.cookId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanEntry(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('day: $day, ')
          ..write('recipeId: $recipeId, ')
          ..write('title: $title, ')
          ..write('servings: $servings, ')
          ..write('cookId: $cookId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    updatedAt,
    seq,
    deleted,
    day,
    recipeId,
    title,
    servings,
    cookId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealPlanEntry &&
          other.id == this.id &&
          other.updatedAt == this.updatedAt &&
          other.seq == this.seq &&
          other.deleted == this.deleted &&
          other.day == this.day &&
          other.recipeId == this.recipeId &&
          other.title == this.title &&
          other.servings == this.servings &&
          other.cookId == this.cookId);
}

class MealPlanEntriesCompanion extends UpdateCompanion<MealPlanEntry> {
  final Value<String> id;
  final Value<int> updatedAt;
  final Value<int> seq;
  final Value<bool> deleted;
  final Value<String> day;
  final Value<String?> recipeId;
  final Value<String> title;
  final Value<int?> servings;
  final Value<String?> cookId;
  final Value<int> rowid;
  const MealPlanEntriesCompanion({
    this.id = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.seq = const Value.absent(),
    this.deleted = const Value.absent(),
    this.day = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.title = const Value.absent(),
    this.servings = const Value.absent(),
    this.cookId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MealPlanEntriesCompanion.insert({
    required String id,
    required int updatedAt,
    required int seq,
    this.deleted = const Value.absent(),
    required String day,
    this.recipeId = const Value.absent(),
    required String title,
    this.servings = const Value.absent(),
    this.cookId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       updatedAt = Value(updatedAt),
       seq = Value(seq),
       day = Value(day),
       title = Value(title);
  static Insertable<MealPlanEntry> custom({
    Expression<String>? id,
    Expression<int>? updatedAt,
    Expression<int>? seq,
    Expression<bool>? deleted,
    Expression<String>? day,
    Expression<String>? recipeId,
    Expression<String>? title,
    Expression<int>? servings,
    Expression<String>? cookId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (seq != null) 'seq': seq,
      if (deleted != null) 'deleted': deleted,
      if (day != null) 'day': day,
      if (recipeId != null) 'recipe_id': recipeId,
      if (title != null) 'title': title,
      if (servings != null) 'servings': servings,
      if (cookId != null) 'cook_id': cookId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MealPlanEntriesCompanion copyWith({
    Value<String>? id,
    Value<int>? updatedAt,
    Value<int>? seq,
    Value<bool>? deleted,
    Value<String>? day,
    Value<String?>? recipeId,
    Value<String>? title,
    Value<int?>? servings,
    Value<String?>? cookId,
    Value<int>? rowid,
  }) {
    return MealPlanEntriesCompanion(
      id: id ?? this.id,
      updatedAt: updatedAt ?? this.updatedAt,
      seq: seq ?? this.seq,
      deleted: deleted ?? this.deleted,
      day: day ?? this.day,
      recipeId: recipeId ?? this.recipeId,
      title: title ?? this.title,
      servings: servings ?? this.servings,
      cookId: cookId ?? this.cookId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (deleted.present) {
      map['deleted'] = Variable<bool>(deleted.value);
    }
    if (day.present) {
      map['day'] = Variable<String>(day.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<String>(recipeId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (cookId.present) {
      map['cook_id'] = Variable<String>(cookId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealPlanEntriesCompanion(')
          ..write('id: $id, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('seq: $seq, ')
          ..write('deleted: $deleted, ')
          ..write('day: $day, ')
          ..write('recipeId: $recipeId, ')
          ..write('title: $title, ')
          ..write('servings: $servings, ')
          ..write('cookId: $cookId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalSettingsTable extends LocalSettings
    with TableInfo<$LocalSettingsTable, LocalSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  LocalSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalSetting(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $LocalSettingsTable createAlias(String alias) {
    return $LocalSettingsTable(attachedDatabase, alias);
  }
}

class LocalSetting extends DataClass implements Insertable<LocalSetting> {
  final String key;
  final String value;
  const LocalSetting({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  LocalSettingsCompanion toCompanion(bool nullToAbsent) {
    return LocalSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory LocalSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalSetting(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  LocalSetting copyWith({String? key, String? value}) =>
      LocalSetting(key: key ?? this.key, value: value ?? this.value);
  LocalSetting copyWithCompanion(LocalSettingsCompanion data) {
    return LocalSetting(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalSetting(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalSetting &&
          other.key == this.key &&
          other.value == this.value);
}

class LocalSettingsCompanion extends UpdateCompanion<LocalSetting> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const LocalSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<LocalSetting> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return LocalSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PeersTable extends Peers with TableInfo<$PeersTable, Peer> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PeersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastAddressMeta = const VerificationMeta(
    'lastAddress',
  );
  @override
  late final GeneratedColumn<String> lastAddress = GeneratedColumn<String>(
    'last_address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<int> lastSyncAt = GeneratedColumn<int>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _theirSeqMeta = const VerificationMeta(
    'theirSeq',
  );
  @override
  late final GeneratedColumn<int> theirSeq = GeneratedColumn<int>(
    'their_seq',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _ourSeqAckedMeta = const VerificationMeta(
    'ourSeqAcked',
  );
  @override
  late final GeneratedColumn<int> ourSeqAcked = GeneratedColumn<int>(
    'our_seq_acked',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    deviceId,
    name,
    lastAddress,
    lastSyncAt,
    theirSeq,
    ourSeqAcked,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'peers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Peer> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('last_address')) {
      context.handle(
        _lastAddressMeta,
        lastAddress.isAcceptableOrUnknown(
          data['last_address']!,
          _lastAddressMeta,
        ),
      );
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    if (data.containsKey('their_seq')) {
      context.handle(
        _theirSeqMeta,
        theirSeq.isAcceptableOrUnknown(data['their_seq']!, _theirSeqMeta),
      );
    }
    if (data.containsKey('our_seq_acked')) {
      context.handle(
        _ourSeqAckedMeta,
        ourSeqAcked.isAcceptableOrUnknown(
          data['our_seq_acked']!,
          _ourSeqAckedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deviceId};
  @override
  Peer map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Peer(
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lastAddress: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_address'],
      ),
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_sync_at'],
      ),
      theirSeq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}their_seq'],
      )!,
      ourSeqAcked: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}our_seq_acked'],
      )!,
    );
  }

  @override
  $PeersTable createAlias(String alias) {
    return $PeersTable(attachedDatabase, alias);
  }
}

class Peer extends DataClass implements Insertable<Peer> {
  final String deviceId;
  final String name;
  final String? lastAddress;
  final int? lastSyncAt;

  /// Höchste seq des Partners, die wir schon haben.
  final int theirSeq;

  /// Höchste eigene seq, die der Partner bestätigt hat.
  final int ourSeqAcked;
  const Peer({
    required this.deviceId,
    required this.name,
    this.lastAddress,
    this.lastSyncAt,
    required this.theirSeq,
    required this.ourSeqAcked,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['device_id'] = Variable<String>(deviceId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || lastAddress != null) {
      map['last_address'] = Variable<String>(lastAddress);
    }
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<int>(lastSyncAt);
    }
    map['their_seq'] = Variable<int>(theirSeq);
    map['our_seq_acked'] = Variable<int>(ourSeqAcked);
    return map;
  }

  PeersCompanion toCompanion(bool nullToAbsent) {
    return PeersCompanion(
      deviceId: Value(deviceId),
      name: Value(name),
      lastAddress: lastAddress == null && nullToAbsent
          ? const Value.absent()
          : Value(lastAddress),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
      theirSeq: Value(theirSeq),
      ourSeqAcked: Value(ourSeqAcked),
    );
  }

  factory Peer.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Peer(
      deviceId: serializer.fromJson<String>(json['deviceId']),
      name: serializer.fromJson<String>(json['name']),
      lastAddress: serializer.fromJson<String?>(json['lastAddress']),
      lastSyncAt: serializer.fromJson<int?>(json['lastSyncAt']),
      theirSeq: serializer.fromJson<int>(json['theirSeq']),
      ourSeqAcked: serializer.fromJson<int>(json['ourSeqAcked']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deviceId': serializer.toJson<String>(deviceId),
      'name': serializer.toJson<String>(name),
      'lastAddress': serializer.toJson<String?>(lastAddress),
      'lastSyncAt': serializer.toJson<int?>(lastSyncAt),
      'theirSeq': serializer.toJson<int>(theirSeq),
      'ourSeqAcked': serializer.toJson<int>(ourSeqAcked),
    };
  }

  Peer copyWith({
    String? deviceId,
    String? name,
    Value<String?> lastAddress = const Value.absent(),
    Value<int?> lastSyncAt = const Value.absent(),
    int? theirSeq,
    int? ourSeqAcked,
  }) => Peer(
    deviceId: deviceId ?? this.deviceId,
    name: name ?? this.name,
    lastAddress: lastAddress.present ? lastAddress.value : this.lastAddress,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
    theirSeq: theirSeq ?? this.theirSeq,
    ourSeqAcked: ourSeqAcked ?? this.ourSeqAcked,
  );
  Peer copyWithCompanion(PeersCompanion data) {
    return Peer(
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      name: data.name.present ? data.name.value : this.name,
      lastAddress: data.lastAddress.present
          ? data.lastAddress.value
          : this.lastAddress,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
      theirSeq: data.theirSeq.present ? data.theirSeq.value : this.theirSeq,
      ourSeqAcked: data.ourSeqAcked.present
          ? data.ourSeqAcked.value
          : this.ourSeqAcked,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Peer(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('lastAddress: $lastAddress, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('theirSeq: $theirSeq, ')
          ..write('ourSeqAcked: $ourSeqAcked')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    deviceId,
    name,
    lastAddress,
    lastSyncAt,
    theirSeq,
    ourSeqAcked,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Peer &&
          other.deviceId == this.deviceId &&
          other.name == this.name &&
          other.lastAddress == this.lastAddress &&
          other.lastSyncAt == this.lastSyncAt &&
          other.theirSeq == this.theirSeq &&
          other.ourSeqAcked == this.ourSeqAcked);
}

class PeersCompanion extends UpdateCompanion<Peer> {
  final Value<String> deviceId;
  final Value<String> name;
  final Value<String?> lastAddress;
  final Value<int?> lastSyncAt;
  final Value<int> theirSeq;
  final Value<int> ourSeqAcked;
  final Value<int> rowid;
  const PeersCompanion({
    this.deviceId = const Value.absent(),
    this.name = const Value.absent(),
    this.lastAddress = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.theirSeq = const Value.absent(),
    this.ourSeqAcked = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PeersCompanion.insert({
    required String deviceId,
    required String name,
    this.lastAddress = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.theirSeq = const Value.absent(),
    this.ourSeqAcked = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : deviceId = Value(deviceId),
       name = Value(name);
  static Insertable<Peer> custom({
    Expression<String>? deviceId,
    Expression<String>? name,
    Expression<String>? lastAddress,
    Expression<int>? lastSyncAt,
    Expression<int>? theirSeq,
    Expression<int>? ourSeqAcked,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deviceId != null) 'device_id': deviceId,
      if (name != null) 'name': name,
      if (lastAddress != null) 'last_address': lastAddress,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (theirSeq != null) 'their_seq': theirSeq,
      if (ourSeqAcked != null) 'our_seq_acked': ourSeqAcked,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PeersCompanion copyWith({
    Value<String>? deviceId,
    Value<String>? name,
    Value<String?>? lastAddress,
    Value<int?>? lastSyncAt,
    Value<int>? theirSeq,
    Value<int>? ourSeqAcked,
    Value<int>? rowid,
  }) {
    return PeersCompanion(
      deviceId: deviceId ?? this.deviceId,
      name: name ?? this.name,
      lastAddress: lastAddress ?? this.lastAddress,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      theirSeq: theirSeq ?? this.theirSeq,
      ourSeqAcked: ourSeqAcked ?? this.ourSeqAcked,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lastAddress.present) {
      map['last_address'] = Variable<String>(lastAddress.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<int>(lastSyncAt.value);
    }
    if (theirSeq.present) {
      map['their_seq'] = Variable<int>(theirSeq.value);
    }
    if (ourSeqAcked.present) {
      map['our_seq_acked'] = Variable<int>(ourSeqAcked.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PeersCompanion(')
          ..write('deviceId: $deviceId, ')
          ..write('name: $name, ')
          ..write('lastAddress: $lastAddress, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('theirSeq: $theirSeq, ')
          ..write('ourSeqAcked: $ourSeqAcked, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MembersTable members = $MembersTable(this);
  late final $StoresTable stores = $StoresTable(this);
  late final $DepartmentsTable departments = $DepartmentsTable(this);
  late final $StoreDepartmentOrdersTable storeDepartmentOrders =
      $StoreDepartmentOrdersTable(this);
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $ProductMemoriesTable productMemories = $ProductMemoriesTable(
    this,
  );
  late final $AreasTable areas = $AreasTable(this);
  late final $ChoresTable chores = $ChoresTable(this);
  late final $ChoreCompletionsTable choreCompletions = $ChoreCompletionsTable(
    this,
  );
  late final $WastePickupsTable wastePickups = $WastePickupsTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeCollectionsTable recipeCollections =
      $RecipeCollectionsTable(this);
  late final $MealPlanEntriesTable mealPlanEntries = $MealPlanEntriesTable(
    this,
  );
  late final $LocalSettingsTable localSettings = $LocalSettingsTable(this);
  late final $PeersTable peers = $PeersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    members,
    stores,
    departments,
    storeDepartmentOrders,
    shoppingItems,
    productMemories,
    areas,
    chores,
    choreCompletions,
    wastePickups,
    recipes,
    recipeCollections,
    mealPlanEntries,
    localSettings,
    peers,
  ];
}

typedef $$MembersTableCreateCompanionBuilder = MembersCompanion Function({
  required String id,
  required int updatedAt,
  required int seq,
  Value<bool> deleted,
  required String name,
  required int color,
  Value<bool> paused,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$MembersTableUpdateCompanionBuilder = MembersCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<int> seq,
  Value<bool> deleted,
  Value<String> name,
  Value<int> color,
  Value<bool> paused,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$MembersTableFilterComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MembersTableOrderingComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paused => $composableBuilder(
    column: $table.paused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $MembersTable> {
  $$MembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get paused =>
      $composableBuilder(column: $table.paused, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$MembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MembersTable,
          Member,
          $$MembersTableFilterComposer,
          $$MembersTableOrderingComposer,
          $$MembersTableAnnotationComposer,
          $$MembersTableCreateCompanionBuilder,
          $$MembersTableUpdateCompanionBuilder,
          (Member, BaseReferences<_$AppDatabase, $MembersTable, Member>),
          Member,
          PrefetchHooks Function()
        > {
  $$MembersTableTableManager(_$AppDatabase db, $MembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> paused = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                color: color,
                paused: paused,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String name,
                required int color,
                Value<bool> paused = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MembersCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                color: color,
                paused: paused,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MembersTable, Member>(table),
                  BaseReferences<_$AppDatabase, $MembersTable, Member>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MembersTable,
      Member,
      $$MembersTableFilterComposer,
      $$MembersTableOrderingComposer,
      $$MembersTableAnnotationComposer,
      $$MembersTableCreateCompanionBuilder,
      $$MembersTableUpdateCompanionBuilder,
      (Member, BaseReferences<_$AppDatabase, $MembersTable, Member>),
      Member,
      PrefetchHooks Function()
    >;
typedef $$StoresTableCreateCompanionBuilder = StoresCompanion Function({
  required String id,
  required int updatedAt,
  required int seq,
  Value<bool> deleted,
  required String name,
  required int color,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$StoresTableUpdateCompanionBuilder = StoresCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<int> seq,
  Value<bool> deleted,
  Value<String> name,
  Value<int> color,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$StoresTableFilterComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoresTableOrderingComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoresTable> {
  $$StoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$StoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoresTable,
          Store,
          $$StoresTableFilterComposer,
          $$StoresTableOrderingComposer,
          $$StoresTableAnnotationComposer,
          $$StoresTableCreateCompanionBuilder,
          $$StoresTableUpdateCompanionBuilder,
          (Store, BaseReferences<_$AppDatabase, $StoresTable, Store>),
          Store,
          PrefetchHooks Function()
        > {
  $$StoresTableTableManager(_$AppDatabase db, $StoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                color: color,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String name,
                required int color,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoresCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                color: color,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StoresTable, Store>(table),
                  BaseReferences<_$AppDatabase, $StoresTable, Store>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoresTable,
      Store,
      $$StoresTableFilterComposer,
      $$StoresTableOrderingComposer,
      $$StoresTableAnnotationComposer,
      $$StoresTableCreateCompanionBuilder,
      $$StoresTableUpdateCompanionBuilder,
      (Store, BaseReferences<_$AppDatabase, $StoresTable, Store>),
      Store,
      PrefetchHooks Function()
    >;
typedef $$DepartmentsTableCreateCompanionBuilder =
    DepartmentsCompanion Function({
      required String id,
      required int updatedAt,
      required int seq,
      Value<bool> deleted,
      Value<String?> name,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$DepartmentsTableUpdateCompanionBuilder =
    DepartmentsCompanion Function({
      Value<String> id,
      Value<int> updatedAt,
      Value<int> seq,
      Value<bool> deleted,
      Value<String?> name,
      Value<int> sortOrder,
      Value<int> rowid,
    });

class $$DepartmentsTableFilterComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DepartmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DepartmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DepartmentsTable> {
  $$DepartmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DepartmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DepartmentsTable,
          Department,
          $$DepartmentsTableFilterComposer,
          $$DepartmentsTableOrderingComposer,
          $$DepartmentsTableAnnotationComposer,
          $$DepartmentsTableCreateCompanionBuilder,
          $$DepartmentsTableUpdateCompanionBuilder,
          (
            Department,
            BaseReferences<_$AppDatabase, $DepartmentsTable, Department>,
          ),
          Department,
          PrefetchHooks Function()
        > {
  $$DepartmentsTableTableManager(_$AppDatabase db, $DepartmentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DepartmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DepartmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DepartmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DepartmentsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DepartmentsTable, Department>(table),
                  BaseReferences<_$AppDatabase, $DepartmentsTable, Department>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DepartmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DepartmentsTable,
      Department,
      $$DepartmentsTableFilterComposer,
      $$DepartmentsTableOrderingComposer,
      $$DepartmentsTableAnnotationComposer,
      $$DepartmentsTableCreateCompanionBuilder,
      $$DepartmentsTableUpdateCompanionBuilder,
      (
        Department,
        BaseReferences<_$AppDatabase, $DepartmentsTable, Department>,
      ),
      Department,
      PrefetchHooks Function()
    >;
typedef $$StoreDepartmentOrdersTableCreateCompanionBuilder =
    StoreDepartmentOrdersCompanion Function({
      required String id,
      required int updatedAt,
      required int seq,
      Value<bool> deleted,
      required String storeId,
      required String departmentId,
      required double position,
      Value<int> rowid,
    });
typedef $$StoreDepartmentOrdersTableUpdateCompanionBuilder =
    StoreDepartmentOrdersCompanion Function({
      Value<String> id,
      Value<int> updatedAt,
      Value<int> seq,
      Value<bool> deleted,
      Value<String> storeId,
      Value<String> departmentId,
      Value<double> position,
      Value<int> rowid,
    });

class $$StoreDepartmentOrdersTableFilterComposer
    extends Composer<_$AppDatabase, $StoreDepartmentOrdersTable> {
  $$StoreDepartmentOrdersTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StoreDepartmentOrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $StoreDepartmentOrdersTable> {
  $$StoreDepartmentOrdersTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeId => $composableBuilder(
    column: $table.storeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StoreDepartmentOrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $StoreDepartmentOrdersTable> {
  $$StoreDepartmentOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get storeId =>
      $composableBuilder(column: $table.storeId, builder: (column) => column);

  GeneratedColumn<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);
}

class $$StoreDepartmentOrdersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StoreDepartmentOrdersTable,
          StoreDepartmentOrder,
          $$StoreDepartmentOrdersTableFilterComposer,
          $$StoreDepartmentOrdersTableOrderingComposer,
          $$StoreDepartmentOrdersTableAnnotationComposer,
          $$StoreDepartmentOrdersTableCreateCompanionBuilder,
          $$StoreDepartmentOrdersTableUpdateCompanionBuilder,
          (
            StoreDepartmentOrder,
            BaseReferences<
              _$AppDatabase,
              $StoreDepartmentOrdersTable,
              StoreDepartmentOrder
            >,
          ),
          StoreDepartmentOrder,
          PrefetchHooks Function()
        > {
  $$StoreDepartmentOrdersTableTableManager(
    _$AppDatabase db,
    $StoreDepartmentOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StoreDepartmentOrdersTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$StoreDepartmentOrdersTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$StoreDepartmentOrdersTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> storeId = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<double> position = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StoreDepartmentOrdersCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                storeId: storeId,
                departmentId: departmentId,
                position: position,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String storeId,
                required String departmentId,
                required double position,
                Value<int> rowid = const Value.absent(),
              }) => StoreDepartmentOrdersCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                storeId: storeId,
                departmentId: departmentId,
                position: position,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<
                    $StoreDepartmentOrdersTable,
                    StoreDepartmentOrder
                  >(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StoreDepartmentOrdersTable,
                    StoreDepartmentOrder
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StoreDepartmentOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StoreDepartmentOrdersTable,
      StoreDepartmentOrder,
      $$StoreDepartmentOrdersTableFilterComposer,
      $$StoreDepartmentOrdersTableOrderingComposer,
      $$StoreDepartmentOrdersTableAnnotationComposer,
      $$StoreDepartmentOrdersTableCreateCompanionBuilder,
      $$StoreDepartmentOrdersTableUpdateCompanionBuilder,
      (
        StoreDepartmentOrder,
        BaseReferences<
          _$AppDatabase,
          $StoreDepartmentOrdersTable,
          StoreDepartmentOrder
        >,
      ),
      StoreDepartmentOrder,
      PrefetchHooks Function()
    >;
typedef $$ShoppingItemsTableCreateCompanionBuilder =
    ShoppingItemsCompanion Function({
      required String id,
      required int updatedAt,
      required int seq,
      Value<bool> deleted,
      required String name,
      required String normalized,
      Value<double?> amount,
      Value<String?> unit,
      Value<String?> note,
      required String departmentId,
      Value<String> storeIds,
      Value<int> status,
      Value<String?> addedBy,
      Value<String?> source,
      required int createdAt,
      Value<int?> doneAt,
      Value<String?> doneStoreId,
      Value<int> rowid,
    });
typedef $$ShoppingItemsTableUpdateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<String> id,
      Value<int> updatedAt,
      Value<int> seq,
      Value<bool> deleted,
      Value<String> name,
      Value<String> normalized,
      Value<double?> amount,
      Value<String?> unit,
      Value<String?> note,
      Value<String> departmentId,
      Value<String> storeIds,
      Value<int> status,
      Value<String?> addedBy,
      Value<String?> source,
      Value<int> createdAt,
      Value<int?> doneAt,
      Value<String?> doneStoreId,
      Value<int> rowid,
    });

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get normalized => $composableBuilder(
    column: $table.normalized,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeIds => $composableBuilder(
    column: $table.storeIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get addedBy => $composableBuilder(
    column: $table.addedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get doneStoreId => $composableBuilder(
    column: $table.doneStoreId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get normalized => $composableBuilder(
    column: $table.normalized,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeIds => $composableBuilder(
    column: $table.storeIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get addedBy => $composableBuilder(
    column: $table.addedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get doneStoreId => $composableBuilder(
    column: $table.doneStoreId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get normalized => $composableBuilder(
    column: $table.normalized,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeIds =>
      $composableBuilder(column: $table.storeIds, builder: (column) => column);

  GeneratedColumn<int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get addedBy =>
      $composableBuilder(column: $table.addedBy, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  GeneratedColumn<String> get doneStoreId => $composableBuilder(
    column: $table.doneStoreId,
    builder: (column) => column,
  );
}

class $$ShoppingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingItemsTable,
          ShoppingItem,
          $$ShoppingItemsTableFilterComposer,
          $$ShoppingItemsTableOrderingComposer,
          $$ShoppingItemsTableAnnotationComposer,
          $$ShoppingItemsTableCreateCompanionBuilder,
          $$ShoppingItemsTableUpdateCompanionBuilder,
          (
            ShoppingItem,
            BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>,
          ),
          ShoppingItem,
          PrefetchHooks Function()
        > {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> normalized = const Value.absent(),
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> storeIds = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> addedBy = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> doneAt = const Value.absent(),
                Value<String?> doneStoreId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingItemsCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                normalized: normalized,
                amount: amount,
                unit: unit,
                note: note,
                departmentId: departmentId,
                storeIds: storeIds,
                status: status,
                addedBy: addedBy,
                source: source,
                createdAt: createdAt,
                doneAt: doneAt,
                doneStoreId: doneStoreId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String name,
                required String normalized,
                Value<double?> amount = const Value.absent(),
                Value<String?> unit = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required String departmentId,
                Value<String> storeIds = const Value.absent(),
                Value<int> status = const Value.absent(),
                Value<String?> addedBy = const Value.absent(),
                Value<String?> source = const Value.absent(),
                required int createdAt,
                Value<int?> doneAt = const Value.absent(),
                Value<String?> doneStoreId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ShoppingItemsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                normalized: normalized,
                amount: amount,
                unit: unit,
                note: note,
                departmentId: departmentId,
                storeIds: storeIds,
                status: status,
                addedBy: addedBy,
                source: source,
                createdAt: createdAt,
                doneAt: doneAt,
                doneStoreId: doneStoreId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ShoppingItemsTable, ShoppingItem>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ShoppingItemsTable,
                    ShoppingItem
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ShoppingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingItemsTable,
      ShoppingItem,
      $$ShoppingItemsTableFilterComposer,
      $$ShoppingItemsTableOrderingComposer,
      $$ShoppingItemsTableAnnotationComposer,
      $$ShoppingItemsTableCreateCompanionBuilder,
      $$ShoppingItemsTableUpdateCompanionBuilder,
      (
        ShoppingItem,
        BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem>,
      ),
      ShoppingItem,
      PrefetchHooks Function()
    >;
typedef $$ProductMemoriesTableCreateCompanionBuilder =
    ProductMemoriesCompanion Function({
      required String id,
      required int updatedAt,
      required int seq,
      Value<bool> deleted,
      required String name,
      required String departmentId,
      Value<String> storeCounts,
      Value<int> usageCount,
      Value<int?> lastBoughtAt,
      Value<double?> avgIntervalDays,
      Value<bool> staple,
      Value<int> rowid,
    });
typedef $$ProductMemoriesTableUpdateCompanionBuilder =
    ProductMemoriesCompanion Function({
      Value<String> id,
      Value<int> updatedAt,
      Value<int> seq,
      Value<bool> deleted,
      Value<String> name,
      Value<String> departmentId,
      Value<String> storeCounts,
      Value<int> usageCount,
      Value<int?> lastBoughtAt,
      Value<double?> avgIntervalDays,
      Value<bool> staple,
      Value<int> rowid,
    });

class $$ProductMemoriesTableFilterComposer
    extends Composer<_$AppDatabase, $ProductMemoriesTable> {
  $$ProductMemoriesTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get storeCounts => $composableBuilder(
    column: $table.storeCounts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastBoughtAt => $composableBuilder(
    column: $table.lastBoughtAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgIntervalDays => $composableBuilder(
    column: $table.avgIntervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get staple => $composableBuilder(
    column: $table.staple,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProductMemoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProductMemoriesTable> {
  $$ProductMemoriesTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get storeCounts => $composableBuilder(
    column: $table.storeCounts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastBoughtAt => $composableBuilder(
    column: $table.lastBoughtAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgIntervalDays => $composableBuilder(
    column: $table.avgIntervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get staple => $composableBuilder(
    column: $table.staple,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProductMemoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProductMemoriesTable> {
  $$ProductMemoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get departmentId => $composableBuilder(
    column: $table.departmentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get storeCounts => $composableBuilder(
    column: $table.storeCounts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get usageCount => $composableBuilder(
    column: $table.usageCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastBoughtAt => $composableBuilder(
    column: $table.lastBoughtAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgIntervalDays => $composableBuilder(
    column: $table.avgIntervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get staple =>
      $composableBuilder(column: $table.staple, builder: (column) => column);
}

class $$ProductMemoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProductMemoriesTable,
          ProductMemory,
          $$ProductMemoriesTableFilterComposer,
          $$ProductMemoriesTableOrderingComposer,
          $$ProductMemoriesTableAnnotationComposer,
          $$ProductMemoriesTableCreateCompanionBuilder,
          $$ProductMemoriesTableUpdateCompanionBuilder,
          (
            ProductMemory,
            BaseReferences<_$AppDatabase, $ProductMemoriesTable, ProductMemory>,
          ),
          ProductMemory,
          PrefetchHooks Function()
        > {
  $$ProductMemoriesTableTableManager(
    _$AppDatabase db,
    $ProductMemoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProductMemoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProductMemoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProductMemoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> departmentId = const Value.absent(),
                Value<String> storeCounts = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<int?> lastBoughtAt = const Value.absent(),
                Value<double?> avgIntervalDays = const Value.absent(),
                Value<bool> staple = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductMemoriesCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                departmentId: departmentId,
                storeCounts: storeCounts,
                usageCount: usageCount,
                lastBoughtAt: lastBoughtAt,
                avgIntervalDays: avgIntervalDays,
                staple: staple,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String name,
                required String departmentId,
                Value<String> storeCounts = const Value.absent(),
                Value<int> usageCount = const Value.absent(),
                Value<int?> lastBoughtAt = const Value.absent(),
                Value<double?> avgIntervalDays = const Value.absent(),
                Value<bool> staple = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProductMemoriesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                departmentId: departmentId,
                storeCounts: storeCounts,
                usageCount: usageCount,
                lastBoughtAt: lastBoughtAt,
                avgIntervalDays: avgIntervalDays,
                staple: staple,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ProductMemoriesTable, ProductMemory>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ProductMemoriesTable,
                    ProductMemory
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProductMemoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProductMemoriesTable,
      ProductMemory,
      $$ProductMemoriesTableFilterComposer,
      $$ProductMemoriesTableOrderingComposer,
      $$ProductMemoriesTableAnnotationComposer,
      $$ProductMemoriesTableCreateCompanionBuilder,
      $$ProductMemoriesTableUpdateCompanionBuilder,
      (
        ProductMemory,
        BaseReferences<_$AppDatabase, $ProductMemoriesTable, ProductMemory>,
      ),
      ProductMemory,
      PrefetchHooks Function()
    >;
typedef $$AreasTableCreateCompanionBuilder = AreasCompanion Function({
  required String id,
  required int updatedAt,
  required int seq,
  Value<bool> deleted,
  Value<String?> name,
  Value<int> sortOrder,
  Value<int> rowid,
});
typedef $$AreasTableUpdateCompanionBuilder = AreasCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<int> seq,
  Value<bool> deleted,
  Value<String?> name,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$AreasTableFilterComposer extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AreasTableOrderingComposer
    extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AreasTableAnnotationComposer
    extends Composer<_$AppDatabase, $AreasTable> {
  $$AreasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$AreasTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AreasTable,
          Area,
          $$AreasTableFilterComposer,
          $$AreasTableOrderingComposer,
          $$AreasTableAnnotationComposer,
          $$AreasTableCreateCompanionBuilder,
          $$AreasTableUpdateCompanionBuilder,
          (Area, BaseReferences<_$AppDatabase, $AreasTable, Area>),
          Area,
          PrefetchHooks Function()
        > {
  $$AreasTableTableManager(_$AppDatabase db, $AreasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AreasTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AreasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AreasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AreasCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                Value<String?> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AreasCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AreasTable, Area>(table),
                  BaseReferences<_$AppDatabase, $AreasTable, Area>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AreasTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AreasTable,
      Area,
      $$AreasTableFilterComposer,
      $$AreasTableOrderingComposer,
      $$AreasTableAnnotationComposer,
      $$AreasTableCreateCompanionBuilder,
      $$AreasTableUpdateCompanionBuilder,
      (Area, BaseReferences<_$AppDatabase, $AreasTable, Area>),
      Area,
      PrefetchHooks Function()
    >;
typedef $$ChoresTableCreateCompanionBuilder = ChoresCompanion Function({
  required String id,
  required int updatedAt,
  required int seq,
  Value<bool> deleted,
  required String name,
  required String areaId,
  Value<int> effortMinutes,
  Value<int> recurrence,
  Value<int> intervalDays,
  Value<int> weekdays,
  Value<int?> dueDate,
  Value<int> assignment,
  Value<String?> assigneeId,
  Value<int?> lastDoneAt,
  Value<String?> lastDoneBy,
  Value<int?> snoozedUntil,
  Value<bool> remind,
  required int createdAt,
  Value<int> rowid,
});
typedef $$ChoresTableUpdateCompanionBuilder = ChoresCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<int> seq,
  Value<bool> deleted,
  Value<String> name,
  Value<String> areaId,
  Value<int> effortMinutes,
  Value<int> recurrence,
  Value<int> intervalDays,
  Value<int> weekdays,
  Value<int?> dueDate,
  Value<int> assignment,
  Value<String?> assigneeId,
  Value<int?> lastDoneAt,
  Value<String?> lastDoneBy,
  Value<int?> snoozedUntil,
  Value<bool> remind,
  Value<int> createdAt,
  Value<int> rowid,
});

class $$ChoresTableFilterComposer
    extends Composer<_$AppDatabase, $ChoresTable> {
  $$ChoresTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get areaId => $composableBuilder(
    column: $table.areaId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get effortMinutes => $composableBuilder(
    column: $table.effortMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assignment => $composableBuilder(
    column: $table.assignment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assigneeId => $composableBuilder(
    column: $table.assigneeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastDoneAt => $composableBuilder(
    column: $table.lastDoneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastDoneBy => $composableBuilder(
    column: $table.lastDoneBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get remind => $composableBuilder(
    column: $table.remind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChoresTableOrderingComposer
    extends Composer<_$AppDatabase, $ChoresTable> {
  $$ChoresTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get areaId => $composableBuilder(
    column: $table.areaId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effortMinutes => $composableBuilder(
    column: $table.effortMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekdays => $composableBuilder(
    column: $table.weekdays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDate => $composableBuilder(
    column: $table.dueDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assignment => $composableBuilder(
    column: $table.assignment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assigneeId => $composableBuilder(
    column: $table.assigneeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastDoneAt => $composableBuilder(
    column: $table.lastDoneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastDoneBy => $composableBuilder(
    column: $table.lastDoneBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get remind => $composableBuilder(
    column: $table.remind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChoresTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChoresTable> {
  $$ChoresTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get areaId =>
      $composableBuilder(column: $table.areaId, builder: (column) => column);

  GeneratedColumn<int> get effortMinutes => $composableBuilder(
    column: $table.effortMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get recurrence => $composableBuilder(
    column: $table.recurrence,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weekdays =>
      $composableBuilder(column: $table.weekdays, builder: (column) => column);

  GeneratedColumn<int> get dueDate =>
      $composableBuilder(column: $table.dueDate, builder: (column) => column);

  GeneratedColumn<int> get assignment => $composableBuilder(
    column: $table.assignment,
    builder: (column) => column,
  );

  GeneratedColumn<String> get assigneeId => $composableBuilder(
    column: $table.assigneeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastDoneAt => $composableBuilder(
    column: $table.lastDoneAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastDoneBy => $composableBuilder(
    column: $table.lastDoneBy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get snoozedUntil => $composableBuilder(
    column: $table.snoozedUntil,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get remind =>
      $composableBuilder(column: $table.remind, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ChoresTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChoresTable,
          Chore,
          $$ChoresTableFilterComposer,
          $$ChoresTableOrderingComposer,
          $$ChoresTableAnnotationComposer,
          $$ChoresTableCreateCompanionBuilder,
          $$ChoresTableUpdateCompanionBuilder,
          (Chore, BaseReferences<_$AppDatabase, $ChoresTable, Chore>),
          Chore,
          PrefetchHooks Function()
        > {
  $$ChoresTableTableManager(_$AppDatabase db, $ChoresTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChoresTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChoresTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChoresTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> areaId = const Value.absent(),
                Value<int> effortMinutes = const Value.absent(),
                Value<int> recurrence = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<int> assignment = const Value.absent(),
                Value<String?> assigneeId = const Value.absent(),
                Value<int?> lastDoneAt = const Value.absent(),
                Value<String?> lastDoneBy = const Value.absent(),
                Value<int?> snoozedUntil = const Value.absent(),
                Value<bool> remind = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChoresCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                areaId: areaId,
                effortMinutes: effortMinutes,
                recurrence: recurrence,
                intervalDays: intervalDays,
                weekdays: weekdays,
                dueDate: dueDate,
                assignment: assignment,
                assigneeId: assigneeId,
                lastDoneAt: lastDoneAt,
                lastDoneBy: lastDoneBy,
                snoozedUntil: snoozedUntil,
                remind: remind,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String name,
                required String areaId,
                Value<int> effortMinutes = const Value.absent(),
                Value<int> recurrence = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<int> weekdays = const Value.absent(),
                Value<int?> dueDate = const Value.absent(),
                Value<int> assignment = const Value.absent(),
                Value<String?> assigneeId = const Value.absent(),
                Value<int?> lastDoneAt = const Value.absent(),
                Value<String?> lastDoneBy = const Value.absent(),
                Value<int?> snoozedUntil = const Value.absent(),
                Value<bool> remind = const Value.absent(),
                required int createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ChoresCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                areaId: areaId,
                effortMinutes: effortMinutes,
                recurrence: recurrence,
                intervalDays: intervalDays,
                weekdays: weekdays,
                dueDate: dueDate,
                assignment: assignment,
                assigneeId: assigneeId,
                lastDoneAt: lastDoneAt,
                lastDoneBy: lastDoneBy,
                snoozedUntil: snoozedUntil,
                remind: remind,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChoresTable, Chore>(table),
                  BaseReferences<_$AppDatabase, $ChoresTable, Chore>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChoresTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChoresTable,
      Chore,
      $$ChoresTableFilterComposer,
      $$ChoresTableOrderingComposer,
      $$ChoresTableAnnotationComposer,
      $$ChoresTableCreateCompanionBuilder,
      $$ChoresTableUpdateCompanionBuilder,
      (Chore, BaseReferences<_$AppDatabase, $ChoresTable, Chore>),
      Chore,
      PrefetchHooks Function()
    >;
typedef $$ChoreCompletionsTableCreateCompanionBuilder =
    ChoreCompletionsCompanion Function({
      required String id,
      required int updatedAt,
      required int seq,
      Value<bool> deleted,
      required String choreId,
      Value<String?> memberId,
      required int doneAt,
      Value<int> effortMinutes,
      Value<int> rowid,
    });
typedef $$ChoreCompletionsTableUpdateCompanionBuilder =
    ChoreCompletionsCompanion Function({
      Value<String> id,
      Value<int> updatedAt,
      Value<int> seq,
      Value<bool> deleted,
      Value<String> choreId,
      Value<String?> memberId,
      Value<int> doneAt,
      Value<int> effortMinutes,
      Value<int> rowid,
    });

class $$ChoreCompletionsTableFilterComposer
    extends Composer<_$AppDatabase, $ChoreCompletionsTable> {
  $$ChoreCompletionsTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get choreId => $composableBuilder(
    column: $table.choreId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get effortMinutes => $composableBuilder(
    column: $table.effortMinutes,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChoreCompletionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ChoreCompletionsTable> {
  $$ChoreCompletionsTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get choreId => $composableBuilder(
    column: $table.choreId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get memberId => $composableBuilder(
    column: $table.memberId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get doneAt => $composableBuilder(
    column: $table.doneAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get effortMinutes => $composableBuilder(
    column: $table.effortMinutes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChoreCompletionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ChoreCompletionsTable> {
  $$ChoreCompletionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get choreId =>
      $composableBuilder(column: $table.choreId, builder: (column) => column);

  GeneratedColumn<String> get memberId =>
      $composableBuilder(column: $table.memberId, builder: (column) => column);

  GeneratedColumn<int> get doneAt =>
      $composableBuilder(column: $table.doneAt, builder: (column) => column);

  GeneratedColumn<int> get effortMinutes => $composableBuilder(
    column: $table.effortMinutes,
    builder: (column) => column,
  );
}

class $$ChoreCompletionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ChoreCompletionsTable,
          ChoreCompletion,
          $$ChoreCompletionsTableFilterComposer,
          $$ChoreCompletionsTableOrderingComposer,
          $$ChoreCompletionsTableAnnotationComposer,
          $$ChoreCompletionsTableCreateCompanionBuilder,
          $$ChoreCompletionsTableUpdateCompanionBuilder,
          (
            ChoreCompletion,
            BaseReferences<
              _$AppDatabase,
              $ChoreCompletionsTable,
              ChoreCompletion
            >,
          ),
          ChoreCompletion,
          PrefetchHooks Function()
        > {
  $$ChoreCompletionsTableTableManager(
    _$AppDatabase db,
    $ChoreCompletionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ChoreCompletionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ChoreCompletionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ChoreCompletionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> choreId = const Value.absent(),
                Value<String?> memberId = const Value.absent(),
                Value<int> doneAt = const Value.absent(),
                Value<int> effortMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChoreCompletionsCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                choreId: choreId,
                memberId: memberId,
                doneAt: doneAt,
                effortMinutes: effortMinutes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String choreId,
                Value<String?> memberId = const Value.absent(),
                required int doneAt,
                Value<int> effortMinutes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChoreCompletionsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                choreId: choreId,
                memberId: memberId,
                doneAt: doneAt,
                effortMinutes: effortMinutes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChoreCompletionsTable, ChoreCompletion>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $ChoreCompletionsTable,
                    ChoreCompletion
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChoreCompletionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ChoreCompletionsTable,
      ChoreCompletion,
      $$ChoreCompletionsTableFilterComposer,
      $$ChoreCompletionsTableOrderingComposer,
      $$ChoreCompletionsTableAnnotationComposer,
      $$ChoreCompletionsTableCreateCompanionBuilder,
      $$ChoreCompletionsTableUpdateCompanionBuilder,
      (
        ChoreCompletion,
        BaseReferences<_$AppDatabase, $ChoreCompletionsTable, ChoreCompletion>,
      ),
      ChoreCompletion,
      PrefetchHooks Function()
    >;
typedef $$WastePickupsTableCreateCompanionBuilder =
    WastePickupsCompanion Function({
      required String id,
      required int updatedAt,
      required int seq,
      Value<bool> deleted,
      required int type,
      required String day,
      Value<String?> assigneeId,
      Value<int> rowid,
    });
typedef $$WastePickupsTableUpdateCompanionBuilder =
    WastePickupsCompanion Function({
      Value<String> id,
      Value<int> updatedAt,
      Value<int> seq,
      Value<bool> deleted,
      Value<int> type,
      Value<String> day,
      Value<String?> assigneeId,
      Value<int> rowid,
    });

class $$WastePickupsTableFilterComposer
    extends Composer<_$AppDatabase, $WastePickupsTable> {
  $$WastePickupsTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get assigneeId => $composableBuilder(
    column: $table.assigneeId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WastePickupsTableOrderingComposer
    extends Composer<_$AppDatabase, $WastePickupsTable> {
  $$WastePickupsTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get assigneeId => $composableBuilder(
    column: $table.assigneeId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WastePickupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WastePickupsTable> {
  $$WastePickupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get assigneeId => $composableBuilder(
    column: $table.assigneeId,
    builder: (column) => column,
  );
}

class $$WastePickupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WastePickupsTable,
          WastePickup,
          $$WastePickupsTableFilterComposer,
          $$WastePickupsTableOrderingComposer,
          $$WastePickupsTableAnnotationComposer,
          $$WastePickupsTableCreateCompanionBuilder,
          $$WastePickupsTableUpdateCompanionBuilder,
          (
            WastePickup,
            BaseReferences<_$AppDatabase, $WastePickupsTable, WastePickup>,
          ),
          WastePickup,
          PrefetchHooks Function()
        > {
  $$WastePickupsTableTableManager(_$AppDatabase db, $WastePickupsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WastePickupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WastePickupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WastePickupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<int> type = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String?> assigneeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WastePickupsCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                type: type,
                day: day,
                assigneeId: assigneeId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required int type,
                required String day,
                Value<String?> assigneeId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WastePickupsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                type: type,
                day: day,
                assigneeId: assigneeId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WastePickupsTable, WastePickup>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WastePickupsTable,
                    WastePickup
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WastePickupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WastePickupsTable,
      WastePickup,
      $$WastePickupsTableFilterComposer,
      $$WastePickupsTableOrderingComposer,
      $$WastePickupsTableAnnotationComposer,
      $$WastePickupsTableCreateCompanionBuilder,
      $$WastePickupsTableUpdateCompanionBuilder,
      (
        WastePickup,
        BaseReferences<_$AppDatabase, $WastePickupsTable, WastePickup>,
      ),
      WastePickup,
      PrefetchHooks Function()
    >;
typedef $$RecipesTableCreateCompanionBuilder = RecipesCompanion Function({
  required String id,
  required int updatedAt,
  required int seq,
  Value<bool> deleted,
  required String title,
  Value<int> servings,
  Value<int?> prepMinutes,
  Value<int?> cookMinutes,
  Value<int?> restMinutes,
  Value<int> difficulty,
  Value<String> ingredients,
  Value<String> steps,
  Value<String?> tips,
  Value<String?> story,
  Value<String?> source,
  Value<String> tags,
  Value<String> collectionIds,
  Value<bool> favorite,
  Value<String?> createdBy,
  required int createdAt,
  Value<int?> lastCookedAt,
  Value<int> rowid,
});
typedef $$RecipesTableUpdateCompanionBuilder = RecipesCompanion Function({
  Value<String> id,
  Value<int> updatedAt,
  Value<int> seq,
  Value<bool> deleted,
  Value<String> title,
  Value<int> servings,
  Value<int?> prepMinutes,
  Value<int?> cookMinutes,
  Value<int?> restMinutes,
  Value<int> difficulty,
  Value<String> ingredients,
  Value<String> steps,
  Value<String?> tips,
  Value<String?> story,
  Value<String?> source,
  Value<String> tags,
  Value<String> collectionIds,
  Value<bool> favorite,
  Value<String?> createdBy,
  Value<int> createdAt,
  Value<int?> lastCookedAt,
  Value<int> rowid,
});

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tips => $composableBuilder(
    column: $table.tips,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get collectionIds => $composableBuilder(
    column: $table.collectionIds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastCookedAt => $composableBuilder(
    column: $table.lastCookedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get steps => $composableBuilder(
    column: $table.steps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tips => $composableBuilder(
    column: $table.tips,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get story => $composableBuilder(
    column: $table.story,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get collectionIds => $composableBuilder(
    column: $table.collectionIds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get favorite => $composableBuilder(
    column: $table.favorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastCookedAt => $composableBuilder(
    column: $table.lastCookedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get prepMinutes => $composableBuilder(
    column: $table.prepMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cookMinutes => $composableBuilder(
    column: $table.cookMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restMinutes => $composableBuilder(
    column: $table.restMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get ingredients => $composableBuilder(
    column: $table.ingredients,
    builder: (column) => column,
  );

  GeneratedColumn<String> get steps =>
      $composableBuilder(column: $table.steps, builder: (column) => column);

  GeneratedColumn<String> get tips =>
      $composableBuilder(column: $table.tips, builder: (column) => column);

  GeneratedColumn<String> get story =>
      $composableBuilder(column: $table.story, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get collectionIds => $composableBuilder(
    column: $table.collectionIds,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get favorite =>
      $composableBuilder(column: $table.favorite, builder: (column) => column);

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get lastCookedAt => $composableBuilder(
    column: $table.lastCookedAt,
    builder: (column) => column,
  );
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
          Recipe,
          PrefetchHooks Function()
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<int?> prepMinutes = const Value.absent(),
                Value<int?> cookMinutes = const Value.absent(),
                Value<int?> restMinutes = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<String> ingredients = const Value.absent(),
                Value<String> steps = const Value.absent(),
                Value<String?> tips = const Value.absent(),
                Value<String?> story = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> collectionIds = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
                Value<int?> lastCookedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                title: title,
                servings: servings,
                prepMinutes: prepMinutes,
                cookMinutes: cookMinutes,
                restMinutes: restMinutes,
                difficulty: difficulty,
                ingredients: ingredients,
                steps: steps,
                tips: tips,
                story: story,
                source: source,
                tags: tags,
                collectionIds: collectionIds,
                favorite: favorite,
                createdBy: createdBy,
                createdAt: createdAt,
                lastCookedAt: lastCookedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String title,
                Value<int> servings = const Value.absent(),
                Value<int?> prepMinutes = const Value.absent(),
                Value<int?> cookMinutes = const Value.absent(),
                Value<int?> restMinutes = const Value.absent(),
                Value<int> difficulty = const Value.absent(),
                Value<String> ingredients = const Value.absent(),
                Value<String> steps = const Value.absent(),
                Value<String?> tips = const Value.absent(),
                Value<String?> story = const Value.absent(),
                Value<String?> source = const Value.absent(),
                Value<String> tags = const Value.absent(),
                Value<String> collectionIds = const Value.absent(),
                Value<bool> favorite = const Value.absent(),
                Value<String?> createdBy = const Value.absent(),
                required int createdAt,
                Value<int?> lastCookedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                title: title,
                servings: servings,
                prepMinutes: prepMinutes,
                cookMinutes: cookMinutes,
                restMinutes: restMinutes,
                difficulty: difficulty,
                ingredients: ingredients,
                steps: steps,
                tips: tips,
                story: story,
                source: source,
                tags: tags,
                collectionIds: collectionIds,
                favorite: favorite,
                createdBy: createdBy,
                createdAt: createdAt,
                lastCookedAt: lastCookedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipesTable, Recipe>(table),
                  BaseReferences<_$AppDatabase, $RecipesTable, Recipe>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, BaseReferences<_$AppDatabase, $RecipesTable, Recipe>),
      Recipe,
      PrefetchHooks Function()
    >;
typedef $$RecipeCollectionsTableCreateCompanionBuilder =
    RecipeCollectionsCompanion Function({
      required String id,
      required int updatedAt,
      required int seq,
      Value<bool> deleted,
      required String name,
      Value<int> color,
      Value<int> rowid,
    });
typedef $$RecipeCollectionsTableUpdateCompanionBuilder =
    RecipeCollectionsCompanion Function({
      Value<String> id,
      Value<int> updatedAt,
      Value<int> seq,
      Value<bool> deleted,
      Value<String> name,
      Value<int> color,
      Value<int> rowid,
    });

class $$RecipeCollectionsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeCollectionsTable> {
  $$RecipeCollectionsTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecipeCollectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeCollectionsTable> {
  $$RecipeCollectionsTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipeCollectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeCollectionsTable> {
  $$RecipeCollectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);
}

class $$RecipeCollectionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeCollectionsTable,
          RecipeCollection,
          $$RecipeCollectionsTableFilterComposer,
          $$RecipeCollectionsTableOrderingComposer,
          $$RecipeCollectionsTableAnnotationComposer,
          $$RecipeCollectionsTableCreateCompanionBuilder,
          $$RecipeCollectionsTableUpdateCompanionBuilder,
          (
            RecipeCollection,
            BaseReferences<
              _$AppDatabase,
              $RecipeCollectionsTable,
              RecipeCollection
            >,
          ),
          RecipeCollection,
          PrefetchHooks Function()
        > {
  $$RecipeCollectionsTableTableManager(
    _$AppDatabase db,
    $RecipeCollectionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeCollectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeCollectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeCollectionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeCollectionsCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                color: color,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String name,
                Value<int> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecipeCollectionsCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                name: name,
                color: color,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RecipeCollectionsTable, RecipeCollection>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $RecipeCollectionsTable,
                    RecipeCollection
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecipeCollectionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeCollectionsTable,
      RecipeCollection,
      $$RecipeCollectionsTableFilterComposer,
      $$RecipeCollectionsTableOrderingComposer,
      $$RecipeCollectionsTableAnnotationComposer,
      $$RecipeCollectionsTableCreateCompanionBuilder,
      $$RecipeCollectionsTableUpdateCompanionBuilder,
      (
        RecipeCollection,
        BaseReferences<
          _$AppDatabase,
          $RecipeCollectionsTable,
          RecipeCollection
        >,
      ),
      RecipeCollection,
      PrefetchHooks Function()
    >;
typedef $$MealPlanEntriesTableCreateCompanionBuilder =
    MealPlanEntriesCompanion Function({
      required String id,
      required int updatedAt,
      required int seq,
      Value<bool> deleted,
      required String day,
      Value<String?> recipeId,
      required String title,
      Value<int?> servings,
      Value<String?> cookId,
      Value<int> rowid,
    });
typedef $$MealPlanEntriesTableUpdateCompanionBuilder =
    MealPlanEntriesCompanion Function({
      Value<String> id,
      Value<int> updatedAt,
      Value<int> seq,
      Value<bool> deleted,
      Value<String> day,
      Value<String?> recipeId,
      Value<String> title,
      Value<int?> servings,
      Value<String?> cookId,
      Value<int> rowid,
    });

class $$MealPlanEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $MealPlanEntriesTable> {
  $$MealPlanEntriesTableFilterComposer({
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

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get cookId => $composableBuilder(
    column: $table.cookId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MealPlanEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $MealPlanEntriesTable> {
  $$MealPlanEntriesTableOrderingComposer({
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

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get deleted => $composableBuilder(
    column: $table.deleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get day => $composableBuilder(
    column: $table.day,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recipeId => $composableBuilder(
    column: $table.recipeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get cookId => $composableBuilder(
    column: $table.cookId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MealPlanEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealPlanEntriesTable> {
  $$MealPlanEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get seq =>
      $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<bool> get deleted =>
      $composableBuilder(column: $table.deleted, builder: (column) => column);

  GeneratedColumn<String> get day =>
      $composableBuilder(column: $table.day, builder: (column) => column);

  GeneratedColumn<String> get recipeId =>
      $composableBuilder(column: $table.recipeId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<String> get cookId =>
      $composableBuilder(column: $table.cookId, builder: (column) => column);
}

class $$MealPlanEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealPlanEntriesTable,
          MealPlanEntry,
          $$MealPlanEntriesTableFilterComposer,
          $$MealPlanEntriesTableOrderingComposer,
          $$MealPlanEntriesTableAnnotationComposer,
          $$MealPlanEntriesTableCreateCompanionBuilder,
          $$MealPlanEntriesTableUpdateCompanionBuilder,
          (
            MealPlanEntry,
            BaseReferences<_$AppDatabase, $MealPlanEntriesTable, MealPlanEntry>,
          ),
          MealPlanEntry,
          PrefetchHooks Function()
        > {
  $$MealPlanEntriesTableTableManager(
    _$AppDatabase db,
    $MealPlanEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealPlanEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealPlanEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealPlanEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> seq = const Value.absent(),
                Value<bool> deleted = const Value.absent(),
                Value<String> day = const Value.absent(),
                Value<String?> recipeId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int?> servings = const Value.absent(),
                Value<String?> cookId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPlanEntriesCompanion(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                day: day,
                recipeId: recipeId,
                title: title,
                servings: servings,
                cookId: cookId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int updatedAt,
                required int seq,
                Value<bool> deleted = const Value.absent(),
                required String day,
                Value<String?> recipeId = const Value.absent(),
                required String title,
                Value<int?> servings = const Value.absent(),
                Value<String?> cookId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MealPlanEntriesCompanion.insert(
                id: id,
                updatedAt: updatedAt,
                seq: seq,
                deleted: deleted,
                day: day,
                recipeId: recipeId,
                title: title,
                servings: servings,
                cookId: cookId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MealPlanEntriesTable, MealPlanEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $MealPlanEntriesTable,
                    MealPlanEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MealPlanEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealPlanEntriesTable,
      MealPlanEntry,
      $$MealPlanEntriesTableFilterComposer,
      $$MealPlanEntriesTableOrderingComposer,
      $$MealPlanEntriesTableAnnotationComposer,
      $$MealPlanEntriesTableCreateCompanionBuilder,
      $$MealPlanEntriesTableUpdateCompanionBuilder,
      (
        MealPlanEntry,
        BaseReferences<_$AppDatabase, $MealPlanEntriesTable, MealPlanEntry>,
      ),
      MealPlanEntry,
      PrefetchHooks Function()
    >;
typedef $$LocalSettingsTableCreateCompanionBuilder =
    LocalSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$LocalSettingsTableUpdateCompanionBuilder =
    LocalSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$LocalSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalSettingsTable> {
  $$LocalSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$LocalSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalSettingsTable,
          LocalSetting,
          $$LocalSettingsTableFilterComposer,
          $$LocalSettingsTableOrderingComposer,
          $$LocalSettingsTableAnnotationComposer,
          $$LocalSettingsTableCreateCompanionBuilder,
          $$LocalSettingsTableUpdateCompanionBuilder,
          (
            LocalSetting,
            BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
          ),
          LocalSetting,
          PrefetchHooks Function()
        > {
  $$LocalSettingsTableTableManager(_$AppDatabase db, $LocalSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocalSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => LocalSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => LocalSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalSettingsTable, LocalSetting>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $LocalSettingsTable,
                    LocalSetting
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalSettingsTable,
      LocalSetting,
      $$LocalSettingsTableFilterComposer,
      $$LocalSettingsTableOrderingComposer,
      $$LocalSettingsTableAnnotationComposer,
      $$LocalSettingsTableCreateCompanionBuilder,
      $$LocalSettingsTableUpdateCompanionBuilder,
      (
        LocalSetting,
        BaseReferences<_$AppDatabase, $LocalSettingsTable, LocalSetting>,
      ),
      LocalSetting,
      PrefetchHooks Function()
    >;
typedef $$PeersTableCreateCompanionBuilder = PeersCompanion Function({
  required String deviceId,
  required String name,
  Value<String?> lastAddress,
  Value<int?> lastSyncAt,
  Value<int> theirSeq,
  Value<int> ourSeqAcked,
  Value<int> rowid,
});
typedef $$PeersTableUpdateCompanionBuilder = PeersCompanion Function({
  Value<String> deviceId,
  Value<String> name,
  Value<String?> lastAddress,
  Value<int?> lastSyncAt,
  Value<int> theirSeq,
  Value<int> ourSeqAcked,
  Value<int> rowid,
});

class $$PeersTableFilterComposer extends Composer<_$AppDatabase, $PeersTable> {
  $$PeersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastAddress => $composableBuilder(
    column: $table.lastAddress,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get theirSeq => $composableBuilder(
    column: $table.theirSeq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ourSeqAcked => $composableBuilder(
    column: $table.ourSeqAcked,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PeersTableOrderingComposer
    extends Composer<_$AppDatabase, $PeersTable> {
  $$PeersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastAddress => $composableBuilder(
    column: $table.lastAddress,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get theirSeq => $composableBuilder(
    column: $table.theirSeq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ourSeqAcked => $composableBuilder(
    column: $table.ourSeqAcked,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PeersTableAnnotationComposer
    extends Composer<_$AppDatabase, $PeersTable> {
  $$PeersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lastAddress => $composableBuilder(
    column: $table.lastAddress,
    builder: (column) => column,
  );

  GeneratedColumn<int> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get theirSeq =>
      $composableBuilder(column: $table.theirSeq, builder: (column) => column);

  GeneratedColumn<int> get ourSeqAcked => $composableBuilder(
    column: $table.ourSeqAcked,
    builder: (column) => column,
  );
}

class $$PeersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PeersTable,
          Peer,
          $$PeersTableFilterComposer,
          $$PeersTableOrderingComposer,
          $$PeersTableAnnotationComposer,
          $$PeersTableCreateCompanionBuilder,
          $$PeersTableUpdateCompanionBuilder,
          (Peer, BaseReferences<_$AppDatabase, $PeersTable, Peer>),
          Peer,
          PrefetchHooks Function()
        > {
  $$PeersTableTableManager(_$AppDatabase db, $PeersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PeersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PeersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PeersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deviceId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> lastAddress = const Value.absent(),
                Value<int?> lastSyncAt = const Value.absent(),
                Value<int> theirSeq = const Value.absent(),
                Value<int> ourSeqAcked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PeersCompanion(
                deviceId: deviceId,
                name: name,
                lastAddress: lastAddress,
                lastSyncAt: lastSyncAt,
                theirSeq: theirSeq,
                ourSeqAcked: ourSeqAcked,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deviceId,
                required String name,
                Value<String?> lastAddress = const Value.absent(),
                Value<int?> lastSyncAt = const Value.absent(),
                Value<int> theirSeq = const Value.absent(),
                Value<int> ourSeqAcked = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PeersCompanion.insert(
                deviceId: deviceId,
                name: name,
                lastAddress: lastAddress,
                lastSyncAt: lastSyncAt,
                theirSeq: theirSeq,
                ourSeqAcked: ourSeqAcked,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PeersTable, Peer>(table),
                  BaseReferences<_$AppDatabase, $PeersTable, Peer>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PeersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PeersTable,
      Peer,
      $$PeersTableFilterComposer,
      $$PeersTableOrderingComposer,
      $$PeersTableAnnotationComposer,
      $$PeersTableCreateCompanionBuilder,
      $$PeersTableUpdateCompanionBuilder,
      (Peer, BaseReferences<_$AppDatabase, $PeersTable, Peer>),
      Peer,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MembersTableTableManager get members =>
      $$MembersTableTableManager(_db, _db.members);
  $$StoresTableTableManager get stores =>
      $$StoresTableTableManager(_db, _db.stores);
  $$DepartmentsTableTableManager get departments =>
      $$DepartmentsTableTableManager(_db, _db.departments);
  $$StoreDepartmentOrdersTableTableManager get storeDepartmentOrders =>
      $$StoreDepartmentOrdersTableTableManager(_db, _db.storeDepartmentOrders);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$ProductMemoriesTableTableManager get productMemories =>
      $$ProductMemoriesTableTableManager(_db, _db.productMemories);
  $$AreasTableTableManager get areas =>
      $$AreasTableTableManager(_db, _db.areas);
  $$ChoresTableTableManager get chores =>
      $$ChoresTableTableManager(_db, _db.chores);
  $$ChoreCompletionsTableTableManager get choreCompletions =>
      $$ChoreCompletionsTableTableManager(_db, _db.choreCompletions);
  $$WastePickupsTableTableManager get wastePickups =>
      $$WastePickupsTableTableManager(_db, _db.wastePickups);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeCollectionsTableTableManager get recipeCollections =>
      $$RecipeCollectionsTableTableManager(_db, _db.recipeCollections);
  $$MealPlanEntriesTableTableManager get mealPlanEntries =>
      $$MealPlanEntriesTableTableManager(_db, _db.mealPlanEntries);
  $$LocalSettingsTableTableManager get localSettings =>
      $$LocalSettingsTableTableManager(_db, _db.localSettings);
  $$PeersTableTableManager get peers =>
      $$PeersTableTableManager(_db, _db.peers);
}
