import 'package:world_cup/database/app_database.dart';

// Define a base para os estados da funcionalidade de partidas.
abstract class MatchState {
  const MatchState();
}

// Representa o estado inicial antes do carregamento das partidas.
class InitialMatchState extends MatchState {
  const InitialMatchState();
}

// Indica que a lista de partidas está sendo carregada.
class LoadingMatchesState extends MatchState {
  const LoadingMatchesState();
}

// Disponibiliza as partidas carregadas para a interface.
class LoadedMatchesState extends MatchState {
  final List<MatchWithTeams> matches;

  const LoadedMatchesState(this.matches);
}

// Representa uma falha ocorrida durante uma operação com partidas.
class MatchErrorState extends MatchState {
  final String message;

  const MatchErrorState(this.message);
}
