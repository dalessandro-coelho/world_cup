
import 'package:flutter/material.dart';
import 'package:world_cup/features/matches/screens/matches_screen.dart';
import 'package:world_cup/features/standings/screen/standings_screen.dart';
import 'package:world_cup/features/teams/screens/teams_screen.dart';

class AppNavigationBar extends StatefulWidget {
  const AppNavigationBar({super.key});

  @override
  State<AppNavigationBar> createState() => _AppNavigationBarState();
}

class _AppNavigationBarState extends State<AppNavigationBar> {
  int currentIndex = 0;

  final screens = const [StandingsScreen(), TeamsScreen(), MatchesScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],

      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,

        onDestinationSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Classificação',
          ),

          NavigationDestination(
            icon: Icon(Icons.public),
            selectedIcon: Icon(Icons.public),
            label: 'Seleções',
          ),

          NavigationDestination(
            icon: Icon(Icons.sports_soccer_outlined),
            selectedIcon: Icon(Icons.sports_soccer),
            label: 'Partidas',
          ),
        ],
      ),
    );
  }
}
