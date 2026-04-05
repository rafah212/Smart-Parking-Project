import 'package:flutter/material.dart';
import 'package:parkliapp/core/services/place_service.dart';
import 'package:parkliapp/features/home/models/place.dart';
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

  double _selectedDistance = 40;
  String _selectedTime = 'Now';

  List<Place> _allPlaces = [];
  bool _isLoadingPlaces = true;
  String? _placesError;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
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
    switch (selectedTime) {
      case 'Now':
        return 0;
      case '15 min':
        return 15;
      case '30 min':
        return 30;
      case '1 h':
        return 60;
      case '3 h':
        return 180;
      case 'Tomorrow':
        return 1440;
      default:
        return 1440;
    }
  }

  bool get _hasActiveFilter {
    return _selectedDistance < 40 || _selectedTime != 'Now';
  }

  List<Place> get _filteredVisitedPlaces {
    final selectedMinutes = _mapSelectedTimeToMinutes(_selectedTime);

    return _allPlaces
        .where((place) {
          final matchesDistance = place.distanceKm <= _selectedDistance;
          final matchesTime = place.availableInMinutes <= selectedMinutes;
          return matchesDistance && matchesTime;
        })
        .take(4)
        .toList();
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
            const HomeHeader(),
            const MapSection(),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0, -18),
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
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
        if (_showSearchSheet)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showSearchSheet = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.08),
              ),
            ),
          ),
        if (_showSearchSheet)
          DraggableScrollableSheet(
            initialChildSize: 0.72,
            minChildSize: 0.0,
            maxChildSize: 0.92,
            snap: true,
            snapSizes: const [0.0, 0.72, 0.92],
            builder: (context, scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.extent <= 0.05) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _showSearchSheet = false;
                        });
                      }
                    });
                  }
                  return true;
                },
                child: HomeSearchSheet(
                  scrollController: scrollController,
                ),
              );
            },
          ),
        if (_showFilterSheet)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showFilterSheet = false;
                });
              },
              child: Container(
                color: Colors.black.withOpacity(0.08),
              ),
            ),
          ),
        if (_showFilterSheet)
          DraggableScrollableSheet(
            initialChildSize: 0.70,
            minChildSize: 0.0,
            maxChildSize: 0.90,
            snap: true,
            snapSizes: const [0.0, 0.70, 0.90],
            builder: (context, scrollController) {
              return NotificationListener<DraggableScrollableNotification>(
                onNotification: (notification) {
                  if (notification.extent <= 0.05) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        setState(() {
                          _showFilterSheet = false;
                        });
                      }
                    });
                  }
                  return true;
                },
                child: HomeFilterSheet(
                  scrollController: scrollController,
                  onClose: () {
                    setState(() {
                      _showFilterSheet = false;
                    });
                  },
                  onApply: (distance, selectedTime) {
                    setState(() {
                      _selectedDistance = distance;
                      _selectedTime = selectedTime;
                      _showFilterSheet = false;
                    });
                  },
                  initialDistance: _selectedDistance,
                  initialSelectedTime: _selectedTime,
                ),
              );
            },
          ),
      ],
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

    return Scaffold(
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
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton({
    required this.isActive,
    required this.onTap,
  });

  final bool isActive;
  final VoidCallback onTap;

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
            color: isActive ? const Color(0xFF237D8C) : const Color(0x30777777),
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
