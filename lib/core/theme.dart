import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const indigo = Color(0xFF24106A);
  static const violet = Color(0xFF5B35C8);
  static const coral = Color(0xFFFF7658);
  static const gold = Color(0xFFFFC857);
  static const canvas = Color(0xFFF8F6FC);

  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: violet,
      brightness: Brightness.light,
      primary: indigo,
      secondary: coral,
      tertiary: gold,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: canvas,
      textTheme: const TextTheme(
        displaySmall: TextStyle(fontWeight: FontWeight.w800, height: 1.2),
        headlineSmall: TextStyle(fontWeight: FontWeight.w800, height: 1.25),
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontWeight: FontWeight.w700),
        bodyLarge: TextStyle(height: 1.55),
        bodyMedium: TextStyle(height: 1.5),
      ),
      cardTheme: const CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: Color(0xFFE7E0F4)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          borderSide: BorderSide(color: violet, width: 2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        height: 72,
        elevation: 0,
        backgroundColor: Colors.white,
        indicatorColor: Color(0xFFE9E1FF),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
    );
  }
}
