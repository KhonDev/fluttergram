import 'package:flutter/material.dart';

class ProfileCountColumnWidget extends StatelessWidget {
  final int count;
  final String title;
  const ProfileCountColumnWidget({
    Key? key,
    required this.count,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          '$count',
          style: const TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15.0,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
