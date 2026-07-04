import 'package:world_cup/app/theme/bloc/theme_bloc.dart';
import 'package:world_cup/app/theme/bloc/theme_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Botão para alternar o tema.
class ThemeToggleButton extends StatelessWidget {
  final double size;
  final double iconSize;

  const ThemeToggleButton({
    super.key,
    this.size = 50,
    this.iconSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        shape: BoxShape.circle,

        border: Border.all(color: isDarkTheme ? Colors.white10 : Colors.black12),
      ),

      child: IconButton(
        tooltip: isDarkTheme ? 'Ativar tema claro' : 'Ativar tema escuro',

        onPressed: () {
          context.read<ThemeBloc>().add(ToggleThemeEvent());
        },

        icon: Icon(
          isDarkTheme ? Icons.light_mode : Icons.dark_mode,
          size: iconSize,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
