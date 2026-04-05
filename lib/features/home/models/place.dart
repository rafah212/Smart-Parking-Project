class Place {
  final String id;
  final String name;
  final String category;
  final String branchName;
  final int availableSlots;
  final int totalSlots;
  final double distanceKm;
  final String priceLabel;
  final double lat;
  final double lng;
  final String imagePath;
  final bool isNearby;
  final int availableInMinutes;

  const Place({
    required this.id,
    required this.name,
    required this.category,
    required this.branchName,
    required this.availableSlots,
    required this.totalSlots,
    required this.distanceKm,
    required this.priceLabel,
    required this.lat,
    required this.lng,
    required this.imagePath,
    this.isNearby = false,
    this.availableInMinutes = 0,
  });

  factory Place.fromJson(
    Map<String, dynamic> json, {
    int availableSlots = 0,
    int totalSlots = 0,
  }) {
    final distance = (json['distance_km'] ?? 0).toDouble();

    return Place(
      id: json['id'] as String,
      name: (json['name'] ?? '') as String,
      category: (json['category'] ?? '') as String,
      branchName: (json['branch_name'] ?? '') as String,
      availableSlots: availableSlots,
      totalSlots: totalSlots,
      distanceKm: distance,
      priceLabel: (json['price_label'] ?? 'FREE') as String,
      lat: (json['lat'] ?? 0).toDouble(),
      lng: (json['lng'] ?? 0).toDouble(),
      imagePath: (json['image_path'] ?? '') as String,
      isNearby: distance <= 5,
      availableInMinutes: 0,
    );
  }

  Place copyWith({
    String? id,
    String? name,
    String? category,
    String? branchName,
    int? availableSlots,
    int? totalSlots,
    double? distanceKm,
    String? priceLabel,
    double? lat,
    double? lng,
    String? imagePath,
    bool? isNearby,
    int? availableInMinutes,
  }) {
    return Place(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      branchName: branchName ?? this.branchName,
      availableSlots: availableSlots ?? this.availableSlots,
      totalSlots: totalSlots ?? this.totalSlots,
      distanceKm: distanceKm ?? this.distanceKm,
      priceLabel: priceLabel ?? this.priceLabel,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      imagePath: imagePath ?? this.imagePath,
      isNearby: isNearby ?? this.isNearby,
      availableInMinutes: availableInMinutes ?? this.availableInMinutes,
    );
  }
}