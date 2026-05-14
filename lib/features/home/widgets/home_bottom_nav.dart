import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; 

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
    return Directionality(
      // تحديد اتجاه الشريط بناءً على اللغة
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Container(
        height: 72,
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFB8B8B8), width: 0.5)),
          borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildItem(0, Icons.home_filled, AppData.translate('Home', 'الرئيسية')),
            _buildItem(1, Icons.bookmark_rounded, AppData.translate('Saved', 'المحفوظة')),
            _buildItem(2, Icons.calendar_month_rounded, AppData.translate('Booking', 'الحجوزات')),
            _buildItem(3, Icons.person_rounded, AppData.translate('Profile', 'حسابي')),
          ],
        ),
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
              textAlign: TextAlign.center,
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