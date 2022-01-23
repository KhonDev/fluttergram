import 'package:flutter/material.dart';
import 'package:fluttergram/domain/entity/post.dart';
import 'package:fluttergram/ui/screens/comments_screen.dart';

class PostFooterWidget extends StatelessWidget {
  const PostFooterWidget({
    Key? key,
    required this.post,
    required this.likesCount,
    required this.onLikePressed,
    required this.isLiked,
  }) : super(key: key);

  final Post post;
  final int likesCount;
  final bool isLiked;
  final VoidCallback onLikePressed;

  void showComments(
    BuildContext context, {
    required String postId,
    required String ownerId,
    required String mediaUrl,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommentsScreen(
          postId: postId,
          ownerId: ownerId,
          mediaUrl: mediaUrl,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: 10.0),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 15.0),
              child: GestureDetector(
                onTap: onLikePressed,
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: Colors.red,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => showComments(
                context,
                postId: post.postId,
                ownerId: post.ownerId,
                mediaUrl: post.mediaUrl,
              ),
              child: Icon(
                Icons.chat,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            top: 10.0,
            bottom: 5.0,
          ),
          child: Text(
            '$likesCount likes',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 10.0),
              child: Text(
                post.username,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: Text(post.description)),
          ],
        ),
      ],
    );
  }
}
