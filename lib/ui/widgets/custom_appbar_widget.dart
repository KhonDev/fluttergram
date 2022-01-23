import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget with PreferredSizeWidget {
  final bool isTimeLine;
  final String text;
  const CustomAppBarWidget({
    Key? key,
    this.isTimeLine = false,
    this.text = '',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        isTimeLine ? 'Fluttergram' : text,
        style: TextStyle(
          fontSize: isTimeLine ? 40.0 : 25.0,
          fontFamily: isTimeLine ? 'Signatra' : '',
        ),
        overflow: TextOverflow.ellipsis,
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
