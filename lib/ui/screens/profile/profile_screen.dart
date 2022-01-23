import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/profile/profile_view_model.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';
import 'package:provider/provider.dart';

import 'widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  final String profileId;
  const ProfileScreen({
    Key? key,
    required this.profileId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void didChangeDependencies() {
    final _model = context.read<ProfileViewModel>();
    context.watch<ProfileViewModel>().getProfile(widget.profileId);
    _model.checkFollowing(widget.profileId);
    _model.getProfilePosts(widget.profileId);
    _model.getFollowersAndFollowings(widget.profileId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _model = context.watch<ProfileViewModel>();
    final isPostOrientationGrid = _model.isPostOrientationGrid;
    return Scaffold(
      appBar: const CustomAppBarWidget(
        isTimeLine: false,
        text: 'Profile',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ProfileHeaderWidget(profileId: widget.profileId),
            const Divider(height: 0.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  splashRadius: 20.0,
                  onPressed: isPostOrientationGrid
                      ? null
                      : _model.togglePostOrientation,
                  icon: Icon(
                    Icons.grid_on,
                    color: isPostOrientationGrid
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
                IconButton(
                  splashRadius: 20.0,
                  onPressed: !isPostOrientationGrid
                      ? null
                      : _model.togglePostOrientation,
                  icon: Icon(
                    Icons.list,
                    color: !isPostOrientationGrid
                        ? Theme.of(context).primaryColor
                        : Colors.grey,
                  ),
                ),
              ],
            ),
            const Divider(height: 0.0),
            ProfilePostsWidget(
              posts: _model.posts,
              isPostOrientationGrid: isPostOrientationGrid,
            ),
            const SizedBox(height: 30.0),
          ],
        ),
      ),
    );
  }
}
