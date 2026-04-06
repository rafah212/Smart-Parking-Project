import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkliapp/app_data.dart';
import 'package:parkliapp/core/services/booking_service.dart';
import 'package:parkliapp/features/home/models/booking_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final BookingService _bookingService = BookingService();

  late String selectedTab;
  List<BookingItem> _allBookings = [];
  bool _isLoading = true;
  String? _error;

  StreamSubscription<List<BookingItem>>? _subscription;

  @override
  void initState() {
    super.initState();
    selectedTab = 'Completed';
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
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
      final bookings = await _bookingService.getUserBookings(user.id);

      if (!mounted) return;

      setState(() {
        _allBookings = bookings;
        _isLoading = false;
        _error = null;
      });

      await _subscription?.cancel();
      _subscription = _bookingService.streamUserBookings(user.id).listen((_) async {
        final fresh = await _bookingService.getUserBookings(user.id);

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
        bookingId: booking.id,
        spotId: booking.spotId,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppData.translate(
              'Booking cancelled successfully',
              'تم إلغاء الحجز بنجاح',
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
        ),
      );
    }
  }

  Future<void> _completeBooking(BookingItem booking) async {
    try {
      await _bookingService.completeBooking(
        bookingId: booking.id,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            AppData.translate(
              'Booking marked as completed',
              'تم تحديث الحجز إلى مكتمل',
            ),
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookings = _filteredBookings;

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                      : bookings.isEmpty
                          ? Center(
                              child: Text(
                                selectedTab == 'Upcoming'
                                    ? AppData.translate(
                                        'No upcoming bookings found',
                                        'لا توجد حجوزات قادمة حالياً',
                                      )
                                    : selectedTab == 'Completed'
                                        ? AppData.translate(
                                            'No completed bookings found',
                                            'لا توجد حجوزات مكتملة',
                                          )
                                        : AppData.translate(
                                            'No cancelled bookings found',
                                            'لا توجد حجوزات ملغاة',
                                          ),
                                style: const TextStyle(color: Colors.grey),
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              itemCount: bookings.length,
                              itemBuilder: (context, index) {
                                final booking = bookings[index];

                                return _buildBookingItem(
                                  booking: booking,
                                  onCancel: booking.status == 'upcoming'
                                      ? () => _cancelBooking(booking)
                                      : null,
                                  onComplete: booking.status == 'upcoming'
                                      ? () => _completeBooking(booking)
                                      : null,
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
        gradient: LinearGradient(
          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Text(
            AppData.translate('Booking', 'حجوزاتي'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
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
        border: Border.all(color: const Color(0xFF237D8C)),
      ),
      child: Row(
        children: [
          _buildTabItem('Upcoming', AppData.translate('Upcoming', 'القادمة')),
          _buildTabItem('Completed', AppData.translate('Completed', 'المكتملة')),
          _buildTabItem('Cancelled', AppData.translate('Cancelled', 'الملغاة')),
        ],
      ),
    );
  }

  Widget _buildTabItem(String key, String label) {
    final isSelected = selectedTab == key;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = key;
          });
        },
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF237D8C) : Colors.transparent,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF5A5A5A),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingItem({
    required BookingItem booking,
    VoidCallback? onCancel,
    VoidCallback? onComplete,
  }) {
    final statusColor = booking.status == 'completed'
        ? const Color(0xFF43A048)
        : booking.status == 'cancelled'
            ? Colors.red
            : const Color(0xFF237D8C);

    final statusText = booking.status == 'completed'
        ? AppData.translate('Done', 'مكتمل')
        : booking.status == 'cancelled'
            ? AppData.translate('Cancelled', 'ملغى')
            : AppData.translate('Upcoming', 'قادم');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF237D8C), width: 0.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.placeName,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF414141),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppData.translate('Spot No.', 'رقم الموقف')} ${booking.spotLabel}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB8B8B8),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                statusText,
                style: TextStyle(
                  color: statusColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (booking.status == 'upcoming') ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                    ),
                    child: Text(
                      AppData.translate('Cancel', 'إلغاء'),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onComplete,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF237D8C),
                    ),
                    child: Text(
                      AppData.translate('Complete', 'إنهاء'),
                      style: const TextStyle(color: Colors.white),
                    ),
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