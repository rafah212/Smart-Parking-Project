import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/data/parking_spots_dummy_data.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/models/parking_spot.dart';
import 'package:parkliapp/features/parking/parking_detail1.dart';

class ParkingLotScreen extends StatefulWidget {
  final Place place;

  const ParkingLotScreen({super.key, required this.place});

  @override
  State<ParkingLotScreen> createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final List<ParkingSpot> _allSpots;

  ParkingSpot? _selectedSpot;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _allSpots = generateCollegeParkingSpots(placeId: widget.place.id);
    _tabController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<ParkingSpot> _spotsBySide(String side) {
    return _allSpots.where((spot) => spot.side == side).toList();
  }

  void _onSpotTap(ParkingSpot spot) {
    if (spot.status == ParkingSpotStatus.booked) return;

    setState(() {
      if (_selectedSpot?.id == spot.id) {
        _selectedSpot = null;
      } else {
        _selectedSpot = spot;
      }
    });
  }

  String get _currentSideLabel {
    return _tabController.index == 0 ? 'Left Area' : 'Right Area';
  }

  @override
  Widget build(BuildContext context) {
    final leftSpots = _spotsBySide('left');
    final rightSpots = _spotsBySide('right');

    return Scaffold(
      backgroundColor: const Color(0xFFF8FBFB),
      body: SafeArea(
        child: Column(
          children: [
            _ParkingHeader(title: widget.place.name),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
              child: Column(
                children: [
                  const _LegendCard(),
                  const SizedBox(height: 14),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F6),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: const Color(0xFF237D8C),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF607176),
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                      tabs: const [
                        Tab(text: 'Left Area'),
                        Tab(text: 'Right Area'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _LeftAreaTab(
                    spots: leftSpots,
                    selectedSpotId: _selectedSpot?.id,
                    onSpotTap: _onSpotTap,
                  ),
                  _RightAreaTab(
                    spots: rightSpots,
                    selectedSpotId: _selectedSpot?.id,
                    onSpotTap: _onSpotTap,
                  ),
                ],
              ),
            ),
            _BottomBookingBar(
              placeName: widget.place.name,
              sideLabel: _currentSideLabel,
              distanceKm: widget.place.distanceKm,
              priceLabel: widget.place.priceLabel,
              selectedSpotLabel: _selectedSpot?.label,
              onBookNow: _selectedSpot == null
                  ? null
                  : () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          content: Text(
                            'Booked ${_selectedSpot!.label} in $_currentSideLabel',
                          ),
                        ),
                      );
                      
        // ثانياً الانتقال لصفحة بيانات الحجز (ParkingDetail1) بعد الضغط مباشرة
                      Navigator.push(
                        context,
                       MaterialPageRoute(
                         builder: (context) => const ParkingDetail1(),
                     ),
                     );
            },
            ),
          ],
        ),
      ),
    );
  }
}

class _ParkingHeader extends StatelessWidget {
  final String title;

  const _ParkingHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.5, 0),
          end: Alignment(0.5, 1),
          colors: [Color(0xFF195A64), Color(0xFF34B5CA)],
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 12,
            top: 22,
            bottom: 0,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 18),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendCard extends StatelessWidget {
  const _LegendCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8ECEE)),
      ),
      child: Wrap(
        spacing: 18,
        runSpacing: 10,
        children: const [
          _LegendItem(
            color: Colors.white,
            borderColor: Color(0xFFCCD8DC),
            label: 'Available',
            icon: Icons.local_parking_rounded,
            iconColor: Color(0x55237D8C),
          ),
          _LegendItem(
            color: Color(0xFFEBEBFD),
            borderColor: Color(0xFF237D8C),
            label: 'Selected',
            icon: Icons.check_circle_rounded,
            iconColor: Color(0xFF237D8C),
          ),
          _LegendItem(
            color: Color(0xFFF5F5F5),
            borderColor: Color(0xFFD7D7D7),
            label: 'Booked',
            icon: Icons.directions_car_filled_rounded,
            iconColor: Color(0xFF7A7A7A),
          ),
          _LegendItem(
            color: Color(0xFFF3F8F8),
            borderColor: Color(0xFFC8DCDD),
            label: 'Shaded',
            icon: Icons.roofing_rounded,
            iconColor: Color(0xFF6E8E93),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final Color borderColor;
  final String label;
  final IconData icon;
  final Color iconColor;

  const _LegendItem({
    required this.color,
    required this.borderColor,
    required this.label,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF53636B),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LeftAreaTab extends StatelessWidget {
  final List<ParkingSpot> spots;
  final String? selectedSpotId;
  final void Function(ParkingSpot spot) onSpotTap;

  const _LeftAreaTab({
    required this.spots,
    required this.selectedSpotId,
    required this.onSpotTap,
  });

  List<_ParkingIslandData> _buildIslands(List<ParkingSpot> spots) {
    final List<_ParkingIslandData> islands = [];

    for (int islandIndex = 0; islandIndex < 9; islandIndex++) {
      final topRowNumber = islandIndex * 2;
      final bottomRowNumber = islandIndex * 2 + 1;

      final topRow = spots.where((s) => s.row == topRowNumber).toList()
        ..sort((a, b) => a.column.compareTo(b.column));

      final bottomRow = spots.where((s) => s.row == bottomRowNumber).toList()
        ..sort((a, b) => a.column.compareTo(b.column));

      islands.add(
        _ParkingIslandData(
          islandIndex: islandIndex,
          isShaded: islandIndex < 4,
          horizontalOffset: _leftAreaOffsets[islandIndex],
          topRow: topRow,
          bottomRow: bottomRow,
        ),
      );
    }

    return islands;
  }

  static const List<double> _leftAreaOffsets = [
    26,
    18,
    10,
    4,
    0,
    6,
    14,
    22,
    30,
  ];

  @override
  Widget build(BuildContext context) {
    final islands = _buildIslands(spots);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: ListView.separated(
        itemCount: islands.length,
        separatorBuilder: (_, __) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final island = islands[index];
          return Padding(
            padding: EdgeInsets.only(left: island.horizontalOffset, right: 6),
            child: _ParkingIslandCard(
              title: 'Island ${index + 1}',
              isShaded: island.isShaded,
              topRow: island.topRow,
              bottomRow: island.bottomRow,
              selectedSpotId: selectedSpotId,
              onSpotTap: onSpotTap,
            ),
          );
        },
      ),
    );
  }
}

class _ParkingIslandData {
  final int islandIndex;
  final bool isShaded;
  final double horizontalOffset;
  final List<ParkingSpot> topRow;
  final List<ParkingSpot> bottomRow;

  _ParkingIslandData({
    required this.islandIndex,
    required this.isShaded,
    required this.horizontalOffset,
    required this.topRow,
    required this.bottomRow,
  });
}

class _ParkingIslandCard extends StatelessWidget {
  final String title;
  final bool isShaded;
  final List<ParkingSpot> topRow;
  final List<ParkingSpot> bottomRow;
  final String? selectedSpotId;
  final void Function(ParkingSpot spot) onSpotTap;

  const _ParkingIslandCard({
    required this.title,
    required this.isShaded,
    required this.topRow,
    required this.bottomRow,
    required this.selectedSpotId,
    required this.onSpotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 14),
      decoration: BoxDecoration(
        color: isShaded ? const Color(0xFFF6FAFA) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isShaded ? const Color(0xFFD5E6E7) : const Color(0xFFE7ECEE),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0x22000000)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'L',
                  style: TextStyle(
                    color: Color(0xFF04031F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xAA237D8C),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              if (isShaded)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EFF0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.roofing_rounded,
                        size: 15,
                        color: Color(0xFF6C8D93),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Shaded',
                        style: TextStyle(
                          color: Color(0xFF6C8D93),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          _HorizontalParkingRow(
            rowSpots: topRow,
            selectedSpotId: selectedSpotId,
            onSpotTap: onSpotTap,
          ),
          const SizedBox(height: 10),
          const _DrivingLanePill(),
          const SizedBox(height: 10),
          _HorizontalParkingRow(
            rowSpots: bottomRow,
            selectedSpotId: selectedSpotId,
            onSpotTap: onSpotTap,
          ),
        ],
      ),
    );
  }
}

class _DrivingLanePill extends StatelessWidget {
  const _DrivingLanePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F7F8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE3EBED)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: const [
          Icon(Icons.arrow_forward_rounded, size: 18, color: Color(0xFF9AA9AE)),
          SizedBox(width: 8),
          Text(
            'Driving lane',
            style: TextStyle(
              color: Color(0xFF93A2A8),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _HorizontalParkingRow extends StatelessWidget {
  final List<ParkingSpot> rowSpots;
  final String? selectedSpotId;
  final void Function(ParkingSpot spot) onSpotTap;

  const _HorizontalParkingRow({
    required this.rowSpots,
    required this.selectedSpotId,
    required this.onSpotTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: rowSpots.map((spot) {
          final isSelected = selectedSpotId == spot.id;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SizedBox(
              width: 72,
              child: _ParkingSpotTile(
                spot: spot,
                isSelected: isSelected,
                onTap: () => onSpotTap(spot),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _VerticalParkingColumn extends StatelessWidget {
  final List<ParkingSpot> rowSpots;
  final String? selectedSpotId;
  final void Function(ParkingSpot spot) onSpotTap;

  const _VerticalParkingColumn({
    required this.rowSpots,
    required this.selectedSpotId,
    required this.onSpotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: rowSpots.map((spot) {
        final isSelected = selectedSpotId == spot.id;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: SizedBox(
            width: 92,
            child: _ParkingSpotTile(
              spot: spot,
              isSelected: isSelected,
              onTap: () => onSpotTap(spot),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _RightAreaTab extends StatelessWidget {
  final List<ParkingSpot> spots;
  final String? selectedSpotId;
  final void Function(ParkingSpot spot) onSpotTap;

  const _RightAreaTab({
    required this.spots,
    required this.selectedSpotId,
    required this.onSpotTap,
  });

  List<List<ParkingSpot>> _buildCurvedRows() {
    final curvedSpots = spots.where((s) => s.row >= 0 && s.row < 8).toList();

    final Map<int, List<ParkingSpot>> grouped = {};
    for (final spot in curvedSpots) {
      grouped.putIfAbsent(spot.row, () => []).add(spot);
    }

    final rows = grouped.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    for (final row in rows) {
      row.value.sort((a, b) => a.column.compareTo(b.column));
    }

    return rows.map((e) => e.value).toList();
  }

  List<ParkingSpot> _rowByNumber(int rowNumber) {
    final row = spots.where((s) => s.row == rowNumber).toList()
      ..sort((a, b) => a.column.compareTo(b.column));
    return row;
  }

  @override
  Widget build(BuildContext context) {
    final curvedRows = _buildCurvedRows();

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE8E8EE)),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0x22000000)),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'R',
                        style: TextStyle(
                          color: Color(0xFF04031F),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Right Area • Outer Curve',
                        style: TextStyle(
                          color: Color(0xAA237D8C),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ...List.generate(curvedRows.length, (index) {
                  final row = curvedRows[index];
                  final offset = _curvedOffsets[index];

                  return Padding(
                    padding: EdgeInsets.only(
                      left: offset,
                      right: 4,
                      bottom: index == curvedRows.length - 1 ? 0 : 10,
                    ),
                    child: _HorizontalParkingRow(
                      rowSpots: row,
                      selectedSpotId: selectedSpotId,
                      onSpotTap: onSpotTap,
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 18),
          const Padding(
            padding: EdgeInsets.only(left: 6, bottom: 10),
            child: Text(
              'Upper T Islands',
              style: TextStyle(
                color: Color(0xFF607176),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...List.generate(4, (index) {
            final base = 100 + index * 10;

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _LargeTIslandCard(
                title: 'Upper T Island ${index + 1}',
                topRow: _rowByNumber(base),
                leftRow: _rowByNumber(base + 1),
                rightRow: _rowByNumber(base + 2),
                bottomRow: _rowByNumber(base + 3),
                selectedSpotId: selectedSpotId,
                onSpotTap: onSpotTap,
              ),
            );
          }),
          const Padding(
            padding: EdgeInsets.only(left: 6, bottom: 10),
            child: Text(
              'Lower T Islands',
              style: TextStyle(
                color: Color(0xFF607176),
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          ...List.generate(3, (index) {
            final base = 100 + (index + 4) * 10;

            return Padding(
              padding: EdgeInsets.only(bottom: index == 2 ? 0 : 16),
              child: _LargeTIslandCard(
                title: 'Lower T Island ${index + 1}',
                topRow: _rowByNumber(base),
                leftRow: _rowByNumber(base + 1),
                rightRow: _rowByNumber(base + 2),
                bottomRow: _rowByNumber(base + 3),
                selectedSpotId: selectedSpotId,
                onSpotTap: onSpotTap,
              ),
            );
          }),
        ],
      ),
    );
  }

  static const List<double> _curvedOffsets = [40, 30, 22, 14, 10, 16, 26, 38];
}

class _LargeTIslandCard extends StatelessWidget {
  final String title;
  final List<ParkingSpot> topRow;
  final List<ParkingSpot> leftRow;
  final List<ParkingSpot> rightRow;
  final List<ParkingSpot> bottomRow;
  final String? selectedSpotId;
  final void Function(ParkingSpot spot) onSpotTap;

  const _LargeTIslandCard({
    required this.title,
    required this.topRow,
    required this.leftRow,
    required this.rightRow,
    required this.bottomRow,
    required this.selectedSpotId,
    required this.onSpotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8E8EE)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0x22000000)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'T',
                  style: TextStyle(
                    color: Color(0xFF04031F),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xAA237D8C),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _HorizontalParkingRow(
            rowSpots: topRow,
            selectedSpotId: selectedSpotId,
            onSpotTap: onSpotTap,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _VerticalParkingColumn(
                rowSpots: leftRow,
                selectedSpotId: selectedSpotId,
                onSpotTap: onSpotTap,
              ),
              const SizedBox(width: 6),
              const Expanded(child: Center(child: _HugeTShapeIslandCenter())),
              const SizedBox(width: 6),
              _VerticalParkingColumn(
                rowSpots: rightRow,
                selectedSpotId: selectedSpotId,
                onSpotTap: onSpotTap,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _DrivingLanePill(),
          const SizedBox(height: 12),
          _HorizontalParkingRow(
            rowSpots: bottomRow,
            selectedSpotId: selectedSpotId,
            onSpotTap: onSpotTap,
          ),
        ],
      ),
    );
  }
}

class _HugeTShapeIslandCenter extends StatelessWidget {
  const _HugeTShapeIslandCenter();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 190,
      height: 220,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 0,
            child: Container(
              width: 190,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE3EBED)),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.local_parking_rounded,
                color: Color(0xFF9AA9AE),
                size: 24,
              ),
            ),
          ),
          Positioned(
            top: 38,
            child: Container(
              width: 64,
              height: 170,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE3EBED)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkingSpotTile extends StatelessWidget {
  final ParkingSpot spot;
  final bool isSelected;
  final VoidCallback onTap;

  const _ParkingSpotTile({
    required this.spot,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isBooked = spot.status == ParkingSpotStatus.booked;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isBooked ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFFEBEBFD)
                : isBooked
                    ? const Color.fromARGB(255, 161, 36, 68)
                    : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF237D8C)
                  : isBooked
                      ? const Color(0xFFDADADA)
                      : const Color(0xFFE7ECEE),
              width: isSelected ? 2.4 : 1.2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                spot.label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF237D8C)
                      : isBooked
                          ? const Color.fromARGB(255, 244, 245, 247)
                          : const Color(0xAA237D8C),
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              if (isBooked)
                const Icon(
                  Icons.directions_car_filled_rounded,
                  color: Color(0xFF1E7280),
                  size: 18,
                )
              else if (isSelected)
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF237D8C),
                  size: 18,
                )
              else
                const Icon(
                  Icons.local_parking_rounded,
                  color: Color(0x33237D8C),
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBookingBar extends StatelessWidget {
  final String placeName;
  final String sideLabel;
  final double distanceKm;
  final String priceLabel;
  final String? selectedSpotLabel;
  final VoidCallback? onBookNow;

  const _BottomBookingBar({
    required this.placeName,
    required this.sideLabel,
    required this.distanceKm,
    required this.priceLabel,
    required this.selectedSpotLabel,
    required this.onBookNow,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Color(0x12000000),
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  selectedSpotLabel == null
                      ? '$placeName - $sideLabel'
                      : '$selectedSpotLabel - $sideLabel',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF1A485F),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${distanceKm.toStringAsFixed(1)} km   $priceLabel',
                  style: const TextStyle(
                    color: Color(0xFF8A8FA3),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: onBookNow,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF237D8C),
                disabledBackgroundColor: const Color(0xFFB7D7DC),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: const Text(
                'Book Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
