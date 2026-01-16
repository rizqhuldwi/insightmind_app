import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/admin_settings_repository.dart';
import '../../data/local/admin_settings.dart';

final adminSettingsRepositoryProvider = Provider<AdminSettingsRepository>((ref) {
  return AdminSettingsRepository();
});

final adminSettingsProvider = StateNotifierProvider<AdminSettingsNotifier, AdminSettings>((ref) {
  final repo = ref.read(adminSettingsRepositoryProvider);
  return AdminSettingsNotifier(repo);
});

class AdminSettingsNotifier extends StateNotifier<AdminSettings> {
  final AdminSettingsRepository _repo;

  AdminSettingsNotifier(this._repo) : super(AdminSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = await _repo.getSettings();
  }

  Future<void> updateSettings({
    String? broadcastMessage,
    String? lowRiskRecommendation,
    String? mediumRiskRecommendation,
    String? highRiskRecommendation,
  }) async {
    final newSettings = state.copyWith(
      broadcastMessage: broadcastMessage,
      lowRiskRecommendation: lowRiskRecommendation,
      mediumRiskRecommendation: mediumRiskRecommendation,
      highRiskRecommendation: highRiskRecommendation,
    );
    await _repo.saveSettings(newSettings);
    state = newSettings;
  }
}
