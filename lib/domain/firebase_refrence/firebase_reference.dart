import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseReference {
  static final storageRef = FirebaseStorage.instance.ref();
  static final userDB = FirebaseFirestore.instance.collection('users');
  static final postDB = FirebaseFirestore.instance.collection('posts');
  static final commentsDB = FirebaseFirestore.instance.collection('comments');
  static final activityDB = FirebaseFirestore.instance.collection('feed');
  static final followersDB = FirebaseFirestore.instance.collection('followers');
  static final followingDB = FirebaseFirestore.instance.collection('following');
  static final timelineDB = FirebaseFirestore.instance.collection('timeline');
}
