import 'package:parkliapp/features/home/models/place.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SavedPlacesService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Place>> getSavedPlaces(String userId) async {
    final savedRows = await _supabase
        .from('saved_places')
        .select('place_id')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    final placeIds = (savedRows as List)
        .map((e) => e['place_id'] as String)
        .toList();

    if (placeIds.isEmpty) return [];

    final placesData = await _supabase
        .from('places')
        .select()
        .inFilter('id', placeIds);

    final spotsData = await _supabase
        .from('parking_spots')
        .select('place_id,status')
        .inFilter('place_id', placeIds);

    final Map<String, int> totalByPlace = {};
    final Map<String, int> availableByPlace = {};

    for (final row in spotsData as List) {
      final placeId = row['place_id'] as String;
      final status = row['status'] as String? ?? 'available';

      totalByPlace[placeId] = (totalByPlace[placeId] ?? 0) + 1;
      if (status == 'available') {
        availableByPlace[placeId] = (availableByPlace[placeId] ?? 0) + 1;
      }
    }

    final places = (placesData as List).map((json) {
      final id = json['id'] as String;
      return Place.fromJson(
        json as Map<String, dynamic>,
        availableSlots: availableByPlace[id] ?? 0,
        totalSlots: totalByPlace[id] ?? 0,
      );
    }).toList();

    places.sort((a, b) {
      return placeIds.indexOf(a.id).compareTo(placeIds.indexOf(b.id));
    });

    return places;
  }

  Future<void> savePlace({
    required String userId,
    required String placeId,
  }) async {
    await _supabase.from('saved_places').upsert({
      'user_id': userId,
      'place_id': placeId,
    });
  }

  Future<void> removeSavedPlace({
    required String userId,
    required String placeId,
  }) async {
    await _supabase
        .from('saved_places')
        .delete()
        .eq('user_id', userId)
        .eq('place_id', placeId);
  }

  Future<bool> isPlaceSaved({
    required String userId,
    required String placeId,
  }) async {
    final data = await _supabase
        .from('saved_places')
        .select('id')
        .eq('user_id', userId)
        .eq('place_id', placeId)
        .limit(1);

    return (data as List).isNotEmpty;
  }
}