import 'package:parkliapp/features/home/models/place.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlaceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  String _normalizeAssetPath(dynamic rawPath) {
    final value = (rawPath ?? '').toString().trim();

    if (value.isEmpty) {
      return 'assets/images/explore_placeholder.png';
    }

    if (value.startsWith('assets/')) {
      return value;
    }

    return 'assets/images/$value';
  }

  Future<List<Place>> getAllPlaces() async {
    final placesData = await _supabase
        .from('places')
        .select()
        .order('distance_km')
        .order('name');

    final spotsData =
        await _supabase.from('parking_spots').select('place_id,status');

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

    return (placesData as List).map((row) {
      final json = Map<String, dynamic>.from(row as Map);
      final id = json['id'] as String;

      json['image_path'] = _normalizeAssetPath(json['image_path']);

      return Place.fromJson(
        json,
        availableSlots: availableByPlace[id] ?? 0,
        totalSlots: totalByPlace[id] ?? 0,
      );
    }).toList();
  }

  Future<List<Place>> getPlacesByCategoryGroup(String groupKey) async {
    final allPlaces = await getAllPlaces();

    return allPlaces.where((place) {
      switch (groupKey) {
        case 'hospitals':
          return place.category == 'hospital';

        case 'university':
          return place.category == 'college';

        case 'shopping':
          return place.category == 'mall' || place.category == 'shopping';

        case 'cafesAndFarms':
          return place.category == 'farm' ||
              place.category == 'cafe' ||
              place.category == 'boulevard' ||
              place.category == 'public_place';

        default:
          return false;
      }
    }).toList();
  }

  Future<Place?> getPlaceById(String placeId) async {
    final data =
        await _supabase.from('places').select().eq('id', placeId).maybeSingle();

    if (data == null) return null;

    final spotsData = await _supabase
        .from('parking_spots')
        .select('place_id,status')
        .eq('place_id', placeId);

    int total = 0;
    int available = 0;

    for (final row in spotsData as List) {
      total++;
      if ((row['status'] as String? ?? 'available') == 'available') {
        available++;
      }
    }

    final json = Map<String, dynamic>.from(data);
    json['image_path'] = _normalizeAssetPath(json['image_path']);

    return Place.fromJson(
      json,
      availableSlots: available,
      totalSlots: total,
    );
  }
}