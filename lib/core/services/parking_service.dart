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

  Future<ParkingSpot?> getSpotById(String spotId) async {
    final data = await _supabase
        .from('parking_spots')
        .select()
        .eq('id', spotId)
        .maybeSingle();

    if (data == null) return null;
    return ParkingSpot.fromJson(data);
  }

  Future<void> updateSpotStatus({
    required String spotId,
    required String status,
  }) async {
    await _supabase
        .from('parking_spots')
        .update({'status': status})
        .eq('id', spotId);
  }

  Future<bool> isSpotAvailable(String spotId) async {
    final data = await _supabase
        .from('parking_spots')
        .select('status')
        .eq('id', spotId)
        .maybeSingle();

    if (data == null) return false;

    final status = (data['status'] as String? ?? 'available').toLowerCase();
    return status == 'available';
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