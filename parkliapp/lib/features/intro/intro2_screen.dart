/*import 'package:flutter/material.dart';
import 'intro3_screen.dart';

class Intro2 extends StatefulWidget {
  const Intro2({super.key});

  @override
  State<Intro2> createState() => _Intro2State();
}

class _Intro2State extends State<Intro2> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(_fadeRoute(const Intro3()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF6F6),
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 375,
            height: 812,
            color: Colors.black,
            child: Center(
              child: Image.asset(
                'assets/images/intro_logo.png',
                width: 60,
                height: 60,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }

  PageRouteBuilder _fadeRoute(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}*/
