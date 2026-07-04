
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_cup/core/constants/available_flags.dart';
import 'package:world_cup/core/widgets/theme_toggle_button.dart';
import 'package:world_cup/features/teams/bloc/team_bloc.dart';
import 'package:world_cup/features/teams/bloc/team_event.dart';


class NewTeamScreen extends StatefulWidget {
  const NewTeamScreen({super.key});

  @override
  State<NewTeamScreen> createState() => _NewTeamScreenState();
}

// Mantém os controladores e a lógica do formulário de cadastro de seleção.
class _NewTeamScreenState extends State<NewTeamScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();

  final _coachController = TextEditingController();

  String selectedGroup = 'Grupo A';

  String selectedFlag = availableFlags['Brasil']!;

  // Libera os controladores de texto usados pelo formulário.
  @override
  void dispose() {
    _nameController.dispose();
    _coachController.dispose();

    super.dispose();
  }

  // Abre a lista de bandeiras disponíveis para seleção.
  Future<void> _openFlagPicker() async {
    final newFlag = await showModalBottomSheet<String>(
      context: context,

      backgroundColor: Theme.of(context).cardColor,

      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),

      builder: (modalContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                Text(
                  'Escolha uma bandeira',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(modalContext).colorScheme.onSurface,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 16)),

                ...availableFlags.entries.map((item) {
                  final flagName = item.key;
                  final flagPath = item.value;

                  return ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: AssetImage(flagPath),
                    ),

                    title: Text(
                      flagName,
                      style: TextStyle(
                        color: Theme.of(modalContext).colorScheme.onSurface,
                      ),
                    ),

                    trailing: flagPath == selectedFlag
                        ? Icon(
                            Icons.check_circle,
                            color: Theme.of(modalContext).colorScheme.primary,
                          )
                        : null,

                    onTap: () {
                      Navigator.pop(modalContext, flagPath);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );

    if (newFlag == null || !mounted) {
      return;
    }

    setState(() {
      selectedFlag = newFlag;
    });
  }

  // Valida os dados preenchidos e solicita o cadastro da seleção.
  void _save() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    context.read<TeamBloc>().add(
      AddTeamEvent(
        name: _nameController.text,
        coach: _coachController.text,
        group: selectedGroup,
        flag: selectedFlag,
      ),
    );

    Navigator.pop(context);
  }

  // Constrói o formulário de cadastro de seleção.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nova Seleção',
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
          Text(
            'Cadastre uma nova seleção para a Copa do Mundo 2026.',
            style: TextStyle(
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const Padding(padding: EdgeInsets.only(top: 20)),

          Container(
            padding: const EdgeInsets.all(24),

            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(28),
              border: Theme.of(context).brightness == Brightness.light
                  ? Border.all(color: const Color(0xFFD1D5DB))
                  : Border.all(color: Colors.white10),
            ),

            child: Form(
              key: _formKey,

              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,

                    children: [
                      Container(
                        width: 180,
                        height: 180,

                        decoration: BoxDecoration(
                          shape: BoxShape.circle,

                          border: Border.all(
                            color: const Color(0xFF89E089),
                            width: 5,
                          ),
                        ),

                        child: CircleAvatar(
                          radius: 52,
                          backgroundImage: AssetImage(selectedFlag),
                        ),
                      ),

                      Positioned(
                        right: 10,
                        bottom: 15,

                        child: Container(
                          width: 48,
                          height: 48,

                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            shape: BoxShape.circle,
                          ),

                          child: IconButton(
                            onPressed: _openFlagPicker,
                            icon: const Icon(Icons.edit),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 16),

                    child: Text(
                      'BANDEIRA DA SELEÇÃO',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 32)),

                  TextFormField(
                    controller: _nameController,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o nome da seleção';
                      }

                      return null;
                    },

                    decoration: InputDecoration(
                      labelText: 'Nome da Seleção',

                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,

                      prefixIcon: const Icon(Icons.flag),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  DropdownButtonFormField<String>(
                    initialValue: selectedGroup,

                    decoration: InputDecoration(
                      labelText: 'Grupo',

                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),

                    items: const [
                      DropdownMenuItem(
                        value: 'Grupo A',
                        child: Text('Grupo A'),
                      ),

                      DropdownMenuItem(
                        value: 'Grupo B',
                        child: Text('Grupo B'),
                      ),

                      DropdownMenuItem(
                        value: 'Grupo C',
                        child: Text('Grupo C'),
                      ),

                      DropdownMenuItem(
                        value: 'Grupo D',
                        child: Text('Grupo D'),
                      ),

                      DropdownMenuItem(
                        value: 'Grupo E',
                        child: Text('Grupo E'),
                      ),

                      DropdownMenuItem(
                        value: 'Grupo F',
                        child: Text('Grupo F'),
                      ),

                      DropdownMenuItem(
                        value: 'Grupo G',
                        child: Text('Grupo G'),
                      ),

                      DropdownMenuItem(
                        value: 'Grupo H',
                        child: Text('Grupo H'),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        selectedGroup = value!;
                      });
                    },
                  ),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  TextFormField(
                    controller: _coachController,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o técnico';
                      }

                      return null;
                    },

                    decoration: InputDecoration(
                      labelText: 'Técnico',

                      prefixIcon: const Icon(Icons.person),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 24)),

                  Container(
                    padding: const EdgeInsets.all(20),

                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF071D3A)
                          : const Color(0xFFF3F7FC),
                      borderRadius: BorderRadius.circular(18),

                      border: Border.all(color: Colors.blue.shade300),
                    ),

                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.primary,
                        ),

                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(left: 12),

                            child: Text(
                              'Após cadastrar a seleção, ela ficará disponível para ser utilizada nas partidas da Copa.',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
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
                        colors: [Color(0xFF89E089), Color(0xFF46A6FF)],
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
                        'Cadastrar Seleção',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
