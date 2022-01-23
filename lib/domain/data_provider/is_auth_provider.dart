import 'package:shared_preferences/shared_preferences.dart';

abstract class IsAuthProvider {
 static Future<bool> getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isAuth') ?? false;
  }

static  Future<bool> setAuth(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setBool('isAuth', value);
  }
}
