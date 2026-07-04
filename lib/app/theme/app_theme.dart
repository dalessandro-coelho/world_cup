import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: const Color(0xFFF5F7FA),

    cardColor: Colors.white,

    colorScheme: ColorScheme.light(
      primary: const Color(0xFF2563EB),
      secondary: const Color(0xFF22C55E),
    ),

    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: const Color(0xFF0F172A),

    cardColor: const Color(0xFF102542),

    colorScheme: ColorScheme.dark(
      primary: const Color(0xFF46A6FF),
      secondary: const Color(0xFF89E089),
    ),

    useMaterial3: true,
  );
}
