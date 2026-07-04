// Define a base para os eventos relacionados às seleções.
import 'package:world_cup/database/app_database.dart';

abstract class TeamEvent {
  const TeamEvent();
}

// Inicia a observação contínua das seleções no banco local.
class StartTeamsObservationEvent extends TeamEvent {
  const StartTeamsObservationEvent();
}

// Entrega ao BLoC a lista atualizada de seleções.
class TeamsUpdatedEvent extends TeamEvent {
  final List<Team> teams;

  const TeamsUpdatedEvent(this.teams);
}

// Informa uma falha ao observar as seleções no banco local.
class TeamsObservationErrorEvent extends TeamEvent {
  final String message;

  const TeamsObservationErrorEvent(this.message);
}

// Solicita o cadastro de uma nova seleção.
class AddTeamEvent extends TeamEvent {
  final String name;
  final String coach;
  final String group;
  final String flag;

  const AddTeamEvent({
    required this.name,
    required this.coach,
    required this.group,
    required this.flag,
  });
}

// Solicita a atualização dos dados de uma seleção existente.
class UpdateTeamEvent extends TeamEvent {
  final int id;
  final String name;
  final String coach;
  final String group;
  final String flag;

  const UpdateTeamEvent({
    required this.id,
    required this.name,
    required this.coach,
    required this.group,
    required this.flag,
  });
}


// Solicita a remoção de uma seleção cadastrada.
class DeleteTeamEvent extends TeamEvent {
  final int id;

  const DeleteTeamEvent(this.id);
}
