import 'package:parkliapp/features/home/models/parking_spot.dart';

List<ParkingSpot> _generateLeftSideSpots({
  required String placeId,
}) {
  final List<ParkingSpot> spots = [];
  int number = 1;

  // 9 islands × 21 spots = 189
  // each island:
  // top row = 10
  // bottom row = 11
  for (int islandIndex = 0; islandIndex < 9; islandIndex++) {
    // top row
    for (int col = 0; col < 10; col++) {
      final isBooked = number % 7 == 0 || number % 13 == 0;

      spots.add(
        ParkingSpot(
          id: '${placeId}_L_$number',
          placeId: placeId,
          side: 'left',
          label: 'L${number.toString().padLeft(3, '0')}',
          row: islandIndex * 2,
          column: col,
          status:
              isBooked ? ParkingSpotStatus.booked : ParkingSpotStatus.available,
        ),
      );

      number++;
    }

    // bottom row
    for (int col = 0; col < 11; col++) {
      final isBooked = number % 7 == 0 || number % 13 == 0;

      spots.add(
        ParkingSpot(
          id: '${placeId}_L_$number',
          placeId: placeId,
          side: 'left',
          label: 'L${number.toString().padLeft(3, '0')}',
          row: islandIndex * 2 + 1,
          column: col,
          status:
              isBooked ? ParkingSpotStatus.booked : ParkingSpotStatus.available,
        ),
      );

      number++;
    }
  }

  return spots;
}

List<ParkingSpot> _generateRightSideSpots({
  required String placeId,
}) {
  final List<ParkingSpot> spots = [];
  int number = 1;

  void addSpot({
    required int row,
    required int column,
  }) {
    final isBooked = number % 6 == 0 || number % 11 == 0;

    spots.add(
      ParkingSpot(
        id: '${placeId}_R_$number',
        placeId: placeId,
        side: 'right',
        label: 'R${number.toString().padLeft(3, '0')}',
        row: row,
        column: column,
        status:
            isBooked ? ParkingSpotStatus.booked : ParkingSpotStatus.available,
      ),
    );

    number++;
  }

  // ===== 1) Curved outer parking = 80 spots =====
  // 8 rows × 10
  for (int row = 0; row < 8; row++) {
    for (int col = 0; col < 10; col++) {
      addSpot(row: row, column: col);
    }
  }

  // ===== 2) 7 large T islands = 154 spots =====
  // top = 8
  // left = 4
  // right = 4
  // bottom = 6
  // total = 22 each
  int baseRow = 100;

  for (int islandIndex = 0; islandIndex < 7; islandIndex++) {
    final topRow = baseRow + islandIndex * 10;
    final leftRow = topRow + 1;
    final rightRow = topRow + 2;
    final bottomRow = topRow + 3;

    for (int col = 0; col < 8; col++) {
      addSpot(row: topRow, column: col);
    }

    for (int col = 0; col < 4; col++) {
      addSpot(row: leftRow, column: col);
    }

    for (int col = 0; col < 4; col++) {
      addSpot(row: rightRow, column: col);
    }

    for (int col = 0; col < 6; col++) {
      addSpot(row: bottomRow, column: col);
    }
  }

  return spots;
}

List<ParkingSpot> generateCollegeParkingSpots({
  required String placeId,
}) {
  return [
    ..._generateLeftSideSpots(placeId: placeId),
    ..._generateRightSideSpots(placeId: placeId),
  ];
}