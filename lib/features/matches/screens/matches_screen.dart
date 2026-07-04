import 'package:world_cup/database/app_database.dart';
import 'package:world_cup/core/widgets/theme_toggle_button.dart';
import 'package:world_cup/core/widgets/empty_state.dart';
import 'package:world_cup/features/matches/bloc/match_bloc.dart';
import 'package:world_cup/features/matches/bloc/match_state.dart';
import 'package:world_cup/features/matches/bloc/match_event.dart';
import 'package:world_cup/features/matches/screens/edit_match_screen.dart';
import 'package:world_cup/features/matches/screens/new_match_screen.dart';
import 'package:world_cup/features/matches/screens/widgets/match_search_field.dart';
import 'package:world_cup/features/matches/screens/widgets/match_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchesScreen extends StatefulWidget {
  const MatchesScreen({super.key});

  @override
  State<MatchesScreen> createState() => _MatchesScreenState();
}

// Mantém o filtro de pesquisa e a interação da tela de partidas.
class _MatchesScreenState extends State<MatchesScreen> {
  String _searchText = '';

  // Constrói o estado visual exibido quando a pesquisa não encontra partidas.
  Widget _buildEmptySearchState(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
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
          Icon(
            Icons.search_off,
            size: 46,
            color: Theme.of(context).colorScheme.primary,
          ),
          const Padding(padding: EdgeInsets.only(top: 12)),
          Text(
            'Nenhuma partida encontrada',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const Padding(padding: EdgeInsets.only(top: 6)),
          Text(
            'Verifique o nome da seleção pesquisada.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  // Constrói a lista de partidas e aplica o filtro de pesquisa.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 27, 136, 8),

        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewMatchScreen()),
          );
        },

        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: SafeArea(
        child: BlocBuilder<MatchBloc, MatchState>(
          builder: (context, state) {
            if (state is InitialMatchState ||
                state is LoadingMatchesState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MatchErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              );
            }

            if (state is LoadedMatchesState) {
              final normalizedSearchText = _searchText
                  .trim()
                  .toLowerCase();

              final filteredMatches = state.matches.where((matchData) {
                final homeTeamName = matchData.homeTeam.name.toLowerCase();

                final awayTeamName = matchData.awayTeam.name.toLowerCase();

                return homeTeamName.contains(normalizedSearchText) ||
                    awayTeamName.contains(normalizedSearchText);
              }).toList();
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),

                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Gerenciamento de Partidas',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),

                            const Padding(padding: EdgeInsets.only(top: 4)),

                            Text(
                              'Acompanhe todos os confrontos da Copa.',
                              style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const ThemeToggleButton(),
                    ],
                  ),

                  const Padding(padding: EdgeInsets.only(top: 24)),

                  Container(
                    height: 200,

                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),

                      image: const DecorationImage(
                        image: AssetImage('assets/imagens/fundo_copa.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  MatchSearchField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  if (state.matches.isEmpty)
                    const EmptyState(
                      icon: Icons.sports_soccer_outlined,
                      title: 'Nenhuma partida cadastrada',
                      message:
                          'Use o botão + para registrar o primeiro confronto da Copa.',
                    )
                  else if (filteredMatches.isEmpty)
                    _buildEmptySearchState(context)
                  else
                    ...filteredMatches.map(
                      (matchData) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: buildMatchCard(
                          context: context,
                          matchData: matchData,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditMatchScreen(
                                  matchData: matchData,
                                ),
                              ),
                            );
                          },
                          onDelete: () {
                            _confirmDeletion(context, matchData);
                          },
                        ),
                      ),
                    ),
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

// Solicita confirmação antes de remover uma partida do banco de dados.
Future<void> _confirmDeletion(
  BuildContext context,
  MatchWithTeams matchData,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Remover partida?'),

        content: Text(
          'A partida entre ${matchData.homeTeam.name} e '
          '${matchData.awayTeam.name} será removida permanentemente.',
          style: TextStyle(
            color: Theme.of(dialogContext).colorScheme.onSurface,
          ),
        ),

        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },

            child: const Text('CANCELAR'),
          ),

          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },

            child: const Text(
              'REMOVER',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );

  if (confirm != true) {
    return;
  }

  context.read<MatchBloc>().add(DeleteMatchEvent(matchData.match.id));
}
