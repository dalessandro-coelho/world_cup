
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:world_cup/core/constants/available_flags.dart';
import 'package:world_cup/core/widgets/theme_toggle_button.dart';
import 'package:world_cup/database/app_database.dart';
import 'package:world_cup/features/teams/bloc/team_bloc.dart';
import 'package:world_cup/features/teams/bloc/team_event.dart';


class EditTeamScreen extends StatefulWidget {
  final Team team;

  const EditTeamScreen({super.key, required this.team});

  @override
  State<EditTeamScreen> createState() => _EditTeamScreenState();
}

// Mantém os controladores e a lógica do formulário de edição de seleção.
class _EditTeamScreenState extends State<EditTeamScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _coachController;

  late String selectedGroup;
  late String selectedFlag;

  // Inicializa os campos do formulário com os dados da seleção recebida.
  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.team.name);

    _coachController = TextEditingController(text: widget.team.coach);

    selectedGroup = widget.team.group;

    selectedFlag = widget.team.flag;
  }

  // Libera os controladores de texto usados pelo formulário.
  @override
  void dispose() {
    _nameController.dispose();
    _coachController.dispose();

    super.dispose();
  }

  // Valida os dados preenchidos e solicita a atualização da seleção.
  void _save() {
    final isFormValid = _formKey.currentState?.validate() ?? false;

    if (!isFormValid) {
      return;
    }

    context.read<TeamBloc>().add(
      UpdateTeamEvent(
        id: widget.team.id,
        name: _nameController.text,
        coach: _coachController.text,
        group: selectedGroup,
        flag: selectedFlag,
      ),
    );

    Navigator.pop(context);
  }

  // Solicita confirmação antes de remover a seleção.
  Future<void> _confirmDeletion() async {
    final teamBloc = context.read<TeamBloc>();

    final relatedMatchesCount = await teamBloc.countRelatedMatches(
      widget.team.id,
    );

    if (!mounted) {
      return;
    }

    if (relatedMatchesCount > 0) {
      final matchesText = relatedMatchesCount == 1
          ? '1 partida cadastrada'
          : '$relatedMatchesCount partidas cadastradas';

      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Não é possível remover'),

            content: Text(
              'A seleção "${widget.team.name}" possui $matchesText. '
              'Remova primeiro as partidas relacionadas antes de excluir a seleção.',
              style: TextStyle(
                color: Theme.of(dialogContext).colorScheme.onSurface,
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('ENTENDI'),
              ),
            ],
          );
        },
      );

      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Remover seleção?'),

          content: Text(
            'A seleção "${widget.team.name}" será removida permanentemente.',
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

    if (confirm != true || !mounted) {
      return;
    }

    teamBloc.add(DeleteTeamEvent(widget.team.id));

    Navigator.pop(context);
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

  // Constrói o formulário de edição da seleção.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Editar Seleção',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
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

                  // Bandeira
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
                          radius: 40,
                          backgroundImage: AssetImage(selectedFlag),
                        ),
                      ),

                      Positioned(
                        right: 10,
                        bottom: 15,

                        child: FloatingActionButton.small(
                          onPressed: _openFlagPicker,
                          child: const Icon(Icons.edit),
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

                  // Nome
                  TextFormField(
                    controller: _nameController,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o nome da seleção';
                      }

                      return null;
                    },

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      prefixIcon: const Icon(Icons.flag),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  // Grupo
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GRUPO',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 8),

                        child: DropdownButtonFormField<String>(
                          initialValue: selectedGroup,

                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(
                              context,
                            ).scaffoldBackgroundColor,
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
                          ],

                          onChanged: (value) {
                            setState(() {
                              selectedGroup = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const Padding(padding: EdgeInsets.only(top: 20)),

                  // Técnico
                  TextFormField(
                    controller: _coachController,

                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Informe o técnico';
                      }

                      return null;
                    },

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).scaffoldBackgroundColor,
                      prefixIcon: const Icon(Icons.person),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const Padding(padding: EdgeInsets.only(top: 24)),

                  // Card informativo
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
                              'Ao salvar as alterações, as estatísticas e confrontos serão atualizados em tempo real em todos os painéis da Copa 2026.',
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

                  // Botão salvar
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
                        'Salvar Alterações',
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
          Padding(
            padding: const EdgeInsets.only(top: 16),

            child: TextButton.icon(
              onPressed: _confirmDeletion,

              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),

              label: const Text(
                'REMOVER SELEÇÃO',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
