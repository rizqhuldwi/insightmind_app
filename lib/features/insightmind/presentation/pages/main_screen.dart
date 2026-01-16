import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../src/app_themes.dart';
import 'home_page.dart';
import 'history_page.dart';
import 'profile_page.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const HistoryPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomBar(isDark),
    );
  }

  Widget _buildBottomBar(bool isDark) {
    return Container(
      height: 110,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // The main bar
          Container(
            height: 70,
            margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Home', isDark),
                _buildNavItem(1, Icons.history_rounded, 'Riwayat', isDark),
                _buildNavItem(2, Icons.person_rounded, 'Profil', isDark),
              ],
            ),
          ),
          
          // Floating Circle Indicating Active Tab
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            left: _getCirclePosition(MediaQuery.of(context).size.width),
            bottom: 45, // Lifted above the bar
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Center(
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForIndex(_currentIndex),
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  double _getCirclePosition(double screenWidth) {
    // Width of bar = screenWidth - 40 (margins)
    // There are 3 items, so each item space = (screenWidth - 40) / 3
    // We want the circle center to align with item center
    final barWidth = screenWidth - 40;
    final itemWidth = barWidth / 3;
    final margin = 20.0;
    
    // Position = margin + (index * itemWidth) + (itemWidth/2) - (circleWidth/2)
    return margin + (_currentIndex * itemWidth) + (itemWidth / 2) - 28;
  }

  IconData _getIconForIndex(int index) {
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.history_rounded;
      case 2: return Icons.person_rounded;
      default: return Icons.home_rounded;
    }
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _currentIndex == index;
    final color = isSelected ? Colors.transparent : (isDark ? Colors.grey[400] : Colors.grey[600]);

    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: (MediaQuery.of(context).size.width - 40) / 3,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 25), // Space for circle
            Opacity(
              opacity: isSelected ? 0 : 1,
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 4),
            Text(
              isSelected ? label : '', // Only show label if selected, or vice versa?
              // In the reference, labels are shown below.
              // Actually, let's show labels only for non-selected or keep it consistent.
              style: TextStyle(
                color: isSelected ? AppColors.primaryBlue : color,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
