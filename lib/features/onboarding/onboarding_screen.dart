import 'package:flutter/material.dart';

import 'onboarding_page1_content.dart';
import 'onboarding_page2_content.dart';
import 'onboarding_page3_content.dart';
import 'package:parkliapp/features/home/home_screen.dart';
import 'package:parkliapp/features/auth/signup_screen.dart';
import 'package:parkliapp/features/auth/login_phone_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_index < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Container(
            width: 375,
            height: 812,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.10, 0.08),
                end: Alignment(0.91, 0.87),
                colors: [Color(0xFF45B8CB), Color(0xFF0E3339)],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // الصفحات
                  PageView(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _index = i),
                    children: [
                      const OnboardingPage1Content(),
                      const OnboardingPage2Content(),
                      OnboardingPage3Content(
                        onCreateAccount: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignUpScreen(),
                            ),
                          );
                        },
                        onLogin: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginPhoneScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  // Top bar: 1/3 + Skip
                  Positioned(
                    left: 17,
                    right: 17,
                    top: 16,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '${_index + 1}',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const TextSpan(
                                text: '/3',
                                style: TextStyle(
                                  color: Color(0x7F0F3339),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: _skip,
                          child: const Text(
                            'Skip',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Bottom controls (dots + Next) - نخفيها في الصفحة الأخيرة (عشان فيها أزرار)
                  if (_index != 2)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 24,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _Pill(isActive: _index == 0),
                          const SizedBox(width: 10),
                          _Dot(isActive: _index == 1),
                          const SizedBox(width: 10),
                          _Dot(isActive: _index == 2),
                          const SizedBox(width: 60),
                          GestureDetector(
                            onTap: _goNext,
                            child: const Text(
                              'Next',
                              style: TextStyle(
                                color: Color(0xFF2E4154),
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF72ACB6) : const Color(0xB23A455D),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: isActive ? 40 : 10,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF72ACB6) : const Color(0xB23A455D),
        borderRadius: BorderRadius.circular(100),
      ),
    );
  }
}
