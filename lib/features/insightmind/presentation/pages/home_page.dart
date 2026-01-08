import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/score_provider.dart';
import 'screening_page.dart';
import 'history_page.dart'; // WEEK6: import halaman riwayat

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final answers = ref.watch(answersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('InsightMind'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          // WEEK6: Tombol menuju halaman riwayat
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Riwayat Screening',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const HistoryPage()),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Bagian 1: Kartu Utama (Mulai Screening)
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Icon(Icons.psychology_alt, size: 60, color: Colors.indigo),
                  const SizedBox(height: 16),
                  const Text(
                    'Selamat Datang di InsightMind',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Mulai screening sederhana untuk memprediksi risiko '
                    'kesehatan mental secara cepat dan muda.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ScreeningPage(),
                          ),
                        );
                      },
                      child: const Text('Mulai Screening'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Spacer
          const SizedBox(height: 24),
          
          // Bagian 2: Riwayat Simulasi (Hanya muncul jika ada jawaban)
          if (answers.isNotEmpty) 
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Riwayat Simulasi Minggu 2',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        for (final a in answers) Chip(label: Text('$a')),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      // Floating Action Button (untuk simulasi)
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          // Simulasi tambah angka 0-3
          final newValue = (DateTime.now().millisecondsSinceEpoch % 4).toInt();
          // Membuat copy baru dan menambahkan nilai
          // Mengupdate state menggunakan method yang tersedia
          ref.read(answersProvider.notifier).addAnswer(newValue); 
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}