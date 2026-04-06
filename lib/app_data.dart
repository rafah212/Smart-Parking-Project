import 'package:flutter/material.dart';

class AppData {
  static bool isArabic = false; //اذا ابي التطبيق يبدأ معي بالعربي احطه true

  // بيانات الحجز اللي بتطلع في التذكرة والتايمر
  static String selectedLocation = isArabic ? "كلية العلوم والآداب" : "College of Science & Arts"; 
  static String selectedSlot = "A5";
  static String selectedVehicle = isArabic ? "سيدان" : "Sedan";
  static DateTime selectedDate = DateTime.now();
  static int durationHours = 4;

  // دالة المترجم
  static String translate(String en, String ar) {
    return isArabic ? ar : en;
  }

  // دالة إعادة التشغيل
  static void restartApp(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}