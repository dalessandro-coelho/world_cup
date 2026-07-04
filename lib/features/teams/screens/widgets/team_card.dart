import 'package:flutter/material.dart';

// Apresenta as principais informações de uma seleção em um card.
class TeamCard extends StatelessWidget {
  final String name;
  final String coach;
  final String group;
  final String flag;
  final VoidCallback onEdit;

  const TeamCard({
    super.key,
    required this.name,
    required this.coach,
    required this.group,
    required this.flag,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),

        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white10
              : Colors.black12,
        ),
      ),

      child: Row(
        children: [
          CircleAvatar(radius: 32, backgroundImage: AssetImage(flag)),

          const Padding(padding: EdgeInsets.only(left: 16)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 6)),

                Text(
                  group,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Padding(padding: EdgeInsets.only(top: 12)),

                Row(
                  children: [
                    Icon(
                      Icons.person,
                      size: 20,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),

                    const Padding(padding: EdgeInsets.only(left: 8)),

                    Expanded(
                      child: Text(
                        coach,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          IconButton(
            onPressed: onEdit,

            icon: Icon(Icons.edit, color: Colors.amber.shade700),
          ),
        ],
      ),
    );
  }
}
