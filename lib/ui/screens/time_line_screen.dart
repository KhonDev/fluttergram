import 'package:flutter/material.dart';
import 'package:fluttergram/domain/entity/post.dart';

import 'package:fluttergram/domain/entity/user.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';

class TimeLineScreen extends StatefulWidget {
  const TimeLineScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<TimeLineScreen> createState() => _TimeLineScreenState();
}

class _TimeLineScreenState extends State<TimeLineScreen> {
  List<Post>? posts;
  List<String> followingList = [];

  @override
  void initState() {
    super.initState();
    getTimeline();
    getFollowing();
  }

  Future<void> getTimeline() async {
    final snapshot = await FirebaseReference.timelineDB
        .doc(UserService.currentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .get();
    posts = snapshot.docs.map((post) => Post.fromDocument(post)).toList();
    setState(() {});
  }

  getFollowing() async {
    final snapshot = await FirebaseReference.followingDB
        .doc(UserService.currentUser.id)
        .collection('userFollowing')
        .get();

    followingList = snapshot.docs.map((doc) => doc.id).toList();
    setState(() {});
  }

  Widget buildTimeline() {
    final postsList = posts;

    if (postsList == null) {
      return const LoadingWidget();
    } else if (postsList.isEmpty) {
      return buildUsersToFollow();
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 20.0),
      itemCount: postsList.length,
      itemBuilder: (_, index) => PostListWidget(post: postsList[index]),
    );
  }

  buildUsersToFollow() {
    final streamData = FirebaseReference.userDB
        .orderBy('timestamp', descending: true)
        .limit(30)
        .snapshots();
    return StreamBuilder(
      stream: streamData,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const LoadingWidget();
        }
        final _users = <User>[];
        snapshot.data.docs.forEach((doc) {
          final user = User.fromDocument(doc);
          final bool isFollowingUser = followingList.contains(user.id);
          if (user.id != UserService.currentUser.id && !isFollowingUser) {
            _users.add(user);
          }
        });
        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.person_add,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    'Users to Follow',
                    style: TextStyle(
                      fontSize: 30.0,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, index) => UserResultWidget(
                  user: _users[index],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(isTimeLine: true),
      body: RefreshIndicator(
        onRefresh: getTimeline,
        child: buildTimeline(),
      ),
    );
  }
}
