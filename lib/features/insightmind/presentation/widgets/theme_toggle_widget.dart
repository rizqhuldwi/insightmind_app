import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

/// Theme toggle button widget
class ThemeToggleWidget extends ConsumerWidget {
  const ThemeToggleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return IconButton(
      key: UniqueKey(),
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: Colors.white,
      ),
      tooltip: isDark ? 'Light Mode' : 'Dark Mode',
      onPressed: () {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }
}
