
import 'package:flutter/material.dart';
import 'package:world_cup/features/standings/models/team_standings.dart';

// Exibe os dados da classificação em formato de tabela horizontal.
class StandingsTable extends StatelessWidget {
  final List<TeamStandings> standings;

  const StandingsTable({super.key, required this.standings});

  // Constrói a tabela com os indicadores de todas as seleções classificadas.
  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: borderColor),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'CLASSIFICAÇÃO',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const Padding(padding: EdgeInsets.only(top: 16)),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: SizedBox(
              width: 730,

              child: Column(
                children: [
                  _buildTableHeader(context),

                  ...List.generate(standings.length, (index) {
                    return _buildTableRow(
                      context: context,
                      position: index + 1,
                      item: standings[index],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Monta o cabeçalho com as abreviações das colunas da tabela.
  Widget _buildTableHeader(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      padding: const EdgeInsets.only(bottom: 12),

      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white10
                : Colors.black12,
          ),
        ),
      ),

      child: Row(
        children: [
          _buildCell(text: '#', width: 38, color: textColor, isBold: true),

          _buildCell(
            text: 'SELEÇÃO',
            width: 250,
            color: textColor,
            isBold: true,
            alignment: TextAlign.left,
          ),

          _buildCell(text: 'J', width: 42, color: textColor, isBold: true),

          _buildCell(text: 'V', width: 42, color: textColor, isBold: true),

          _buildCell(text: 'E', width: 42, color: textColor, isBold: true),

          _buildCell(text: 'D', width: 42, color: textColor, isBold: true),

          _buildCell(text: 'GP', width: 48, color: textColor, isBold: true),

          _buildCell(text: 'GC', width: 48, color: textColor, isBold: true),

          _buildCell(text: 'SG', width: 48, color: textColor, isBold: true),

          _buildCell(text: 'PTS', width: 58, color: textColor, isBold: true),
        ],
      ),
    );
  }

  // Monta uma linha com os dados estatísticos de uma seleção.
  Widget _buildTableRow({
    required BuildContext context,
    required int position,
    required TeamStandings item,
  }) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;

    final formattedGoalDifference = item.goalDifference > 0
        ? '+${item.goalDifference}'
        : item.goalDifference.toString();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),

      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),

      child: Row(
        children: [
          _buildCell(text: position.toString(), width: 38, color: textColor),

          SizedBox(
            width: 250,

            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(item.team.flag),
                ),

                const Padding(padding: EdgeInsets.only(left: 10)),

                Expanded(
                  child: Text(
                    item.team.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _buildCell(text: item.games.toString(), width: 42, color: textColor),

          _buildCell(text: item.wins.toString(), width: 42, color: textColor),

          _buildCell(text: item.draws.toString(), width: 42, color: textColor),

          _buildCell(text: item.losses.toString(), width: 42, color: textColor),

          _buildCell(text: item.goalsFor.toString(), width: 48, color: textColor),

          _buildCell(
            text: item.goalsAgainst.toString(),
            width: 48,
            color: textColor,
          ),

          _buildCell(
            text: formattedGoalDifference,
            width: 48,
            color: item.goalDifference > 0 ? Colors.green : textColor,
          ),

          _buildCell(
            text: item.points.toString(),
            width: 58,
            color: Theme.of(context).colorScheme.primary,
            isBold: true,
          ),
        ],
      ),
    );
  }
}

// Cria uma célula padronizada usada nas linhas da tabela de classificação.
Widget _buildCell({
  required String text,
  required double width,
  required Color color,
  bool isBold = false,
  TextAlign alignment = TextAlign.center,
}) {
  return SizedBox(
    width: width,

    child: Text(
      text,
      textAlign: alignment,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
        fontSize: 13,
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      ),
    ),
  );
}
