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
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return RotationTransition(
            turns: animation,
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        child: Icon(
          isDark ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(isDark),
        ),
      ),
      tooltip: isDark ? 'Light Mode' : 'Dark Mode',
      onPressed: () {
        ref.read(themeProvider.notifier).toggleTheme();
      },
    );
  }
}
