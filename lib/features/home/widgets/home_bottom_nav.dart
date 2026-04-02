import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    this.currentIndex = 0,
    required this.onTap,
  });

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(top: BorderSide(color: Color(0xFFB8B8B8), width: 0.5)),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem(0, Icons.home_filled, 'Home'),
          _buildItem(1, Icons.bookmark_rounded, 'Saved'),
          _buildItem(2, Icons.calendar_month_rounded, 'Booking'), // يرسل رقم 2
          _buildItem(3, Icons.person_rounded, 'Profile'),        // يرسل رقم 3
        ],
      ),
    );
  }

  Widget _buildItem(int index, IconData icon, String label) {
    final bool isActive = currentIndex == index;
    final Color color = isActive ? const Color(0xFF237D8C) : const Color(0xFF9E9E9E);

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 26, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}