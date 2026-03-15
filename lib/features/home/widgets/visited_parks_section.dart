import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'parking_card.dart';

class VisitedParksSection extends StatelessWidget {
  const VisitedParksSection({super.key});

  @override
  Widget build(BuildContext context) {
    final visitedPlaces = [
      const Place(
        id: 'visited_1',
        name: 'College of Science & Arts',
        category: 'university',
        branchName: 'Unaizah 56453',
        availableSlots: 150,
        totalSlots: 150,
        distanceKm: 13.0,
        priceLabel: 'FREE',
        lat: 26.0885,
        lng: 43.9935,
        imagePath: 'assets/images/park1.png',
      ),
      const Place(
        id: 'visited_2',
        name: 'Jada Al-Nakheel',
        category: 'cafesAndFarms',
        branchName: 'Unaizah 56219',
        availableSlots: 24,
        totalSlots: 24,
        distanceKm: 5.7,
        priceLabel: '﷼ 3.45',
        lat: 26.1000,
        lng: 44.0100,
        imagePath: 'assets/images/park2.png',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Your most visited car parks',
              style: TextStyle(
                color: Color(0xFF1E7280),
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ParkingCard(place: visitedPlaces[0]),
          const SizedBox(height: 14),
          ParkingCard(place: visitedPlaces[1]),
        ],
      ),
    );
  }
}