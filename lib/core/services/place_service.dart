import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlaceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  static const double _earthRadiusKm = 6371;

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

  Future<Position?> _getUserPosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    } catch (_) {
      return null;
    }
  }

  double _calculateDistanceKm({
    required double userLat,
    required double userLng,
    required double placeLat,
    required double placeLng,
  }) {
    double toRadians(double degree) {
      return degree * pi / 180;
    }

    final dLat = toRadians(placeLat - userLat);
    final dLng = toRadians(placeLng - userLng);

    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(toRadians(userLat)) *
            cos(toRadians(placeLat)) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return _earthRadiusKm * c;
  }

  bool _hasValidLocation(double lat, double lng) {
    return lat != 0 && lng != 0;
  }

  Future<List<Place>> getAllPlaces() async {
    final userPosition = await _getUserPosition();

    final placesData = await _supabase.from('places').select().order('name');

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

    final places = (placesData as List).map((row) {
      final json = Map<String, dynamic>.from(row as Map);
      final id = json['id'] as String;

      json['image_path'] = _normalizeAssetPath(json['image_path']);

      final lat = (json['lat'] as num?)?.toDouble() ?? 0.0;
      final lng = (json['lng'] as num?)?.toDouble() ?? 0.0;

      final place = Place.fromJson(
        json,
        availableSlots: availableByPlace[id] ?? 0,
        totalSlots: totalByPlace[id] ?? 0,
      );

      if (userPosition == null || !_hasValidLocation(lat, lng)) {
        return place;
      }

      final calculatedDistance = _calculateDistanceKm(
        userLat: userPosition.latitude,
        userLng: userPosition.longitude,
        placeLat: lat,
        placeLng: lng,
      );

      return place.copyWith(
        distanceKm: calculatedDistance,
        isNearby: calculatedDistance <= 5,
      );
    }).toList();

    places.sort((a, b) {
      final distanceCompare = a.distanceKm.compareTo(b.distanceKm);
      if (distanceCompare != 0) return distanceCompare;
      return a.name.compareTo(b.name);
    });

    return places;
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
    final userPosition = await _getUserPosition();

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

    final lat = (json['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (json['lng'] as num?)?.toDouble() ?? 0.0;

    final place = Place.fromJson(
      json,
      availableSlots: available,
      totalSlots: total,
    );

    if (userPosition == null || !_hasValidLocation(lat, lng)) {
      return place;
    }

    final calculatedDistance = _calculateDistanceKm(
      userLat: userPosition.latitude,
      userLng: userPosition.longitude,
      placeLat: lat,
      placeLng: lng,
    );

    return place.copyWith(
      distanceKm: calculatedDistance,
      isNearby: calculatedDistance <= 5,
    );
  }
}
