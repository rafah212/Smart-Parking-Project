import 'package:flutter/material.dart';
import 'widgets/home_bottom_nav.dart';
import 'widgets/home_header.dart';
import 'widgets/home_search_bar.dart';
import 'widgets/map_section.dart';
import 'widgets/visited_parks_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const HomeBottomNav(currentIndex: 0),
      body: SafeArea(
        child: Column(
          children: [
            const HomeHeader(),
            const MapSection(),

            // هذا الجزء هو المهم
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
                    child: const Column(
                      children: [
                        SizedBox(height: 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 13),
                          child: Row(
                            children: [
                              Expanded(child: HomeSearchBar()),
                              SizedBox(width: 10),
                              _FilterButton(),
                            ],
                          ),
                        ),
                        SizedBox(height: 18),
                        VisitedParksSection(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
