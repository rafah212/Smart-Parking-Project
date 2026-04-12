import 'package:flutter/material.dart';
import 'package:parkliapp/features/onboarding/onboarding_screen.dart';

class IntroSequenceScreen extends StatefulWidget {
  const IntroSequenceScreen({super.key});

  @override
  State<IntroSequenceScreen> createState() => _IntroSequenceScreenState();
}

class _IntroSequenceScreenState extends State<IntroSequenceScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoRotation;
  late final Animation<double> _nameOpacity;
  late final Animation<double> _blackCardOpacity;
  late final Animation<Offset> _logoOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 6500),
    );

    // 1) صغير ويثبت شوي
    // 2) يكبر بوضوح
    // 3) يصغر شوي ويرجع يهدأ
    // 4) يثبت قبل الانتقال
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.55,
          end: 0.55,
        ),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.55,
          end: 1.35,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 32,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.35,
          end: 0.90,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.90),
        weight: 30,
      ),
    ]).animate(_controller);

    // 1) مستقيم وثابت
    // 2) يميل أثناء التكبير بشكل أوضح
    // 3) يرجع مستقيم
    // 4) يثبت مستقيم
    _logoRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: 0.0,
        ),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -0.85,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 32,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.85,
          end: 0.0,
        ).chain(CurveTween(curve: Curves.easeInOutCubic)),
        weight: 18,
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.0),
        weight: 30,
      ),
    ]).animate(_controller);

    // يبدأ التحرك بعد ما تكون اللقطة الأولى والثانية أوضح
    _logoOffset = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-82, 0),
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(
          0.68,
          0.84,
          curve: Curves.easeInOutCubic,
        ),
      ),
    );

    _nameOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.84, 1.0, curve: Curves.easeInOut),
    );

    _blackCardOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.84, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: SizedBox(
            width: 375,
            height: 812,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Opacity(
                      opacity: _blackCardOpacity.value,
                      child: Container(
                        color: Colors.black,
                        child: Center(
                          child: Transform.translate(
                            offset: _logoOffset.value,
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: Transform.rotate(
                                angle: _logoRotation.value,
                                child: Image.asset(
                                  'assets/images/intro_logo.png',
                                  width: 64,
                                  height: 64,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _nameOpacity.value,
                      child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF46B8CB), Color(0xFF0A2226)],
                          ),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/images/intro3_logo.png',
                                width: 64,
                                height: 64,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(width: 12),
                              Transform.translate(
                                offset: const Offset(0, 4),
                                child: const Text(
                                  'ParkLi',
                                  style: TextStyle(
                                    fontFamily: 'Nico Moji',
                                    fontSize: 53,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
