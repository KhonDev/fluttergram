import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/domain/service/user_service.dart';

import 'screens.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void changeCurrentIndex(int index) {
    _currentIndex = index;
    setState(() {});
  }

  final _screens = <Widget>[
    const TimeLineScreen(),
    const ActivityFeedScreen(),
    const UploadScreen(),
    const SearchScreen(),
    ProfileScreen(profileId: UserService.currentUser.id),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: CupertinoTabBar(
        onTap: (index) => changeCurrentIndex(index),
        currentIndex: _currentIndex,
        activeColor: Theme.of(context).primaryColor,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.whatshot),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_active),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.photo_camera,
              size: 35.0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: '',
          ),
        ],
      ),
    );
  }
}
