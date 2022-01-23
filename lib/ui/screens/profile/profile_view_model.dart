import 'package:flutter/material.dart';
import 'package:fluttergram/app.dart';
import 'package:fluttergram/domain/entity/post.dart';
import 'package:fluttergram/domain/entity/user.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/screens/edit_profile/edit_profile_screen.dart';
import 'package:fluttergram/ui/screens/profile/widgets/edit_profile_button_widget.dart';

class ProfileViewModel extends ChangeNotifier {
  final currentUser = UserService.currentUser;
  bool _isPostOrientationGrid = true;
  bool _isFollowing = false;
  bool _isFollowLoading = false;
  User? _user;
  bool _userLoading = true;
  int _postCount = 0;
  int _followersCount = 0;
  int _followingsCount = 0;
  List<Post> _posts = [];

  bool get isPostOrientationGrid => _isPostOrientationGrid;
  bool get isFollowing => _isFollowing;
  bool get userLoading => _userLoading;
  bool get isFollowLoading => _isFollowLoading;
  User? get user => _user;
  int get postCount => _postCount;
  int get followersCount => _followersCount;
  int get followingsCount => _followingsCount;
  List<Post> get posts => _posts;

  void checkFollowing(String profileId) async {
    final followersDoc = await FirebaseReference.followersDB
        .doc(profileId)
        .collection('userFollowers')
        .doc(currentUser.id)
        .get();

    _isFollowing = followersDoc.exists;
    notifyListeners();
  }

  void getFollowersAndFollowings(String profileId) async {
    final followers = await FirebaseReference.followersDB
        .doc(profileId)
        .collection('userFollowers')
        .get();

    final followings = await FirebaseReference.followingDB
        .doc(profileId)
        .collection('userFollowing')
        .get();

    _followersCount = followers.docs.length;
    _followingsCount = followings.docs.length;
    notifyListeners();
  }

  Widget buildProfileButton(String profileId) {
    final isProfileOwner = currentUser.id == profileId;

    if (isProfileOwner) {
      return EditProfileButtonWidget(
        title: 'Edit Profile',
        onPressed: () => editProfile(profileId),
      );
    }
    return EditProfileButtonWidget(
      title: _isFollowing ? 'Unfollow' : 'Follow',
      onPressed: () => handleFollowingToggle(profileId),
      isFollowLoading: _isFollowLoading,
    );
  }

  void handleFollowingToggle(String profileId) async {
    _isFollowLoading = true;
    notifyListeners();

    final followersDoc = FirebaseReference.followersDB
        .doc(profileId)
        .collection('userFollowers')
        .doc(currentUser.id);
    final followingDoc = FirebaseReference.followingDB
        .doc(currentUser.id)
        .collection('userFollowing')
        .doc(profileId);
    final activityDoc = FirebaseReference.activityDB
        .doc(profileId)
        .collection('feedItems')
        .doc(currentUser.id);

    if (_isFollowing) {
      final docs = [followersDoc, followingDoc, activityDoc];
      for (var doc in docs) {
        var data = await doc.get();
        if (data.exists) await data.reference.delete();
      }
    } else {
      followersDoc.set({});
      followingDoc.set({});
      activityDoc.set({
        'type': 'follow',
        'ownerId': profileId,
        'username': UserService.currentUser.username,
        'userId': currentUser.id,
        'userAvatar': UserService.currentUser.photoUrl,
        'timestamp': DateTime.now(),
        'postId': '',
        'mediaUrl': '',
        'commentData': '',
      });
    }
    _isFollowing = !_isFollowing;
    _isFollowLoading = false;
    getFollowersAndFollowings(profileId);
  }

  getProfilePosts(String profileId) async {
    final snapshot = await FirebaseReference.postDB
        .doc(profileId)
        .collection('userPosts')
        .orderBy('timestamp', descending: true)
        .get();

    _postCount = snapshot.docs.length;
    _posts = snapshot.docs.map((e) => Post.fromDocument(e)).toList();
    notifyListeners();
  }

  editProfile(String profileId) async {
    final result = await App.navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const EditProfileScreen(),
      ),
    );
    if (result) {
      await getProfile(profileId);
    }
  }

  Future<void> getProfile(String profileId) async {
    var result = await FirebaseReference.userDB.doc(profileId).get();
    _user = User.fromDocument(result);
    _userLoading = false;
    notifyListeners();
  }

  void togglePostOrientation() {
    _isPostOrientationGrid = !isPostOrientationGrid;
    notifyListeners();
  }
}
