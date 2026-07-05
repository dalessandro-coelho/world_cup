import 'dart:async';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_cup/database/app_database.dart';
import 'package:world_cup/features/teams/bloc/team_event.dart';
import 'package:world_cup/features/teams/bloc/team_state.dart';

// Gerencia a leitura e as operações de cadastro, edição e remoção de seleções.
class TeamBloc extends Bloc<TeamEvent, TeamState> {
  final AppDatabase database;

  StreamSubscription<List<Team>>? _teamsSubscription;

  TeamBloc(this.database) : super(const InitialTeamState()) {
    on<StartTeamsObservationEvent>(_startTeamsObservation);

    on<TeamsUpdatedEvent>(_updateTeamsList);

    on<TeamsObservationErrorEvent>(_showError);

    on<AddTeamEvent>(_addTeam);

    on<UpdateTeamEvent>(_updateTeam);

    on<DeleteTeamEvent>(_deleteTeam);
  }

  // Informa quantas partidas estão vinculadas a uma seleção.
  Future<int> countRelatedMatches(int teamId) {
    return database.countMatchesByTeamId(teamId);
  }

  // Inicia a inscrição que acompanha as seleções armazenadas no banco.
  Future<void> _startTeamsObservation(
    StartTeamsObservationEvent event,
    Emitter<TeamState> emit,
  ) async {
    emit(const LoadingTeamsState());

    await _teamsSubscription?.cancel();

    _teamsSubscription = database.watchAllTeams().listen(
      (teams) {
        add(TeamsUpdatedEvent(teams));
      },
      onError: (Object error, StackTrace stackTrace) {
        add(
          const TeamsObservationErrorEvent(
            'Não foi possível carregar as seleções.',
          ),
        );
      },
    );
  }

  // Publica a lista mais recente de seleções para a interface.
  void _updateTeamsList(TeamsUpdatedEvent event, Emitter<TeamState> emit) {
    emit(LoadedTeamsState(event.teams));
  }

  // Publica uma mensagem de erro para a interface.
  void _showError(TeamsObservationErrorEvent event, Emitter<TeamState> emit) {
    emit(TeamErrorState(event.message));
  }

  // Salva uma nova seleção no banco de dados local.
  Future<void> _addTeam(AddTeamEvent event, Emitter<TeamState> emit) async {
    try {
      await database.addTeam(
        name: event.name.trim(),
        coach: event.coach.trim(),
        group: event.group,
        flag: event.flag,
      );
    } catch (_) {
      emit(const TeamErrorState('Não foi possível cadastrar a seleção.'));
    }
  }

  // Atualiza uma seleção existente no banco de dados local.
  Future<void> _updateTeam(
    UpdateTeamEvent event,
    Emitter<TeamState> emit,
  ) async {
    try {
      await database.updateTeam(
        id: event.id,
        name: event.name.trim(),
        coach: event.coach.trim(),
        group: event.group,
        flag: event.flag,
      );
    } catch (_) {
      emit(const TeamErrorState('Não foi possível atualizar a seleção.'));
    }
  }

  // Remove uma seleção existente do banco de dados local.
  Future<void> _deleteTeam(
    DeleteTeamEvent event,
    Emitter<TeamState> emit, 
  ) async {
    try {
      final relatedMatchesCount = await database.countMatchesByTeamId(event.id);
      if (relatedMatchesCount > 0) {
        return;
      }     
      await database.deleteTeam(event.id);
    } catch (_) {
      emit(const TeamErrorState('Não foi possível remover a seleção.'));
    }
  }

  // Cancela a inscrição ativa antes de encerrar o BLoC.
  @override
  Future<void> close() async {
    await _teamsSubscription?.cancel();

    return super.close();
  }
}
