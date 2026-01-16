import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../src/app_themes.dart';

class ThemeSettings {
  final ThemeMode mode;
  final int colorIndex;

  const ThemeSettings({
    this.mode = ThemeMode.light,
    this.colorIndex = 0,
  });

  AppPalette get palette => AppPalettes.all[colorIndex];
  
  ThemeSettings copyWith({ThemeMode? mode, int? colorIndex}) {
    return ThemeSettings(
      mode: mode ?? this.mode,
      colorIndex: colorIndex ?? this.colorIndex,
    );
  }
}

/// Provider for theme management
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeSettings>((ref) {
  return ThemeNotifier();
});

/// Theme Notifier to manage theme state with persistence
class ThemeNotifier extends StateNotifier<ThemeSettings> {
  static const String _themeModeKey = 'theme_mode';
  static const String _themeColorKey = 'theme_color_index';
  
  ThemeNotifier() : super(const ThemeSettings()) {
    _loadTheme();
  }

  /// Load saved theme preference from SharedPreferences
  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString(_themeModeKey);
    final colorIndex = prefs.getInt(_themeColorKey) ?? 0;
    
    ThemeMode mode = ThemeMode.light;
    if (themeModeString != null) {
      mode = ThemeMode.values.firstWhere(
        (m) => m.toString() == themeModeString,
        orElse: () => ThemeMode.light,
      );
    }
    
    state = ThemeSettings(mode: mode, colorIndex: colorIndex);
  }

  /// Save theme preference to SharedPreferences
  Future<void> _saveTheme(ThemeSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeModeKey, settings.mode.toString());
    await prefs.setInt(_themeColorKey, settings.colorIndex);
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = state.mode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(mode: newMode);
    await _saveTheme(state);
  }

  /// Set specific color palette
  Future<void> setColor(int index) async {
    if (index >= 0 && index < AppPalettes.all.length) {
      state = state.copyWith(colorIndex: index);
      await _saveTheme(state);
    }
  }

  /// Check if current theme is dark
  bool get isDark => state.mode == ThemeMode.dark;
}
