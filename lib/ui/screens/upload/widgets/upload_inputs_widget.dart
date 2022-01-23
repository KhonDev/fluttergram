import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:fluttergram/ui/screens/upload/upload_view_model.dart';
import 'package:provider/provider.dart';

class UploadInputsWidget extends StatelessWidget {
  const UploadInputsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              UserService.currentUser.photoUrl,
            ),
          ),
          title: SizedBox(
            width: 250.0,
            child: TextField(
              controller: context.read<UploadViewModel>().captionController,
              decoration: const InputDecoration(
                hintText: 'Write a caption...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(
            Icons.pin_drop,
            color: Colors.blue,
            size: 35.0,
          ),
          title: SizedBox(
            width: 250.0,
            child: TextField(
              controller: context.read<UploadViewModel>().locationController,
              decoration: const InputDecoration(
                hintText: 'Where was this photo taken?',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
