import 'package:world_cup/features/standings/models/team_standings.dart';

// Define a base para os estados exibidos pela funcionalidade de classificação.
abstract class StandingsState {
  const StandingsState();
}

// Representa o estado inicial antes do carregamento da classificação.
class InitialStandingsState extends StandingsState {
  const InitialStandingsState();
}

// Indica que os dados necessários para a classificação estão sendo carregados.
class LoadingStandingsState extends StandingsState {
  const LoadingStandingsState();
}

// Disponibiliza a classificação calculada e os destaques estatísticos da Copa.
class LoadedStandingsState extends StandingsState {
  final List<TeamStandings> standings;

  final TeamStandings? bestAttack;
  final TeamStandings? bestDefense;
  final TeamStandings? mostWins;

  const LoadedStandingsState({
    required this.standings,
    required this.bestAttack,
    required this.bestDefense,
    required this.mostWins,
  });
}

// Representa uma falha ao carregar ou calcular a classificação.
class StandingsErrorState extends StandingsState {
  final String message;

  const StandingsErrorState(this.message);
}
