import 'package:world_cup/database/app_database.dart';

// Define a base para os eventos que atualizam a classificação.
abstract class StandingsEvent {
  const StandingsEvent();
}

// Inicia a escuta das seleções e partidas usadas na classificação.
class StartStandingsObservationEvent extends StandingsEvent {
  const StartStandingsObservationEvent();
}

// Entrega ao BLoC a lista atualizada de seleções cadastradas.
class StandingsTeamsUpdatedEvent extends StandingsEvent {
  final List<Team> teams;

  const StandingsTeamsUpdatedEvent(this.teams);
}

// Entrega ao BLoC a lista atualizada de partidas cadastradas.
class StandingsMatchesUpdatedEvent extends StandingsEvent {
  final List<MatchWithTeams> matches;

  const StandingsMatchesUpdatedEvent(this.matches);
}

// Informa um erro ocorrido durante a observação dos dados da classificação.
class StandingsObservationErrorEvent extends StandingsEvent {
  final String message;

  const StandingsObservationErrorEvent(this.message);
}
