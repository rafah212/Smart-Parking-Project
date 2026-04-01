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
}
