import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../src/app_themes.dart';
import '../providers/theme_provider.dart';

class ColorSelectionWidget extends ConsumerWidget {
  const ColorSelectionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeSettings = ref.watch(themeProvider);
    final isDark = themeSettings.mode == ThemeMode.dark;

    return IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => _ColorPickerDialog(
            currentIndex: themeSettings.colorIndex,
            isDark: isDark,
          ),
        );
      },
      icon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: const Icon(
          Icons.palette_rounded,
          color: Colors.white,
          size: 24,
        ),
      ),
      tooltip: 'Ganti Warna Tema',
    );
  }
}

class _ColorPickerDialog extends ConsumerWidget {
  final int currentIndex;
  final bool isDark;

  const _ColorPickerDialog({
    required this.currentIndex,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pilih Warna Tema',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: List.generate(AppPalettes.all.length, (index) {
                final palette = AppPalettes.all[index];
                final isSelected = index == currentIndex;

                return GestureDetector(
                  onTap: () {
                    ref.read(themeProvider.notifier).setColor(index);
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: isDark
                          ? palette.darkGradient
                          : palette.primaryGradient,
                      border: isSelected
                          ? Border.all(
                              color: isDark ? Colors.white : Colors.black,
                              width: 3,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: palette.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : null,
                  ),
                );
              }),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
      ),
    );
  }
}
