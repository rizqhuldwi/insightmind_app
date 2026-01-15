import 'package:flutter/material.dart';

/// Light Theme Configuration
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF7F8FC),
  
  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 2,
  ),
  
  // Card Theme
  cardTheme: CardThemeData(
    elevation: 2,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  
  // Button Themes
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  ),
  
  // Text Theme
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    titleLarge: TextStyle(fontWeight: FontWeight.bold),
  ),
);

/// Dark Theme Configuration
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.indigo,
    brightness: Brightness.dark,
  ),
  scaffoldBackgroundColor: const Color(0xFF121212),
  
  // AppBar Theme
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.indigo.shade800,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 2,
  ),
  
  // Card Theme
  cardTheme: CardThemeData(
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  
  // Button Themes
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.indigo.shade700,
      foregroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  ),
  
  // Text Theme
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14),
    titleLarge: TextStyle(fontWeight: FontWeight.bold),
  ),
);
