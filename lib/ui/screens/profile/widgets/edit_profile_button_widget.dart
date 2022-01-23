import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/profile/profile_view_model.dart';
import 'package:provider/provider.dart';

class EditProfileButtonWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isFollowLoading;

  const EditProfileButtonWidget({
    Key? key,
    required this.title,
    required this.onPressed,
    this.isFollowLoading = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = context.watch<ProfileViewModel>();
    final isFollowing = _model.isFollowing;
    return SizedBox(
      width: 230.0,
      height: 30.0,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: isFollowing ? Colors.white : Colors.blue,
          primary: Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          side: isFollowing
              ? const BorderSide(color: Colors.grey)
              : BorderSide.none,
        ),
        onPressed: isFollowLoading ? null : onPressed,
        child: isFollowLoading
            ? const SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(strokeWidth: 3.0),
              )
            : Text(
                title,
                style: TextStyle(
                  fontSize: 14.0,
                  color: isFollowing ? Colors.black : Colors.white,
                ),
              ),
      ),
    );
  }
}
