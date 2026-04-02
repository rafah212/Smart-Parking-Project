import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/data/places_dummy_data.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/map_section.dart';
import 'widgets/visited_parks_section.dart';
import 'widgets/home_search_sheet.dart';
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
  int _currentIndex = 0;
  bool _showSearchSheet = false;
  bool _showFilterSheet = false;

  double _selectedDistance = 40;
  String _selectedTime = 'Now';

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

    return dummyPlaces.where((place) {
      final matchesDistance = place.distanceKm <= _selectedDistance;
      final matchesTime = place.availableInMinutes <= selectedMinutes;
      return matchesDistance && matchesTime;
    }).take(4).toList();
  }

  // جسد صفحة الهوم
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
                        const SizedBox(height: 18),
                        const VisitedParksSection(),
                        const SizedBox(height: 20),
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
              child: Container(color: Colors.black.withOpacity(0.08)),
            ),
          ),
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
                child: HomeSearchSheet(scrollController: scrollController),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // الترتيب الحرج جداً (0, 1, 2, 3)
    final List<Widget> pages = [
      _buildHomeBody(),         // Index 0
      const SavedParking(),     // Index 1
      const BookingScreen(),    // Index 2
      const UserProfile(),      // Index 3
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
      body: SafeArea(child: pages[_currentIndex]),
    );
  }
}

class _FilterButton extends StatelessWidget {
  const _FilterButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFFF5FBFC),
        border: Border.all(color: const Color(0x30777777)),
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Icon(Icons.tune_rounded, color: Color(0xFF237D8C), size: 22),
    );
  }
}