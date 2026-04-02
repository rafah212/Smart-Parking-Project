import 'package:flutter/material.dart';
import 'package:parkliapp/features/forgotPass/change_pass.dart';
import 'package:parkliapp/features/home/models/place.dart';
import 'package:parkliapp/features/home/widgets/place_details_screen.dart';
import '../../forgotPass/forget_pass1.dart';

void openPlaceDetails(BuildContext context, Place place) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PlaceDetailsScreen(place: place),
    ),
  );
}

void openForgotPassword(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ForgotPassword1(),
    ),
  );
}

void openChangePassword(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => const ChangePasswordScreen(),
    ),
  );
}