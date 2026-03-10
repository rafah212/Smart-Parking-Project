import 'package:flutter/material.dart';

class OnboardingPage3Content extends StatelessWidget {
  const OnboardingPage3Content({super.key, this.onCreateAccount, this.onLogin});

  final VoidCallback? onCreateAccount;
  final VoidCallback? onLogin;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 90,
          left: 0,
          right: 0,
          child: Image.asset(
            'assets/images/onboarding_page3.png',
            height: 300,
            fit: BoxFit.contain,
          ),
        ),
        const Positioned(
          left: 24,
          right: 24,
          top: 440,
          child: Text(
            'Navigate smartly\n& park with ease',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF181E2E),
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
        ),
        const Positioned(
          left: 55,
          right: 55,
          top: 520,
          child: Text(
            'Use real-time guidance to reach\nyour reserved spot smoothly',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.3,
            ),
          ),
        ),

        // Buttons
        Positioned(
          left: 32,
          right: 32,
          bottom: 110,
          child: _PrimaryButton(
            text: 'Create a new account',
            onTap: onCreateAccount,
          ),
        ),
        Positioned(
          left: 32,
          right: 32,
          bottom: 50,
          child: _SecondaryButton(text: 'log in', onTap: onLogin),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.text, this.onTap});
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 42,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF72ACB6),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({required this.text, this.onTap});
  final String text;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFF0B2B31),
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x26000000),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
