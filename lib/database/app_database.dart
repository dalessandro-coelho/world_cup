import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/matches.dart';
import 'tables/teams.dart';

part 'app_database.g.dart';

// Agrupa uma partida com os dados completos das seleções mandante e visitante.
class MatchWithTeams {
  final Match match;
  final Team homeTeam;
  final Team awayTeam;

  const MatchWithTeams({
    required this.match,
    required this.homeTeam,
    required this.awayTeam,
  });
}

// Centraliza o acesso ao banco de dados local e as operações de CRUD do aplicativo.
@DriftDatabase(tables: [Teams, Matches])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Insere uma nova seleção no banco de dados local.
  Future<int> addTeam({
    required String name,
    required String coach,
    required String group,
    required String flag,
  }) {
    return into(teams).insert(
      TeamsCompanion.insert(
        name: name,
        coach: coach,
        group: group,
        flag: flag,
      ),
    );
  }

  // Busca todas as seleções cadastradas em ordem alfabética.
  Future<List<Team>> getAllTeams() {
    return (select(
      teams,
    )..orderBy([(table) => OrderingTerm(expression: table.name)])).get();
  }

  // Observa alterações na tabela de seleções e emite a lista atualizada.
  Stream<List<Team>> watchAllTeams() {
    return (select(
      teams,
    )..orderBy([(table) => OrderingTerm(expression: table.name)])).watch();
  }

  // Busca uma seleção pelo seu identificador.
  Future<Team?> getTeamById(int id) {
    return (select(
      teams,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }
  
  // Conta quantas partidas utilizam a seleção como mandante ou visitante.
  Future<int> countMatchesByTeamId(int teamId) async {
    final countExpression = matches.id.count();

    final query = selectOnly(matches)
      ..addColumns([countExpression])
      ..where(
        matches.homeTeamId.equals(teamId) | matches.awayTeamId.equals(teamId),
      );

    final result = await query.getSingle();

    return result.read(countExpression) ?? 0;
  }

  // Substitui os dados de uma seleção já cadastrada.
  Future<bool> updateTeam({
    required int id,
    required String name,
    required String coach,
    required String group,
    required String flag,
  }) {
    return update(teams).replace(
      TeamsCompanion(
        id: Value(id),
        name: Value(name),
        coach: Value(coach),
        group: Value(group),
        flag: Value(flag),
      ),
    );
  }

  // Remove uma seleção do banco de dados local.
  Future<int> deleteTeam(int id) {
    return (delete(teams)..where((table) => table.id.equals(id))).go();
  }

  // Insere uma nova partida no banco de dados local.
  Future<int> addMatch({
    required int homeTeamId,
    required int awayTeamId,
    required int homeTeamGoals,
    required int awayTeamGoals,
    required DateTime date,
    required String stadium,
    required String stage,
  }) {
    return into(matches).insert(
      MatchesCompanion.insert(
        homeTeamId: homeTeamId,
        awayTeamId: awayTeamId,
        homeTeamGoals: homeTeamGoals,
        awayTeamGoals: awayTeamGoals,
        date: date,
        stadium: stadium,
        stage: stage,
      ),
    );
  }

  // Busca todas as partidas cadastradas, da mais recente para a mais antiga.
  Future<List<Match>> getAllMatches() {
    return (select(
      matches,
    )..orderBy([(table) => OrderingTerm.desc(table.date)])).get();
  }

  // Observa alterações na tabela de partidas e emite a lista atualizada.
  Stream<List<Match>> watchAllMatches() {
    return (select(
      matches,
    )..orderBy([(table) => OrderingTerm.desc(table.date)])).watch();
  }

  // Busca uma partida pelo seu identificador.
  Future<Match?> getMatchById(int id) {
    return (select(
      matches,
    )..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  // Busca as partidas já associadas aos dados das seleções envolvidas.
  Future<List<MatchWithTeams>> getMatchesWithTeams() async {
    final homeTeamTable = alias(teams, 'tabela_mandante');
    final awayTeamTable = alias(teams, 'tabela_visitante');
    final query =
        (select(
          matches,
        )..orderBy([(table) => OrderingTerm.desc(table.date)])).join([
          innerJoin(
            homeTeamTable,
            homeTeamTable.id.equalsExp(matches.homeTeamId),
          ),
          innerJoin(
            awayTeamTable,
            awayTeamTable.id.equalsExp(matches.awayTeamId),
          ),
        ]);
    final results = await query.get();
    return results.map((row) {
      return MatchWithTeams(
        match: row.readTable(matches),
        homeTeam: row.readTable(homeTeamTable),
        awayTeam: row.readTable(awayTeamTable),
      );
    }).toList();
  }
  
  // Observa partidas e seleções para atualizar automaticamente os dados relacionados.
  Stream<List<MatchWithTeams>> watchMatchesWithTeams() {
    final homeTeamTable = alias(teams, 'tabela_mandante');
    final awayTeamTable = alias(teams, 'tabela_visitante');
    final query =
        (select(
          matches,
        )..orderBy([(table) => OrderingTerm.desc(table.date)])).join([
          innerJoin(
            homeTeamTable,
            homeTeamTable.id.equalsExp(matches.homeTeamId),
          ),
          innerJoin(
            awayTeamTable,
            awayTeamTable.id.equalsExp(matches.awayTeamId),
          ),
        ]);
    return query.watch().map((results) {
      return results.map((row) {
        return MatchWithTeams(
          match: row.readTable(matches),
          homeTeam: row.readTable(homeTeamTable),
          awayTeam: row.readTable(awayTeamTable),
        );
      }).toList();
    });
  }

  // Substitui os dados de uma partida já cadastrada.
  Future<bool> updateMatch({
    required int id,
    required int homeTeamId,
    required int awayTeamId,
    required int homeTeamGoals,
    required int awayTeamGoals,
    required DateTime date,
    required String stadium,
    required String stage,
  }) {
    return update(matches).replace(
      MatchesCompanion(
        id: Value(id),
        homeTeamId: Value(homeTeamId),
        awayTeamId: Value(awayTeamId),
        homeTeamGoals: Value(homeTeamGoals),
        awayTeamGoals: Value(awayTeamGoals),
        date: Value(date),
        stadium: Value(stadium),
        stage: Value(stage),
      ),
    );
  }

  // Remove uma partida do banco de dados local.
  Future<int> deleteMatch(int id) {
    return (delete(matches)..where((table) => table.id.equals(id))).go();
  }
}


// Cria a conexão com o arquivo SQLite somente quando ela for necessária.
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final directory = await getApplicationDocumentsDirectory();

    final file = File(p.join(directory.path, 'minha_copa.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}
