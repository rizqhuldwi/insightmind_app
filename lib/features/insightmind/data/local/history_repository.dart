import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart'; // Import UUID (pastikan package uuid: ^4.5.1 sudah ditambahkan)
import 'screening_record.dart'; // Import model data Hive

class HistoryRepository {
  static const String boxName = 'screening_records';

  // WEEK6: Buka box jika belum terbuka (lazy-open)
  Future<Box<ScreeningRecord>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<ScreeningRecord>(boxName);
    }
    return Hive.box<ScreeningRecord>(boxName);
    // NOTE: Di sini bisa ditambah enkripsi (HiveAesCipher) jika diperlukan
  }

  // WEEK6: Tambah satu record riwayat (dipanggil saat hasil muncul)
  Future<void> addRecord({
    required int score,
    required String riskLevel,
    String? note,
    String? answersJson, // JSON string dari jawaban
  }) async {
    final box = await _openBox();
    final id = const Uuid().v4(); // ID unik
    final record = ScreeningRecord(
      id: id,
      timestamp: DateTime.now(),
      score: score,
      riskLevel: riskLevel,
      note: note,
      answersJson: answersJson,
    );

    await box.put(
      id,
      record,
    ); // simpan dengan key = id (mudah dihapus per item)
  }

  // WEEK6: Ambil semua riwayat (urutkan terbaru di atas)
  Future<List<ScreeningRecord>> getAll() async {
    final box = await _openBox();
    final records = box.values.toList();
    // Urutkan dari yang terbaru (descending)
    records.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return records;
  }

  // WEEK6: Hapus 1 item berdasarkan ID
  Future<void> deleteById(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  // WEEK6: Kosongkan seluruh riwayat
  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
// testing commit