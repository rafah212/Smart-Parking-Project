import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/place_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/app_data.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/map_section.dart';
import 'widgets/visited_parks_section.dart';
import 'package:parkliapp/features/home/widgets/home_search_sheet.dart';
import 'widgets/home_filter_sheet.dart';
import 'saved_parking.dart';
import 'user_profile.dart';
import 'booking_screen.dart';
import 'package:parkliapp/features/parking/parking_timer.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PlaceService _placeService = PlaceService();

  int _currentIndex = 0;
  bool _showSearchSheet = false;
  bool _showFilterSheet = false;

  final MapController _mapController = MapController();
  double _selectedDistance = 40;
  late String _selectedTime;

  List<Place> _allPlaces = [];
  bool _isLoadingPlaces = true;
  String? _placesError;

  @override
  void initState() {
    super.initState();
    _selectedTime = AppData.translate('Now', 'الآن');
    _loadPlaces();
  }

  void _moveToLocation(double lat, double lng) {
    _mapController.move(LatLng(lat, lng), 15.0);
    setState(() {
      _showSearchSheet = false;
    });
  }

  Future<void> _loadPlaces() async {
    try {
      final places = await _placeService.getAllPlaces();

      if (!mounted) return;
      setState(() {
        _allPlaces = places;
        _isLoadingPlaces = false;
        _placesError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _placesError = e.toString();
        _isLoadingPlaces = false;
      });
    }
  }

  int _mapSelectedTimeToMinutes(String selectedTime) {
    if (selectedTime == AppData.translate('Now', 'الآن')) return 0;
    if (selectedTime == AppData.translate('15 min', '١٥ دقيقة')) return 15;
    if (selectedTime == AppData.translate('30 min', '٣٠ دقيقة')) return 30;
    if (selectedTime == AppData.translate('1 h', '١ ساعة')) return 60;
    if (selectedTime == AppData.translate('3 h', '٣ ساعات')) return 180;
    return 1440;
  }

  bool get _hasActiveFilter {
    return _selectedDistance < 40 ||
        _selectedTime != AppData.translate('Now', 'الآن');
  }

  List<Place> get _filteredVisitedPlaces {
    final selectedMinutes = _mapSelectedTimeToMinutes(_selectedTime);

    return _allPlaces.where((place) {
      final matchesDistance = place.distanceKm <= _selectedDistance;
      final matchesTime = place.availableInMinutes <= selectedMinutes;
      return matchesDistance && matchesTime;
    }).take(4).toList();
  }

  Widget _buildPlacesContent() {
    if (_isLoadingPlaces) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 30),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_placesError != null) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          _placesError!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    return Column(
      children: [
        const SizedBox(height: 18),
        VisitedParksSection(
          visitedPlaces: _filteredVisitedPlaces,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildHomeBody() {
    return Stack(
      children: [
        Column(
          children: [
            const HomeHeader(hasNewNotifications: true),
            MapSection(mapController: _mapController),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          child: Row(
                            children: [
                              Expanded(
                                child: HomeSearchBar(
                                  onTap: () {
                                    setState(() {
                                      _showSearchSheet = true;
                                      _showFilterSheet = false;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              _FilterButton(
                                isActive: _hasActiveFilter,
                                onTap: () {
                                  setState(() {
                                    _showFilterSheet = true;
                                    _showSearchSheet = false;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        _buildPlacesContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        if (AppData.durationHours > 0)
          Positioned(
            bottom: 40,
            left: AppData.isArabic ? 20 : null,
            right: AppData.isArabic ? null : 20,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ParkingTimerPage(),
                  ),
                ).then((_) => setState(() {}));
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF237D8C),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    Text(
                      AppData.translate('Live', 'نشط'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        if (_showSearchSheet)
          _buildBackdrop(() => setState(() => _showSearchSheet = false)),
        if (_showSearchSheet)
          DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.0,
            maxChildSize: 0.92,
            snap: true,
            builder: (context, scrollController) {
              return HomeSearchSheet(
                scrollController: scrollController,
              );
            },
          ),

        if (_showFilterSheet)
          _buildBackdrop(() => setState(() => _showFilterSheet = false)),
        if (_showFilterSheet)
          DraggableScrollableSheet(
            initialChildSize: 0.70,
            minChildSize: 0.0,
            maxChildSize: 0.90,
            snap: true,
            builder: (context, scrollController) {
              return HomeFilterSheet(
                scrollController: scrollController,
                onClose: () => setState(() => _showFilterSheet = false),
                onApply: (distance, time) {
                  setState(() {
                    _selectedDistance = distance;
                    _selectedTime = time;
                    _showFilterSheet = false;
                  });
                },
                initialDistance: _selectedDistance,
                initialSelectedTime: _selectedTime,
              );
            },
          ),
      ],
    );
  }

  Widget _buildBackdrop(VoidCallback onTap) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: onTap,
        child: Container(color: Colors.black.withOpacity(0.08)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _buildHomeBody(),
      const SavedParking(),
      const BookingScreen(),
      const UserProfile(),
    ];

    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: HomeBottomNav(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
              _showSearchSheet = false;
              _showFilterSheet = false;
            });
          },
        ),
        body: SafeArea(
          child: pages[_currentIndex],
        ),
      ),
    );
  }
}

class _FilterButton extends StatelessWidget {
  final bool isActive;
  final VoidCallback onTap;

  const _FilterButton({
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF237D8C) : const Color(0xFFF5FBFC),
          border: Border.all(
            color: isActive
                ? const Color(0xFF237D8C)
                : const Color(0x30777777),
          ),
          borderRadius: BorderRadius.circular(22),
        ),
        child: Icon(
          Icons.tune_rounded,
          color: isActive ? Colors.white : const Color(0xFF237D8C),
          size: 22,
        ),
      ),
    );
  }
}