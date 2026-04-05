import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class SavedParking extends StatelessWidget {
  const SavedParking({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          // الهيدر العلوي
          Container(
            width: double.infinity,
            height: 100,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  AppData.translate('Saved', 'المحفوظة'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // قائمة الكروت المحفوظة
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              children: [
                _buildSavedCard(
                  AppData.translate('College of Science & Arts-Lot 2', 'كلية العلوم والآداب - موقف ٢'),
                  '${AppData.translate('Spot No.', 'رقم الموقف')} A01',
                ),
                const SizedBox(height: 16),
                _buildSavedCard(
                  AppData.translate('Warf Farm Parking -Area 2', 'مواقف مزرعة وارف - منطقة ٢'),
                  '${AppData.translate('Spot No.', 'رقم الموقف')} B02',
                ),
                const SizedBox(height: 16),
                _buildSavedCard(
                  AppData.translate('Jada Al-Nakheel Parking - Area 1', 'مواقف جادة النخيل - منطقة ١'),
                  '${AppData.translate('Spot No.', 'رقم الموقف')} A04',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ويدجيت الكارت المحدث
  Widget _buildSavedCard(String title, String subtitle) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCFD),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF237D8C), width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF414141),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFB8B8B8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.star,
            color: Color(0xFF237D8C),
            size: 24,
          ),
        ],
      ),
    );
  }
}