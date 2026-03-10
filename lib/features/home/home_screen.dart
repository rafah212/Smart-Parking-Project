import 'package:flutter/material.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/map_section.dart';
import 'widgets/visited_parks_section.dart';
import 'widgets/home_search_sheet.dart';
import 'saved_parking.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _showSearchSheet = false;

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
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              const _FilterButton(),
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
                child: HomeSearchSheet(scrollController: scrollController),
              );
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      _buildHomeBody(),
      const SavedParking(),
      const Center(child: Text('Booking')),
      const Center(child: Text('Profile')),
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: HomeBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _showSearchSheet = false;
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
