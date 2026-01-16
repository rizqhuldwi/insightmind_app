import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../../data/local/screening_record.dart';
import '../../data/services/pdf_service.dart';
import '../providers/questionnaire_provider.dart';

class HistoryDetailPage extends ConsumerWidget {
  final ScreeningRecord record;

  const HistoryDetailPage({super.key, required this.record});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questions = ref.watch(questionsProvider);
    
    // Parse answers dari JSON string
    Map<String, int> answers = {};
    if (record.answersJson != null && record.answersJson!.isNotEmpty) {
      try {
        final decoded = jsonDecode(record.answersJson!);
        answers = Map<String, int>.from(decoded);
      } catch (e) {
        // Handle parsing error
      }
    }

    // Tentukan warna berdasarkan risk level
    Color riskColor;
    switch (record.riskLevel) {
      case 'Tinggi':
        riskColor = Colors.red;
        break;
      case 'Sedang':
        riskColor = Colors.orange;
        break;
      default:
        riskColor = Colors.green;
    }

    // Rekomendasi berdasarkan risk level
    String recommendation;
    switch (record.riskLevel) {
      case 'Tinggi':
        recommendation = 'Pertimbangkan berbicara dengan konselor/psikolog.';
        break;
      case 'Sedang':
        recommendation = 'Kurangi beban, istirahat cukup, dan hubungi layanan kampus.';
        break;
      default:
        recommendation = 'Pertahankan kebiasaan baik. Jaga tidur, makan, dan olahraga.';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Riwayat'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          // Tombol Download PDF
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Download PDF',
            onPressed: () async {
              try {
                // Show loading
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuat PDF...')),
                );

                final pdfService = PdfService();
                final pdfBytes = await pdfService.generateScreeningReport(
                  record: record,
                  questions: questions,
                );
                
                await pdfService.previewAndSave(pdfBytes);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal membuat PDF: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Summary Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Icon
                  const Icon(Icons.assessment, size: 48, color: Colors.indigo),
                  const SizedBox(height: 12),
                  
                  // Tanggal
                  Text(
                    'Screening ${record.timestamp.day}/${record.timestamp.month}/${record.timestamp.year}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Pukul ${record.timestamp.hour}:${record.timestamp.minute.toString().padLeft(2, '0')}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  
                  // Score
                  Text(
                    'Skor: ${record.score}/27',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Risk Level Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: riskColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Risiko ${record.riskLevel}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Recommendation
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.lightbulb, color: Colors.amber),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            recommendation,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Header for answers section
          Text(
            'Detail Jawaban',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          const SizedBox(height: 8),

          // Check if answers are available
          if (answers.isEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, size: 48, color: Colors.grey.shade400),
                      const SizedBox(height: 8),
                      Text(
                        'Detail jawaban tidak tersedia',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Screening ini dilakukan sebelum fitur detail diaktifkan',
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            )
          else
            // Questions List
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final selectedScore = answers[question.id];

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                elevation: 1,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Question text
                      Text(
                        '${index + 1}. ${question.text}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Options
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: question.options.map((opt) {
                          final isSelected = selectedScore == opt.score;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.indigo : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(16),
                              border: isSelected 
                                ? Border.all(color: Colors.indigo.shade700, width: 2)
                                : null,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSelected)
                                  const Padding(
                                    padding: EdgeInsets.only(right: 4),
                                    child: Icon(Icons.check, size: 16, color: Colors.white),
                                  ),
                                Text(
                                  opt.label,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : Colors.black87,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    fontSize: 13,
                                  ),
                                ),
                                if (isSelected)
                                  Text(
                                    ' (${opt.score})',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            }),

          const SizedBox(height: 16),

          // Download PDF Button at bottom
          FilledButton.icon(
            onPressed: () async {
              try {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Membuat PDF...')),
                );

                final pdfService = PdfService();
                final pdfBytes = await pdfService.generateScreeningReport(
                  record: record,
                  questions: questions,
                );
                
                await pdfService.previewAndSave(pdfBytes);
              } catch (e) {
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Gagal membuat PDF: $e')),
                );
              }
            },
            icon: const Icon(Icons.download),
            label: const Text('Download Laporan PDF'),
          ),

          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
