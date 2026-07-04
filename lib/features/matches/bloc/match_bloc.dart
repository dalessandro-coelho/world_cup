import 'dart:async';

import 'package:world_cup/database/app_database.dart';
import 'package:world_cup/features/matches/bloc/match_state.dart';
import 'package:world_cup/features/matches/bloc/match_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Gerencia a leitura e as operações de cadastro, edição e remoção de partidas.
class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final AppDatabase database;

  StreamSubscription<List<MatchWithTeams>>? _matchesSubscription;

  MatchBloc(this.database) : super(const InitialMatchState()) {
    on<StartMatchesObservationEvent>(_startMatchesObservation);

    on<MatchesUpdatedEvent>(_updateMatchesList);

    on<MatchesObservationErrorEvent>(_showError);

    on<AddMatchEvent>(_addMatch);

    on<UpdateMatchEvent>(_updateMatch);

    on<DeleteMatchEvent>(_deleteMatch);
  }

  // Inicia a inscrição que acompanha as partidas armazenadas no banco.
  Future<void> _startMatchesObservation(
    StartMatchesObservationEvent event,
    Emitter<MatchState> emit,
  ) async {
    emit(const LoadingMatchesState());

    await _matchesSubscription?.cancel();

    _matchesSubscription = database.watchMatchesWithTeams().listen(
      (matches) {
        add(MatchesUpdatedEvent(matches));
      },
      onError: (Object error, StackTrace stackTrace) {
        add(
          const MatchesObservationErrorEvent(
            'Não foi possível carregar as partidas.',
          ),
        );
      },
    );
  }

  // Mostra a lista mais recente de partidas pra tela.
  void _updateMatchesList(
    MatchesUpdatedEvent event,
    Emitter<MatchState> emit,
  ) {
    emit(LoadedMatchesState(event.matches));
  }

  // Mostra uma mensagem de erro pra tela.
  void _showError(
    MatchesObservationErrorEvent event,
    Emitter<MatchState> emit,
  ) {
    emit(MatchErrorState(event.message));
  }

  // Salva uma nova partida no banco de dados local.
  Future<void> _addMatch(
    AddMatchEvent event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await database.addMatch(
        homeTeamId: event.homeTeamId,
        awayTeamId: event.awayTeamId,
        homeTeamGoals: event.homeTeamGoals,
        awayTeamGoals: event.awayTeamGoals,
        date: event.date,
        stadium: event.stadium.trim(),
        stage: event.stage,
      );
    } catch (_) {
      emit(const MatchErrorState('Não foi possível cadastrar a partida.'));
    }
  }

  // Atualiza uma partida existente no banco de dados local.
  Future<void> _updateMatch(
    UpdateMatchEvent event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await database.updateMatch(
        id: event.id,
        homeTeamId: event.homeTeamId,
        awayTeamId: event.awayTeamId,
        homeTeamGoals: event.homeTeamGoals,
        awayTeamGoals: event.awayTeamGoals,
        date: event.date,
        stadium: event.stadium.trim(),
        stage: event.stage,
      );
    } catch (_) {
      emit(const MatchErrorState('Não foi possível atualizar a partida.'));
    }
  }

  // Remove uma partida existente do banco de dados local.
  Future<void> _deleteMatch(
    DeleteMatchEvent event,
    Emitter<MatchState> emit,
  ) async {
    try {
      await database.deleteMatch(event.id);
    } catch (_) {
      emit(const MatchErrorState('Não foi possível remover a partida.'));
    }
  }

  // Cancela a inscrição ativa antes de encerrar o BLoC.
  @override
  Future<void> close() async {
    await _matchesSubscription?.cancel();

    return super.close();
  }
}
