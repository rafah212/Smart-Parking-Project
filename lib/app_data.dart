import 'package:flutter/material.dart';

class AppData {
  static bool isArabic = false;

  static String? selectedPlaceId;
  static String? selectedSpotId;
  static String? selectedVehicleId;
  static String? currentBookingId;

  static DateTime selectedDate = DateTime.now();
  static String? selectedTime; //n
  static int durationHours = 1; 

  
  static DateTime? bookingEndTime; 
  
  static bool isNotificationShown = false;


  static String translate(String en, String ar) {
    return isArabic ? ar : en;
  }

  static void restartApp(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
  }

  static void setNewBooking(int hours) {
    durationHours = hours;
    bookingEndTime = DateTime.now().add(Duration(hours: hours));
    isNotificationShown = false;
  }
}