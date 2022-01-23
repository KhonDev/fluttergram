import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/user_service.dart';

class ActivityFeedViewModel {
  var _feeds = <QueryDocumentSnapshot<Map<String, dynamic>>>[];
  Stream? _feedsStream;
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get feeds => _feeds;
  Stream get feedsStream => _feedsStream!;

  ActivityFeedViewModel() {
    getActivityFeed();
  }

  void getActivityFeed() {
    _feedsStream = FirebaseReference.activityDB
        .doc(UserService.currentUser.id)
        .collection('feedItems')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots();

    _feedsStream?.listen((snapshot) {
      _feeds = snapshot.docs;
    });
  }
}
