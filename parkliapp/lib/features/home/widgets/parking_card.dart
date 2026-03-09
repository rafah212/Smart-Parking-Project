import 'package:flutter/material.dart';

class ParkingCard extends StatelessWidget {
  const ParkingCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.location,
    required this.statusText,
    required this.distance,
  });

  final String imagePath;
  final String title;
  final String location;
  final String statusText;
  final String distance;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            imagePath,
            width: 87,
            height: 72,
            fit: BoxFit.cover,
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
                  children:[
                    Expanded(
                      child: Text(
                        title,
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
                      distance,
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
                  location,
                  style: const TextStyle(
                    color: Color(0xFFA6ADB6),
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  statusText,
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
    );
  }
}