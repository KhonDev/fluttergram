import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/upload/upload_view_model.dart';
import 'package:fluttergram/ui/screens/upload/widgets/widgets.dart';
import 'package:provider/provider.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = context.watch<UploadViewModel>();

    return _model.imageFile == null
        ? const UploadGetImageWidget()
        : const UploadPostWidget();
  }
}
