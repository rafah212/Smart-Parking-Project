import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'parking_card.dart';

class VisitedParksSection extends StatelessWidget {
  final List<Place> visitedPlaces;

  const VisitedParksSection({
    super.key,
    required this.visitedPlaces,
  });

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
          if (visitedPlaces.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                color: const Color(0xFFF5FBFC),
                border: Border.all(color: const Color(0x30777777)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'No parking matches your filter',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFF677191),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          else
            ...List.generate(visitedPlaces.length, (index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == visitedPlaces.length - 1 ? 0 : 14,
                ),
                child: ParkingCard(place: visitedPlaces[index]),
              );
            }),
        ],
      ),
    );
  }
}