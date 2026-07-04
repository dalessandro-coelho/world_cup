import 'package:world_cup/core/widgets/theme_toggle_button.dart';
import 'package:world_cup/features/matches/bloc/match_bloc.dart';
import 'package:world_cup/features/matches/bloc/match_event.dart';
import 'package:world_cup/features/teams/bloc/team_bloc.dart';
import 'package:world_cup/features/teams/bloc/team_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewMatchScreen extends StatefulWidget {
  const NewMatchScreen({super.key});

  @override
  State<NewMatchScreen> createState() => _NewMatchScreenState();
}

// Mantém os dados temporários e a lógica do formulário de cadastro de partida.
class _NewMatchScreenState extends State<NewMatchScreen> {
  final _formKey = GlobalKey<FormState>();

  final _homeGoalsController = TextEditingController();

  final _awayGoalsController = TextEditingController();

  final _stadiumController = TextEditingController();

  final _dateController = TextEditingController();

  int? homeTeamId;
  int? awayTeamId;

  DateTime? selectedDate;

  String stage = 'Fase de Grupos';

  // Libera os controladores de texto usados no formulário de cadastro.
  @override
  void dispose() {
    _homeGoalsController.dispose();
    _awayGoalsController.dispose();
    _stadiumController.dispose();
    _dateController.dispose();

    super.dispose();
  }

  // Valida o formulário e solicita o cadastro de uma nova partida.
  void _save() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    final selectedHomeTeamId = homeTeamId;
    final selectedAwayTeamId = awayTeamId;
    final date = selectedDate;

    final homeTeamGoals = int.tryParse(_homeGoalsController.text);
    final awayTeamGoals = int.tryParse(_awayGoalsController.text);



    if (selectedHomeTeamId == null ||
        selectedAwayTeamId == null ||
        date == null ||
        homeTeamGoals == null ||
        awayTeamGoals == null) {
      return;
    }

    if (homeTeamId == awayTeamId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Mandante e visitante precisam ser seleções diferentes.',
          ),
        ),
      );

      return;
    }



    context.read<MatchBloc>().add(
      AddMatchEvent(
        homeTeamId: selectedHomeTeamId,
        awayTeamId: selectedAwayTeamId,
        homeTeamGoals: homeTeamGoals,
        awayTeamGoals: awayTeamGoals,
        date: date,
        stadium: _stadiumController.text,
        stage: stage,
      ),
    );

    Navigator.pop(context);
  }

  // Constrói o formulário de cadastro de partida.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),

            child: const ThemeToggleButton(),
          ),
        ],

        title: const Text(
          'Nova Partida',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Text(
            'Registre os detalhes e o placar oficial do confronto.',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const Padding(padding: EdgeInsets.only(top: 24)),

          Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,

              borderRadius: BorderRadius.circular(25),

              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white10
                    : Colors.black12,
              ),
            ),

            child: BlocBuilder<TeamBloc, TeamState>(
              builder: (context, state) {
                if (state is InitialTeamState || state is LoadingTeamsState) {
                  return const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (state is TeamErrorState) {
                  return Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  );
                }

                if (state is! LoadedTeamsState) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final teams = state.teams;

                if (teams.length < 2) {
                  return Column(
                    children: [
                      Icon(
                        Icons.flag_outlined,
                        size: 44,
                        color: Theme.of(context).colorScheme.primary,
                      ),

                      const Padding(padding: EdgeInsets.only(top: 16)),

                      Text(
                        'Seleções insuficientes',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      const Padding(padding: EdgeInsets.only(top: 8)),

                      Text(
                        'Cadastre pelo menos duas seleções antes de registrar uma partida.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  );
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<int>(
                        initialValue: homeTeamId,

                        isExpanded: true,

                        validator: (value) {
                          if (value == null) {
                            return 'Selecione a seleção mandante';
                          }

                          if (value == awayTeamId) {
                            return 'Mandante e visitante não podem ser iguais';
                          }

                          return null;
                        },

                        decoration: InputDecoration(
                          labelText: 'Seleção Mandante',

                          filled: true,

                          fillColor: Theme.of(context).scaffoldBackgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),

                        items: teams.map((team) {
                          return DropdownMenuItem<int>(
                            value: team.id,

                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage(team.flag),
                                ),

                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),

                                Expanded(
                                  child: Text(
                                    team.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            homeTeamId = value;

                            if (awayTeamId == value) {
                              awayTeamId = null;
                            }
                          });
                        },
                      ),

                      const Padding(padding: EdgeInsets.only(top: 20)),

                      TextFormField(
                        controller: _homeGoalsController,

                        keyboardType: TextInputType.number,

                        textAlign: TextAlign.center,

                        validator: (value) {
                          final goals = int.tryParse(value ?? '');

                          if (goals == null || goals < 0) {
                            return 'Informe um placar válido';
                          }

                          return null;
                        },

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),

                        decoration: InputDecoration(
                          labelText: 'Gols Mandante',

                          filled: true,

                          fillColor: Theme.of(context).scaffoldBackgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const Padding(padding: EdgeInsets.only(top: 20)),

                      DropdownButtonFormField<int>(
                        initialValue: awayTeamId,

                        isExpanded: true,

                        validator: (value) {
                          if (value == null) {
                            return 'Selecione a seleção visitante';
                          }

                          if (value == homeTeamId) {
                            return 'Mandante e visitante não podem ser iguais';
                          }

                          return null;
                        },

                        decoration: InputDecoration(
                          labelText: 'Seleção Visitante',

                          filled: true,

                          fillColor: Theme.of(context).scaffoldBackgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),

                        items: teams.map((team) {
                          return DropdownMenuItem<int>(
                            value: team.id,

                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: AssetImage(team.flag),
                                ),

                                const Padding(
                                  padding: EdgeInsets.only(left: 10),
                                ),

                                Expanded(
                                  child: Text(
                                    team.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),

                        onChanged: (value) {
                          setState(() {
                            awayTeamId = value;

                            if (homeTeamId == value) {
                              homeTeamId = null;
                            }
                          });
                        },
                      ),

                      const Padding(padding: EdgeInsets.only(top: 20)),

                      TextFormField(
                        controller: _awayGoalsController,

                        keyboardType: TextInputType.number,

                        textAlign: TextAlign.center,

                        validator: (value) {
                          final goals = int.tryParse(value ?? '');

                          if (goals == null || goals < 0) {
                            return 'Informe um placar válido';
                          }

                          return null;
                        },

                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),

                        decoration: InputDecoration(
                          labelText: 'Gols Visitante',

                          filled: true,

                          fillColor: Theme.of(context).scaffoldBackgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const Padding(padding: EdgeInsets.only(top: 20)),

                      TextFormField(
                        controller: _dateController,

                        readOnly: true,

                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Selecione uma data';
                          }

                          return null;
                        },

                        decoration: InputDecoration(
                          labelText: 'Data da Partida',

                          prefixIcon: const Icon(Icons.calendar_month),

                          filled: true,

                          fillColor: Theme.of(context).scaffoldBackgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),

                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,

                            initialDate: selectedDate ?? DateTime.now(),

                            firstDate: DateTime(2025),

                            lastDate: DateTime(2030),
                          );

                          if (pickedDate == null || !mounted) {
                            return;
                          }

                          setState(() {
                            selectedDate = pickedDate;
                            _dateController.text =
                                '${selectedDate?.day.toString().padLeft(2, '0')}/'
                                '${selectedDate?.month.toString().padLeft(2, '0')}/'
                                '${pickedDate.year}';
                          });
                        },
                      ),

                      const Padding(padding: EdgeInsets.only(top: 20)),

                      TextFormField(
                        controller: _stadiumController,

                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o estádio';
                          }

                          return null;
                        },

                        decoration: InputDecoration(
                          labelText: 'Estádio',

                          prefixIcon: const Icon(Icons.stadium),

                          filled: true,

                          fillColor: Theme.of(context).scaffoldBackgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const Padding(padding: EdgeInsets.only(top: 20)),

                      DropdownButtonFormField<String>(
                        initialValue: stage,

                        decoration: InputDecoration(
                          labelText: 'Fase',

                          filled: true,

                          fillColor: Theme.of(context).scaffoldBackgroundColor,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color:
                                  Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.white10
                                  : Colors.black12,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                        ),

                        items: const [
                          DropdownMenuItem(
                            value: 'Fase de Grupos',
                            child: Text('Fase de Grupos'),
                          ),
                          DropdownMenuItem(
                            value: 'Oitavas',
                            child: Text('Oitavas'),
                          ),
                          DropdownMenuItem(
                            value: 'Quartas',
                            child: Text('Quartas'),
                          ),
                          DropdownMenuItem(
                            value: 'Semifinal',
                            child: Text('Semifinal'),
                          ),
                          DropdownMenuItem(
                            value: 'Final',
                            child: Text('Final'),
                          ),
                        ],

                        onChanged: (value) {
                          if (value == null) {
                            return;
                          }

                          setState(() {
                            stage = value;
                          });
                        },
                      ),

                      const Padding(padding: EdgeInsets.only(top: 24)),

                      Container(
                        padding: const EdgeInsets.all(20),

                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF071D3A)
                              : Colors.blue.shade50,

                          borderRadius: BorderRadius.circular(18),

                          border: Border.all(color: Colors.blue.shade300),
                        ),

                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue.shade400,
                            ),

                            const Padding(padding: EdgeInsets.only(left: 12)),

                            Expanded(
                              child: Text(
                                'Após salvar, a classificação da Copa será recalculada automaticamente.',
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const Padding(padding: EdgeInsets.only(top: 24)),

                      Container(
                        height: 65,

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),

                          gradient: const LinearGradient(
                            colors: [
                              Color.fromARGB(255, 139, 228, 139),
                              Color.fromARGB(255, 50, 120, 185),
                            ],
                          ),
                        ),

                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                          ),

                          onPressed: _save,

                          icon: const Icon(Icons.save),

                          label: const Text(
                            'Salvar Resultado',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
