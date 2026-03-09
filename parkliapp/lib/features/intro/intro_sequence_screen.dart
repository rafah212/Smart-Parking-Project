import 'package:flutter/material.dart';
import '../pages/page1_screen.dart';
import '../../core/widgets/responsive_preview.dart';
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
  // late final Animation<Offset> _logoOffset;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000), // 5 ثواني كاملة
    );

    // 0.0 → 0.2 : صغير
    // 0.2 → 0.4 : يكبر
    // 0.4 → 0.6 : يصغر شوي
    // 0.6 → 1.0 : يثبت
    _logoScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20, // 0% - 20%
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.0,
          end: 1.3,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 20, // 20% - 40%
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.3,
          end: 0.9,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20, // 40% - 60%
      ),
      TweenSequenceItem(
        tween: ConstantTween(0.9),
        weight: 40, // 60% - 100%
      ),
    ]).animate(_controller);

    _logoRotation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.0,
          end: -0.8,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 30, // 0% - 30%
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: -0.8,
          end: -0.2,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30, // 30% - 60%
      ),
      TweenSequenceItem(
        tween: ConstantTween(-0.2),
        weight: 40, // 60% - 100%
      ),
    ]).animate(_controller);

    _nameOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
    );

    _blackCardOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (!mounted) return;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const Page1Screen()),
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
      body: ResponsivePreview(
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
                          child: Transform.scale(
                            scale: _logoScale.value,
                            child: Transform.rotate(
                              angle: _logoRotation.value,
                              child: Image.asset(
                                'assets/images/intro_logo.png', // شعار
                                width: 64,
                                height: 64,
                                fit: BoxFit.contain,
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
                                'assets/images/intro3_logo.png', // شعار مع الاسم
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
        );
     }
   }
