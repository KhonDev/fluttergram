import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/domain/entity/user.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/utils/show_profile.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';

class PostHeaderWidget extends StatelessWidget {
  const PostHeaderWidget({
    Key? key,
    required this.location,
    required this.ownerId,
    required this.postId,
  }) : super(key: key);

  final String location;
  final String ownerId;
  final String postId;

  handlePostDelete(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Remove this post'),
        children: [
          SimpleDialogOption(
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
              deletePost();
            },
          ),
          SimpleDialogOption(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void deletePost() async {
    FirebaseReference.postDB
        .doc(ownerId)
        .collection('userPosts')
        .doc(postId)
        .get()
        .then((doc) {
      if (doc.exists) {
        doc.reference.delete();
      }
    });

    FirebaseReference.storageRef.child("post_$postId.jpg").delete();

    final snapshot = await FirebaseReference.activityDB
        .doc(ownerId)
        .collection('feedItems')
        .where('postId', isEqualTo: postId)
        .get();

    for (var doc in snapshot.docs) {
      if (doc.exists) doc.reference.delete();
    }

    final commentsSnapshot = await FirebaseReference.commentsDB
        .doc(postId)
        .collection('comments')
        .get();

    for (var doc in commentsSnapshot.docs) {
      if (doc.exists) doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseReference.userDB.doc(ownerId).get(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const LoadingWidget();
        }
        final User _user = User.fromDocument(snapshot.data);
        final bool isPostOwner = ownerId == UserService.currentUser.id;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: CachedNetworkImageProvider(_user.photoUrl),
          ),
          title: GestureDetector(
            onTap: () => showProfile(context, _user.id),
            child: Text(
              _user.username,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(location),
          trailing: isPostOwner
              ? IconButton(
                  onPressed: () => handlePostDelete(context),
                  icon: const Icon(
                    Icons.more_vert,
                  ),
                )
              : null,
        );
      },
    );
  }
}
