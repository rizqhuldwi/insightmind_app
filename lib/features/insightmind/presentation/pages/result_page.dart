import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pam_teori/features/insightmind/presentation/providers/history_provider.dart';
import 'dart:convert';
import '../../../../src/app_themes.dart';
import '../providers/score_provider.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/admin_settings_provider.dart';

class ResultPage extends ConsumerStatefulWidget {
  const ResultPage({super.key});

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  bool _saved = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_saved) {
      final result = ref.read(resultProvider);
      final qState = ref.read(questionnaireProvider);
      final repo = ref.read(historyRepositoryProvider);
      final authState = ref.read(authNotifierProvider);

      final answersJson = jsonEncode(qState.answers);

      repo
          .addRecord(
            score: result.score,
            riskLevel: result.riskLevel,
            note: null,
            answersJson: answersJson,
            userId: authState.user?.id,
          )
          .then((_) {
            if (mounted) {
              ref.invalidate(historyListProvider);
            }
          });
      _saved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(resultProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final settings = ref.watch(adminSettingsProvider);

    String recommendation;
    IconData riskIcon;
    Color riskColor;
    String riskEmoji;

    switch (result.riskLevel) {
      case 'Tinggi':
        recommendation = settings.highRiskRecommendation;
        riskIcon = Icons.warning_rounded;
        riskColor = const Color(0xFFEF4444);
        riskEmoji = '😟';
        break;
      case 'Sedang':
        recommendation = settings.mediumRiskRecommendation;
        riskIcon = Icons.info_rounded;
        riskColor = const Color(0xFFF59E0B);
        riskEmoji = '😐';
        break;
      default:
        recommendation = settings.lowRiskRecommendation;
        riskIcon = Icons.check_circle_rounded;
        riskColor = const Color(0xFF10B981);
        riskEmoji = '😊';
        break;
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Expanded(
                      child: Text(
                        'Hasil Screening',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Result Card
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Emoji
                      Text(riskEmoji, style: const TextStyle(fontSize: 80)),
                      const SizedBox(height: 24),

                      // Score Circle
                      Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              riskColor.withOpacity(0.2),
                              riskColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(color: riskColor, width: 4),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${result.score}',
                              style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: riskColor,
                              ),
                            ),
                            Text(
                              'Skor',
                              style: TextStyle(
                                fontSize: 14,
                                color: isDark
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Risk Level Badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: riskColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(color: riskColor.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(riskIcon, color: riskColor, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              'Risiko ${result.riskLevel}',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: riskColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Recommendation
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF334155)
                              : Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: AppColors.primaryBlue,
                              size: 28,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              recommendation,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                height: 1.5,
                                color: isDark
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Saved info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            size: 16,
                            color: AppColors.primaryBlue,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Hasil telah disimpan ke riwayat',
                            style: TextStyle(
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                              color: isDark
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Back Button
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.home_rounded),
                          label: const Text('Kembali ke Beranda'),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
