import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    this.currentIndex = 0,
  });

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFB8B8B8)),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(13),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 5.3,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            isActive: currentIndex == 0,
          ),
          _NavItem(
            icon: Icons.bookmark_rounded,
            label: 'Saved',
            isActive: currentIndex == 1,
          ),
          _NavItem(
            icon: Icons.qr_code_scanner_rounded,
            label: 'Booking',
            isActive: currentIndex == 2,
          ),
          _NavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
            isActive: currentIndex == 3,
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
  });

  final IconData icon;
  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF237D8C);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: activeColor,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: activeColor,
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}