import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pam_teori/features/insightmind/presentation/providers/history_provider.dart';
import '../providers/score_provider.dart';
// Digunakan untuk autosave Hive dan refresh list

// Menggunakan ConsumerStatefulWidget untuk menangani lifecycle (didChangeDependencies)
class ResultPage extends ConsumerStatefulWidget {
  const ResultPage({super.key});

  @override
  ConsumerState<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends ConsumerState<ResultPage> {
  // Flag agar data tidak disimpan berulang kali saat widget rebuild [cite: 397]
  bool _saved = false; 

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Simpan data hanya ketika halaman dimuat pertama kali [cite: 397]
    if (!_saved) {
      final result = ref.read(resultProvider); // Ambil hasil akhir (skor + risiko)
      final repo = ref.read(historyRepositoryProvider);
      
      repo.addRecord(
        score: result.score,
        riskLevel: result.riskLevel,
        note: null,
      ).then((_) {
        // Refresh list history agar data terbaru muncul di HistoryPage
        if (mounted) {
          ref.invalidate(historyListProvider); 
        }
      });
      _saved = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(resultProvider);
    
    String recommendation;
    
    // Logika penentuan rekomendasi berdasarkan riskLevel
    switch (result.riskLevel) {
      case 'Tinggi':
        recommendation =
            'Pertimbangkan berbicara dengan konselor/psikolog.';
        break;
      case 'Sedang':
        recommendation =
            'Kurangi beban, istirahat cukup, dan hubungi layanan kampus.';
        break;
      default:
        recommendation =
            'Pertahankan kebiasaan baik. Jaga tidur, makan, dan olahraga.';
        break;
    }

    // Fungsi bantu untuk warna dinamis
    Color getColorByRisk(String riskLevel) {
      if (riskLevel == 'Tinggi') return Colors.red;
      if (riskLevel == 'Sedang') return Colors.orange;
      return Colors.green;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hasil Screening'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Ikon
                  const Icon(Icons.emoji_objects, size: 60, color: Colors.indigo),
                  const SizedBox(height: 12),
                  
                  // Skor
                  Text(
                    'Skor Anda: ${result.score}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  
                  // Tingkat Risiko (Warna Dinamis)
                  Text(
                    'Tingkat Risiko: ${result.riskLevel}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      // Penentuan warna risiko
                      color: getColorByRisk(result.riskLevel),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Rekomendasi
                  Text(
                    recommendation,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Informasi bahwa hasil otomatis disimpan [cite: 399]
                  const Text(
                    'Hasil telah disimpan di perangkat (Riwayat)',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  // Tombol Kembali
                  FilledButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}