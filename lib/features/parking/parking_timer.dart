import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class ParkingTimerPage extends StatefulWidget {
  const ParkingTimerPage({super.key});

  @override
  State<ParkingTimerPage> createState() => _ParkingTimerPageState();
}

class _ParkingTimerPageState extends State<ParkingTimerPage> {
  // بنبدأ بـ 4 ساعات ( تغييره حسب الحاجة)
  int _secondsRemaining = 4 * 60 * 60; 
  final int _totalSeconds = 4 * 60 * 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int totalSeconds) {
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return "${hours.toString().padLeft(2, '0')} : ${minutes.toString().padLeft(2, '0')} : ${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // زر الإغلاق (X) في الأعلى
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // --- الدائرة والتايمر (مثل الصورة) ---
              Stack(
                alignment: Alignment.center,
                children: [
                  // الدائرة الكبيرة الشفافة (الخلفية)
                  Opacity(
                    opacity: 0.1,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                    ),
                  ),
                  
                  // القوس الأبيض (Progress Arc)
                  SizedBox(
                    width: 300,
                    height: 300,
                    child: CustomPaint(
                      painter: TimerPainter(
                        progress: _secondsRemaining / _totalSeconds,
                      ),
                    ),
                  ),

                  // أرقام التايمر
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _formatTime(_secondsRemaining),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 44,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _LabelText(label: 'Hours'),
                          SizedBox(width: 20),
                          _LabelText(label: 'Minutes'),
                          SizedBox(width: 15),
                          _LabelText(label: 'Seconds'),
                        ],
    ),
                    ],
                  ),
                ],
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

// رسم القوس الأبيض المتحرك
class TimerPainter extends CustomPainter {
  final double progress;
  TimerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // رسم القوس (يبدأ من الأعلى -90 درجة)
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width / 2, size.height / 2), radius: size.width / 2),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) => oldDelegate.progress != progress;
}

class _LabelText extends StatelessWidget {
  final String label;
  const _LabelText({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(color: Color(0xFFE2E9FD), fontSize: 14, fontWeight: FontWeight.w400),
    );
  }
}