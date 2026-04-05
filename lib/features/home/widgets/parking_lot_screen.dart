import 'dart:async';

import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/parking_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/models/parking_spot.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ParkingLotScreen extends StatefulWidget {
  final Place place;

  const ParkingLotScreen({super.key, required this.place});

  @override
  State<ParkingLotScreen> createState() => _ParkingLotScreenState();
}

class _ParkingLotScreenState extends State<ParkingLotScreen>
    with TickerProviderStateMixin {
  late final ParkingService _parkingService;

  List<ParkingSpot> _allSpots = [];
  List<String> _sections = [];
  TabController? _tabController;
  ParkingSpot? _selectedSpot;
  bool _isLoading = true;
  String? _error;

  StreamSubscription<List<ParkingSpot>>? _spotsSubscription;

  @override
  void initState() {
    super.initState();
    _parkingService = ParkingService();
    _loadSpots();
    _listenToSpotsStream();
  }

  Future<void> _loadSpots() async {
    try {
      final spots = await _parkingService.getSpotsByPlace(widget.place.id);

      if (!mounted) return;

      _applySpots(spots);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _listenToSpotsStream() {
    _spotsSubscription?.cancel();
    _spotsSubscription =
        _parkingService.streamSpotsByPlace(widget.place.id).listen(
      (spots) {
        if (!mounted) return;
        _applySpots(spots);
      },
      onError: (error) {
        if (!mounted) return;
        setState(() {
          _error = error.toString();
          _isLoading = false;
        });
      },
    );
  }

  void _applySpots(List<ParkingSpot> spots) {
    final sections = spots.map((e) => e.section).toSet().toList()..sort();

    final oldIndex = _tabController?.index ?? 0;
    final newIndex = sections.isEmpty
        ? 0
        : oldIndex >= sections.length
            ? 0
            : oldIndex;

    _tabController?.dispose();

    if (sections.isEmpty) {
      _tabController = null;
    } else {
      _tabController = TabController(
        length: sections.length,
        vsync: this,
        initialIndex: newIndex,
      );

      _tabController!.addListener(() {
        if (mounted) {
          setState(() {});
        }
      });
    }

    ParkingSpot? updatedSelected;
    if (_selectedSpot != null) {
      try {
        updatedSelected = spots.firstWhere((s) => s.id == _selectedSpot!.id);
        if (updatedSelected.isBooked) {
          updatedSelected = null;
        }
      } catch (_) {
        updatedSelected = null;
      }
    }

    setState(() {
      _allSpots = spots;
      _sections = sections;
      _selectedSpot = updatedSelected;
      _isLoading = false;
      _error = null;
    });
  }

  @override
  void dispose() {
    _spotsSubscription?.cancel();
    _tabController?.dispose();
    super.dispose();
  }

  List<ParkingSpot> _spotsBySection(String section) {
    final filtered =
        _allSpots.where((spot) => spot.section == section).toList();
    filtered.sort((a, b) {
      final rowCompare = a.row.compareTo(b.row);
      if (rowCompare != 0) return rowCompare;
      return a.column.compareTo(b.column);
    });
    return filtered;
  }

  void _onSpotTap(ParkingSpot spot) {
    if (spot.isBooked) return;

    setState(() {
      if (_selectedSpot?.id == spot.id) {
        _selectedSpot = null;
      } else {
        _selectedSpot = spot;
      }
    });
  }

  Future<void> _bookSelectedSpot() async {
    if (_selectedSpot == null) return;

    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('You need to log in first'),
        ),
      );
      return;
    }

    try {
      final selectedSpot = _selectedSpot!;

      await _parkingService.bookSpot(
        userId: user.id,
        spot: selectedSpot,
      );

      if (!mounted) return;

      setState(() {
        _selectedSpot = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text('Booked ${selectedSpot.label} successfully'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(e.toString()),
        ),
      );
    }
  }

  String _formatSectionLabel(String section) {
    final words = section.split('_');
    return words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }

  String get _currentSectionLabel {
    if (_sections.isEmpty || _tabController == null) return 'Parking Area';
    return _formatSectionLabel(_sections[_tabController!.index]);
  }

  @override
  Widget build(BuildContext context) {
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
                  if (_sections.isNotEmpty && _tabController != null)
                    Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F6),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TabBar(
                        isScrollable: true,
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
                        tabs: _sections
                            .map((section) =>
                                Tab(text: _formatSectionLabel(section)))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )
                      : _sections.isEmpty || _tabController == null
                          ? const Center(
                              child: Text(
                                'No parking spots found',
                                style: TextStyle(
                                  color: Color(0xFF607176),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            )
                          : TabBarView(
                              controller: _tabController,
                              children: _sections.map((section) {
                                return _SectionTab(
                                  sectionTitle: _formatSectionLabel(section),
                                  spots: _spotsBySection(section),
                                  selectedSpotId: _selectedSpot?.id,
                                  onSpotTap: _onSpotTap,
                                );
                              }).toList(),
                            ),
            ),
            _BottomBookingBar(
              placeName: widget.place.name,
              sectionLabel: _currentSectionLabel,
              distanceKm: widget.place.distanceKm,
              priceLabel: widget.place.priceLabel,
              selectedSpotLabel: _selectedSpot?.label,
              onBookNow: _selectedSpot == null ? null : _bookSelectedSpot,
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
            color: Color(0xFFE74C3C),
            borderColor: Color(0xFFE74C3C),
            label: 'Booked',
            icon: Icons.directions_car_filled_rounded,
            iconColor: Colors.white,
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

class _SectionTab extends StatelessWidget {
  final String sectionTitle;
  final List<ParkingSpot> spots;
  final String? selectedSpotId;
  final void Function(ParkingSpot spot) onSpotTap;

  const _SectionTab({
    required this.sectionTitle,
    required this.spots,
    required this.selectedSpotId,
    required this.onSpotTap,
  });

  Map<int, List<ParkingSpot>> _groupRows(List<ParkingSpot> spots) {
    final Map<int, List<ParkingSpot>> grouped = {};
    for (final spot in spots) {
      grouped.putIfAbsent(spot.row, () => []).add(spot);
    }

    for (final row in grouped.values) {
      row.sort((a, b) => a.column.compareTo(b.column));
    }

    return Map.fromEntries(
      grouped.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final groupedRows = _groupRows(spots);

    if (spots.isEmpty) {
      return Center(
        child: Text(
          'No spots found in $sectionTitle',
          style: const TextStyle(
            color: Color(0xFF607176),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sectionTitle,
                  style: const TextStyle(
                    color: Color(0xAA237D8C),
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                ...groupedRows.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: _ParkingRowCard(
                      rowNumber: entry.key,
                      rowSpots: entry.value,
                      selectedSpotId: selectedSpotId,
                      onSpotTap: onSpotTap,
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ParkingRowCard extends StatelessWidget {
  final int rowNumber;
  final List<ParkingSpot> rowSpots;
  final String? selectedSpotId;
  final void Function(ParkingSpot spot) onSpotTap;

  const _ParkingRowCard({
    required this.rowNumber,
    required this.rowSpots,
    required this.selectedSpotId,
    required this.onSpotTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FBFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE7ECEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Row ${rowNumber + 1}',
            style: const TextStyle(
              color: Color(0xFF607176),
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          SingleChildScrollView(
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

    Color bgColor;
    Color borderColor;
    Color textColor;
    IconData iconData;
    Color iconColor;

    if (isSelected) {
      bgColor = const Color(0xFFEBEBFD);
      borderColor = const Color(0xFF237D8C);
      textColor = const Color(0xFF237D8C);
      iconData = Icons.check_circle_rounded;
      iconColor = const Color(0xFF237D8C);
    } else if (isBooked) {
      bgColor = const Color(0xFFE74C3C);
      borderColor = const Color(0xFFE74C3C);
      textColor = Colors.white;
      iconData = Icons.directions_car_filled_rounded;
      iconColor = Colors.white;
    } else {
      bgColor = Colors.white;
      borderColor = const Color(0xFFE7ECEE);
      textColor = const Color(0xAA237D8C);
      iconData = Icons.local_parking_rounded;
      iconColor = const Color(0x33237D8C);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isBooked ? null : onTap,
        borderRadius: BorderRadius.circular(14),
        child: Ink(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: borderColor,
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
                  color: textColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Icon(iconData, color: iconColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomBookingBar extends StatelessWidget {
  final String placeName;
  final String sectionLabel;
  final double distanceKm;
  final String priceLabel;
  final String? selectedSpotLabel;
  final VoidCallback? onBookNow;

  const _BottomBookingBar({
    required this.placeName,
    required this.sectionLabel,
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
                      ? '$placeName - $sectionLabel'
                      : '$selectedSpotLabel - $sectionLabel',
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
