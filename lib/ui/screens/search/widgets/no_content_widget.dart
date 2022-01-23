import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttergram/resources/resources.dart';

class NoContentWidget extends StatelessWidget {
  const NoContentWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            Svgs.search,
            height: orientation == Orientation.portrait ? 300.0 : 180.0,
            fit: BoxFit.scaleDown,
          ),
          const Text(
            'Find Users',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 50.0,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
