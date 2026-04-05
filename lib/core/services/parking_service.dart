import 'package:parkliapp/features/home/models/parking_spot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParkingService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<ParkingSpot>> getSpotsByPlace(String placeId) async {
    final data = await _supabase
        .from('parking_spots')
        .select()
        .eq('place_id', placeId)
        .order('section')
        .order('row')
        .order('column_no');

    return (data as List)
        .map((e) => ParkingSpot.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> bookSpot({
    required String userId,
    required ParkingSpot spot,
  }) async {
    final updated = await _supabase
        .from('parking_spots')
        .update({'status': 'booked'})
        .eq('id', spot.id)
        .eq('status', 'available')
        .select();

    if ((updated as List).isEmpty) {
      throw Exception('This parking spot has already been booked');
    }

    await _supabase.from('bookings').insert({
      'user_id': userId,
      'place_id': spot.placeId,
      'spot_id': spot.id,
      'spot_label': spot.label,
      'status': 'upcoming',
    });
  }

  Stream<List<ParkingSpot>> streamSpotsByPlace(String placeId) {
    return _supabase
        .from('parking_spots')
        .stream(primaryKey: ['id'])
        .eq('place_id', placeId)
        .map(
          (rows) => rows.map((row) => ParkingSpot.fromJson(row)).toList()
            ..sort((a, b) {
              final sectionCompare = a.section.compareTo(b.section);
              if (sectionCompare != 0) return sectionCompare;

              final rowCompare = a.row.compareTo(b.row);
              if (rowCompare != 0) return rowCompare;

              return a.column.compareTo(b.column);
            }),
        );
  }
}
