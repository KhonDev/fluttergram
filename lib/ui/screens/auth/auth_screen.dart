import 'package:flutter/material.dart';
import 'package:fluttergram/resources/resources.dart';
import 'package:fluttergram/ui/screens/auth/auth_view_model.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.deepPurple,
              Colors.teal,
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Fluttergram',
              style: TextStyle(
                fontFamily: 'Signatra',
                color: Colors.white,
                fontSize: 55.0,
              ),
            ),
            GestureDetector(
              onTap: context.read<AuthViewModel>().signIn,
              child: Container(
                width: 260.0,
                height: 60.0,
                margin: const EdgeInsets.only(top: 10.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      Images.googleSigninButton,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
