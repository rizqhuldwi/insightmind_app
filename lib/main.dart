import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pam_teori/src/app.dart';
import 'features/insightmind/data/local/screening_record.dart';
import 'features/insightmind/data/local/journal_entry.dart';
import 'features/insightmind/data/local/user.dart';
import 'features/insightmind/data/local/mood_entry.dart';
import 'features/insightmind/data/local/profile.dart';
import 'features/insightmind/data/local/auth_repository.dart';
import 'features/insightmind/data/local/admin_settings.dart';
import 'features/insightmind/domain/entities/question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive untuk Flutter
  await Hive.initFlutter();

  // Registrasi adapter
  Hive.registerAdapter(ScreeningRecordAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(MoodEntryAdapter());
  Hive.registerAdapter(ProfileAdapter());
  Hive.registerAdapter(AdminSettingsAdapter());
  Hive.registerAdapter(QuestionAdapter());
  Hive.registerAdapter(AnswerOptionAdapter());

  // Buka box-box yang diperlukan
  await Hive.openBox<ScreeningRecord>('screening_records');
  await Hive.openBox<JournalEntry>('journals');
  await Hive.openBox<User>('users');
  await Hive.openBox('auth_session');
  await Hive.openBox<MoodEntry>('mood_entries');
  await Hive.openBox<Profile>('profiles');
  await Hive.openBox<AdminSettings>('admin_settings');
  await Hive.openBox<Question>('screening_questions');

  // Inisialisasi admin default
  final authRepo = AuthRepository();
  await authRepo.initDefaultAdmin();

  // Riverpod root scope
  runApp(const ProviderScope(child: InsightMindApp()));
}
