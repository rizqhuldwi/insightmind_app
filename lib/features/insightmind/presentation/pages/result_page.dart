import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final dynamic result;
  const ResultPage({Key? key, this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fallbacks jika result null atau tipe tidak sesuai
    final score = result?.score ?? 0;
    final riskLevel = result?.riskLevel ?? 'Tidak diketahui';

    String recommendation;
    switch (riskLevel) {
      case 'Tinggi':
        recommendation =
            'Pertimbangkan berbicara dengan konselor/psikolog. Kurangi beban, istirahat cukup, dan hubungi layanan kampus.';
        break;
      case 'Sedang':
        recommendation =
            'Lakukan aktivitas relaksasi (napas dalam, olahraga ringan), atur waktu, dan evaluasi beban kuliah/kerja.';
        break;
      default:
        recommendation =
            'Pertahankan kebiasaan baik. Jaga tidur, makan, dan olahraga.';
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Screening'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Skor Anda: $score',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Tingkat Risiko: $riskLevel',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 24),
            Text(
              recommendation,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Spacer(),
            const Text(
              'Disclaimer: InsightMind bersifat edukatif, bukan alat diagnosis medis.',
              textAlign: TextAlign.center,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}