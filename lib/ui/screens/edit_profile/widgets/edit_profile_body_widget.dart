import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/domain/entity/user.dart';

class EditProfileBodyWidget extends StatelessWidget {
  const EditProfileBodyWidget({
    Key? key,
    required this.currentUser,
    required this.displayErrorText,
    required this.displayNameController,
    required this.bioErrorText,
    required this.bioController,
  }) : super(key: key);

  final User currentUser;
  final String? displayErrorText;
  final String? bioErrorText;
  final TextEditingController displayNameController;
  final TextEditingController bioController;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 16.0,
              bottom: 8.0,
            ),
            child: CircleAvatar(
              radius: 50.0,
              backgroundImage: CachedNetworkImageProvider(currentUser.photoUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                TextField(
                  controller: displayNameController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Display Name',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                    border: const OutlineInputBorder(),
                    isDense: true,
                    errorText: displayErrorText,
                  ),
                ),
                const SizedBox(height: 20.0),
                TextField(
                  controller: bioController,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Bio',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                    ),
                    border: const OutlineInputBorder(),
                    isDense: true,
                    errorText: bioErrorText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
