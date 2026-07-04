import 'package:world_cup/database/app_database.dart';

// Define a base para os eventos relacionados às partidas.
abstract class MatchEvent {
  const MatchEvent();
}

// Inicia a observação das partidas salvas no banco.
class StartMatchesObservationEvent extends MatchEvent {
  const StartMatchesObservationEvent();
}

// Entrega ao BLoC a lista atualizada de partidas com suas seleções.
class MatchesUpdatedEvent extends MatchEvent {
  final List<MatchWithTeams> matches;

  const MatchesUpdatedEvent(this.matches);
}

// Informa uma falha ao observar as partidas no banco local.
class MatchesObservationErrorEvent extends MatchEvent {
  final String message;

  const MatchesObservationErrorEvent(this.message);
}

// Solicita o cadastro de uma nova partida.
class AddMatchEvent extends MatchEvent {
  final int homeTeamId;
  final int awayTeamId;
  final int homeTeamGoals;
  final int awayTeamGoals;
  final DateTime date;
  final String stadium;
  final String stage;

  const AddMatchEvent({
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeTeamGoals,
    required this.awayTeamGoals,
    required this.date,
    required this.stadium,
    required this.stage,
  });
}

// Solicita a atualização dos dados de uma partida existente.
class UpdateMatchEvent extends MatchEvent {
  final int id;
  final int homeTeamId;
  final int awayTeamId;
  final int homeTeamGoals;
  final int awayTeamGoals;
  final DateTime date;
  final String stadium;
  final String stage;

  const UpdateMatchEvent({
    required this.id,
    required this.homeTeamId,
    required this.awayTeamId,
    required this.homeTeamGoals,
    required this.awayTeamGoals,
    required this.date,
    required this.stadium,
    required this.stage,
  });
}

// Solicita a remoção de uma partida cadastrada.
class DeleteMatchEvent extends MatchEvent {
  final int id;

  const DeleteMatchEvent(this.id);
}
