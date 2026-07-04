// Calcula a classificação e os destaques estatísticos a partir das partidas registradas.
import 'package:world_cup/database/app_database.dart';
import 'package:world_cup/features/standings/models/team_standings.dart';

class StandingsCalculator {
  const StandingsCalculator();

  // Gera a classificação completa com base nas seleções e partidas informadas.
  List<TeamStandings> calculate({
    required List<Team> teams,
    required List<MatchWithTeams> matches,
  }) {
    final standingsById = <int, TeamStandings>{
      for (final team in teams) team.id: TeamStandings(team: team),
    };

    for (final matchData in matches) {
      final match = matchData.match;

      final homeTeam = standingsById[match.homeTeamId];
      final awayTeam = standingsById[match.awayTeamId];

      if (homeTeam == null || awayTeam == null) {
        continue;
      }

      homeTeam.registerMatch(
        goalsScored: match.homeTeamGoals,
        goalsConceded: match.awayTeamGoals,
      );

      awayTeam.registerMatch(
        goalsScored: match.awayTeamGoals,
        goalsConceded: match.homeTeamGoals,
      );
    }

    final standings = standingsById.values.toList();

    standings.sort(_compareTeams);

    return standings;
  }

  // Encontra a seleção com o maior número de gols marcados.
  TeamStandings? getBestAttack(List<TeamStandings> standings) {
    final teamsWithMatches = _filterTeamsWithMatches(standings);

    if (teamsWithMatches.isEmpty) {
      return null;
    }

    final sorted = [...teamsWithMatches];

    sorted.sort((first, second) {
      final compareGoalsFor = second.goalsFor.compareTo(first.goalsFor);

      if (compareGoalsFor != 0) {
        return compareGoalsFor;
      }

      return first.team.name.toLowerCase().compareTo(
        second.team.name.toLowerCase(),
      );
    });

    return sorted.first;
  }

  // Encontra a seleção com o menor número de gols sofridos.
  TeamStandings? getBestDefense(List<TeamStandings> standings) {
    final teamsWithMatches = _filterTeamsWithMatches(standings);

    if (teamsWithMatches.isEmpty) {
      return null;
    }

    final sorted = [...teamsWithMatches];

    sorted.sort((first, second) {
      final compareGoalsAgainst = first.goalsAgainst.compareTo(
        second.goalsAgainst,
      );

      if (compareGoalsAgainst != 0) {
        return compareGoalsAgainst;
      }

      return first.team.name.toLowerCase().compareTo(
        second.team.name.toLowerCase(),
      );
    });

    return sorted.first;
  }

  // Encontra a seleção com a maior quantidade de vitórias.
  TeamStandings? getMostWins(List<TeamStandings> standings) {
    final teamsWithMatches = _filterTeamsWithMatches(standings);

    if (teamsWithMatches.isEmpty) {
      return null;
    }

    final sorted = [...teamsWithMatches];

    sorted.sort((first, second) {
      final compareWins = second.wins.compareTo(first.wins);

      if (compareWins != 0) {
        return compareWins;
      }

      return first.team.name.toLowerCase().compareTo(
        second.team.name.toLowerCase(),
      );
    });

    return sorted.first;
  }

  // Remove da análise as seleções que ainda não disputaram partidas.
  List<TeamStandings> _filterTeamsWithMatches(List<TeamStandings> standings) {
    return standings.where((item) => item.games > 0).toList();
  }

  // Aplica os critérios de desempate para ordenar a classificação.
  int _compareTeams(TeamStandings first, TeamStandings second) {
    final comparePoints = second.points.compareTo(first.points);

    if (comparePoints != 0) {
      return comparePoints;
    }

    final compareGoalDifference = second.goalDifference.compareTo(
      first.goalDifference,
    );

    if (compareGoalDifference != 0) {
      return compareGoalDifference;
    }

    final compareGoalsFor = second.goalsFor.compareTo(first.goalsFor);

    if (compareGoalsFor != 0) {
      return compareGoalsFor;
    }

    final compareWins = second.wins.compareTo(first.wins);

    if (compareWins != 0) {
      return compareWins;
    }

    return first.team.name.toLowerCase().compareTo(
      second.team.name.toLowerCase(),
    );
  }
}
