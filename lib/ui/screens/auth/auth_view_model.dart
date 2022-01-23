import 'package:flutter/material.dart';
import 'package:fluttergram/app.dart';
import 'package:fluttergram/domain/data_provider/is_auth_provider.dart';
import 'package:fluttergram/domain/service/google_auth_service.dart';
import 'package:fluttergram/domain/service/notification_service.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/navigation/main_navigation.dart';

class AuthViewModel {
  final BuildContext context;

  AuthViewModel(this.context);

  void signIn() async {
    final _notificationService = NotificationService(context);
    final account = await GoogleAuthService.signIn();
    if (account != null) {
      await IsAuthProvider.setAuth(true);
      final user = await UserService.getUser(account, context);
      await _notificationService.configurePushNotification();
      if (user != null) {
        App.navigatorKey.currentState?.pushReplacementNamed(RouteNames.home);
      }
    }
  }
}
