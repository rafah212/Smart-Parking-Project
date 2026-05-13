import 'dart:async';
import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/booking_service.dart';
import 'package:parkliapp/features/home/models/booking_item.dart';
import 'package:parkliapp/features/home/home_screen.dart';
import 'package:parkliapp/core/services/app_session_service.dart';
import 'package:intl/intl.dart';
import 'dart:ui' as ui;

class ParkingTimerPage extends StatefulWidget {
  const ParkingTimerPage({super.key});

  @override
  State<ParkingTimerPage> createState() => _ParkingTimerPageState();
}

class _ParkingTimerPageState extends State<ParkingTimerPage> {
  final BookingService _bookingService = BookingService();
  final AppSessionService _appSessionService = AppSessionService();
  List<BookingItem> _activeBookings = [];
  bool _isLoading = true;
  Timer? _globalTimer;

  @override
  void initState() {
    super.initState();
    _loadBookingsFromSupabase();

    // محرك الوقت: يحدّث الشاشة كل ثانية واحدة لجعل الوقت يتحرك
    _globalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _loadBookingsFromSupabase() async {
    final session = await _appSessionService.getCurrentSession();

    if (session == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      return;
    }

    try {
      final all = await _bookingService.getUserBookings(session.userId);

      if (!mounted) return;

      setState(() {
        _activeBookings = all.where((b) => b.status == 'upcoming').toList();
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _globalTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection:
          AppData.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FBFB),
        appBar: AppBar(
          title: Text(AppData.translate('My Active Timers', 'مؤقتات حجوزاتي')),
          backgroundColor: const Color(0xFF195A64),
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () {
              // العودة للهوم ومسح مكدس الصفحات لضمان عدم الرجوع للخلف
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            },
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFF237D8C)))
            : _activeBookings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _activeBookings.length,
                    itemBuilder: (context, index) =>
                        _buildBookingTimerCard(_activeBookings[index]),
                  ),
      ),
    );
  }

  Widget _buildBookingTimerCard(BookingItem booking) {
    final now = DateTime.now();

    // جلب أوقات البداية والنهاية من موديل الحجز
    final startTime = (booking.startTime ?? now).toLocal();
    final endTime = (booking.endTime ?? now).toLocal();

    bool hasStarted = now.isAfter(startTime);
    Duration diff =
        hasStarted ? endTime.difference(now) : startTime.difference(now);

    // إخفاء البطاقة إذا انتهى وقت الحجز بالكامل
    if (hasStarted && diff.inSeconds <= 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
        ],
        border: Border.all(color: const Color(0xFF237D8C).withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // الـ Expanded هنا يمنع مشكلة تداخل النصوص (Overflow) للاسم الطويل
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(booking.placeName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color(0xFF195A64))),
                    const SizedBox(height: 4),
                    Text(
                        '${AppData.translate('Spot', 'موقف')}: ${booking.spotLabel}',
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              // أيقونة التايمر فقط (تم حذف أيقونة التقويم بناءً على طلبك)
              Icon(Icons.timer_outlined,
                  color: hasStarted ? const Color(0xFF237D8C) : Colors.orange),
            ],
          ),
          const Divider(height: 30),
          Column(
            children: [
              Text(
                hasStarted
                    ? AppData.translate('Remaining Time', 'الوقت المتبقي')
                    : AppData.translate('Starts in', 'يبدأ خلال'),
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              // الـ FittedBox يضمن بقاء أرقام التايمر داخل الإطار في جميع أحجام الشاشات
              FittedBox(
                child: Text(
                  _formatDuration(diff),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF195A64),
                      letterSpacing: 1.2,
                      fontFamily: 'monospace'),
                ),
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _subLabel(AppData.translate('Day', 'يوم')),
                  _subLabel(' : '),
                  _subLabel(AppData.translate('Hour', 'ساعة')),
                  _subLabel(' : '),
                  _subLabel(AppData.translate('Min', 'دقيقة')),
                  _subLabel(' : '),
                  _subLabel(AppData.translate('Sec', 'ثانية')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: hasStarted
                  ? (diff.inSeconds / endTime.difference(startTime).inSeconds)
                      .clamp(0.0, 1.0)
                  : 1.0,
              backgroundColor: Colors.grey[100],
              minHeight: 6,
              color: hasStarted ? const Color(0xFF34B5CA) : Colors.orange[200],
            ),
          ),
        ],
      ),
    );
  }

  Widget _subLabel(String text) {
    return Text(text, style: const TextStyle(fontSize: 10, color: Colors.grey));
  }

  String _formatDuration(Duration d) {
    if (d.inSeconds <= 0) return "00 : 00 : 00 : 00";

    int days = d.inDays;
    int hours = d.inHours.remainder(24);
    int minutes = d.inMinutes.remainder(60);
    int seconds = d.inSeconds.remainder(60);

    return "${days.toString().padLeft(2, '0')} : "
        "${hours.toString().padLeft(2, '0')} : "
        "${minutes.toString().padLeft(2, '0')} : "
        "${seconds.toString().padLeft(2, '0')}";
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_off_outlined, size: 80, color: Colors.grey),
          const SizedBox(height: 16),
          Text(
            AppData.translate(
                'No active bookings', 'لا توجد حجوزات نشطة حالياً'),
            style: const TextStyle(color: Colors.grey, fontSize: 16),
          ),
        ],
      ),
    );
  }
}
