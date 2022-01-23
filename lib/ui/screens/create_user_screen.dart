import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttergram/ui/widgets/custom_appbar_widget.dart';

class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({Key? key}) : super(key: key);

  @override
  _CreateUserScreenState createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String? username;

  void onSubmit() {
    final form = _formKey.currentState;

    if (form!.validate()) {
      FocusScope.of(context).unfocus();
      form.save();
      SnackBar snackBar = SnackBar(content: Text('Welcome $username'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Timer(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).clearSnackBars();
        Navigator.pop(context, username);
      });
    }
  }

  String? validateForm(String? text) {
    if (text == null) return 'Please, type username';

    if (text.trim().length < 3 || text.isEmpty) {
      return 'Username too short';
    } else if (text.trim().length > 12) {
      return 'Username too long';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(
        isTimeLine: false,
        text: 'Set up your profile',
      ),
      body: SizedBox(
        width: double.infinity,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              const Spacer(),
              const Text(
                'Create a username',
                style: TextStyle(fontSize: 25.0),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0).copyWith(bottom: 40.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onSaved: (value) => setState(() => username = value),
                    validator: validateForm,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Username',
                      labelStyle: TextStyle(fontSize: 15.0),
                      hintText: 'Must be at least 3 characters.',
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 300.0,
                height: 50.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                  ),
                  onPressed: onSubmit,
                  child: const Text(
                    'Submit',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
