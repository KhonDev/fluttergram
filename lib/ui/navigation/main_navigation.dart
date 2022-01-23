import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/loader/loader_screen.dart';
import 'package:fluttergram/ui/screens/screens.dart';

abstract class RouteNames {
  static const loader = '/';
  static const auth = 'auth';
  static const home = 'home';
  static const createUser = 'create-user';
}

class MainNavigation {
  String initialRoute = RouteNames.loader;

  final routes = <String, Widget Function(BuildContext)>{
    RouteNames.loader: (context) => const LoaderScreen(),
    RouteNames.auth: (_) => const AuthScreen(),
    RouteNames.home: (_) => const HomeScreen(),
    RouteNames.createUser: (_) => const CreateUserScreen(),
  };

  static void resetNavigation(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      RouteNames.loader,
      (route) => false,
    );
  }
}
