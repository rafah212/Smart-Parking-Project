import 'package:parkliapp/app_data.dart';

class BookingItem {
  final String id;
  final String userId;
  final String placeId;
  final String placeName;
  final String placeNameAr;
  final String spotId;
  final String spotLabel;
  final String status;
  final DateTime? bookedAt;
  final DateTime? createdAt;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? durationHours;

  const BookingItem({
    required this.id,
    required this.userId,
    required this.placeId,
    required this.placeName,
    required this.placeNameAr,
    required this.spotId,
    required this.spotLabel,
    required this.status,
    this.bookedAt,
    this.createdAt,
    this.startTime,
    this.endTime,
    this.durationHours,
  });

  String get displayPlaceName =>
      AppData.isArabic ? placeNameAr : placeName;

  factory BookingItem.fromJoinedJson(Map<String, dynamic> json) {
    final place = json['places'];

    return BookingItem(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      placeId: json['place_id'] as String,
      placeName: place != null
          ? (place['name'] ?? 'Unknown Place') as String
          : 'Unknown Place',
      placeNameAr: place != null
          ? (place['name_ar'] ?? place['name'] ?? 'مكان غير معروف') as String
          : 'مكان غير معروف',
      spotId: json['spot_id'] as String,
      spotLabel: (json['spot_label'] ?? 'Unknown Spot') as String,
      status: (json['status'] ?? 'upcoming') as String,
      bookedAt: json['booked_at'] != null
          ? DateTime.tryParse(json['booked_at'])?.toLocal()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])?.toLocal()
          : null,
      startTime: json['start_time'] != null
          ? DateTime.tryParse(json['start_time'])?.toLocal()
          : null,
      endTime: json['end_time'] != null
          ? DateTime.tryParse(json['end_time'])?.toLocal()
          : null,
      durationHours: json['duration_hours'] as int?,
    );
  }
}