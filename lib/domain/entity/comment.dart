import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  final String userId;
  final String username;
  final String avatar;
  final String comment;
  final Timestamp timestamp;

  Comment({
    required this.userId,
    required this.username,
    required this.avatar,
    required this.comment,
    required this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot doc) {
    return Comment(
      userId: doc['userId'],
      username: doc['username'],
      avatar: doc['avatar'],
      comment: doc['comment'],
      timestamp: doc['timestamp'],
    );
  }
}
