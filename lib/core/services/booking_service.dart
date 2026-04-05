import 'package:parkliapp/features/home/models/booking_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BookingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<BookingItem>> getUserBookings(String userId) async {
    final data = await _supabase
        .from('bookings')
        .select('''
          id,
          user_id,
          place_id,
          spot_id,
          spot_label,
          status,
          booked_at,
          created_at,
          places (
            name
          )
        ''')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((e) => BookingItem.fromJoinedJson(e as Map<String, dynamic>))
        .toList();
  }

  Stream<List<BookingItem>> streamUserBookings(String userId) {
    return _supabase
        .from('bookings')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at')
        .map((rows) {
          final sorted = [...rows];
          sorted.sort((a, b) {
            final aDate = DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
            final bDate = DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
            return bDate.compareTo(aDate);
          });

          return sorted.map((row) {
            return BookingItem(
              id: row['id'] as String,
              userId: row['user_id'] as String,
              placeId: row['place_id'] as String,
              placeName: 'Loading...',
              spotId: row['spot_id'] as String,
              spotLabel: (row['spot_label'] ?? 'Unknown Spot') as String,
              status: (row['status'] ?? 'upcoming') as String,
              bookedAt: row['booked_at'] != null
                  ? DateTime.tryParse(row['booked_at'])
                  : null,
              createdAt: row['created_at'] != null
                  ? DateTime.tryParse(row['created_at'])
                  : null,
            );
          }).toList();
        });
  }

  Future<void> cancelBooking({
    required String bookingId,
    required String spotId,
  }) async {
    await _supabase
        .from('bookings')
        .update({'status': 'cancelled'})
        .eq('id', bookingId);

    await _supabase
        .from('parking_spots')
        .update({'status': 'available'})
        .eq('id', spotId);
  }

  Future<void> completeBooking({
    required String bookingId,
  }) async {
    await _supabase
        .from('bookings')
        .update({'status': 'completed'})
        .eq('id', bookingId);
  }
}