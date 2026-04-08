import 'package:supabase_flutter/supabase_flutter.dart';

class VehicleData {
  final String id;
  final String plateType;
  final String country;
  final bool isSaudi;
  final String? plateLetters;
  final String? plateNumbers;
  final String? plateText;

  const VehicleData({
    required this.id,
    required this.plateType,
    required this.country,
    required this.isSaudi,
    this.plateLetters,
    this.plateNumbers,
    this.plateText,
  });

  factory VehicleData.fromJson(Map<String, dynamic> json) {
    return VehicleData(
      id: json['id'] as String,
      plateType: (json['plate_type'] ?? '') as String,
      country: (json['country'] ?? '') as String,
      isSaudi: (json['is_saudi'] ?? true) as bool,
      plateLetters: json['plate_letters'] as String?,
      plateNumbers: json['plate_numbers'] as String?,
      plateText: json['plate_text'] as String?,
    );
  }

  String get displayPlate {
    if (isSaudi) {
      final letters = (plateLetters ?? '').trim();
      final numbers = (plateNumbers ?? '').trim();
      return '$letters | $numbers'.trim();
    }
    return (plateText ?? '').trim();
  }
}

class VehicleService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<VehicleData>> getMyVehicles(String userId) async {
    final data = await _supabase
        .from('vehicles')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List)
        .map((item) => VehicleData.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> addVehicle({
    required String userId,
    required bool isSaudi,
    required String plateType,
    required String country,
    String? plateLetters,
    String? plateNumbers,
    String? plateText,
  }) async {
    await _supabase.from('vehicles').insert({
      'user_id': userId,
      'is_saudi': isSaudi,
      'plate_type': plateType,
      'country': country,
      'plate_letters': plateLetters,
      'plate_numbers': plateNumbers,
      'plate_text': plateText,
    });
  }

  Future<VehicleData?> getVehicleById(String vehicleId) async {
    final data = await _supabase
        .from('vehicles')
        .select()
        .eq('id', vehicleId)
        .maybeSingle();

    if (data == null) return null;
    return VehicleData.fromJson(data);
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _supabase.from('vehicles').delete().eq('id', vehicleId);
  }
}
