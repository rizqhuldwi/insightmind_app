import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/questionnaire_provider.dart';
import '../../domain/entities/question.dart';

class ManageQuestionsPage extends ConsumerWidget {
  const ManageQuestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pertanyaan'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: questions.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return _QuestionCard(question: question);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ManageQuestionsPage.showQuestionDialog(context, ref),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.help_outline, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Belum ada pertanyaan',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  static void showQuestionDialog(BuildContext context, WidgetRef ref, [Question? question]) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final isEdit = question != null;
    final textController = TextEditingController(text: question?.text ?? '');
    
    // Default 4 options if new
    final optionsControllers = (question?.options ?? [
      const AnswerOption(label: 'Tidak Pernah', score: 0),
      const AnswerOption(label: 'Beberapa Hari', score: 1),
      const AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      const AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ]).map((opt) => {
      'label': TextEditingController(text: opt.label),
      'score': TextEditingController(text: opt.score.toString()),
    }).toList();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEdit ? 'Edit Pertanyaan' : 'Tambah Pertanyaan'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: 'Teks Pertanyaan',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 24),
                
                Row(
                  children: [
                    Icon(Icons.list_alt, size: 20, color: primaryColor),
                    const SizedBox(width: 8),
                    const Text('Opsi Jawaban', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 16),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isDark ? Colors.white24 : Colors.grey[300]!),
                  ),
                  child: Column(
                    children: optionsControllers.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final controllers = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${idx + 1}.',
                              style: const TextStyle(fontWeight: FontWeight.bold, height: 3),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: TextField(
                                controller: controllers['label'],
                                decoration: InputDecoration(
                                  labelText: 'Label Opsi',
                                  isDense: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextField(
                                controller: controllers['score'],
                                decoration: InputDecoration(
                                  labelText: 'Skor',
                                  isDense: true,
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: primaryColor),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () async {
                final text = textController.text.trim();
                if (text.isEmpty) return;

                final options = optionsControllers.map((c) => AnswerOption(
                  label: c['label']!.text.trim(),
                  score: int.tryParse(c['score']!.text) ?? 0,
                )).toList();

                final repo = ref.read(questionRepositoryProvider);
                if (isEdit) {
                  await repo.updateQuestion(Question(
                    id: question.id,
                    text: text,
                    options: options,
                  ));
                } else {
                  await repo.addQuestion(text, options);
                }

                // Refresh state
                ref.read(questionsProvider.notifier).state = repo.getQuestions();
                
                if (context.mounted) {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isEdit ? 'Pertanyaan berhasil diperbarui' : 'Pertanyaan berhasil ditambahkan'),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuestionCard extends ConsumerWidget {
  final Question question;

  const _QuestionCard({required this.question});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    question.text,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit, color: primaryColor),
                  onPressed: () => ManageQuestionsPage.showQuestionDialog(context, ref, question),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(context, ref),
                ),
              ],
            ),
            const Divider(),
            ...question.options.map((opt) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text('• ${opt.label} (Skor: ${opt.score})', 
                style: TextStyle(fontSize: 13, color: Colors.grey[600])),
            )),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Pertanyaan'),
        content: const Text('Apakah Anda yakin ingin menghapus pertanyaan ini?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              final repo = ref.read(questionRepositoryProvider);
              await repo.deleteQuestion(question.id);
              ref.read(questionsProvider.notifier).state = repo.getQuestions();
              if (context.mounted) Navigator.pop(ctx);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
