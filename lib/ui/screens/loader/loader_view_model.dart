import 'package:flutter/cupertino.dart';
import 'package:fluttergram/app.dart';
import 'package:fluttergram/domain/data_provider/is_auth_provider.dart';
import 'package:fluttergram/domain/service/google_auth_service.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/navigation/main_navigation.dart';

class LoaderViewModel {
  final BuildContext context;

  LoaderViewModel(this.context) {
    asyncInit();
  }

  void asyncInit() async {
    await checkAuth();
  }

  Future<void> checkAuth() async {
    final isAuth = await IsAuthProvider.getAuth();
    final account = await GoogleAuthService.googleSignIn
        .signInSilently(suppressErrors: true);
    if (account == null || !isAuth) {
      await UserService.getUser(account, context);
      App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteNames.auth,
        (route) => false,
      );
    } else {
      await UserService.getUser(account, context);
      App.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        RouteNames.home,
        (route) => false,
      );
    }
  }
}
