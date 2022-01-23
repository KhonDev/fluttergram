import 'package:google_sign_in/google_sign_in.dart';

abstract class GoogleAuthService {
  static final _googleSignIn = GoogleSignIn();

  static GoogleSignIn get googleSignIn => _googleSignIn;

  static Future<GoogleSignInAccount?> signIn() async =>
      await _googleSignIn.signIn();

  static void signOut() => _googleSignIn.signOut();
}
