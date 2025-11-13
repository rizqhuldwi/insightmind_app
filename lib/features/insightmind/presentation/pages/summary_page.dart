// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:pam_teori/features/insightmind/domain/entities/question.dart';
// import '../providers/questionnaire_provider.dart';
// import '../providers/score_provider.dart';
// import 'result_page.dart';

// class SummaryPage extends ConsumerWidget {
//   const SummaryPage({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Watch state dari provider
//     final questions = ref.watch(questionsProvider);
//     final formState = ref.watch(questionnaireProvider);
//     final answers = formState.answers;

//     void handleSubmit() {
//       // Alirkan jawaban yang sudah diurutkan ke pipeline Minggu 2 (answersProvider)
//       // Ini penting agar resultProvider yang bergantung pada List<int> answersProvider tetap bekerja.
//       final answersOrdered = questions.map((q) => answers[q.id]!).toList();
//       ref.read(answersProvider.notifier).state = answersOrdered;

//       // Navigasi ke Halaman Hasil
//       Navigator.of(context).push(
//         MaterialPageRoute(builder: (context) => const ResultPage()),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ringkasan Jawaban'),
//         backgroundColor: Colors.indigo,
//         foregroundColor: Colors.white,
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: questions.length,
//         itemBuilder: (context, index) {
//           final q = questions[index];
//           final score = answers[q.id];
//           // Cari label jawaban berdasarkan skor yang tersimpan
//           final selectedOption = q.options.firstWhere(
//             (opt) => opt.score == score,
//             orElse: () => const AnswerOption(label: 'Belum Terjawab', score: -1),
//           );

//           return Card(
//             margin: const EdgeInsets.only(bottom: 12),
//             child: ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.indigo,
//                 child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
//               ),
//               title: Text(q.text, style: const TextStyle(fontWeight: FontWeight.bold)),
//               subtitle: Padding(
//                 padding: const EdgeInsets.only(top: 4.0),
//                 child: Text('Jawaban Anda: ${selectedOption.label}'),
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: SafeArea(
//         minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
//         child: FilledButton(
//           onPressed: handleSubmit,
//           style: FilledButton.styleFrom(
//             backgroundColor: Colors.indigo,
//             padding: const EdgeInsets.symmetric(vertical: 14),
//           ),
//           child: const Text('Lihat Hasil'),
//         ),
//       ),
//     );
//   }
// }

// lib/features/insightmind/presentation/pages/summary_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pam_teori/features/insightmind/domain/entities/question.dart';
import '../providers/questionnaire_provider.dart';
import '../providers/score_provider.dart';
import 'result_page.dart';

class SummaryPage extends ConsumerWidget {
  const SummaryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch state dari provider
    final questions = ref.watch(questionsProvider);
    final formState = ref.watch(questionnaireProvider);
    final answers = formState.answers;

    final totalQuestions = questions.length;
    final answeredQuestions = answers.length;
    final progress = answeredQuestions / totalQuestions;

    void handleSubmit() {
      // Alirkan jawaban yang sudah diurutkan ke pipeline Minggu 2 (answersProvider)
      final answersOrdered = questions.map((q) => answers[q.id]!).toList();
      ref.read(answersProvider.notifier).state = answersOrdered;

      // Navigasi ke Halaman Hasil
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ResultPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Jawaban'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Info Widget
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.indigo.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info, color: Colors.indigo),
                      const SizedBox(width: 10),
                      const Flexible(
                        child: Text(
                          'Periksa kembali ringkasan jawaban Anda sebelum melihat hasil screening.',
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // 2. Progres Bar
                Text(
                  'Progress: ${(progress * 100).toInt()}%',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
                ),
                const SizedBox(height: 16),

                // 3. Statistik Jawaban (Total Pertanyaan & Dijawab)
                Row(
                  children: [
                    Chip(
                      label: Text('$totalQuestions Total Pertanyaan'),
                      avatar: CircleAvatar(child: Text('$totalQuestions')),
                      backgroundColor: Colors.indigo.withOpacity(0.1),
                      labelStyle: TextStyle(color: Colors.indigo[800]),
                    ),
                    const SizedBox(width: 8),
                    Chip(
                      label: Text('$answeredQuestions Dijawab'),
                      avatar: CircleAvatar(child: Text('$answeredQuestions')),
                      backgroundColor: Colors.green.withOpacity(0.1),
                      labelStyle: TextStyle(color: Colors.green[800]),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
              ],
            ),
          ),
          
          // 4. Daftar Jawaban
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final q = questions[index];
                final score = answers[q.id];
                final selectedOption = q.options.firstWhere(
                  (opt) => opt.score == score,
                  orElse: () => const AnswerOption(label: 'Belum Terjawab', score: -1),
                );

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nomor Pertanyaan (Circle Avatar)
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.indigo,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '${index + 1}', 
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Konten Pertanyaan & Jawaban
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(q.text, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 4),
                            Text(
                              'Jawaban Anda: ${selectedOption.label}', 
                              style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: FilledButton(
          onPressed: handleSubmit,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.indigo,
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const Text('Lihat Hasil'),
        ),
      ),
    );
  }
}