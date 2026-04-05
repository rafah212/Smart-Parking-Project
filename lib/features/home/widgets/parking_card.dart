import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({super.key, required this.place});

  final Place place;

  String _formattedDistance() {
    if (place.distanceKm < 1) {
      return '${(place.distanceKm * 1000).toInt()} m';
    }
    return '${place.distanceKm.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = place.imagePath.isNotEmpty
        ? place.imagePath
        : 'assets/images/explore_placeholder.png';

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailsScreen(place: place),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imagePath,
              width: 87,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) {
                return Container(
                  width: 87,
                  height: 72,
                  color: const Color(0xFFEAF4F5),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.local_parking_rounded,
                    color: Color(0xFF237D8C),
                    size: 28,
                  ),
                );
              },
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SizedBox(
              height: 72,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          place.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF237D8C),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formattedDistance(),
                        style: const TextStyle(
                          color: Color(0xFF237D8C),
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    place.branchName.isNotEmpty
                        ? place.branchName
                        : place.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFA6ADB6),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${place.availableSlots}/${place.totalSlots} Total slots available',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF237D8C),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}