import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../src/app_themes.dart';
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
  bool showWeeklyView = true;

  @override
  Widget build(BuildContext context) {
    final moodListAsync = ref.watch(moodListProvider);
    final averageMood = ref.watch(averageMoodProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Modern App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.primaryBlue,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [const ThemeToggleWidget(), const SizedBox(width: 8)],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkGradient
                      : AppColors.primaryGradient,
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(60, 50, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.mood_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Mood Tracker',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: moodListAsync.when(
              data: (allMoods) {
                final displayMoods = showWeeklyView
                    ? ref.read(moodRepositoryProvider).getRecentMoodEntries(7)
                    : ref.read(moodRepositoryProvider).getRecentMoodEntries(30);

                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Average Mood Card
                      if (allMoods.isNotEmpty) ...[
                        _buildAverageMoodCard(averageMood, isDark),
                        const SizedBox(height: 16),
                      ],

                      // Chart Section
                      _buildChartSection(displayMoods, isDark),
                      const SizedBox(height: 24),

                      // Mood History Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Riwayat Mood',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                          if (allMoods.isNotEmpty)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${allMoods.length} entri',
                                style: TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Mood History List
                      if (allMoods.isEmpty)
                        _buildEmptyState(isDark)
                      else
                        ...allMoods.map((mood) => _buildMoodItem(mood, isDark)),

                      const SizedBox(height: 80), // Space for FAB
                    ],
                  ),
                );
              },
              loading: () => const SizedBox(
                height: 400,
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (error, stack) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showMoodEntryDialog,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Catat Mood'),
      ),
    );
  }

  Widget _buildAverageMoodCard(double avgMood, bool isDark) {
    final emoji = MoodEntry.getEmojiForLevel(avgMood.round());

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryBlue.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(emoji, style: const TextStyle(fontSize: 36)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Rata-rata Mood (7 Hari)',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    avgMood.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                avgMood >= 3
                    ? Icons.trending_up_rounded
                    : Icons.trending_down_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(List<MoodEntry> moods, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trend Mood',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
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
                style: ButtonStyle(visualDensity: VisualDensity.compact),
              ),
            ],
          ),
          const SizedBox(height: 16),
          MoodChartWidget(
            moodEntries: moods,
            daysToShow: showWeeklyView ? 7 : 30,
          ),
        ],
      ),
    );
  }

  Widget _buildMoodItem(MoodEntry mood, bool isDark) {
    final dateFormat = DateFormat('EEEE, dd MMM yyyy');
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getMoodColor(mood.moodLevel).withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(mood.moodEmoji, style: const TextStyle(fontSize: 26)),
          ),
        ),
        title: Text(
          mood.moodDescription,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 12,
                  color: Colors.grey[500],
                ),
                const SizedBox(width: 4),
                Text(
                  '${dateFormat.format(mood.timestamp)} • ${timeFormat.format(mood.timestamp)}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
            if (mood.note != null && mood.note!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                mood.note!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
            if (mood.tags.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: mood.tags.map((tag) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      tag,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.primaryBlue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete_outline_rounded,
            color: isDark ? Colors.grey[500] : Colors.grey[400],
          ),
          onPressed: () => _deleteMood(mood, isDark),
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mood_rounded,
              size: 48,
              color: AppColors.primaryBlue.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Belum Ada Catatan Mood',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Mulai catat mood harian kamu dengan\nmenekan tombol di bawah',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDark ? Colors.grey[400] : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Color _getMoodColor(int moodLevel) {
    switch (moodLevel) {
      case 5:
        return const Color(0xFF10B981);
      case 4:
        return const Color(0xFF34D399);
      case 3:
        return const Color(0xFFF59E0B);
      case 2:
        return const Color(0xFFF97316);
      case 1:
        return const Color(0xFFEF4444);
      default:
        return Colors.grey;
    }
  }

  void _showMoodEntryDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: const MoodEntryDialog(),
      ),
    );
  }

  void _deleteMood(MoodEntry mood, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.delete_rounded, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Text('Hapus Mood'),
          ],
        ),
        content: const Text(
          'Apakah Anda yakin ingin menghapus catatan mood ini?',
        ),
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
                  SnackBar(
                    content: const Text('Mood berhasil dihapus'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
