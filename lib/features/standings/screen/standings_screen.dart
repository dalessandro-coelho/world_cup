
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_cup/core/widgets/empty_state.dart';
import 'package:world_cup/core/widgets/theme_toggle_button.dart';
import 'package:world_cup/features/standings/bloc/standings_bloc.dart';
import 'package:world_cup/features/standings/bloc/standings_state.dart';
import 'package:world_cup/features/standings/screen/widgets/standings_table.dart';
import 'package:world_cup/features/standings/screen/widgets/statistic_card.dart';

class StandingsScreen extends StatelessWidget {
  const StandingsScreen({super.key});

  // Constrói a interface conforme o estado atual da classificação.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<StandingsBloc, StandingsState>(
          builder: (context, state) {
            if (state is InitialStandingsState ||
                state is LoadingStandingsState) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is StandingsErrorState) {
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

            if (state is LoadedStandingsState) {
              return ListView(
                padding: const EdgeInsets.fromLTRB(16, 28, 16, 16),

                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: const ThemeToggleButton(),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 16)),

                  _buildHeader(),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  if (state.standings.isEmpty)
                    const EmptyState(
                      icon: Icons.emoji_events_outlined,
                      title: 'Nenhuma seleção cadastrada',
                      message:
                          'Cadastre seleções e partidas para gerar a classificação automaticamente.',
                    )
                  else ...[
                    StandingsTable(standings: state.standings),

                    const Padding(padding: EdgeInsets.only(top: 24)),

                    WorldCupStatistics(
                      bestAttack: state.bestAttack,
                      bestDefense: state.bestDefense,
                      mostWins: state.mostWins,
                    ),
                  ],
                ],
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  // Constrói o banner visual exibido no topo da tela de classificação.
  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          height: 220,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),

            image: const DecorationImage(
              image: AssetImage('assets/imagens/banner_copa.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),

        Positioned(
          top: 12,
          right: 12,

          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}
