import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Inter', // غيريه لو بتستخدمين خط ثاني
    );
  }
}