
// Define a base para os estados da funcionalidade de seleções.
import 'package:world_cup/database/app_database.dart';

abstract class TeamState {
  const TeamState();
}

// Representa o estado inicial antes do carregamento das seleções.
class InitialTeamState extends TeamState {
  const InitialTeamState();
}

// Indica que a lista de seleções está sendo carregada.
class LoadingTeamsState extends TeamState {
  const LoadingTeamsState();
}

// Disponibiliza as seleções carregadas para a interface.
class LoadedTeamsState extends TeamState {
  final List<Team> teams;

  const LoadedTeamsState(this.teams);
}

// Representa uma falha ocorrida durante uma operação com seleções.
class TeamErrorState extends TeamState {
  final String message;

  const TeamErrorState(this.message);
}
