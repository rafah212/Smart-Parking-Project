import 'package:flutter/material.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';

void openPlaceDetails(BuildContext context, Place place) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PlaceDetailsScreen(place: place),
    ),
  );
}