import 'package:flutter/material.dart';

// Palette Data Class
class AppPalette {
  final String name;
  final Color primary;
  final Color primaryDark;
  final Color primaryLight;
  final Color accent;
  final LinearGradient primaryGradient;
  final LinearGradient darkGradient;

  const AppPalette({
    required this.name,
    required this.primary,
    required this.primaryDark,
    required this.primaryLight,
    required this.accent,
    required this.primaryGradient,
    required this.darkGradient,
  });
}

// Modern Color Palettes
class AppPalettes {
  static const blue = AppPalette(
    name: 'Blue',
    primary: Color(0xFF2563EB),
    primaryDark: Color(0xFF1D4ED8),
    primaryLight: Color(0xFF3B82F6),
    accent: Color(0xFF0EA5E9),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF2563EB), Color(0xFF0EA5E9)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    darkGradient: LinearGradient(
      colors: [Color(0xFF1E40AF), Color(0xFF0369A1)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const green = AppPalette(
    name: 'Green',
    primary: Color(0xFF10B981),
    primaryDark: Color(0xFF047857),
    primaryLight: Color(0xFF34D399),
    accent: Color(0xFF059669),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF10B981), Color(0xFF34D399)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    darkGradient: LinearGradient(
      colors: [Color(0xFF065F46), Color(0xFF047857)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const purple = AppPalette(
    name: 'Purple',
    primary: Color(0xFF8B5CF6),
    primaryDark: Color(0xFF6D28D9),
    primaryLight: Color(0xFFA78BFA),
    accent: Color(0xFF7C3AED),
    primaryGradient: LinearGradient(
      colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    darkGradient: LinearGradient(
      colors: [Color(0xFF5B21B6), Color(0xFF7C3AED)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const orange = AppPalette(
    name: 'Orange',
    primary: Color(0xFFF97316),
    primaryDark: Color(0xFFC2410C),
    primaryLight: Color(0xFFFB923C),
    accent: Color(0xFFEA580C),
    primaryGradient: LinearGradient(
      colors: [Color(0xFFF97316), Color(0xFFFB923C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    darkGradient: LinearGradient(
      colors: [Color(0xFF9A3412), Color(0xFFEA580C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const rose = AppPalette(
    name: 'Rose',
    primary: Color(0xFFF43F5E),
    primaryDark: Color(0xFFBE123C),
    primaryLight: Color(0xFFFB7185),
    accent: Color(0xFFE11D48),
    primaryGradient: LinearGradient(
      colors: [Color(0xFFF43F5E), Color(0xFFFB7185)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    darkGradient: LinearGradient(
      colors: [Color(0xFF9F1239), Color(0xFFBE123C)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );

  static const List<AppPalette> all = [blue, green, purple, orange, rose];
}

class AppColors {
  // Common Colors
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceDark = Color(0xFF1E293B);
}

class AppTheme {
  static ThemeData createTheme(bool isDark, AppPalette palette) {
    if (isDark) {
      return _createDarkTheme(palette);
    } else {
      return _createLightTheme(palette);
    }
  }

  static ThemeData _createLightTheme(AppPalette palette) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: Brightness.light,
        primary: palette.primary,
        secondary: palette.accent,
        surface: AppColors.surfaceLight,
        background: AppColors.backgroundLight,
      ),
      scaffoldBackgroundColor: AppColors.backgroundLight,

      appBarTheme: AppBarTheme(
        backgroundColor: palette.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 2,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
          letterSpacing: 0.5,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: Colors.white,
        surfaceTintColor: Colors.transparent,
        shadowColor: palette.primary.withOpacity(0.1),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primary,
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

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primary,
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

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: palette.primary, width: 1.5),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: palette.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

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
          borderSide: BorderSide(color: palette.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: palette.primary,
        unselectedItemColor: Colors.grey,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      chipTheme: ChipThemeData(
        backgroundColor: palette.primary.withOpacity(0.1),
        labelStyle: TextStyle(color: palette.primary, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      dividerTheme: DividerThemeData(color: Colors.grey.shade200, thickness: 1),

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

      iconTheme: IconThemeData(color: palette.primary, size: 24),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.primary,
        linearTrackColor: const Color(0xFFE2E8F0),
      ),
    );
  }

  static ThemeData _createDarkTheme(AppPalette palette) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: palette.primary,
        brightness: Brightness.dark,
        primary: palette.primaryLight,
        secondary: palette.accent,
        surface: AppColors.surfaceDark,
        background: AppColors.backgroundDark,
      ),
      scaffoldBackgroundColor: AppColors.backgroundDark,

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

      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        color: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: palette.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: palette.primaryLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: palette.accent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          side: BorderSide(color: palette.accent, width: 1.5),
        ),
      ),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: palette.primaryLight,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),

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
          borderSide: BorderSide(color: palette.accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),

      chipTheme: ChipThemeData(
        backgroundColor: palette.primaryLight.withOpacity(0.2),
        labelStyle: TextStyle(color: palette.accent, fontSize: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      dividerTheme: const DividerThemeData(color: Color(0xFF334155), thickness: 1),

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

      iconTheme: IconThemeData(color: palette.accent, size: 24),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: palette.accent,
        linearTrackColor: const Color(0xFF334155),
      ),
    );
  }
}
