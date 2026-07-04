import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:world_cup/core/widgets/empty_state.dart';
import 'package:world_cup/core/widgets/theme_toggle_button.dart';
import 'package:world_cup/features/teams/bloc/team_bloc.dart';
import 'package:world_cup/features/teams/bloc/team_state.dart';
import 'package:world_cup/features/teams/screens/edit_team_screen.dart';
import 'package:world_cup/features/teams/screens/new_team_screen.dart';
import 'package:world_cup/features/teams/screens/widgets/team_card.dart';
import 'package:world_cup/features/teams/screens/widgets/team_search_field.dart';


class TeamsScreen extends StatefulWidget {
  const TeamsScreen({super.key});

  @override
  State<TeamsScreen> createState() => _TeamsScreenState();
}

// Mantém o filtro de pesquisa e a interação da tela de seleções.
class _TeamsScreenState extends State<TeamsScreen> {
  String _searchText = '';

  // Constrói a lista de seleções e aplica o filtro de pesquisa.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const NewTeamScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: BlocBuilder<TeamBloc, TeamState>(
          builder: (context, state) {
            if (state is InitialTeamState || state is LoadingTeamsState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is TeamErrorState) {
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

            if (state is LoadedTeamsState) {
              final normalizedSearchText = _searchText.trim().toLowerCase();
              final filteredTeams = state.teams.where((team) {
                return team.name.toLowerCase().contains(normalizedSearchText);
              }).toList();

              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),

                children: [
                  _buildHeader(context),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  TeamSearchField(
                    onChanged: (value) {
                      setState(() {
                        _searchText = value;
                      });
                    },
                  ),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  if (state.teams.isEmpty)
                    const EmptyState(
                      icon: Icons.flag_outlined,
                      title: 'Nenhuma seleção cadastrada',
                      message:
                          'Use o botão + para cadastrar a primeira seleção.',
                    )
                  else if (filteredTeams.isEmpty)
                    const EmptyState(
                      icon: Icons.search_off,
                      title: 'Nenhuma seleção encontrada',
                      message: 'Verifique o nome pesquisado.',
                    )
                  else
                    ...filteredTeams.map(
                      (team) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: TeamCard(
                          name: team.name,
                          coach: team.coach,
                          group: team.group,
                          flag: team.flag,
                          onEdit: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditTeamScreen(team: team),
                              ),
                            );
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

  // Monta o cabeçalho informativo da tela de seleções.
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,

      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              'Seleções',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            Text(
              'Gerencie as seleções da competição',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
          ],
        ),

        const ThemeToggleButton(),
      ],
    );
  }
}
