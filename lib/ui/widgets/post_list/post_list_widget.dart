import 'dart:async';

import 'package:animator/animator.dart';
import 'package:flutter/material.dart';

import 'package:fluttergram/domain/entity/post.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/widgets/widgets.dart';

import 'widgets/widgets.dart';

class PostListWidget extends StatefulWidget {
  final Post post;

  const PostListWidget({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostListWidget> createState() => _PostListWidgetState();
}

class _PostListWidgetState extends State<PostListWidget> {
  final currentUser = UserService.currentUser;
  bool showHeart = false;
  late bool isLiked;
  late int likesCount;

  int getLikeCount() {
    if (widget.post.likes == null) return 0;

    int count = 0;
    widget.post.likes.values.forEach((val) {
      if (val == true) {
        count += 1;
      }
    });
    return count;
  }

  void handleLikePost() {
    bool _isLiked = widget.post.likes[currentUser.id] ?? false;

    if (_isLiked) {
      FirebaseReference.postDB
          .doc(widget.post.ownerId)
          .collection('userPosts')
          .doc(widget.post.postId)
          .update({'likes.${currentUser.id}': false});
      actictyFeedAction('delete');
      likesCount -= 1;
      isLiked = false;
      widget.post.likes[currentUser.id] = false;
      setState(() {});
    } else {
      FirebaseReference.postDB
          .doc(widget.post.ownerId)
          .collection('userPosts')
          .doc(widget.post.postId)
          .update({'likes.${currentUser.id}': true});
      actictyFeedAction('like');
      likesCount += 1;
      isLiked = true;
      widget.post.likes[currentUser.id] = true;
      showHeart = true;
      setState(() {});
      Timer(const Duration(milliseconds: 800), () {
        setState(() => showHeart = false);
      });
    }
  }

  void actictyFeedAction(String type) {
    if (currentUser.id == widget.post.ownerId) return;
    final doc = FirebaseReference.activityDB
        .doc(widget.post.ownerId)
        .collection('feedItems')
        .doc(widget.post.postId);
    if (type == 'delete') {
      doc.get().then((data) {
        if (data.exists) data.reference.delete();
      });
      return;
    }
    doc.set({
      'type': type,
      'username': currentUser.username,
      'userId': currentUser.id,
      'userAvatar': currentUser.photoUrl,
      'postId': widget.post.postId,
      'mediaUrl': widget.post.mediaUrl,
      'timestamp': DateTime.now(),
      'commentData': '',
    });
  }

  @override
  void initState() {
    super.initState();
    likesCount = getLikeCount();
    isLiked = (widget.post.likes[currentUser.id]) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        PostHeaderWidget(
          location: widget.post.location,
          ownerId: widget.post.ownerId,
          postId: widget.post.postId,
        ),
        GestureDetector(
          onDoubleTap: handleLikePost,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CachedNetworkImageWidget(
                height: 400.0,
                url: widget.post.mediaUrl,
              ),
              if (showHeart)
                Animator(
                  duration: const Duration(milliseconds: 500),
                  tween: Tween(begin: 0.8, end: 1.4),
                  curve: Curves.easeInOut,
                  cycles: 0,
                  builder: (context, AnimatorState animatorState, _) =>
                      Transform.scale(
                    scale: animatorState.animation.value,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 80.0,
                    ),
                  ),
                ),
            ],
          ),
        ),
        PostFooterWidget(
          post: widget.post,
          isLiked: isLiked,
          likesCount: likesCount,
          onLikePressed: handleLikePost,
        ),
      ],
    );
  }
}
