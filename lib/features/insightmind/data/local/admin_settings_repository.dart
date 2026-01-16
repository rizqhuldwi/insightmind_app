import 'package:hive_flutter/hive_flutter.dart';
import 'admin_settings.dart';

class AdminSettingsRepository {
  static const String boxName = 'admin_settings';
  static const String settingsKey = 'current_settings';

  Future<Box<AdminSettings>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<AdminSettings>(boxName);
    }
    return Hive.box<AdminSettings>(boxName);
  }

  Future<AdminSettings> getSettings() async {
    final box = await _openBox();
    final settings = box.get(settingsKey);
    return settings ?? AdminSettings();
  }

  Future<void> saveSettings(AdminSettings settings) async {
    final box = await _openBox();
    await box.put(settingsKey, settings);
  }
}
