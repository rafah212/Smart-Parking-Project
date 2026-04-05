import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class OnboardingPage1Content extends StatelessWidget {
  const OnboardingPage1Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Stack(
        children: [
          Positioned(
            top: 140,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/onboarding_page1.png',
              height: 290,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            top: 500,
            child: Text(
              AppData.translate(
                'Find the nearest\nparking spot',
                'ابحث عن أقرب\nموقف سيارات'
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
            left: 24,
            right: 24,
            top: 595,
            child: Text(
              AppData.translate(
                'Locate available spots instantly\nwherever you are',
                'حدد المواقع المتاحة فوراً\nأينما كنت'
              ),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white, // رجعناها أبيض نفس كودك الأصلي
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 1.3,
                letterSpacing: 0.04,
              ),
            ),
          ),
        ],
      ),
    );
  }
}