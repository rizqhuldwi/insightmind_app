import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import 'journal_entry.dart';

class JournalRepository {
  static const String boxName = 'journals';

  /// Buka box jika belum terbuka
  Future<Box<JournalEntry>> _openBox() async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<JournalEntry>(boxName);
    }
    return Hive.box<JournalEntry>(boxName);
  }

  /// Tambah jurnal baru
  Future<void> addJournal({
    required String title,
    required String content,
    required String mood,
  }) async {
    final box = await _openBox();
    final id = const Uuid().v4();
    final entry = JournalEntry(
      id: id,
      title: title,
      content: content,
      mood: mood,
      createdAt: DateTime.now(),
    );
    await box.put(id, entry);
  }

  /// Ambil semua jurnal (terbaru di atas)
  Future<List<JournalEntry>> getAll() async {
    final box = await _openBox();
    final entries = box.values.toList();
    entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  /// Hapus jurnal berdasarkan ID
  Future<void> deleteById(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  /// Update jurnal
  Future<void> updateJournal({
    required String id,
    required String title,
    required String content,
    required String mood,
  }) async {
    final box = await _openBox();
    final existing = box.get(id);
    if (existing != null) {
      final updated = JournalEntry(
        id: id,
        title: title,
        content: content,
        mood: mood,
        createdAt: existing.createdAt,
      );
      await box.put(id, updated);
    }
  }

  /// Kosongkan semua jurnal
  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
