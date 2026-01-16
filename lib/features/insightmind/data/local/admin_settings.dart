import 'package:hive/hive.dart';

part 'admin_settings.g.dart';

@HiveType(typeId: 6)
class AdminSettings extends HiveObject {
  @HiveField(0)
  final String broadcastMessage;

  @HiveField(1)
  final String lowRiskRecommendation;

  @HiveField(2)
  final String mediumRiskRecommendation;

  @HiveField(3)
  final String highRiskRecommendation;

  AdminSettings({
    this.broadcastMessage = 'Selamat datang di InsightMind! Jaga kesehatan mental Anda.',
    this.lowRiskRecommendation = 'Pertahankan kebiasaan baik Anda! Tetap jaga pola tidur, makan sehat, dan olahraga teratur.',
    this.mediumRiskRecommendation = 'Kurangi beban, istirahat cukup, dan pertimbangkan untuk menghubungi layanan konseling kampus.',
    this.highRiskRecommendation = 'Pertimbangkan untuk berbicara dengan konselor atau psikolog profesional. Kesehatan mental Anda sangat penting.',
  });

  AdminSettings copyWith({
    String? broadcastMessage,
    String? lowRiskRecommendation,
    String? mediumRiskRecommendation,
    String? highRiskRecommendation,
  }) {
    return AdminSettings(
      broadcastMessage: broadcastMessage ?? this.broadcastMessage,
      lowRiskRecommendation: lowRiskRecommendation ?? this.lowRiskRecommendation,
      mediumRiskRecommendation: mediumRiskRecommendation ?? this.mediumRiskRecommendation,
      highRiskRecommendation: highRiskRecommendation ?? this.highRiskRecommendation,
    );
  }
}
