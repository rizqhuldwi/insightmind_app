import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pam_teori/features/insightmind/data/local/journal_repository.dart';
import 'package:pam_teori/features/insightmind/data/local/journal_entry.dart';

/// Provider untuk mengakses repository jurnal
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  return JournalRepository();
});

/// Provider Future untuk me-load semua jurnal
final journalListProvider = FutureProvider<List<JournalEntry>>((ref) async {
  final repo = ref.watch(journalRepositoryProvider);
  return repo.getAll();
});
