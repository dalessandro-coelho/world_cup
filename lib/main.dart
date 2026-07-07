import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:world_cup/app/theme/app_theme.dart';
import 'package:world_cup/app/theme/bloc/theme_bloc.dart';
import 'package:world_cup/app/theme/bloc/theme_state.dart';
import 'package:world_cup/database/app_database.dart';
import 'package:world_cup/features/matches/bloc/match_bloc.dart';
import 'package:world_cup/features/matches/bloc/match_event.dart';
import 'package:world_cup/features/standings/bloc/standings_bloc.dart';
import 'package:world_cup/features/standings/bloc/standings_event.dart';
import 'package:world_cup/features/teams/bloc/team_bloc.dart';
import 'package:world_cup/features/teams/bloc/team_event.dart';
import 'package:world_cup/navigation/app_navigation_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final database = AppDatabase();

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (_, database) {
            database.close();
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeBloc()),
          BlocProvider(
            create: (context) =>
                TeamBloc(context.read<AppDatabase>())
                  ..add(const StartTeamsObservationEvent()),
          ),
          BlocProvider(
            create: (context) =>
                MatchBloc(context.read<AppDatabase>())
                  ..add(const StartMatchesObservationEvent()),
          ),
          BlocProvider(
            create: (context) =>
                StandingsBloc(context.read<AppDatabase>())
                  ..add(const StartStandingsObservationEvent()),
          ),
        ],
        child: const WorldCupApp(),
      ),
    ),
  );
}

class WorldCupApp extends StatelessWidget {
  const WorldCupApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,

          title: 'Copa do Mundo da FIFA 2026™',

          theme: AppTheme.lightTheme,

          darkTheme: AppTheme.darkTheme,

          themeMode: state.themeMode,

          home: const AppNavigationBar(),
        );
      },
    );
  }
}
