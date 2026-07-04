import 'package:world_cup/database/app_database.dart';
import 'package:flutter/material.dart';

// Formata uma data para a representação usada no card da partida.
String formatDate(DateTime date) {
  final dayText = date.day.toString().padLeft(2, '0');
  final monthText = date.month.toString().padLeft(2, '0');
  final yearText = date.year;
  return '$dayText/$monthText/$yearText';
}

// Constrói o card que apresenta placar, seleções, data, estádio e ações da partida.
Widget buildMatchCard({
  required BuildContext context,
  required MatchWithTeams matchData,
  required VoidCallback onEdit,
  required VoidCallback onDelete,
}) {
  final match = matchData.match;
  final homeTeam = matchData.homeTeam;
  final awayTeam = matchData.awayTeam;

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

    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(homeTeam.flag),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 10)),

                  Text(
                    homeTeam.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),

            const Padding(padding: EdgeInsets.only(left: 12)),

            Column(
              children: [
                Text(
                  '${match.homeTeamGoals} x ${match.awayTeamGoals}',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 6)),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Text(
                    'ENCERRADA',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),

            const Padding(padding: EdgeInsets.only(left: 12)),

            Expanded(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(awayTeam.flag),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 10)),

                  Text(
                    awayTeam.name,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const Padding(padding: EdgeInsets.only(top: 18)),

        Divider(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.black12,
        ),

        const Padding(padding: EdgeInsets.only(top: 12)),

        Row(
          children: [
            Icon(
              Icons.calendar_month,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),

            const Padding(padding: EdgeInsets.only(left: 8)),

            Expanded(
              child: Text(
                formatDate(match.date),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),

            Icon(
              Icons.stadium,
              size: 18,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),

            const Padding(padding: EdgeInsets.only(left: 8)),

            Expanded(
              child: Text(
                match.stadium,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),

        const Padding(padding: EdgeInsets.only(top: 14)),

        Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),

            decoration: BoxDecoration(
              color: Theme.of(
                context,
              ).colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Text(
              match.stage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),

        const Padding(padding: EdgeInsets.only(top: 6)),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,

          children: [
            IconButton(
              tooltip: 'Editar partida',

              onPressed: onEdit,

              icon: Icon(Icons.edit, color: Colors.amber.shade700),
            ),

            IconButton(
              tooltip: 'Remover partida',

              onPressed: onDelete,

              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            ),
          ],
        ),
      ],
    ),
  );
}
