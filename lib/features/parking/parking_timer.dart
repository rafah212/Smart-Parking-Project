import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/features/home/home_screen.dart';

class ParkingTimerPage extends StatefulWidget {
  const ParkingTimerPage({super.key});

  @override
  State<ParkingTimerPage> createState() => _ParkingTimerPageState();
}

class _ParkingTimerPageState extends State<ParkingTimerPage> {
  int _secondsRemaining = 0;
  int _totalSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
  }

  void _initializeTimer() {
    // 1. إذا لم يكن هناك وقت نهاية محدد، اجعل كل شيء أصفاراً
    if (AppData.bookingEndTime == null) {
      setState(() {
        _secondsRemaining = 0;
        _totalSeconds = 0;
      });
      return;
    }

    // 2. احسب إجمالي الثواني بناءً على الساعات المحجوزة للعرض في الدائرة
    _totalSeconds = AppData.durationHours * 3600;

    // 3. تحديث الوقت المتبقي فوراً
    _updateRemainingTime();

    // 4. ابدأ المؤقت الدوري كل ثانية
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateRemainingTime();
      }
    });
  }

  void _updateRemainingTime() {
    if (AppData.bookingEndTime != null) {
      final now = DateTime.now();
      final difference = AppData.bookingEndTime!.difference(now).inSeconds;
      
      setState(() {
        _secondsRemaining = difference > 0 ? difference : 0;
      });

      // إذا انتهى الوقت
      if (_secondsRemaining <= 0) {
        _timer?.cancel();
        _onTimerFinished();
      }
    }
  }

  void _onTimerFinished() {
    if (!AppData.isNotificationShown) {
      debugPrint("Time is up!");
      // هنا تضعين كود الإشعار مستقبلاً
      AppData.isNotificationShown = true; 
    }
    
    setState(() {
      AppData.durationHours = 0;
      AppData.bookingEndTime = null;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatTime(int seconds) {
    if (seconds <= 0) return "00 : 00 : 00";
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return "${h.toString().padLeft(2, '0')} : ${m.toString().padLeft(2, '0')} : ${s.toString().padLeft(2, '0')}";
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
                // زر الإغلاق
                Align(
                  alignment: AppData.isArabic ? Alignment.topRight : Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 30),
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                        (route) => false,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Stack الدائرة والوقت
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // الدائرة الخلفية الباهتة
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
                    // الدائرة المتحركة (الرسم)
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: CustomPaint(
                        painter: TimerPainter(
                          progress: _totalSeconds > 0 ? _secondsRemaining / _totalSeconds : 0,
                        ),
                      ),
                    ),
                    // نصوص الوقت
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
      ..strokeWidth = 8
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