import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/app.dart';
import 'package:fluttergram/domain/entity/user.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/ui/screens/create_user_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserService {
  static User? _currentUser;

  static User get currentUser => _currentUser!;

  static Future<User?> getUser(
      GoogleSignInAccount? account, BuildContext context) async {
    if (account != null) {
      DocumentSnapshot doc =
          await FirebaseReference.userDB.doc(account.id).get();

      if (!doc.exists) {
        doc = await createUserInFirestore(context, account);
      }
      _currentUser = User.fromDocument(doc);
      return currentUser;
    }
  }

  static Future<DocumentSnapshot> createUserInFirestore(
      BuildContext context, GoogleSignInAccount user) async {
    String username = (await App.navigatorKey.currentState?.push(
          MaterialPageRoute(
            builder: (context) => const CreateUserScreen(),
          ),
        )) ??
        'newuser';

    FirebaseReference.userDB.doc(user.id).set({
      'id': user.id,
      'username': username,
      'photoUrl': user.photoUrl,
      'email': user.email,
      'displayName': user.displayName,
      'bio': '',
      'timestamp': DateTime.now(),
    });
    await FirebaseReference.followersDB
        .doc(user.id)
        .collection('userFollowers')
        .doc(user.id)
        .set({});
    final result = await FirebaseReference.userDB.doc(user.id).get();

    return result;
  }
}
