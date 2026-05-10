import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/booking_service.dart';
import 'package:parkliapp/features/home/models/booking_item.dart';
import 'package:parkliapp/core/services/app_session_service.dart';
import 'dart:ui' as ui;

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingService _bookingService = BookingService();
  final AppSessionService _appSessionService = AppSessionService();

  late String selectedTab;
  List<BookingItem> _allBookings = [];
  bool _isLoading = true;
  String? _error;

  StreamSubscription<List<BookingItem>>? _subscription;

  @override
  void initState() {
    super.initState();
    selectedTab = 'Upcoming'; // تغيير الافتراضي للقادمة
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final session = await _appSessionService.getCurrentSession();

    if (session == null) {
      setState(() {
        _error = AppData.translate(
          'You need to log in first',
          'يجب تسجيل الدخول أولاً',
        );
        _isLoading = false;
      });
      return;
    }

    try {
      final bookings = await _bookingService.getUserBookings(session.userId);

      if (!mounted) return;
      setState(() {
        _allBookings = bookings;
        _isLoading = false;
        _error = null;
      });

      await _subscription?.cancel();
      _subscription =
          _bookingService.streamUserBookings(session.userId).listen((fresh) {
        if (!mounted) return;
        setState(() {
          _allBookings = fresh;
        });
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  List<BookingItem> get _filteredBookings {
    return _allBookings.where((booking) {
      if (selectedTab == 'Upcoming') return booking.status == 'upcoming';
      if (selectedTab == 'Completed') return booking.status == 'completed';
      if (selectedTab == 'Cancelled') return booking.status == 'cancelled';
      return false;
    }).toList();
  }

  Future<void> _cancelBooking(BookingItem booking) async {
    try {
      await _bookingService.cancelBooking(
          bookingId: booking.id, spotId: booking.spotId);
      _loadBookings(); // تحديث القائمة
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _completeBooking(BookingItem booking) async {
    try {
      await _bookingService.completeBooking(bookingId: booking.id);
      _loadBookings(); // تحديث القائمة
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookings = _filteredBookings;
    return Directionality(
      textDirection:
          AppData.isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildTabSwitcher(),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator(color: Color(0xFF237D8C)))
                  : _error != null
                      ? Center(child: Text(_error!))
                      : bookings.isEmpty
                          ? Center(
                              child: Text(AppData.translate(
                                  'No bookings found', 'لا توجد حجوزات')))
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              itemCount: bookings.length,
                              itemBuilder: (context, index) {
                                return _buildBookingItem(
                                  booking: bookings[index],
                                  onCancel: () =>
                                      _cancelBooking(bookings[index]),
                                  onComplete: () =>
                                      _completeBooking(bookings[index]),
                                );
                              },
                            ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 100,
      decoration: const BoxDecoration(
        gradient:
            LinearGradient(colors: [Color(0xFF195A64), Color(0xFF34B5CA)]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(AppData.translate('My Bookings', 'حجوزاتي'),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildTabSwitcher() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      height: 48,
      decoration: BoxDecoration(
        color: const Color(0xFFECF5F6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF237D8C).withOpacity(0.3)),
      ),
      child: Row(
        children: [
          _buildTabItem('Upcoming', AppData.translate('Upcoming', 'القادمة')),
          _buildTabItem(
              'Completed', AppData.translate('Completed', 'المكتملة')),
          _buildTabItem('Cancelled', AppData.translate('Cancelled', 'الملغاة')),
        ],
      ),
    );
  }

  Widget _buildTabItem(String key, String label) {
    final isSelected = selectedTab == key;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = key),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF237D8C) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(label,
              style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF5A5A5A),
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildBookingItem(
      {required BookingItem booking,
      VoidCallback? onCancel,
      VoidCallback? onComplete}) {
    final statusColor = booking.status == 'completed'
        ? Colors.green
        : booking.status == 'cancelled'
            ? Colors.red
            : const Color(0xFF237D8C);

    String formattedDate = booking.startTime != null
        ? DateFormat('yyyy-MM-dd').format(booking.startTime!)
        : '---';
    String formattedTime = booking.startTime != null && booking.endTime != null
        ? '${DateFormat('hh:mm a').format(booking.startTime!)} - ${DateFormat('hh:mm a').format(booking.endTime!)}'
        : '---';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // التعديل هنا: Expanded يمنع الـ Overflow ويسمح للاسم بالنزول لسطر ثاني
              Expanded(
                child: Text(
                  booking.placeName,
                  style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF195A64)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                booking.status == 'upcoming'
                    ? AppData.translate('Upcoming', 'قادم')
                    : (booking.status == 'completed'
                        ? AppData.translate('Done', 'مكتمل')
                        : AppData.translate('Cancelled', 'ملغى')),
                style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.location_on, size: 14, color: Colors.grey),
              const SizedBox(width: 5),
              Text('${AppData.translate('Spot', 'موقف')}: ${booking.spotLabel}',
                  style: const TextStyle(fontSize: 13, color: Colors.grey)),
            ],
          ),
          const Divider(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                const Icon(Icons.calendar_today,
                    size: 14, color: Color(0xFF237D8C)),
                const SizedBox(width: 5),
                Text(formattedDate, style: const TextStyle(fontSize: 12))
              ]),
              Row(children: [
                const Icon(Icons.access_time,
                    size: 14, color: Color(0xFF237D8C)),
                const SizedBox(width: 5),
                Text(formattedTime, style: const TextStyle(fontSize: 12))
              ]),
            ],
          ),
          if (booking.status == 'upcoming') ...[
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(AppData.translate('Cancel', 'إلغاء'),
                        style: const TextStyle(color: Colors.red)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF237D8C),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8))),
                    child: Text(AppData.translate('Complete', 'إنهاء'),
                        style: const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
