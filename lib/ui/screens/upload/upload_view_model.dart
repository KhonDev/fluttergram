import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttergram/domain/firebase_refrence/firebase_reference.dart';
import 'package:fluttergram/domain/service/user_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class UploadViewModel extends ChangeNotifier {
  File? _imageFile;
  final _locationController = TextEditingController();
  final _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isUploading = false;
  bool _inProgressLocation = false;
  String _postId = const Uuid().v4();

  bool get isUploading => _isUploading;
  bool get inProgressLocation => _inProgressLocation;
  TextEditingController get locationController => _locationController;
  TextEditingController get captionController => _captionController;
  ImagePicker get imagePicker => _picker;
  File? get imageFile => _imageFile;

  void handleTakePhoto(BuildContext context) async {
    Navigator.pop(context);
    final file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 960,
      maxHeight: 675,
    );

    if (file != null) {
      _imageFile = File(file.path);
      notifyListeners();
    }
  }

  void handleChooseFromGallery(BuildContext context) async {
    Navigator.pop(context);
    final file = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (file != null) {
      _imageFile = File(file.path);
      notifyListeners();
    }
  }

  showSelectImageDialog(BuildContext context) {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Create Post'),
        children: <Widget>[
          SimpleDialogOption(
            child: const Text('Photo with Camera'),
            onPressed: () => handleTakePhoto(context),
          ),
          SimpleDialogOption(
            child: const Text('Image from Gallery'),
            onPressed: () => handleChooseFromGallery(context),
          ),
          SimpleDialogOption(
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void clearImage() {
    _imageFile = null;
    notifyListeners();
  }

  Future<void> compressImage() async {
    final file = await _imageFile!.readAsBytes();
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    final decodedImage = img.decodeImage(file);
    final compressedImage = File('$path/img_$_postId.jpg')
      ..writeAsBytesSync(
        img.encodeJpg(decodedImage!, quality: 85),
      );
    _imageFile = compressedImage;
    notifyListeners();
  }

  Future<String> uploadImage(imageFile) async {
    final uploadTask = FirebaseReference.storageRef
        .child("post_$_postId.jpg")
        .putFile(imageFile);
    String downloadUrl = await (await uploadTask).ref.getDownloadURL();

    return downloadUrl;
  }

  void handleSubmit() async {
    _isUploading = true;
    notifyListeners();
    await compressImage();
    String mediaUrl = await uploadImage(_imageFile);

    createPostInFireStore(
      mediaUrl: mediaUrl,
      location: _locationController.text.trim(),
      description: _captionController.text.trim(),
    );

    _locationController.clear();
    _captionController.clear();
    _imageFile = null;
    _isUploading = false;
    _postId = const Uuid().v4();
    notifyListeners();
  }

  createPostInFireStore({
    required String mediaUrl,
    required String location,
    required String description,
  }) {
    FirebaseReference.postDB
        .doc(UserService.currentUser.id)
        .collection('userPosts')
        .doc(_postId)
        .set({
      'postId': _postId,
      'ownerId': UserService.currentUser.id,
      'username': UserService.currentUser.username,
      'description': description,
      'location': location,
      'mediaUrl': mediaUrl,
      'timestamp': DateTime.now(),
      'likes': {},
    });
  }

  void getUserLocation() async {
    _inProgressLocation = true;
    notifyListeners();
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    final placemarkFirst = placemarks.first;
    final completeAdress =
        '${placemarkFirst.subThoroughfare} ${placemarkFirst.thoroughfare}, ${placemarkFirst.subLocality} ${placemarkFirst.locality}, ${placemarkFirst.subAdministrativeArea} ${placemarkFirst.administrativeArea}, ${placemarkFirst.postalCode}, ${placemarkFirst.country}';
    debugPrint(completeAdress);
    final formattedAdress =
        '${placemarkFirst.locality}, ${placemarkFirst.country}';
    _locationController.text = formattedAdress;
    _inProgressLocation = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _locationController.dispose();
    _captionController.dispose();
    super.dispose();
  }
}
