import 'package:hive/hive.dart';

part 'mood_entry.g.dart';

@HiveType(typeId: 4) // typeId unik untuk mood entries
class MoodEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int moodLevel; // 1-5 scale (1=very bad, 5=very good)

  @HiveField(2)
  final String moodEmoji; // Emoji representation of mood

  @HiveField(3)
  final String? note; // Optional note about the mood

  @HiveField(4)
  final DateTime timestamp; // When the mood was recorded

  @HiveField(5)
  final List<String> tags; // Tags like "work", "family", "health", etc.

  MoodEntry({
    required this.id,
    required this.moodLevel,
    required this.moodEmoji,
    this.note,
    required this.timestamp,
    this.tags = const [],
  });

  /// Helper method to get mood description based on level
  String get moodDescription {
    switch (moodLevel) {
      case 1:
        return 'Sangat Buruk';
      case 2:
        return 'Buruk';
      case 3:
        return 'Biasa Saja';
      case 4:
        return 'Baik';
      case 5:
        return 'Sangat Baik';
      default:
        return 'Unknown';
    }
  }

  /// Helper method to get mood emoji based on level (fallback if emoji not set)
  static String getEmojiForLevel(int level) {
    switch (level) {
      case 1:
        return '😢';
      case 2:
        return '😞';
      case 3:
        return '😐';
      case 4:
        return '😊';
      case 5:
        return '😄';
      default:
        return '😐';
    }
  }
}
