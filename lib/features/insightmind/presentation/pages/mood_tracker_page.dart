import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/mood_provider.dart';
import '../widgets/mood_chart_widget.dart';
import '../widgets/mood_entry_dialog.dart';
import '../widgets/theme_toggle_widget.dart';
import '../../data/local/mood_entry.dart';

class MoodTrackerPage extends ConsumerStatefulWidget {
  const MoodTrackerPage({super.key});

  @override
  ConsumerState<MoodTrackerPage> createState() => _MoodTrackerPageState();
}

class _MoodTrackerPageState extends ConsumerState<MoodTrackerPage> {
  bool showWeeklyView = true; // true = 7 days, false = 30 days

  @override
  Widget build(BuildContext context) {
    final moodListAsync = ref.watch(moodListProvider);
    final averageMood = ref.watch(averageMoodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Tracker'),
        actions: const [
          ThemeToggleWidget(),
          SizedBox(width: 8),
        ],
      ),
      body: moodListAsync.when(
        data: (allMoods) {
          // Filter moods based on selected view
          final displayMoods = showWeeklyView
              ? ref.read(moodRepositoryProvider).getRecentMoodEntries(7)
              : ref.read(moodRepositoryProvider).getRecentMoodEntries(30);

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Average Mood Card
              if (allMoods.isNotEmpty) ...[
                _buildAverageMoodCard(averageMood),
                const SizedBox(height: 16),
              ],

              // Chart with view toggle
              _buildChartSection(displayMoods),
              const SizedBox(height: 16),

              // Mood History Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Riwayat Mood',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  if (allMoods.isNotEmpty)
                    Text(
                      '${allMoods.length} entri',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Mood History List
              if (allMoods.isEmpty)
                _buildEmptyState()
              else
                ...allMoods.map((mood) => _buildMoodItem(mood)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMoodEntryDialog,
        icon: const Icon(Icons.add),
        label: const Text('Catat Mood'),
      ),
    );
  }

  Widget _buildAverageMoodCard(double avgMood) {
    final emoji = MoodEntry.getEmojiForLevel(avgMood.round());
    
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rata-rata Mood (7 Hari)',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    avgMood.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.trending_up,
              color: avgMood >= 3 ? Colors.green : Colors.orange,
              size: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(List<MoodEntry> moods) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Trend Mood',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('7 Hari')),
                ButtonSegment(value: false, label: Text('30 Hari')),
              ],
              selected: {showWeeklyView},
              onSelectionChanged: (Set<bool> newSelection) {
                setState(() {
                  showWeeklyView = newSelection.first;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 12),
        MoodChartWidget(
          moodEntries: moods,
          daysToShow: showWeeklyView ? 7 : 30,
        ),
      ],
    );
  }

  Widget _buildMoodItem(MoodEntry mood) {
    final dateFormat = DateFormat('EEEE, dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getMoodColor(mood.moodLevel).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              mood.moodEmoji,
              style: const TextStyle(fontSize: 28),
            ),
          ),
        ),
        title: Text(
          mood.moodDescription,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${dateFormat.format(mood.timestamp)} • ${timeFormat.format(mood.timestamp)}',
              style: const TextStyle(fontSize: 12),
            ),
            if (mood.note != null && mood.note!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                mood.note!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
            if (mood.tags.isNotEmpty) ...[
              const SizedBox(height: 6),
              Wrap(
                spacing: 4,
                children: mood.tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    labelStyle: const TextStyle(fontSize: 10),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _deleteMood(mood),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.mood, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'Belum Ada Catatan Mood',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Mulai catat mood harian kamu dengan menekan tombol di bawah',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(int moodLevel) {
    switch (moodLevel) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.lightGreen;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.deepOrange;
      case 1:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _showMoodEntryDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const MoodEntryDialog(),
    );
  }

  void _deleteMood(MoodEntry mood) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Mood'),
        content: const Text('Apakah Anda yakin ingin menghapus catatan mood ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () async {
              await ref.read(moodRepositoryProvider).deleteMoodEntry(mood.id);
              ref.invalidate(moodListProvider);
              ref.invalidate(recentMoodProvider);
              ref.invalidate(moodTrendProvider);
              ref.invalidate(averageMoodProvider);
              
              if (mounted) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Mood berhasil dihapus')),
                );
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
