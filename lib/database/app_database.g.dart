part of 'app_database.dart';

class $TeamsTable extends Teams with TableInfo<$TeamsTable, Team> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TeamsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('nome');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'nome',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coachMeta = const VerificationMeta(
    'tecnico',
  );
  @override
  late final GeneratedColumn<String> coach = GeneratedColumn<String>(
    'tecnico',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupMeta = const VerificationMeta('grupo');
  @override
  late final GeneratedColumn<String> group = GeneratedColumn<String>(
    'grupo',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _flagMeta = const VerificationMeta(
    'bandeira',
  );
  @override
  late final GeneratedColumn<String> flag = GeneratedColumn<String>(
    'bandeira',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, coach, group, flag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'selecoes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Team> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final date = instance.toColumns(true);
    if (date.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(date['id']!, _idMeta));
    }
    if (date.containsKey('nome')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(date['nome']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (date.containsKey('tecnico')) {
      context.handle(
        _coachMeta,
        coach.isAcceptableOrUnknown(date['tecnico']!, _coachMeta),
      );
    } else if (isInserting) {
      context.missing(_coachMeta);
    }
    if (date.containsKey('grupo')) {
      context.handle(
        _groupMeta,
        group.isAcceptableOrUnknown(date['grupo']!, _groupMeta),
      );
    } else if (isInserting) {
      context.missing(_groupMeta);
    }
    if (date.containsKey('bandeira')) {
      context.handle(
        _flagMeta,
        flag.isAcceptableOrUnknown(date['bandeira']!, _flagMeta),
      );
    } else if (isInserting) {
      context.missing(_flagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Team map(Map<String, dynamic> date, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Team(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        date['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        date['${effectivePrefix}nome'],
      )!,
      coach: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        date['${effectivePrefix}tecnico'],
      )!,
      group: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        date['${effectivePrefix}grupo'],
      )!,
      flag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        date['${effectivePrefix}bandeira'],
      )!,
    );
  }

  @override
  $TeamsTable createAlias(String alias) {
    return $TeamsTable(attachedDatabase, alias);
  }
}

class Team extends DataClass implements Insertable<Team> {
  final int id;
  final String name;
  final String coach;
  final String group;
  final String flag;
  const Team({
    required this.id,
    required this.name,
    required this.coach,
    required this.group,
    required this.flag,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['nome'] = Variable<String>(name);
    map['tecnico'] = Variable<String>(coach);
    map['grupo'] = Variable<String>(group);
    map['bandeira'] = Variable<String>(flag);
    return map;
  }

  TeamsCompanion toCompanion(bool nullToAbsent) {
    return TeamsCompanion(
      id: Value(id),
      name: Value(name),
      coach: Value(coach),
      group: Value(group),
      flag: Value(flag),
    );
  }

  factory Team.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Team(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['nome']),
      coach: serializer.fromJson<String>(json['tecnico']),
      group: serializer.fromJson<String>(json['grupo']),
      flag: serializer.fromJson<String>(json['bandeira']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'nome': serializer.toJson<String>(name),
      'tecnico': serializer.toJson<String>(coach),
      'grupo': serializer.toJson<String>(group),
      'bandeira': serializer.toJson<String>(flag),
    };
  }

  Team copyWith({
    int? id,
    String? name,
    String? coach,
    String? group,
    String? flag,
  }) => Team(
    id: id ?? this.id,
    name: name ?? this.name,
    coach: coach ?? this.coach,
    group: group ?? this.group,
    flag: flag ?? this.flag,
  );
  Team copyWithCompanion(TeamsCompanion date) {
    return Team(
      id: date.id.present ? date.id.value : this.id,
      name: date.name.present ? date.name.value : this.name,
      coach: date.coach.present ? date.coach.value : this.coach,
      group: date.group.present ? date.group.value : this.group,
      flag: date.flag.present ? date.flag.value : this.flag,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Team(')
          ..write('id: $id, ')
          ..write('nome: $name, ')
          ..write('tecnico: $coach, ')
          ..write('grupo: $group, ')
          ..write('bandeira: $flag')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, coach, group, flag);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Team &&
          other.id == this.id &&
          other.name == this.name &&
          other.coach == this.coach &&
          other.group == this.group &&
          other.flag == this.flag);
}

class TeamsCompanion extends UpdateCompanion<Team> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> coach;
  final Value<String> group;
  final Value<String> flag;
  const TeamsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.coach = const Value.absent(),
    this.group = const Value.absent(),
    this.flag = const Value.absent(),
  });
  TeamsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String coach,
    required String group,
    required String flag,
  }) : name = Value(name),
       coach = Value(coach),
       group = Value(group),
       flag = Value(flag);
  static Insertable<Team> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? coach,
    Expression<String>? group,
    Expression<String>? flag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'nome': name,
      if (coach != null) 'tecnico': coach,
      if (group != null) 'grupo': group,
      if (flag != null) 'bandeira': flag,
    });
  }

  TeamsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? coach,
    Value<String>? group,
    Value<String>? flag,
  }) {
    return TeamsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      coach: coach ?? this.coach,
      group: group ?? this.group,
      flag: flag ?? this.flag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['nome'] = Variable<String>(name.value);
    }
    if (coach.present) {
      map['tecnico'] = Variable<String>(coach.value);
    }
    if (group.present) {
      map['grupo'] = Variable<String>(group.value);
    }
    if (flag.present) {
      map['bandeira'] = Variable<String>(flag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TeamsCompanion(')
          ..write('id: $id, ')
          ..write('nome: $name, ')
          ..write('tecnico: $coach, ')
          ..write('grupo: $group, ')
          ..write('bandeira: $flag')
          ..write(')'))
        .toString();
  }
}

class $MatchesTable extends Matches with TableInfo<$MatchesTable, Match> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MatchesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _homeTeamIdMeta = const VerificationMeta(
    'mandanteId',
  );
  @override
  late final GeneratedColumn<int> homeTeamId = GeneratedColumn<int>(
    'mandante_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES selecoes (id)',
    ),
  );
  static const VerificationMeta _awayTeamIdMeta = const VerificationMeta(
    'visitanteId',
  );
  @override
  late final GeneratedColumn<int> awayTeamId = GeneratedColumn<int>(
    'visitante_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES selecoes (id)',
    ),
  );
  static const VerificationMeta _homeTeamGoalsMeta = const VerificationMeta(
    'golsMandante',
  );
  @override
  late final GeneratedColumn<int> homeTeamGoals = GeneratedColumn<int>(
    'gols_mandante',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _awayTeamGoalsMeta = const VerificationMeta(
    'golsVisitante',
  );
  @override
  late final GeneratedColumn<int> awayTeamGoals = GeneratedColumn<int>(
    'gols_visitante',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('data');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'data',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stadiumMeta = const VerificationMeta(
    'estadio',
  );
  @override
  late final GeneratedColumn<String> stadium = GeneratedColumn<String>(
    'estadio',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stageMeta = const VerificationMeta('fase');
  @override
  late final GeneratedColumn<String> stage = GeneratedColumn<String>(
    'fase',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    homeTeamId,
    awayTeamId,
    homeTeamGoals,
    awayTeamGoals,
    date,
    stadium,
    stage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'partidas';
  @override
  VerificationContext validateIntegrity(
    Insertable<Match> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final date = instance.toColumns(true);
    if (date.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(date['id']!, _idMeta));
    }
    if (date.containsKey('mandante_id')) {
      context.handle(
        _homeTeamIdMeta,
        homeTeamId.isAcceptableOrUnknown(date['mandante_id']!, _homeTeamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_homeTeamIdMeta);
    }
    if (date.containsKey('visitante_id')) {
      context.handle(
        _awayTeamIdMeta,
        awayTeamId.isAcceptableOrUnknown(
          date['visitante_id']!,
          _awayTeamIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_awayTeamIdMeta);
    }
    if (date.containsKey('gols_mandante')) {
      context.handle(
        _homeTeamGoalsMeta,
        homeTeamGoals.isAcceptableOrUnknown(
          date['gols_mandante']!,
          _homeTeamGoalsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_homeTeamGoalsMeta);
    }
    if (date.containsKey('gols_visitante')) {
      context.handle(
        _awayTeamGoalsMeta,
        awayTeamGoals.isAcceptableOrUnknown(
          date['gols_visitante']!,
          _awayTeamGoalsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_awayTeamGoalsMeta);
    }
    if (date.containsKey('data')) {
      context.handle(
        _dateMeta,
        this.date.isAcceptableOrUnknown(date['data']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (date.containsKey('estadio')) {
      context.handle(
        _stadiumMeta,
        stadium.isAcceptableOrUnknown(date['estadio']!, _stadiumMeta),
      );
    } else if (isInserting) {
      context.missing(_stadiumMeta);
    }
    if (date.containsKey('fase')) {
      context.handle(
        _stageMeta,
        stage.isAcceptableOrUnknown(date['fase']!, _stageMeta),
      );
    } else if (isInserting) {
      context.missing(_stageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Match map(Map<String, dynamic> date, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Match(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        date['${effectivePrefix}id'],
      )!,
      homeTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        date['${effectivePrefix}mandante_id'],
      )!,
      awayTeamId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        date['${effectivePrefix}visitante_id'],
      )!,
      homeTeamGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        date['${effectivePrefix}gols_mandante'],
      )!,
      awayTeamGoals: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        date['${effectivePrefix}gols_visitante'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        date['${effectivePrefix}data'],
      )!,
      stadium: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        date['${effectivePrefix}estadio'],
      )!,
      stage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        date['${effectivePrefix}fase'],
      )!,
    );
  }

  @override
  $MatchesTable createAlias(String alias) {
    return $MatchesTable(attachedDatabase, alias);
  }
}

class Match extends DataClass implements Insertable<Match> {
  final int id;
  final int homeTeamId;
  final int awayTeamId;
  final int homeTeamGoals;
  final int awayTeamGoals;
  final DateTime date;
  final String stadium;
  final String stage;
  const Match({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeTeamGoals,
    required this.awayTeamGoals,
    required this.date,
    required this.stadium,
    required this.stage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['mandante_id'] = Variable<int>(homeTeamId);
    map['visitante_id'] = Variable<int>(awayTeamId);
    map['gols_mandante'] = Variable<int>(homeTeamGoals);
    map['gols_visitante'] = Variable<int>(awayTeamGoals);
    map['data'] = Variable<DateTime>(date);
    map['estadio'] = Variable<String>(stadium);
    map['fase'] = Variable<String>(stage);
    return map;
  }

  MatchesCompanion toCompanion(bool nullToAbsent) {
    return MatchesCompanion(
      id: Value(id),
      homeTeamId: Value(homeTeamId),
      awayTeamId: Value(awayTeamId),
      homeTeamGoals: Value(homeTeamGoals),
      awayTeamGoals: Value(awayTeamGoals),
      date: Value(date),
      stadium: Value(stadium),
      stage: Value(stage),
    );
  }

  factory Match.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Match(
      id: serializer.fromJson<int>(json['id']),
      homeTeamId: serializer.fromJson<int>(json['mandanteId']),
      awayTeamId: serializer.fromJson<int>(json['visitanteId']),
      homeTeamGoals: serializer.fromJson<int>(json['golsMandante']),
      awayTeamGoals: serializer.fromJson<int>(json['golsVisitante']),
      date: serializer.fromJson<DateTime>(json['data']),
      stadium: serializer.fromJson<String>(json['estadio']),
      stage: serializer.fromJson<String>(json['fase']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'mandanteId': serializer.toJson<int>(homeTeamId),
      'visitanteId': serializer.toJson<int>(awayTeamId),
      'golsMandante': serializer.toJson<int>(homeTeamGoals),
      'golsVisitante': serializer.toJson<int>(awayTeamGoals),
      'data': serializer.toJson<DateTime>(date),
      'estadio': serializer.toJson<String>(stadium),
      'fase': serializer.toJson<String>(stage),
    };
  }

  Match copyWith({
    int? id,
    int? homeTeamId,
    int? awayTeamId,
    int? homeTeamGoals,
    int? awayTeamGoals,
    DateTime? date,
    String? stadium,
    String? stage,
  }) => Match(
    id: id ?? this.id,
    homeTeamId: homeTeamId ?? this.homeTeamId,
    awayTeamId: awayTeamId ?? this.awayTeamId,
    homeTeamGoals: homeTeamGoals ?? this.homeTeamGoals,
    awayTeamGoals: awayTeamGoals ?? this.awayTeamGoals,
    date: date ?? this.date,
    stadium: stadium ?? this.stadium,
    stage: stage ?? this.stage,
  );
  Match copyWithCompanion(MatchesCompanion date) {
    return Match(
      id: date.id.present ? date.id.value : this.id,
      homeTeamId: date.homeTeamId.present
          ? date.homeTeamId.value
          : this.homeTeamId,
      awayTeamId: date.awayTeamId.present
          ? date.awayTeamId.value
          : this.awayTeamId,
      homeTeamGoals: date.homeTeamGoals.present
          ? date.homeTeamGoals.value
          : this.homeTeamGoals,
      awayTeamGoals: date.awayTeamGoals.present
          ? date.awayTeamGoals.value
          : this.awayTeamGoals,
      date: date.date.present ? date.date.value : this.date,
      stadium: date.stadium.present ? date.stadium.value : this.stadium,
      stage: date.stage.present ? date.stage.value : this.stage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Match(')
          ..write('id: $id, ')
          ..write('mandanteId: $homeTeamId, ')
          ..write('visitanteId: $awayTeamId, ')
          ..write('golsMandante: $homeTeamGoals, ')
          ..write('golsVisitante: $awayTeamGoals, ')
          ..write('data: $date, ')
          ..write('estadio: $stadium, ')
          ..write('fase: $stage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    homeTeamId,
    awayTeamId,
    homeTeamGoals,
    awayTeamGoals,
    date,
    stadium,
    stage,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Match &&
          other.id == this.id &&
          other.homeTeamId == this.homeTeamId &&
          other.awayTeamId == this.awayTeamId &&
          other.homeTeamGoals == this.homeTeamGoals &&
          other.awayTeamGoals == this.awayTeamGoals &&
          other.date == this.date &&
          other.stadium == this.stadium &&
          other.stage == this.stage);
}

class MatchesCompanion extends UpdateCompanion<Match> {
  final Value<int> id;
  final Value<int> homeTeamId;
  final Value<int> awayTeamId;
  final Value<int> homeTeamGoals;
  final Value<int> awayTeamGoals;
  final Value<DateTime> date;
  final Value<String> stadium;
  final Value<String> stage;
  const MatchesCompanion({
    this.id = const Value.absent(),
    this.homeTeamId = const Value.absent(),
    this.awayTeamId = const Value.absent(),
    this.homeTeamGoals = const Value.absent(),
    this.awayTeamGoals = const Value.absent(),
    this.date = const Value.absent(),
    this.stadium = const Value.absent(),
    this.stage = const Value.absent(),
  });
  MatchesCompanion.insert({
    this.id = const Value.absent(),
    required int homeTeamId,
    required int awayTeamId,
    required int homeTeamGoals,
    required int awayTeamGoals,
    required DateTime date,
    required String stadium,
    required String stage,
  }) : homeTeamId = Value(homeTeamId),
       awayTeamId = Value(awayTeamId),
       homeTeamGoals = Value(homeTeamGoals),
       awayTeamGoals = Value(awayTeamGoals),
       date = Value(date),
       stadium = Value(stadium),
       stage = Value(stage);
  static Insertable<Match> custom({
    Expression<int>? id,
    Expression<int>? homeTeamId,
    Expression<int>? awayTeamId,
    Expression<int>? homeTeamGoals,
    Expression<int>? awayTeamGoals,
    Expression<DateTime>? date,
    Expression<String>? stadium,
    Expression<String>? stage,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (homeTeamId != null) 'mandante_id': homeTeamId,
      if (awayTeamId != null) 'visitante_id': awayTeamId,
      if (homeTeamGoals != null) 'gols_mandante': homeTeamGoals,
      if (awayTeamGoals != null) 'gols_visitante': awayTeamGoals,
      if (date != null) 'data': date,
      if (stadium != null) 'estadio': stadium,
      if (stage != null) 'fase': stage,
    });
  }

  MatchesCompanion copyWith({
    Value<int>? id,
    Value<int>? homeTeamId,
    Value<int>? awayTeamId,
    Value<int>? homeTeamGoals,
    Value<int>? awayTeamGoals,
    Value<DateTime>? date,
    Value<String>? stadium,
    Value<String>? stage,
  }) {
    return MatchesCompanion(
      id: id ?? this.id,
      homeTeamId: homeTeamId ?? this.homeTeamId,
      awayTeamId: awayTeamId ?? this.awayTeamId,
      homeTeamGoals: homeTeamGoals ?? this.homeTeamGoals,
      awayTeamGoals: awayTeamGoals ?? this.awayTeamGoals,
      date: date ?? this.date,
      stadium: stadium ?? this.stadium,
      stage: stage ?? this.stage,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (homeTeamId.present) {
      map['mandante_id'] = Variable<int>(homeTeamId.value);
    }
    if (awayTeamId.present) {
      map['visitante_id'] = Variable<int>(awayTeamId.value);
    }
    if (homeTeamGoals.present) {
      map['gols_mandante'] = Variable<int>(homeTeamGoals.value);
    }
    if (awayTeamGoals.present) {
      map['gols_visitante'] = Variable<int>(awayTeamGoals.value);
    }
    if (date.present) {
      map['data'] = Variable<DateTime>(date.value);
    }
    if (stadium.present) {
      map['estadio'] = Variable<String>(stadium.value);
    }
    if (stage.present) {
      map['fase'] = Variable<String>(stage.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MatchesCompanion(')
          ..write('id: $id, ')
          ..write('mandanteId: $homeTeamId, ')
          ..write('visitanteId: $awayTeamId, ')
          ..write('golsMandante: $homeTeamGoals, ')
          ..write('golsVisitante: $awayTeamGoals, ')
          ..write('data: $date, ')
          ..write('estadio: $stadium, ')
          ..write('fase: $stage')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $TeamsTable teams = $TeamsTable(this);
  late final $MatchesTable matches = $MatchesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [teams, matches];
}

typedef $$TeamsTableCreateCompanionBuilder =
    TeamsCompanion Function({
      Value<int> id,
      required String name,
      required String coach,
      required String group,
      required String flag,
    });
typedef $$TeamsTableUpdateCompanionBuilder =
    TeamsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> coach,
      Value<String> group,
      Value<String> flag,
    });

class $$TeamsTableFilterComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coach => $composableBuilder(
    column: $table.coach,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get group => $composableBuilder(
    column: $table.group,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TeamsTableOrderingComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coach => $composableBuilder(
    column: $table.coach,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get group => $composableBuilder(
    column: $table.group,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flag => $composableBuilder(
    column: $table.flag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TeamsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TeamsTable> {
  $$TeamsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get coach =>
      $composableBuilder(column: $table.coach, builder: (column) => column);

  GeneratedColumn<String> get group =>
      $composableBuilder(column: $table.group, builder: (column) => column);

  GeneratedColumn<String> get flag =>
      $composableBuilder(column: $table.flag, builder: (column) => column);
}

class $$TeamsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TeamsTable,
          Team,
          $$TeamsTableFilterComposer,
          $$TeamsTableOrderingComposer,
          $$TeamsTableAnnotationComposer,
          $$TeamsTableCreateCompanionBuilder,
          $$TeamsTableUpdateCompanionBuilder,
          (Team, BaseReferences<_$AppDatabase, $TeamsTable, Team>),
          Team,
          PrefetchHooks Function()
        > {
  $$TeamsTableTableManager(_$AppDatabase db, $TeamsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TeamsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TeamsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TeamsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> coach = const Value.absent(),
                Value<String> group = const Value.absent(),
                Value<String> flag = const Value.absent(),
              }) => TeamsCompanion(
                id: id,
                name: name,
                coach: coach,
                group: group,
                flag: flag,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String coach,
                required String group,
                required String flag,
              }) => TeamsCompanion.insert(
                id: id,
                name: name,
                coach: coach,
                group: group,
                flag: flag,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TeamsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TeamsTable,
      Team,
      $$TeamsTableFilterComposer,
      $$TeamsTableOrderingComposer,
      $$TeamsTableAnnotationComposer,
      $$TeamsTableCreateCompanionBuilder,
      $$TeamsTableUpdateCompanionBuilder,
      (Team, BaseReferences<_$AppDatabase, $TeamsTable, Team>),
      Team,
      PrefetchHooks Function()
    >;
typedef $$MatchesTableCreateCompanionBuilder =
    MatchesCompanion Function({
      Value<int> id,
      required int homeTeamId,
      required int awayTeamId,
      required int homeTeamGoals,
      required int awayTeamGoals,
      required DateTime date,
      required String stadium,
      required String stage,
    });
typedef $$MatchesTableUpdateCompanionBuilder =
    MatchesCompanion Function({
      Value<int> id,
      Value<int> homeTeamId,
      Value<int> awayTeamId,
      Value<int> homeTeamGoals,
      Value<int> awayTeamGoals,
      Value<DateTime> date,
      Value<String> stadium,
      Value<String> stage,
    });

final class $$MatchesTableReferences
    extends BaseReferences<_$AppDatabase, $MatchesTable, Match> {
  $$MatchesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TeamsTable _mandanteIdTable(_$AppDatabase db) =>
      db.teams.createAlias('partidas__mandante_id__selecoes__id');

  $$TeamsTableProcessedTableManager get homeTeamId {
    final $_column = $_itemColumn<int>('mandante_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_mandanteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TeamsTable _visitanteIdTable(_$AppDatabase db) =>
      db.teams.createAlias('partidas__visitante_id__selecoes__id');

  $$TeamsTableProcessedTableManager get awayTeamId {
    final $_column = $_itemColumn<int>('visitante_id')!;

    final manager = $$TeamsTableTableManager(
      $_db,
      $_db.teams,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_visitanteIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MatchesTableFilterComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get homeTeamGoals => $composableBuilder(
    column: $table.homeTeamGoals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get awayTeamGoals => $composableBuilder(
    column: $table.awayTeamGoals,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stadium => $composableBuilder(
    column: $table.stadium,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnFilters(column),
  );

  $$TeamsTableFilterComposer get homeTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableFilterComposer get awayTeamId {
    final $$TeamsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableFilterComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableOrderingComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get homeTeamGoals => $composableBuilder(
    column: $table.homeTeamGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get awayTeamGoals => $composableBuilder(
    column: $table.awayTeamGoals,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stadium => $composableBuilder(
    column: $table.stadium,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stage => $composableBuilder(
    column: $table.stage,
    builder: (column) => ColumnOrderings(column),
  );

  $$TeamsTableOrderingComposer get homeTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableOrderingComposer get awayTeamId {
    final $$TeamsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableOrderingComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableAnnotationComposer
    extends Composer<_$AppDatabase, $MatchesTable> {
  $$MatchesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get homeTeamGoals => $composableBuilder(
    column: $table.homeTeamGoals,
    builder: (column) => column,
  );

  GeneratedColumn<int> get awayTeamGoals => $composableBuilder(
    column: $table.awayTeamGoals,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get stadium =>
      $composableBuilder(column: $table.stadium, builder: (column) => column);

  GeneratedColumn<String> get stage =>
      $composableBuilder(column: $table.stage, builder: (column) => column);

  $$TeamsTableAnnotationComposer get homeTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.homeTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TeamsTableAnnotationComposer get awayTeamId {
    final $$TeamsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.awayTeamId,
      referencedTable: $db.teams,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TeamsTableAnnotationComposer(
            $db: $db,
            $table: $db.teams,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MatchesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MatchesTable,
          Match,
          $$MatchesTableFilterComposer,
          $$MatchesTableOrderingComposer,
          $$MatchesTableAnnotationComposer,
          $$MatchesTableCreateCompanionBuilder,
          $$MatchesTableUpdateCompanionBuilder,
          (Match, $$MatchesTableReferences),
          Match,
          PrefetchHooks Function({bool homeTeamId, bool awayTeamId})
        > {
  $$MatchesTableTableManager(_$AppDatabase db, $MatchesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MatchesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MatchesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MatchesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> homeTeamId = const Value.absent(),
                Value<int> awayTeamId = const Value.absent(),
                Value<int> homeTeamGoals = const Value.absent(),
                Value<int> awayTeamGoals = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String> stadium = const Value.absent(),
                Value<String> stage = const Value.absent(),
              }) => MatchesCompanion(
                id: id,
                homeTeamId: homeTeamId,
                awayTeamId: awayTeamId,
                homeTeamGoals: homeTeamGoals,
                awayTeamGoals: awayTeamGoals,
                date: date,
                stadium: stadium,
                stage: stage,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int homeTeamId,
                required int awayTeamId,
                required int homeTeamGoals,
                required int awayTeamGoals,
                required DateTime date,
                required String stadium,
                required String stage,
              }) => MatchesCompanion.insert(
                id: id,
                homeTeamId: homeTeamId,
                awayTeamId: awayTeamId,
                homeTeamGoals: homeTeamGoals,
                awayTeamGoals: awayTeamGoals,
                date: date,
                stadium: stadium,
                stage: stage,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$MatchesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({homeTeamId = false, awayTeamId = false}) {
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
                    if (homeTeamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.homeTeamId,
                                referencedTable: $$MatchesTableReferences
                                    ._mandanteIdTable(db),
                                referencedColumn: $$MatchesTableReferences
                                    ._mandanteIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (awayTeamId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.awayTeamId,
                                referencedTable: $$MatchesTableReferences
                                    ._visitanteIdTable(db),
                                referencedColumn: $$MatchesTableReferences
                                    ._visitanteIdTable(db)
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

typedef $$MatchesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MatchesTable,
      Match,
      $$MatchesTableFilterComposer,
      $$MatchesTableOrderingComposer,
      $$MatchesTableAnnotationComposer,
      $$MatchesTableCreateCompanionBuilder,
      $$MatchesTableUpdateCompanionBuilder,
      (Match, $$MatchesTableReferences),
      Match,
      PrefetchHooks Function({bool homeTeamId, bool awayTeamId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$TeamsTableTableManager get teams =>
      $$TeamsTableTableManager(_db, _db.teams);
  $$MatchesTableTableManager get matches =>
      $$MatchesTableTableManager(_db, _db.matches);
}
