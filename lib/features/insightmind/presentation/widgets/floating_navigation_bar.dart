import 'package:flutter/material.dart';

class FloatingNavItem {
  final IconData icon;
  final String label;

  FloatingNavItem({required this.icon, required this.label});
}

class FloatingNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final List<FloatingNavItem> items;
  final ValueChanged<int> onItemSelected;

  const FloatingNavigationBar({
    super.key,
    required this.selectedIndex,
    required this.items,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
      height: 70,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onItemSelected(index),
              behavior: HitTestBehavior.opaque,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                   // Inactive Label (Optional, if you want labels for all, 
                   // but image shows label only for active)
                       if (isSelected) 
                        Positioned(
                          bottom: 8,
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      
                      // Active Icon Circle
                      AnimatedPositioned(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOutBack,
                        top: isSelected ? -25 : 0, // Lift up when selected
                        bottom: isSelected ? 25 : 0,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isSelected ? 56 : 40,
                          height: isSelected ? 56 : 40,
                          decoration: BoxDecoration(
                            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                            shape: BoxShape.circle,
                            border: isSelected 
                              ? Border.all(color: isDark ? const Color(0xFF0F172A) : Colors.white, width: 4)
                              : null,
                            boxShadow: isSelected ? [
                              BoxShadow(
                                color: Theme.of(context).primaryColor.withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              )
                            ] : [],
                          ),
                          child: Icon(
                            item.icon,
                            color: isSelected ? Colors.white : Colors.grey.withOpacity(0.6),
                            size: isSelected ? 26 : 24,
                          ),
                        ),
                      ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
