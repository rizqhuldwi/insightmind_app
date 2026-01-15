import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/mood_provider.dart';

class MoodEntryDialog extends ConsumerStatefulWidget {
  const MoodEntryDialog({super.key});

  @override
  ConsumerState<MoodEntryDialog> createState() => _MoodEntryDialogState();
}

class _MoodEntryDialogState extends ConsumerState<MoodEntryDialog> {
  int selectedMoodLevel = 3;
  final noteController = TextEditingController();
  final List<String> selectedTags = [];
  
  final List<String> availableTags = [
    'Kerja',
    'Keluarga',
    'Kesehatan',
    'Sosial',
    'Hobi',
    'Olahraga',
    'Tidur',
    'Lainnya',
  ];

  final Map<int, Map<String, dynamic>> moodLevels = {
    1: {'emoji': '😢', 'label': 'Sangat Buruk', 'color': Colors.red},
    2: {'emoji': '😞', 'label': 'Buruk', 'color': Colors.deepOrange},
    3: {'emoji': '😐', 'label': 'Biasa Saja', 'color': Colors.orange},
    4: {'emoji': '😊', 'label': 'Baik', 'color': Colors.lightGreen},
    5: {'emoji': '😄', 'label': 'Sangat Baik', 'color': Colors.green},
  };

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentMood = moodLevels[selectedMoodLevel]!;
    
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Title
            const Text(
              'Bagaimana Perasaanmu?',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            
            // Mood Level Selector
            Center(
              child: Column(
                children: [
                  Text(
                    currentMood['emoji'],
                    style: const TextStyle(fontSize: 80),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currentMood['label'],
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: currentMood['color'],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Mood Slider
            Slider(
              value: selectedMoodLevel.toDouble(),
              min: 1,
              max: 5,
              divisions: 4,
              label: currentMood['label'],
              activeColor: currentMood['color'],
              onChanged: (value) {
                setState(() {
                  selectedMoodLevel = value.toInt();
                });
              },
            ),
            const SizedBox(height: 20),
            
            // Note Input
            TextField(
              controller: noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Catatan (Opsional)',
                hintText: 'Ceritakan tentang perasaanmu...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Tags Selection
            const Text(
              'Tag (Opsional)',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: availableTags.map((tag) {
                final isSelected = selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        selectedTags.add(tag);
                      } else {
                        selectedTags.remove(tag);
                      }
                    });
                  },
                  selectedColor: Colors.indigo.withOpacity(0.3),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            
            // Submit Button
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () async {
                  final repo = ref.read(moodRepositoryProvider);
                  
                  await repo.addMoodEntry(
                    moodLevel: selectedMoodLevel,
                    moodEmoji: moodLevels[selectedMoodLevel]!['emoji'],
                    note: noteController.text.trim().isEmpty 
                        ? null 
                        : noteController.text.trim(),
                    tags: selectedTags,
                  );
                  
                  // Invalidate providers to refresh data
                  ref.invalidate(moodListProvider);
                  ref.invalidate(recentMoodProvider);
                  ref.invalidate(moodTrendProvider);
                  ref.invalidate(monthlyMoodTrendProvider);
                  ref.invalidate(averageMoodProvider);
                  
                  if (context.mounted) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Mood berhasil dicatat!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                icon: const Icon(Icons.save),
                label: const Text('Simpan Mood'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
