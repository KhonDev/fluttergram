import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:fluttergram/domain/data_provider/is_auth_provider.dart';
import 'package:fluttergram/domain/entity/user.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/google_auth_service.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/screens/edit_profile/widgets/widgets.dart';
import 'package:fluttergram/ui/screens/screens.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _currentUser = UserService.currentUser;
  final _displayNameController = TextEditingController();
  final _bioController = TextEditingController();
  String? _displayErrorText;
  String? _bioErrorText;
  bool isLoading = false;
  late User _user;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  void getUser() async {
    setState(() => isLoading = true);

    final doc = await FirebaseReference.userDB.doc(_currentUser.id).get();
    _user = User.fromDocument(doc);
    _displayNameController.text = _user.displayName;
    _bioController.text = _user.bio;
    setState(() => isLoading = false);
  }

  void updateProfile() {
    _displayErrorText = null;
    _bioErrorText = null;
    final String displayName = _displayNameController.text.trim();
    final String bio = _bioController.text.trim();
    if (displayName.length < 3 || displayName.isEmpty) {
      _displayErrorText = 'Display Name is short';
    }
    if (bio.length > 100) {
      _bioErrorText = 'Bio text too long';
    }
    setState(() {});

    if (_displayErrorText == null && _bioErrorText == null) {
      FirebaseReference.userDB.doc(_currentUser.id).update({
        'displayName': displayName,
        'bio': bio,
      });
      Navigator.pop(context, true);
    }
  }

  void showLogoutDialog() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Are you sure?'),
        content: const Text('Are you sure logout\nprofile?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('No'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            child: const Text('Yes'),
            onPressed: logOut,
          ),
        ],
      ),
    );
  }

  void logOut() async {
    await IsAuthProvider.setAuth(true);
    GoogleAuthService.signOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const AuthScreen(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: showLogoutDialog,
            color: Colors.red,
            iconSize: 28.0,
            splashRadius: 20.0,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: isLoading
          ? const LoadingWidget()
          : EditProfileBodyWidget(
              bioController: _bioController,
              bioErrorText: _bioErrorText,
              currentUser: _currentUser,
              displayErrorText: _displayErrorText,
              displayNameController: _displayNameController,
            ),
      floatingActionButton: isLoading
          ? null
          : FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: updateProfile,
              child: const Icon(
                Icons.check,
                color: Colors.white,
              ),
            ),
    );
  }
}
