import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/post_screen.dart';

void showPost(BuildContext context, String postId, String userId) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostScreen(
        postId: postId,
        userId: userId,
      ),
    ),
  );
}
