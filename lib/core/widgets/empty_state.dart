import 'package:flutter/material.dart';

// Mostra uma mensagem na tela quando não existe dados pra apresentar.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final darkTheme = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),

        border: Border.all(color: darkTheme ? Colors.white10 : Colors.black12),
      ),

      child: Column(
        children: [
          Icon(icon, size: 48, color: Theme.of(context).colorScheme.primary),

          const Padding(padding: EdgeInsets.only(top: 14)),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),

          const Padding(padding: EdgeInsets.only(top: 8)),

          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
