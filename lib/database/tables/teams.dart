import 'package:drift/drift.dart';

// Define a tabela que armazena as seleções cadastradas.
@DataClassName('Team')
class Teams extends Table {
  @override
  String get tableName => 'selecoes';

  IntColumn get id => integer().autoIncrement()();

  TextColumn get name => text().named('nome')();

  TextColumn get coach => text().named('tecnico')();

  TextColumn get group => text().named('grupo')();

  TextColumn get flag => text().named('bandeira')();
}
