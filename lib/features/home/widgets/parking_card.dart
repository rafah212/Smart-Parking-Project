import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';
import 'package:parkliapp/app_data.dart'; // استيراد المخ

class ParkingCard extends StatelessWidget {
  const ParkingCard({super.key, required this.place});

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppData.isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PlaceDetailsScreen(place: place)),
          );
        },
        borderRadius: BorderRadius.circular(10),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                place.imagePath,
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
                          '${place.distanceKm} ${AppData.translate('km', 'كم')}',
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
                      place.branchName,
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
                      '${place.availableSlots}/${place.totalSlots} ${AppData.translate('Total slots available', 'إجمالي المواقف المتاحة')}',
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
      ),
    );
  }
}