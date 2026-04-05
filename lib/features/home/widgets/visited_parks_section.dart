import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'parking_card.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class VisitedParksSection extends StatelessWidget {
  final List<Place> visitedPlaces;

  const VisitedParksSection({
    super.key,
    required this.visitedPlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // تحديد الاتجاه بناءً على اللغة المختار في AppData
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان الرئيسي للقسم
            Text(
              AppData.translate('Your most visited car parks', 'أكثر المواقف زيارة'),
              style: const TextStyle(
                color: Color(0xFF1E7280),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            
            // حالة إذا كانت القائمة فارغة
            if (visitedPlaces.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5FBFC),
                  border: Border.all(color: const Color(0x30777777)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  AppData.translate(
                    'No parking matches your filter', 
                    'لا توجد مواقف تطابق بحثك حالياً'
                  ),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF677191),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else
              // عرض قائمة المواقف المختارة
              ...List.generate(visitedPlaces.length, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == visitedPlaces.length - 1 ? 0 : 14,
                  ),
                  child: ParkingCard(place: visitedPlaces[index]),
                );
              }),
          ],
        ),
      ),
    );
  }
}