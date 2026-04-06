import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:parkliapp/app.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/features/home/home_screen.dart'; // استيراد المخ
import 'package:parkliapp/features/home/home_screen.dart'; // استيراد صفحة الهوم للعودة لها عند الضغط على زر الإغلاق


class ParkingTimerPage extends StatefulWidget {
  const ParkingTimerPage({super.key});

  @override
  State<ParkingTimerPage> createState() => _ParkingTimerPageState();
}

class _ParkingTimerPageState extends State<ParkingTimerPage> {
  late int _totalSeconds;
  late int _secondsRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // جلب الوقت المختار من AppData (بالساعات) وتحويله لثوانٍ
    _totalSeconds = AppData.durationHours * 3600;
    _secondsRemaining = _totalSeconds;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
          // تحديث القيمة في AppData لكي تظهر القيمة الحقيقية في الهوم
          // AppData.currentRemainingSeconds = _secondsRemaining; // اختياري لو ودك تعرضي الثواني في الهوم
        });
      } else {
        _timer?.cancel();
          setState(() {
            AppData.durationHours = 0; // تحديث الحالة في AppData عند انتهاء الوقت
          });
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
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
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
                // --- زر الإغلاق (X) المعدل ---
                Align(
                  alignment: AppData.isArabic ? Alignment.topRight : Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () {
                        // العودة للصفحة الرئيسية مع بقاء التايمر يعمل في الخلفية
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ),

                const Spacer(flex: 1),

                // --- تصميم الدائرة والتايمر ---
                Stack(
                  alignment: Alignment.center,
                  children: [
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
                    
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: CustomPaint(
                        painter: TimerPainter(
                          progress: _secondsRemaining / _totalSeconds,
                        ),
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatTime(_secondsRemaining),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 44,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _LabelText(label: AppData.translate('Hours', 'ساعات')),
                            const SizedBox(width: 20),
                            _LabelText(label: AppData.translate('Minutes', 'دقائق')),
                            const SizedBox(width: 20),
                            _LabelText(label: AppData.translate('Seconds', 'ثوانٍ')),
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
      ),
    );
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  TimerPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

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
      style: const TextStyle(color: Color(0xFFE2E9FD), fontSize: 13, fontWeight: FontWeight.w500),
    );
  }
}