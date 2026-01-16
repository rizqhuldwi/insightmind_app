import 'package:hive/hive.dart';

part 'journal_entry.g.dart';

@HiveType(typeId: 5) // typeId unik untuk model jurnal
class JournalEntry extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final String mood; // Emoji mood: 😊, 😐, 😢, 😰, 😡

  @HiveField(4)
  final DateTime createdAt;

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.mood,
    required this.createdAt,
  });
}
