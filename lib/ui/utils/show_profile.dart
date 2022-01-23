import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/screens.dart';

void showProfile(BuildContext context, String profileId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfileScreen(profileId: profileId),
    ),
  );
}
