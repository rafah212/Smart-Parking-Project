import 'package:flutter/material.dart';

class HomeBottomNav extends StatelessWidget {
  const HomeBottomNav({
    super.key,
    this.currentIndex = 0,
    required this.onTap, // أضفنا هذا السطر لاستقبال وظيفة النقر
  });

  final int currentIndex;
  final Function(int) onTap; // تعريف دالة النقر

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
          // قمنا بتغليف كل عنصر بـ GestureDetector ليصبح قابلاً للنقر
          _buildItem(0, Icons.home_rounded, 'Home'),
          _buildItem(1, Icons.bookmark_rounded, 'Saved'),
          _buildItem(2, Icons.qr_code_scanner_rounded, 'Booking'),
          _buildItem(3, Icons.person_outline_rounded, 'Profile'),
        ],
      ),
    );
  }

  // دالة مساعدة لبناء العناصر وجعلها ترسل رقمها عند النقر
  Widget _buildItem(int index, IconData icon, String label) {
    return GestureDetector(
      onTap: () => onTap(index), // عند النقر، نرسل رقم العنصر للهوم سكرين
      behavior: HitTestBehavior.opaque, // لجعل منطقة النقر واسعة وسهلة
      child: _NavItem(
        icon: icon,
        label: label,
        isActive: currentIndex == index,
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
    // جعلنا اللون يتغير بناءً على حالة النشاط (نشط = أزرق، غير نشط = رمادي)
    final Color color = isActive ? const Color(0xFF237D8C) : const Color(0xFFB8B8B8);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 24,
          color: color, // استخدام اللون المتغير
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color, // استخدام اللون المتغير
            fontSize: 12,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}