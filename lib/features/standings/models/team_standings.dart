import 'package:world_cup/database/app_database.dart';

// Armazena os indicadores de desempenho de uma seleção na tabela de classificação.
class TeamStandings {
  final Team team;

  int games;
  int wins;
  int draws;
  int losses;
  int goalsFor;
  int goalsAgainst;
  int points;

  TeamStandings({
    required this.team,
    this.games = 0,
    this.wins = 0,
    this.draws = 0,
    this.losses = 0,
    this.goalsFor = 0,
    this.goalsAgainst = 0,
    this.points = 0,
  });

  // Calcula o saldo de gols da seleção.
  int get goalDifference {
    return goalsFor - goalsAgainst;
  }



  // Atualiza os indicadores da seleção após o registro de uma partida.
  void registerMatch({
    required int goalsScored,
    required int goalsConceded,
  }) {
    games++;

    goalsFor += goalsScored;
    goalsAgainst += goalsConceded;

    if (goalsScored > goalsConceded) {
      wins++;
      points += 3;
      return;
    }

    if (goalsScored == goalsConceded) {
      draws++;
      points++;
      return;
    }

    losses++;
  }
}
