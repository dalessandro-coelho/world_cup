import 'package:drift/drift.dart';
import 'package:world_cup/database/tables/teams.dart';

// Define a tabela que armazena as partidas.
@DataClassName('Match')
class Matches extends Table {
  @override
  String get tableName => 'partidas';

  IntColumn get id => integer().autoIncrement()();

  IntColumn get homeTeamId => integer().named('mandante_id').references(Teams, #id)();

  IntColumn get awayTeamId => integer().named('visitante_id').references(Teams, #id)();

  IntColumn get homeTeamGoals => integer().named('gols_mandante')();

  IntColumn get awayTeamGoals => integer().named('gols_visitante')();

  DateTimeColumn get date => dateTime().named('data')();

  TextColumn get stadium => text().named('estadio')();

  TextColumn get stage => text().named('fase')();
}
