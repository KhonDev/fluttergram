import 'package:flutter/material.dart';
import 'package:fluttergram/ui/screens/upload/upload_view_model.dart';
import 'package:fluttergram/ui/screens/upload/widgets/widgets.dart';
import 'package:provider/provider.dart';

class UploadPostWidget extends StatelessWidget {
  const UploadPostWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _model = context.watch<UploadViewModel>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          onPressed: _model.clearImage,
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: const Text(
          'Caption Post',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _model.isUploading ? null : () => _model.handleSubmit(),
            child: const Text(
              'Post',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_model.isUploading) const LinearProgressIndicator(),
            const UploadImageWidget(),
            const UploadInputsWidget(),
            const SizedBox(height: 20.0),
            const UploadButtonWidget()
          ],
        ),
      ),
    );
  }
}
