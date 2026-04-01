enum ParkingSpotStatus { available, booked }

class ParkingSpot {
  final String id;
  final String placeId;
  final String side;
  final String label;
  final int row;
  final int column;
  final ParkingSpotStatus status;

  const ParkingSpot({
    required this.id,
    required this.placeId,
    required this.side,
    required this.label,
    required this.row,
    required this.column,
    required this.status,
  });

  ParkingSpot copyWith({
    String? id,
    String? placeId,
    String? side,
    String? label,
    int? row,
    int? column,
    ParkingSpotStatus? status,
  }) {
    return ParkingSpot(
      id: id ?? this.id,
      placeId: placeId ?? this.placeId,
      side: side ?? this.side,
      label: label ?? this.label,
      row: row ?? this.row,
      column: column ?? this.column,
      status: status ?? this.status,
    );
  }
}
