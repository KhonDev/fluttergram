import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String username;
  final String displayName;
  final String email;
  final String bio;
  final String photoUrl;
  final Timestamp timestamp;

  User({
    required this.id,
    required this.username,
    required this.displayName,
    required this.email,
    required this.bio,
    required this.photoUrl,
    required this.timestamp,
  });

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
      id: doc['id'],
      username: doc['username'],
      displayName: doc['displayName'],
      email: doc['email'],
      bio: doc['bio'],
      photoUrl: doc['photoUrl'],
      timestamp: doc['timestamp'],
    );
  }
}
