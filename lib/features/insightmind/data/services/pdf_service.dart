import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:convert';
import '../local/screening_record.dart';
import '../../domain/entities/question.dart';

/// Service untuk generate PDF laporan screening
class PdfService {
  /// Generate PDF report dari hasil screening
  Future<Uint8List> generateScreeningReport({
    required ScreeningRecord record,
    required List<Question> questions,
  }) async {
    final pdf = pw.Document();

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
    PdfColor riskColor;
    switch (record.riskLevel) {
      case 'Tinggi':
        riskColor = PdfColors.red;
        break;
      case 'Sedang':
        riskColor = PdfColors.orange;
        break;
      default:
        riskColor = PdfColors.green;
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

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // Header
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: PdfColors.indigo,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Center(
                child: pw.Text(
                  'Laporan Hasil Screening InsightMind',
                  style: pw.TextStyle(
                    fontSize: 20,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            ),
            
            pw.SizedBox(height: 20),

            // Info Section
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Informasi Screening',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Divider(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tanggal:'),
                      pw.Text(
                        '${record.timestamp.day}/${record.timestamp.month}/${record.timestamp.year} ${record.timestamp.hour}:${record.timestamp.minute.toString().padLeft(2, '0')}',
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Skor Total:'),
                      pw.Text(
                        '${record.score}/27',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 8),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Tingkat Risiko:'),
                      pw.Container(
                        padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: pw.BoxDecoration(
                          color: riskColor,
                          borderRadius: pw.BorderRadius.circular(4),
                        ),
                        child: pw.Text(
                          record.riskLevel,
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 16),

            // Recommendation
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.blue50,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                children: [
                  pw.Text('💡 ', style: const pw.TextStyle(fontSize: 16)),
                  pw.Expanded(
                    child: pw.Text(
                      'Rekomendasi: $recommendation',
                      style: const pw.TextStyle(fontSize: 11),
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 20),

            // Answers Section
            pw.Text(
              'Detail Jawaban',
              style: pw.TextStyle(
                fontSize: 14,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.Divider(),
            pw.SizedBox(height: 8),

            // Questions and Answers
            ...questions.asMap().entries.map((entry) {
              final index = entry.key;
              final question = entry.value;
              final selectedScore = answers[question.id];
              
              // Find selected option label
              String selectedLabel = 'Tidak dijawab';
              if (selectedScore != null) {
                for (final opt in question.options) {
                  if (opt.score == selectedScore) {
                    selectedLabel = opt.label;
                    break;
                  }
                }
              }

              return pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 12),
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(6),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${index + 1}. ${question.text}',
                      style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 6),
                    pw.Row(
                      children: [
                        pw.Text(
                          'Jawaban: ',
                          style: const pw.TextStyle(fontSize: 10),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: pw.BoxDecoration(
                            color: selectedScore != null ? PdfColors.indigo100 : PdfColors.grey300,
                            borderRadius: pw.BorderRadius.circular(4),
                          ),
                          child: pw.Text(
                            '$selectedLabel${selectedScore != null ? ' (Skor: $selectedScore)' : ''}',
                            style: pw.TextStyle(
                              fontSize: 10,
                              fontWeight: pw.FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),

            pw.SizedBox(height: 20),

            // Footer
            pw.Container(
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(6),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    'Catatan:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Hasil screening ini bukan diagnosa medis. Untuk evaluasi lebih lanjut, silakan konsultasi dengan profesional kesehatan mental.',
                    style: const pw.TextStyle(fontSize: 9),
                    textAlign: pw.TextAlign.center,
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Preview dan/atau save PDF
  Future<void> previewAndSave(Uint8List pdfBytes) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }
}
