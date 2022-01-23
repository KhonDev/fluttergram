import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/upload/upload_view_model.dart';
import 'package:provider/provider.dart';

class UploadButtonWidget extends StatelessWidget {
  const UploadButtonWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isProgress =
        context.select((UploadViewModel m) => m.inProgressLocation);
    return SizedBox(
      width: 200.0,
      height: 40.0,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed:
            isProgress ? null : context.read<UploadViewModel>().getUserLocation,
        label: isProgress
            ? const SizedBox(
                width: 10.0,
                height: 10.0,
                child: CircularProgressIndicator(strokeWidth: 2.0),
              )
            : const Text(
                'Use current location',
                style: TextStyle(color: Colors.white),
              ),
        icon: isProgress
            ? const SizedBox()
            : const Icon(Icons.my_location, color: Colors.white),
      ),
    );
  }
}
