import 'package:flutter/material.dart';

// Modern Blue Color Palette
class AppColors {
  // Primary Blues
  static const Color primaryBlue = Color(0xFF2563EB);
  static const Color primaryBlueDark = Color(0xFF1D4ED8);
  static const Color primaryBlueLight = Color(0xFF3B82F6);

  // Accent Blues
  static const Color accentBlue = Color(0xFF0EA5E9);
  static const Color skyBlue = Color(0xFF38BDF8);

  // Background Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1E40AF), Color(0xFF0369A1)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

/// Light Theme Configuration - Modern & Elegant Blue
final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    brightness: Brightness.light,
    primary: AppColors.primaryBlue,
    secondary: AppColors.accentBlue,
    surface: AppColors.surfaceLight,
    background: AppColors.backgroundLight,
  ),
  scaffoldBackgroundColor: AppColors.backgroundLight,

  // AppBar Theme - Modern Gradient Look
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 2,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.5,
    ),
  ),

  // Card Theme - Soft Shadow & Rounded
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: Colors.white,
    surfaceTintColor: Colors.transparent,
    shadowColor: AppColors.primaryBlue.withOpacity(0.1),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Filled Button Theme
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      side: const BorderSide(color: AppColors.primaryBlue, width: 1.5),
    ),
  ),

  // Text Button Theme
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      textStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey.shade50,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: Colors.grey.shade200),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.primaryBlue, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),

  // Bottom Navigation Bar Theme
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.white,
    selectedItemColor: AppColors.primaryBlue,
    unselectedItemColor: Colors.grey,
    elevation: 8,
    type: BottomNavigationBarType.fixed,
  ),

  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
    labelStyle: const TextStyle(color: AppColors.primaryBlue, fontSize: 12),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),

  // Text Theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E293B),
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF1E293B),
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Color(0xFF1E293B),
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1E293B),
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Color(0xFF1E293B),
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF334155),
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF475569)),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
    bodySmall: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
  ),

  // Icon Theme
  iconTheme: const IconThemeData(color: AppColors.primaryBlue, size: 24),

  // Progress Indicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.primaryBlue,
    linearTrackColor: Color(0xFFE2E8F0),
  ),
);

/// Dark Theme Configuration - Modern & Elegant Blue
final ThemeData darkTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primaryBlue,
    brightness: Brightness.dark,
    primary: AppColors.primaryBlueLight,
    secondary: AppColors.skyBlue,
    surface: AppColors.surfaceDark,
    background: AppColors.backgroundDark,
  ),
  scaffoldBackgroundColor: AppColors.backgroundDark,

  // AppBar Theme
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF1E293B),
    foregroundColor: Colors.white,
    centerTitle: true,
    elevation: 0,
    scrolledUnderElevation: 2,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
      letterSpacing: 0.5,
    ),
  ),

  // Card Theme
  cardTheme: CardThemeData(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    color: AppColors.surfaceDark,
    surfaceTintColor: Colors.transparent,
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlueLight,
      foregroundColor: Colors.white,
      elevation: 0,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),

  // Filled Button Theme
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.primaryBlueLight,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  ),

  // Outlined Button Theme
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.skyBlue,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      side: const BorderSide(color: AppColors.skyBlue, width: 1.5),
    ),
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryBlueLight,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0xFF334155),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF475569)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.skyBlue, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),

  // Chip Theme
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.primaryBlueLight.withOpacity(0.2),
    labelStyle: const TextStyle(color: AppColors.skyBlue, fontSize: 12),
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  ),

  // Divider Theme
  dividerTheme: const DividerThemeData(color: Color(0xFF334155), thickness: 1),

  // Text Theme
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      color: Colors.white,
      letterSpacing: -0.5,
    ),
    displayMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    headlineLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    headlineMedium: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFFCBD5E1),
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF94A3B8)),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF94A3B8)),
    bodySmall: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
  ),

  // Icon Theme
  iconTheme: const IconThemeData(color: AppColors.skyBlue, size: 24),

  // Progress Indicator Theme
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.skyBlue,
    linearTrackColor: Color(0xFF334155),
  ),
);
