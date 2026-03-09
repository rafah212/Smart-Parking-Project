import 'package:flutter/material.dart';

class OnboardingPage2Content extends StatelessWidget {
  const OnboardingPage2Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        const Positioned(
          left: 24,
          right: 24,
          top: 500,
          child: Text(
            'Reserve your spot\nin seconds',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF181E2E),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
        ),
        const Positioned(
          left: 55,
          right: 55,
          top: 590,
          child: Text(
            'Book your parking before you arrive\nno waiting, no stress',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
        ),
      ],
    );
  }
}
