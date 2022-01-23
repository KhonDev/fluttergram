import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/google_auth_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NotificationService {
  final BuildContext context;

  NotificationService(this.context);

  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> configurePushNotification() async {
    final GoogleSignInAccount? user =
        GoogleAuthService.googleSignIn.currentUser;
    if (user == null) return;

    if (Platform.isIOS) _getIOSPermission();

    _firebaseMessaging.getToken().then((token) {
      debugPrint('Firebase token: $token\n');
      FirebaseReference.userDB
          .doc(user.id)
          .update({"androidNotificationToken": token});
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("onMessage data: ${message.data}");
      debugPrint("onMessage data: ${message.notification?.body ?? "pustoy"}");
      final String recipientId = message.data['recipient'];
      final String body = message.notification?.body ?? '';
      if (recipientId == user.id) {
        SnackBar snackBar = SnackBar(
          content: Text(
            body,
            overflow: TextOverflow.ellipsis,
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  _getIOSPermission() {
    _firebaseMessaging.requestPermission();
  }
}
