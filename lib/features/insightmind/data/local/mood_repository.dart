import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'mood_entry.dart';

/// Repository untuk operasi CRUD mood entries
class MoodRepository {
  static const String _boxName = 'mood_entries';
  final _uuid = const Uuid();

  /// Get Hive box for mood entries
  Box<MoodEntry> get _box => Hive.box<MoodEntry>(_boxName);

  /// Add new mood entry
  Future<void> addMoodEntry({
    required int moodLevel,
    required String moodEmoji,
    String? note,
    DateTime? timestamp,
    List<String> tags = const [],
  }) async {
    final entry = MoodEntry(
      id: _uuid.v4(),
      moodLevel: moodLevel,
      moodEmoji: moodEmoji,
      note: note,
      timestamp: timestamp ?? DateTime.now(),
      tags: tags,
    );

    await _box.put(entry.id, entry);
  }

  /// Get all mood entries sorted by timestamp (newest first)
  List<MoodEntry> getAllMoodEntries() {
    final entries = _box.values.toList();
    entries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return entries;
  }

  /// Get mood entries within a date range
  List<MoodEntry> getMoodEntriesInRange(DateTime start, DateTime end) {
    final allEntries = getAllMoodEntries();
    return allEntries.where((entry) {
      return entry.timestamp.isAfter(start.subtract(const Duration(days: 1))) &&
          entry.timestamp.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  /// Get mood entries for the last N days
  List<MoodEntry> getRecentMoodEntries(int days) {
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: days));
    return getMoodEntriesInRange(startDate, now);
  }

  /// Update an existing mood entry
  Future<void> updateMoodEntry({
    required String id,
    int? moodLevel,
    String? moodEmoji,
    String? note,
    List<String>? tags,
  }) async {
    final entry = _box.get(id);
    if (entry != null) {
      final updated = MoodEntry(
        id: entry.id,
        moodLevel: moodLevel ?? entry.moodLevel,
        moodEmoji: moodEmoji ?? entry.moodEmoji,
        note: note ?? entry.note,
        timestamp: entry.timestamp,
        tags: tags ?? entry.tags,
      );
      await _box.put(id, updated);
    }
  }

  /// Delete a mood entry by ID
  Future<void> deleteMoodEntry(String id) async {
    await _box.delete(id);
  }

  /// Get average mood level for a date range
  double getAverageMood(DateTime start, DateTime end) {
    final entries = getMoodEntriesInRange(start, end);
    if (entries.isEmpty) return 0;

    final total = entries.fold<int>(0, (sum, entry) => sum + entry.moodLevel);
    return total / entries.length;
  }

  /// Get mood entries count
  int get entryCount => _box.length;

  /// Clear all mood entries (for testing/debug)
  Future<void> clearAllEntries() async {
    await _box.clear();
  }
}
