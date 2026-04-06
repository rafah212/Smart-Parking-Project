import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class OnboardingPage2Content extends StatelessWidget {
  const OnboardingPage2Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          Positioned(
            top: 90,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/onboarding_page2.png',
              height: 360,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 500,
            child: Text(
              AppData.translate(
                'Reserve your spot\nin seconds',
                'احجز موقفك\nفي ثوانٍ معدودة'
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF181E2E),
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.1,
              ),
            ),
          ),
          Positioned(
            left: 55,
            right: 55,
            top: 590,
            child: Text(
              AppData.translate(
                'Book your parking before you arrive\nno waiting, no stress',
                'احجز موقفك قبل وصولك\nبلا انتظار، بلا توتر'
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}