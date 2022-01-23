import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttergram/domain/entity/user.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';

class SearchViewModel extends ChangeNotifier {
  QuerySnapshot? _searchResults;
  final List<User> _usersList = [];
  bool _isLoading = false;

  QuerySnapshot<Object?>? get searchResults => _searchResults;
  List<User> get usersList => _usersList;
  bool get isLoading => _isLoading;

  void handleSearch(String query) async {
    _isLoading = true;
    notifyListeners();
    QuerySnapshot<Map<String, dynamic>> users = await FirebaseReference.userDB
        .where('displayName', isGreaterThanOrEqualTo: query)
        .get();

    _searchResults = users;
    _usersList.clear();
    for (var user in users.docs) {
      _usersList.add(User.fromDocument(user));
    }
    _isLoading = false;
    notifyListeners();
  }
}
