import 'package:parkliapp/features/home/models/booking_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:parkliapp/app_data.dart';
class BookingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<BookingItem>> getUserBookings(String userId) async {
    final data = await _supabase.from('bookings').select('''
          id,
          user_id,
          place_id,
          spot_id,
          spot_label,
          status,
          booked_at,
          created_at,
          start_time,
          end_time,
          places (
            name,
            name_ar
          )
        ''').eq('user_id', userId).order('created_at', ascending: false);

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
            final aDate =
                DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
            final bDate =
                DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
            return bDate.compareTo(aDate);
          });

          return sorted.map((row) {
            return BookingItem(
              id: row['id'] as String,
              userId: row['user_id'] as String,
              placeId: row['place_id'] as String,
              placeName: 'Loading...',
              placeNameAr: 'جارٍ التحميل...',
              spotId: row['spot_id'] as String,
              spotLabel: (row['spot_label'] ?? 'Unknown Spot') as String,
              status: (row['status'] ?? 'upcoming') as String,
              bookedAt: row['booked_at'] != null
                  ? DateTime.tryParse(row['booked_at'])?.toLocal()
                  : null,
              createdAt: row['created_at'] != null
                  ? DateTime.tryParse(row['created_at'])?.toLocal()
                  : null,
              startTime: row['start_time'] != null
                  ? DateTime.tryParse(row['start_time'])?.toLocal()
                  : null,
              endTime: row['end_time'] != null
                  ? DateTime.tryParse(row['end_time'])?.toLocal()
                  : null,
            );
          }).toList();
        });
  }

  Future<String> createBooking({
    required String userId,
    required String placeId,
    required String spotId,
    required String spotLabel,
    required DateTime bookedAt,
    DateTime? startTime,
    DateTime? endTime,
  }) async {
    final updatedSpot = await _supabase
        .from('parking_spots')
        .update({'status': 'booked'})
        .eq('id', spotId)
        .eq('status', 'available')
        .select();

    if ((updatedSpot as List).isEmpty) {
      throw Exception('This parking spot has already been booked');
    }

    final inserted = await _supabase
        .from('bookings')
        .insert({
          'user_id': userId,
          'place_id': placeId,
          'spot_id': spotId,
          'spot_label': spotLabel,
          'status': 'upcoming',
          'booked_at': bookedAt.toUtc().toIso8601String(),
          'start_time': startTime?.toUtc().toIso8601String(),
          'end_time': endTime?.toUtc().toIso8601String(),
        })
        .select('id')
        .single();

    return inserted['id'] as String;
  }

  Future<Map<String, dynamic>?> getBookingById(String bookingId) async {
    final data = await _supabase.from('bookings').select('''
          id,
          user_id,
          place_id,
          spot_id,
          spot_label,
          status,
          booked_at,
          created_at,
          start_time,
          end_time,
          places (
            name,
            price_label,
            distance_km
          )
        ''').eq('id', bookingId).maybeSingle();

    return data;
  }

  Future<void> cancelBooking({
    required String bookingId,
    required String spotId,
  }) async {
    await _supabase
        .from('bookings')
        .update({'status': 'cancelled'}).eq('id', bookingId);

    await _supabase
        .from('parking_spots')
        .update({'status': 'available'}).eq('id', spotId);
  }

  Future<void> completeBooking({
    required String bookingId,
  }) async {
    await _supabase
        .from('bookings')
        .update({'status': 'completed'}).eq('id', bookingId);
  }

  Future<void> extendBooking({
    required String bookingId,
    required DateTime newEndTime,
  }) async {
    await _supabase.from('bookings').update({
      'end_time': newEndTime.toUtc().toIso8601String(),
    }).eq('id', bookingId);
  }

  Future<void> createNotification({
  required String userId,
  required String titleEn,
  required String titleAr,
  required String bodyEn,
  required String bodyAr,
}) async {
  await _supabase.from('notifications').insert({
    'user_id': userId,
    'title': AppData.translate(titleEn, titleAr),
    'body': AppData.translate(bodyEn, bodyAr),
    'created_at': DateTime.now().toUtc().toIso8601String(),
  });
}
}
