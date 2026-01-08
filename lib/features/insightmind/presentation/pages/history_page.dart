import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pam_teori/features/insightmind/presentation/providers/history_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  // Fungsi konfirmasi dialog untuk hapus semua
  Future<bool?> _showClearDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: const Text('Yakin ingin menghapus semua riwayat?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // WEEK6: load semua riwayat
    final historyAsync = ref.watch(historyListProvider);
    final repo = ref.read(historyRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Screening'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      // body menangani 3 state (data/loading/error)
      body: historyAsync.when(
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada riwayat'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final record = items[index];
              return Card(
                elevation: 1,
                child: ListTile(
                  title: Text('Skor: ${record.score} (${record.riskLevel})'),
                  subtitle: Text(
                    // Tampilkan timestamp & id (informasi teknis)
                    'Waktu: ${record.timestamp.toLocal().toString().substring(0, 16)} | ID: ${record.id}',
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    tooltip: 'Hapus item ini',
                    onPressed: () async {
                      await repo.deleteById(record.id); // Hapus item
                      
                      // Refresh UI
                      ref.invalidate(historyListProvider); // Invalidasi Future agar data update
                      
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Riwayat dihapus.')),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        // State Loading
        loading: () => const Center(child: CircularProgressIndicator()),
        // State Error
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
      
      // WEEK6: Tombol "Kosongkan Semua" di bawah (Hanya muncul jika ada data)
      bottomNavigationBar: historyAsync.maybeWhen(
        data: (items) {
          if (items.isEmpty) return null; 
          
          return SafeArea(
            minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton.tonalIcon(
              icon: const Icon(Icons.delete_sweep),
              label: const Text('Kosongkan Semua Riwayat'),
              onPressed: () async {
                final ok = await _showClearDialog(context); // Tampilkan dialog konfirmasi
                
                if (ok == true) {
                  await repo.clearAll(); // Kosongkan semua
                  ref.invalidate(historyListProvider); // Refresh UI
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Semua riwayat dikosongkan.')),
                  );
                }
              },
            ),
          );
        },
        orElse: () => null,
      ),
    );
  }
}