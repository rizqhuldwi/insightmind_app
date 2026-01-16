import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../widgets/theme_toggle_widget.dart';
import '../../../../src/app_themes.dart';
import '../../domain/entities/question.dart';
import '../providers/questionnaire_provider.dart';
import 'login_page.dart';

class AdminDashboardPage extends ConsumerStatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  ConsumerState<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends ConsumerState<AdminDashboardPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuestionDialog(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Soal'),
        backgroundColor: AppColors.primaryBlue,
      ),
      body: Column(
        children: [
          // Header Section
          _buildHeader(context, authState.user?.name ?? 'Admin', isDark),

          // Content
          Expanded(
            child: _buildScreeningEditorTab(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dashboard Admin',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                ThemeToggleWidget(),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  onPressed: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- SCREENING EDITOR ---
  Widget _buildScreeningEditorTab() {
    final questions = ref.watch(questionsProvider);

    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Row(
              children: [
                Icon(Icons.quiz_rounded, color: AppColors.primaryBlue),
                const SizedBox(width: 8),
                const Text(
                  'Daftar Pertanyaan Screening',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shadowColor: Colors.black12,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        question.text,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      children: [
                        const Divider(height: 1),
                        ...question.options.map((opt) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                          child: Row(
                            children: [
                              Icon(Icons.check_circle_outline_rounded, size: 18, color: Colors.grey[400]),
                              const SizedBox(width: 12),
                              Expanded(child: Text(opt.label, style: TextStyle(color: Colors.grey[700]))),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Skor: ${opt.score}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        )),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton.icon(
                                icon: const Icon(Icons.edit_rounded, size: 18),
                                label: const Text('Edit'),
                                style: TextButton.styleFrom(foregroundColor: AppColors.primaryBlue),
                                onPressed: () => _showQuestionDialog(question: question, index: index),
                              ),
                              const SizedBox(width: 8),
                              TextButton.icon(
                                icon: const Icon(Icons.delete_rounded, size: 18),
                                label: const Text('Hapus'),
                                style: TextButton.styleFrom(foregroundColor: Colors.red),
                                onPressed: () => _confirmDeleteQuestion(index),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showQuestionDialog({Question? question, int? index}) {
    final textController = TextEditingController(text: question?.text ?? '');
    final optionControllers = (question?.options ?? [
      const AnswerOption(label: 'Tidak Pernah', score: 0),
      const AnswerOption(label: 'Beberapa Hari', score: 1),
      const AnswerOption(label: 'Lebih dari Separuh Hari', score: 2),
      const AnswerOption(label: 'Hampir Setiap Hari', score: 3),
    ]).map((o) => TextEditingController(text: o.label)).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(question == null ? Icons.add_circle_outline : Icons.edit_note_rounded, color: AppColors.primaryBlue),
            const SizedBox(width: 12),
            Text(question == null ? 'Tambah Soal' : 'Edit Soal'),
          ],
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Teks Pertanyaan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 8),
                TextField(
                  controller: textController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Masukkan teks pertanyaan...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.list_alt_rounded, size: 18, color: Colors.grey),
                    SizedBox(width: 6),
                    Text('Opsi Jawaban & Skor', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 12),
                ...List.generate(4, (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(color: Colors.blue.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                        child: Center(child: Text('$i', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: optionControllers[i],
                          decoration: InputDecoration(
                            hintText: 'Label jawaban skor $i',
                            isDense: true,
                            filled: true,
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            onPressed: () {
              if (textController.text.trim().isEmpty) return;
              
              final newQuestion = Question(
                id: question?.id ?? 'q${DateTime.now().millisecondsSinceEpoch}',
                text: textController.text.trim(),
                options: List.generate(4, (i) => AnswerOption(
                  label: optionControllers[i].text.trim(),
                  score: i,
                )),
              );

              if (index == null) {
                ref.read(questionsProvider.notifier).addQuestion(newQuestion);
              } else {
                ref.read(questionsProvider.notifier).updateQuestion(index, newQuestion);
              }
              
              Navigator.pop(ctx);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(index == null ? 'Pertanyaan ditambahkan!' : 'Pertanyaan diperbarui!'),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: Text(question == null ? 'Tambah' : 'Simpan'),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteQuestion(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Hapus Pertanyaan'),
        content: const Text('Apakah Anda yakin ingin menghapus pertanyaan ini? Tindakan ini tidak dapat dibatalkan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            onPressed: () {
              ref.read(questionsProvider.notifier).deleteQuestion(index);
              Navigator.pop(ctx);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Pertanyaan berhasil dihapus'),
                  backgroundColor: Colors.redAccent,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  Color _getRiskColor(String level) {
    switch (level.toLowerCase()) {
      case 'rendah': return Colors.green;
      case 'sedang': return Colors.orange;
      case 'tinggi': return Colors.red;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }


  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginPage()));
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

