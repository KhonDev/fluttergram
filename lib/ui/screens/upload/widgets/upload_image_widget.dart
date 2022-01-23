import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/upload/upload_view_model.dart';
import 'package:provider/provider.dart';

class UploadImageWidget extends StatelessWidget {
  const UploadImageWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _imageFile = context.select((UploadViewModel m) => m.imageFile);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      margin: const EdgeInsets.only(bottom: 10.0),
      height: 220.0,
      width: double.infinity,
      child: Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(_imageFile!),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
