import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pam_teori/features/insightmind/domain/entities/question.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/score_provider.dart';
import 'result_page.dart';


class ScreeningPage extends ConsumerWidget {
  const ScreeningPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Ambil data dari Riverpod
    final questions = ref.watch(questionsProvider);
    final qState = ref.watch(questionnaireProvider);
    final notifier = ref.read(questionnaireProvider.notifier);

    // 2. Hitung progress
    final progress = questions.isEmpty ? 0.0 : (qState.answers.length / questions.length);

    // 3. Cek apakah form sudah lengkap
    final isComplete = qState.isComplete;


    // ===============================================
    // FUNGSI SUBMIT (Handles Validation and Navigation)
    // ===============================================
    void handleSubmit() {
      if (!isComplete) {
        // Tampilkan SnackBar jika belum lengkap
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lengkapi semua pertanyaan sebelum melihat hasil.'),
          ),
        );
        return;
      }

      // Sinkronkan ke pipeline score_provider (Minggu 2):
      // Konversi Map<String, int> answers ke List<int> berurutan
      final ordered = <int>[];
      for (final q in questions) {
        // Ambil skor berdasarkan ID pertanyaan (q1, q2, ...)
        ordered.add(qState.answers[q.id]!);
      }
      
      // Update answersProvider (StateProvider<List<int>>)
      ref.read(answersProvider.notifier).state = ordered;

      // Navigasi ke halaman hasil
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ResultPage()),
      );
    }
    // ===============================================


    return Scaffold(
      appBar: AppBar(
        title: const Text('Screening InsightMind'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        children: [
          // ===============================================
          // PROGRESS BAR
          // ===============================================
          Card(
            elevation: 1.5,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Terisi: ${qState.answers.length}/${questions.length} pertanyaan',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // ===============================================
          // DAFTAR PERTANYAAN (ITERASI)
          // ===============================================
          ...List.generate(questions.length, (i) {
            final question = questions[i];
            final selectedScore = qState.answers[question.id];

            return _QuestionCard(
              index: i,
              question: question,
              selectedScore: selectedScore,
              onOptionSelected: (score) {
                notifier.selectAnswer(
                    questionId: question.id, score: score);
              },
            );
          }),
          
          // Tambahkan spacer/padding antara pertanyaan terakhir dan tombol
          const SizedBox(height: 8),
          const SizedBox(height: 12), 

          // ===============================================
          // TOMBOL SUBMIT
          // ===============================================
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Lihat Hasil'),
              onPressed: handleSubmit,
            ),
          ),

          const SizedBox(height: 8),

          // ===============================================
          // TOMBOL RESET OPSIONAL
          // ===============================================
          TextButton.icon(
            onPressed: () {
              notifier.reset(); // Panggil fungsi reset
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Jawaban direset.')));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Jawaban'),
          ),
        ],
      ),
    );
  }
}

// ===============================================
// WIDGET BANTUAN: QUESTION CARD (_QuestionCard)
// ===============================================
class _QuestionCard extends StatelessWidget {
  final int index;
  final Question question;
  final int? selectedScore;
  final ValueChanged<int> onOptionSelected;

  const _QuestionCard({
    required this.index,
    required this.question,
    required this.selectedScore,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Teks pertanyaan
            Text(
              '${index + 1}. ${question.text}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            
            // Opsi jawaban (ChoiceChip)
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final opt in question.options)
                  ChoiceChip(
                    label: Text(opt.label),
                    selected: selectedScore == opt.score,
                    onSelected: (_) => onOptionSelected(opt.score),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}