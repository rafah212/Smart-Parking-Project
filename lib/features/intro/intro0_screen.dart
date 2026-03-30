/*import 'dart:async';
import 'package:flutter/material.dart';
import 'intro1_screen.dart';

class Intro0 extends StatefulWidget {
  const Intro0({super.key});

  @override
 // State<Intro0> createState() => _Intro0State();
}

/*class _Intro0State extends State<Intro0> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(_fadeRoute(const Intro1()));
    });
  }*/

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
      transitionDuration: const Duration(milliseconds: 400), // سرعة الانتقال
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}*/
