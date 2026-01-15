import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pam_teori/features/insightmind/data/local/journal_entry.dart';
import 'package:pam_teori/features/insightmind/presentation/providers/journal_provider.dart';

class JournalPage extends ConsumerWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journalAsync = ref.watch(journalListProvider);
    final repo = ref.read(journalRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jurnal Saya'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: journalAsync.when(
        data: (journals) {
          if (journals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book_outlined, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Belum ada catatan jurnal',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan tombol + di halaman utama\nuntuk menambah catatan',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: journals.length,
            itemBuilder: (context, index) {
              final journal = journals[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () {
                    _showJournalDetail(context, ref, journal);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mood Emoji
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.indigo.withAlpha(25),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              journal.mood,
                              style: const TextStyle(fontSize: 28),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Content
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                journal.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                journal.content,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _formatDate(journal.createdAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Popup Menu untuk Edit & Delete
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                          onSelected: (value) async {
                            if (value == 'edit') {
                              _showEditJournalDialog(context, ref, journal);
                            } else if (value == 'delete') {
                              final confirm = await _showDeleteConfirmation(context);
                              if (confirm == true) {
                                await repo.deleteById(journal.id);
                                ref.invalidate(journalListProvider);
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Jurnal dihapus')),
                                );
                              }
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, color: Colors.indigo),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Hapus'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      return 'Hari ini, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays == 1) {
      return 'Kemarin, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (diff.inDays < 7) {
      return '${diff.inDays} hari lalu';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  Future<bool?> _showDeleteConfirmation(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Jurnal?'),
        content: const Text('Catatan ini akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  void _showJournalDetail(BuildContext context, WidgetRef ref, JournalEntry journal) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (sheetContext, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Mood & Title & Action Buttons
              Row(
                children: [
                  Text(journal.mood, style: const TextStyle(fontSize: 40)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          journal.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatDate(journal.createdAt),
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showEditJournalDialog(context, ref, journal);
                      },
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final confirm = await _showDeleteConfirmation(context);
                        if (confirm == true) {
                          final repo = ref.read(journalRepositoryProvider);
                          await repo.deleteById(journal.id);
                          ref.invalidate(journalListProvider);
                          if (!context.mounted) return;
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Jurnal dihapus')),
                          );
                        }
                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                      label: const Text('Hapus', style: TextStyle(color: Colors.red)),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              // Content
              Text(
                journal.content,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditJournalDialog(BuildContext context, WidgetRef ref, JournalEntry journal) {
    final titleController = TextEditingController(text: journal.title);
    final contentController = TextEditingController(text: journal.content);
    String selectedMood = journal.mood;
    
    final moods = ['😊', '😌', '😐', '😢', '😰', '😡'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (stateContext, setState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(stateContext).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                
                // Title
                const Text(
                  'Edit Jurnal',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                
                // Mood Selector
                const Text('Bagaimana perasaanmu?', style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: moods.map((mood) {
                    final isSelected = selectedMood == mood;
                    return GestureDetector(
                      onTap: () => setState(() => selectedMood = mood),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.indigo.withAlpha(30) : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected 
                              ? Border.all(color: Colors.indigo, width: 2) 
                              : null,
                        ),
                        child: Text(mood, style: const TextStyle(fontSize: 28)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                
                // Title Input
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Content Input
                TextField(
                  controller: contentController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Isi Jurnal',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                
                // Submit Button
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () async {
                      final title = titleController.text.trim();
                      final content = contentController.text.trim();
                      
                      if (title.isEmpty || content.isEmpty) {
                        ScaffoldMessenger.of(stateContext).showSnackBar(
                          const SnackBar(content: Text('Judul dan isi tidak boleh kosong')),
                        );
                        return;
                      }
                      
                      final repo = ref.read(journalRepositoryProvider);
                      await repo.updateJournal(
                        id: journal.id,
                        title: title,
                        content: content,
                        mood: selectedMood,
                      );
                      
                      ref.invalidate(journalListProvider);
                      
                      Navigator.pop(ctx);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Jurnal berhasil diupdate!')),
                      );
                    },
                    icon: const Icon(Icons.save),
                    label: const Text('Simpan Perubahan'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
