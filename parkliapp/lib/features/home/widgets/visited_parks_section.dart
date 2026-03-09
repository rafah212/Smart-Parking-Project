import 'package:flutter/material.dart';
import 'parking_card.dart';

class VisitedParksSection extends StatelessWidget {
  const VisitedParksSection({super.key});

  @override
  Widget build(BuildContext context) {
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
          ParkingCard(
            imagePath: 'assets/images/park1.png',
            title: 'College of Science & Arts',
            location: 'Unaizah 56453',
            statusText: 'Free / 150 slots available',
            distance: '13 km',
          ),
          const SizedBox(height: 14),
          ParkingCard(
            imagePath: 'assets/images/park2.png',
            title: 'Jada Al-Nakheel',
            location: 'Unaizah 56219',
            statusText: '﷼ 3.45 / 24 slots available',
            distance: '5.7 km',
          ),
        ],
      ),
    );
  }
}