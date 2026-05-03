import 'package:flutter/material.dart';

class AppData {
  static bool isArabic = false;

  static String? selectedPlaceId;
  static String? selectedSpotId;
  static String? selectedVehicleId;
  static String? currentBookingId;


  static int currentRemainingSeconds = 0; //  التايمر مستمر حتى لو اغلقت الصفحة
  static DateTime selectedDate = DateTime.now();
  static int durationHours = 4;

  static String translate(String en, String ar) {
    return isArabic ? ar : en;
  }

  static void restartApp(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }
}