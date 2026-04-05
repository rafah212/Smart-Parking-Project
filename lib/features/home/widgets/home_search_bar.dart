import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class HomeSearchBar extends StatelessWidget {
  final VoidCallback? onTap;

  const HomeSearchBar({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // لضمان أن الأيقونة تظهر على اليمين في العربي واليسار في الإنجليزي
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 46,
          decoration: BoxDecoration(
            color: const Color(0xFFF5FBFC),
            border: Border.all(color: const Color(0x30777777)),
            borderRadius: BorderRadius.circular(22),
          ),
          child: Row(
            children: [
              const SizedBox(width: 14),
              const Icon(Icons.search, color: Color(0xFF8D8D8D), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  AppData.translate('Search', 'بحث'),
                  style: const TextStyle(
                    color: Color(0xFF8D8D8D),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}