import 'dart:async';

import 'package:world_cup/database/app_database.dart';
import 'package:world_cup/features/standings/bloc/standings_state.dart';
import 'package:world_cup/features/standings/bloc/standings_event.dart';
import 'package:world_cup/features/standings/rules/standings_calculator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Controla o carregamento e o recálculo automático da classificação da competição.
class StandingsBloc extends Bloc<StandingsEvent, StandingsState> {
  final AppDatabase database;

  final StandingsCalculator _calculator =
      const StandingsCalculator();

  StreamSubscription<List<Team>>? _teamsSubscription;

  StreamSubscription<List<MatchWithTeams>>? _matchesSubscription;

  List<Team> _teams = [];

  List<MatchWithTeams> _matches = [];

  StandingsBloc(this.database) : super(const InitialStandingsState()) {
    on<StartStandingsObservationEvent>(_startStandingsObservation);

    on<StandingsTeamsUpdatedEvent>(_updateTeams);

    on<StandingsMatchesUpdatedEvent>(_updateMatches);

    on<StandingsObservationErrorEvent>(_showError);
  }

  // Inicia as inscrições que acompanham mudanças em seleções e partidas.
  Future<void> _startStandingsObservation(
    StartStandingsObservationEvent event,
    Emitter<StandingsState> emit,
  ) async {
    emit(const LoadingStandingsState());

    await _teamsSubscription?.cancel();
    await _matchesSubscription?.cancel();

    _teamsSubscription = database.watchAllTeams().listen(
      (teams) {
        add(StandingsTeamsUpdatedEvent(teams));
      },
      onError: (Object error, StackTrace stackTrace) {
        add(
          const StandingsObservationErrorEvent(
            'Não foi possível carregar a classificação.',
          ),
        );
      },
    );

    _matchesSubscription = database.watchMatchesWithTeams().listen(
      (matches) {
        add(StandingsMatchesUpdatedEvent(matches));
      },
      onError: (Object error, StackTrace stackTrace) {
        add(
          const StandingsObservationErrorEvent(
            'Não foi possível carregar as partidas da classificação.',
          ),
        );
      },
    );
  }

  // Atualiza a lista de seleções utilizada no cálculo da classificação.
  void _updateTeams(
    StandingsTeamsUpdatedEvent event,
    Emitter<StandingsState> emit,
  ) {
    _teams = event.teams;

    _calculateStandings(emit);
  }

  // Atualiza a lista de partidas utilizada no cálculo da classificação.
  void _updateMatches(
    StandingsMatchesUpdatedEvent event,
    Emitter<StandingsState> emit,
  ) {
    _matches = event.matches;

    _calculateStandings(emit);
  }

  // Publica um estado de erro para a interface.
  void _showError(
    StandingsObservationErrorEvent event,
    Emitter<StandingsState> emit,
  ) {
    emit(StandingsErrorState(event.message));
  }

  // Calcula a tabela e os destaques estatísticos a partir dos dados atuais.
  void _calculateStandings(Emitter<StandingsState> emit) {
    final standings = _calculator.calculate(
      teams: _teams,
      matches: _matches,
    );

    emit(
      LoadedStandingsState(
        standings: standings,
        bestAttack: _calculator.getBestAttack(standings),
        bestDefense: _calculator.getBestDefense(standings),
        mostWins: _calculator.getMostWins(standings),
      ),
    );
  }

  // Cancela as inscrições ativas antes de encerrar o BLoC.
  @override
  Future<void> close() async {
    await _teamsSubscription?.cancel();
    await _matchesSubscription?.cancel();

    return super.close();
  }
}
