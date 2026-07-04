import 'package:world_cup/app/theme/bloc/theme_state.dart';
import 'package:world_cup/app/theme/bloc/theme_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(themeMode: ThemeMode.dark)) {
    on<ToggleThemeEvent>(_toggleTheme);
  }

  void _toggleTheme(ToggleThemeEvent event, Emitter<ThemeState> emit) {
    emit(
      ThemeState(
        themeMode: state.themeMode == ThemeMode.dark
            ? ThemeMode.light
            : ThemeMode.dark,
      ),
    );
  }
}
