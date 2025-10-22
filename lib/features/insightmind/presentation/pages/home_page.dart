import 'package:flutter/material.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<int> answers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('InsightMind - Home'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Simulasi Jawaban Kuisioner (nilai 0-3)\n'
              'Klik tombol + untuk menambah jawaban acak.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [
                for (int i = 0; i < answers.length; i++)
                  Chip(label: Text('${answers[i]}')),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: answers.isEmpty
                    ? null
                    : () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ResultPage(),
                          ),
                        );
                      },
                child: const Text('Lihat Hasil'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        onPressed: () {
          final newValue = DateTime.now().millisecondsSinceEpoch % 4; // 0..3
          setState(() {
            answers.add(newValue);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}