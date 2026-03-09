import 'package:flutter/material.dart';

class OnboardingPage1Content extends StatelessWidget {
  const OnboardingPage1Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        const Positioned(
          left: 24,
          right: 24,
          top: 500,
          child: Text(
            'Find the nearest\nparking spot',
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
          left: 24,
          right: 24,
          top: 595,
          child: Text(
            'Locate available spots instantly\nwherever you are',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
              letterSpacing: 0.04,
            ),
          ),
        ),
      ],
    );
  }
}
