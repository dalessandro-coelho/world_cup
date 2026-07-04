import 'package:world_cup/database/app_database.dart';
import 'package:world_cup/core/widgets/theme_toggle_button.dart';
import 'package:world_cup/features/matches/bloc/match_bloc.dart';
import 'package:world_cup/features/matches/bloc/match_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditMatchScreen extends StatefulWidget {
  final MatchWithTeams matchData;

  const EditMatchScreen({super.key, required this.matchData});

  @override
  State<EditMatchScreen> createState() => _EditMatchScreenState();
}

// Mantém os controladores e a lógica do formulário de edição de partida.
class _EditMatchScreenState extends State<EditMatchScreen> {
  late final TextEditingController _homeGoalsController;
  late final TextEditingController _awayGoalsController;
  late final TextEditingController _stadiumController;
  late final TextEditingController _dateController;

  late DateTime selectedDate;

  late String stage;

  // Inicializa os campos do formulário com os dados da partida recebida.
  @override
  void initState() {
    super.initState();

    final match = widget.matchData.match;

    _homeGoalsController = TextEditingController(
      text: match.homeTeamGoals.toString(),
    );

    _awayGoalsController = TextEditingController(
      text: match.awayTeamGoals.toString(),
    );

    _stadiumController = TextEditingController(text: match.stadium);

    selectedDate = match.date;

    _dateController = TextEditingController(
      text: _formatDate(selectedDate),
    );

    stage = match.stage;
  }

  // Libera os controladores de texto usados pelo formulário.
  @override
  void dispose() {
    _homeGoalsController.dispose();
    _awayGoalsController.dispose();
    _stadiumController.dispose();
    _dateController.dispose();

    super.dispose();
  }

  // Valida os dados alterados e solicita a atualização da partida.
  void _save() {
    final homeTeamGoals = int.tryParse(_homeGoalsController.text);

    final awayTeamGoals = int.tryParse(_awayGoalsController.text);

    if (homeTeamGoals == null ||
        awayTeamGoals == null ||
        homeTeamGoals < 0 ||
        awayTeamGoals < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe placares válidos.')),
      );

      return;
    }

    if (_stadiumController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Informe o estádio da partida.')),
      );

      return;
    }

    final match = widget.matchData.match;



    context.read<MatchBloc>().add(
      UpdateMatchEvent(
        id: match.id,
        homeTeamId: match.homeTeamId,
        awayTeamId: match.awayTeamId,
        homeTeamGoals: homeTeamGoals,
        awayTeamGoals: awayTeamGoals,
        date: selectedDate,
        stadium: _stadiumController.text.trim(),
        stage: stage,
      ),
    );

    Navigator.pop(context);
  }
  


  // Constrói o formulário de edição da partida.
  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white10
        : Colors.black12;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),

        title: const Text(
          'Editar Partida',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),

            child: const ThemeToggleButton(),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          Container(
            height: 220,

            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),

              image: const DecorationImage(
                image: AssetImage('assets/imagens/estadio.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const Padding(padding: EdgeInsets.only(top: 24)),

          Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: borderColor),
            ),

            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    widget.matchData.homeTeam.flag,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 8)),

                Text(
                  widget.matchData.homeTeam.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 16)),

                TextFormField(
                  controller: _homeGoalsController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 16)),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),

                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: const Text(
                    'VS',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 16)),

                TextFormField(
                  controller: _awayGoalsController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 16)),

                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                    widget.matchData.awayTeam.flag,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 8)),

                Text(
                  widget.matchData.awayTeam.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 24)),

                TextFormField(
                  controller: _dateController,
                  readOnly: true,

                  decoration: InputDecoration(
                    labelText: 'Data da Partida',
                    suffixIcon: const Icon(Icons.calendar_month),

                    filled: true,
                    fillColor: Theme.of(context).scaffoldBackgroundColor,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),

                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),

                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2025),
                      lastDate: DateTime(2030),
                    );

                    if (pickedDate == null || !mounted) {
                      return;
                    }

                    setState(() {
                      selectedDate = pickedDate;

                      _dateController.text = _formatDate(pickedDate);
                    });
                  },
                ),

                const Padding(padding: EdgeInsets.only(top: 20)),

                TextFormField(
                  controller: _stadiumController,

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
                      borderSide: BorderSide(color: borderColor),
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
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),

                  items: const [
                    DropdownMenuItem(
                      value: 'Fase de Grupos',
                      child: Text('Fase de Grupos'),
                    ),

                    DropdownMenuItem(value: 'Oitavas', child: Text('Oitavas')),

                    DropdownMenuItem(value: 'Quartas', child: Text('Quartas')),

                    DropdownMenuItem(
                      value: 'Semifinal',
                      child: Text('Semifinal'),
                    ),

                    DropdownMenuItem(value: 'Final', child: Text('Final')),
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
                'Salvar Alterações',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          const Padding(padding: EdgeInsets.only(top: 16)),

          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },

            child: const Text(
              'DESCARTAR',
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Formata uma data para o padrão dia/mês/ano exibido na interface.
  String _formatDate(DateTime date) {
    final dayText = date.day.toString().padLeft(2, '0');
    final monthText = date.month.toString().padLeft(2, '0');
    final yearText = date.year;

    return '$dayText/$monthText/$yearText';
  }
}
