/*import 'package:flutter/material.dart';

class Intro3 extends StatelessWidget {
  const Intro3({super.key});

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
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF46B8CB), Color(0xFF0A2226)],
                stops: [0.2, 1.0],
              ),
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/intro3_logo.png',
                    height: 64,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(width: 12),
                  
                  Transform.translate(
                    offset: const Offset(0, 4),
                    child: const Text(
                      'ParkLi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 53, 
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Nico Moji',
                      ),
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
}*/
