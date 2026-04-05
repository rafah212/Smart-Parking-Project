import 'dart:async';

import 'package:flutter/material.dart';
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

  String selectedTab = 'Upcoming';
  List<BookingItem> _allBookings = [];
  bool _isLoading = true;
  String? _error;

  StreamSubscription<List<BookingItem>>? _subscription;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      setState(() {
        _error = 'You need to log in first';
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

      _subscription?.cancel();
      _subscription = _bookingService.streamUserBookings(user.id).listen((rows) async {
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
    final tab = selectedTab.toLowerCase();

    return _allBookings.where((booking) {
      if (tab == 'upcoming') return booking.status == 'upcoming';
      if (tab == 'completed') return booking.status == 'completed';
      if (tab == 'cancelled') return booking.status == 'cancelled';
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
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Booking cancelled successfully'),
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
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Booking marked as completed'),
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

    return Scaffold(
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
                                  ? 'No upcoming bookings found'
                                  : selectedTab == 'Completed'
                                      ? 'No completed bookings found'
                                      : 'No cancelled bookings found',
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
      child: const Center(
        child: Padding(
          padding: EdgeInsets.only(top: 30),
          child: Text(
            'Booking',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: 'Poppins',
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
          _buildTabItem('Upcoming'),
          _buildTabItem('Completed'),
          _buildTabItem('Cancelled'),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label) {
    final isSelected = selectedTab == label;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = label;
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
              fontFamily: 'Poppins',
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
        ? 'Done'
        : booking.status == 'cancelled'
            ? 'Cancelled'
            : 'Upcoming';

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
                      'Spot No.${booking.spotLabel}',
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
                    child: const Text(
                      'Cancel',
                      style: TextStyle(color: Colors.red),
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
                    child: const Text(
                      'Complete',
                      style: TextStyle(color: Colors.white),
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