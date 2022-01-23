import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttergram/ui/screens/profile/profile_view_model.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';

import 'widgets.dart';

class ProfileHeaderWidget extends StatelessWidget {
  const ProfileHeaderWidget({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  final String profileId;

  @override
  Widget build(BuildContext context) {
    final _model = context.watch<ProfileViewModel>();
    final _user = _model.user;

    return _model.userLoading || _user == null
        ? const LoadingWidget()
        : Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                          CachedNetworkImageProvider(_user.photoUrl),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ProfileCountColumnWidget(
                                title: 'posts',
                                count: _model.postCount,
                              ),
                              ProfileCountColumnWidget(
                                title: 'followers',
                                count: _model.followersCount,
                              ),
                              ProfileCountColumnWidget(
                                title: 'following',
                                count: _model.followingsCount,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          _model.buildProfileButton(profileId)
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Text(
                  _user.username,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    _user.displayName,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (_user.bio.isNotEmpty) Text(_user.bio),
              ],
            ),
          );
  }
}
