import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/mood_entry.dart';
import '../../data/local/mood_repository.dart';

/// Provider for MoodRepository instance
final moodRepositoryProvider = Provider<MoodRepository>((ref) {
  return MoodRepository();
});

/// Provider for mood entries list
final moodListProvider = StreamProvider<List<MoodEntry>>((ref) async* {
  final repo = ref.watch(moodRepositoryProvider);
  
  // Initial load
  yield repo.getAllMoodEntries();
  
  // Listen for changes (poll every second for simplicity)
  // In production, you might want to use Hive's watch() method
  await for (final _ in Stream.periodic(const Duration(seconds: 1))) {
    yield repo.getAllMoodEntries();
  }
});

/// Provider for recent mood entries (last 7 days)
final recentMoodProvider = Provider<List<MoodEntry>>((ref) {
  final repo = ref.watch(moodRepositoryProvider);
  return repo.getRecentMoodEntries(7);
});

/// Provider for mood trend data (last 7 days)
final moodTrendProvider = Provider<List<MoodEntry>>((ref) {
  final repo = ref.watch(moodRepositoryProvider);
  return repo.getRecentMoodEntries(7);
});

/// Provider for mood trend data (last 30 days)
final monthlyMoodTrendProvider = Provider<List<MoodEntry>>((ref) {
  final repo = ref.watch(moodRepositoryProvider);
  return repo.getRecentMoodEntries(30);
});

/// Provider for average mood in last 7 days
final averageMoodProvider = Provider<double>((ref) {
  final repo = ref.watch(moodRepositoryProvider);
  final now = DateTime.now();
  final weekAgo = now.subtract(const Duration(days: 7));
  return repo.getAverageMood(weekAgo, now);
});
