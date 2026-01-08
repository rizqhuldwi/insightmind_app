import 'package:hive/hive.dart';

part 'screening_record.g.dart'; // file adapter hasil generate build_runner

@HiveType(typeId: 1) // WEEK6: beri typeId unik untuk model ini
class ScreeningRecord extends HiveObject {
  @HiveField(0) // WEEK6: field ini akan diserialisasi sebagai kolom
  final String id;

  @HiveField(1) // WEEK6
  final DateTime timestamp;

  @HiveField(2) // WEEK6
  final int score;

  @HiveField(3) // WEEK6
  final String riskLevel;

  @HiveField(4) // WEEK6: opsional untuk catatan pengguna
  final String? note;

  @HiveField(5) // Menyimpan jawaban dalam format JSON string
  final String? answersJson; // Format: {"q1": 2, "q2": 0, ...}

  ScreeningRecord({
    required this.id,
    required this.timestamp,
    required this.score,
    required this.riskLevel,
    this.note,
    this.answersJson,
  });
}