import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../data/local/mood_entry.dart';

class MoodChartWidget extends StatelessWidget {
  final List<MoodEntry> moodEntries;
  final int daysToShow;

  const MoodChartWidget({
    super.key,
    required this.moodEntries,
    this.daysToShow = 7,
  });

  @override
  Widget build(BuildContext context) {
    if (moodEntries.isEmpty) {
      return Card(
        child: Container(
          height: 250,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 12),
              Text(
                'Belum ada data mood',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 4),
              Text(
                'Mulai catat mood harian kamu!',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mood Trend',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: LineChart(
                _createChartData(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _createChartData() {
    // Get data points from mood entries
    final spots = <FlSpot>[];
    final now = DateTime.now();
    final startDate = now.subtract(Duration(days: daysToShow - 1));

    // Create a map of date to mood level
    final dateToMood = <String, List<int>>{};
    for (var entry in moodEntries) {
      if (entry.timestamp.isAfter(startDate.subtract(const Duration(days: 1)))) {
        final dateKey = DateFormat('yyyy-MM-dd').format(entry.timestamp);
        dateToMood.putIfAbsent(dateKey, () => []).add(entry.moodLevel);
      }
    }

    // Create spots for each day
    for (int i = 0; i < daysToShow; i++) {
      final date = startDate.add(Duration(days: i));
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      
      if (dateToMood.containsKey(dateKey)) {
        // Average mood for this day if multiple entries
        final moods = dateToMood[dateKey]!;
        final avgMood = moods.reduce((a, b) => a + b) / moods.length;
        spots.add(FlSpot(i.toDouble(), avgMood));
      }
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.grey.withOpacity(0.2),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: (value, meta) {
              final date = startDate.add(Duration(days: value.toInt()));
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  DateFormat('dd').format(date),
                  style: const TextStyle(fontSize: 10),
                ),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              if (value >= 1 && value <= 5) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 10),
                );
              }
              return const Text('');
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      minX: 0,
      maxX: (daysToShow - 1).toDouble(),
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              Colors.indigo.withOpacity(0.5),
              Colors.indigo,
            ],
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: _getMoodColor(spot.y),
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                Colors.indigo.withOpacity(0.1),
                Colors.indigo.withOpacity(0.05),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      lineTouchData: LineTouchData(
        enabled: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final date = startDate.add(Duration(days: spot.x.toInt()));
              return LineTooltipItem(
                '${DateFormat('dd MMM').format(date)}\n',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: '${MoodEntry.getEmojiForLevel(spot.y.round())} ${spot.y.toStringAsFixed(1)}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }

  Color _getMoodColor(double mood) {
    if (mood >= 4.5) return Colors.green;
    if (mood >= 3.5) return Colors.lightGreen;
    if (mood >= 2.5) return Colors.orange;
    if (mood >= 1.5) return Colors.deepOrange;
    return Colors.red;
  }
}
