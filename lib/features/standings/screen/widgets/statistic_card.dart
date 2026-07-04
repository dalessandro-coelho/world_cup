
import 'package:flutter/material.dart';
import 'package:world_cup/features/standings/models/team_standings.dart';

// Mostra uma estatística de destaque associada a uma seleção.
class StatisticCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final TeamStandings standings;

  const StatisticCard({super.key, 
    required this.title,
    required this.description,
    required this.icon,
    required this.standings,
  });

  // Constrói o card visual que apresenta uma estatística de destaque.
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.black12,
        ),
      ),

      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,

            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),

            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),

          const Padding(padding: EdgeInsets.only(left: 14)),

          CircleAvatar(
            radius: 22,
            backgroundImage: AssetImage(standings.team.flag),
          ),

          const Padding(padding: EdgeInsets.only(left: 12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 3)),

                Text(
                  standings.team.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),

          Text(
            description,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Organiza os cards com os principais destaques estatísticos da competição.
class WorldCupStatistics extends StatelessWidget {
  final TeamStandings? bestAttack;
  final TeamStandings? bestDefense;
  final TeamStandings? mostWins;

  const WorldCupStatistics({super.key, 
    required this.bestAttack,
    required this.bestDefense,
    required this.mostWins,
  });

  // Constrói a interface deste componente conforme o estado atual.
  @override
  Widget build(BuildContext context) {
    if (bestAttack == null || bestDefense == null || mostWins == null) {
      return Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(24),

          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white10
                : Colors.black12,
          ),
        ),

        child: Text(
          'Cadastre uma partida para visualizar as estatísticas da Copa.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ESTATÍSTICAS DA COPA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),

        const Padding(padding: EdgeInsets.only(top: 14)),

        StatisticCard(
          title: 'Melhor Ataque',
          description: '${bestAttack!.goalsFor} gols marcados',
          icon: Icons.sports_soccer,
          standings: bestAttack!,
        ),

        const Padding(padding: EdgeInsets.only(top: 12)),

        StatisticCard(
          title: 'Melhor Defesa',
          description: '${bestDefense!.goalsAgainst} gols sofridos',
          icon: Icons.shield_outlined,
          standings: bestDefense!,
        ),

        const Padding(padding: EdgeInsets.only(top: 12)),

        StatisticCard(
          title: 'Mais Vitórias',
          description: '${mostWins!.wins} vitórias',
          icon: Icons.emoji_events_outlined,
          standings: mostWins!,
        ),
      ],
    );
  }
}
