import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:padre_mentor/src/app/widgets/image_picker/image_picker_dialog.dart';

class ImagePickerHandler {
  ImagePickerDialog imagePicker;
  AnimationController _controller;
  ImagePickerListener _listener;
  final picker = ImagePicker();
  ImagePickerHandler(this._listener, this._controller);

  openCamera() async {
    imagePicker.dismissDialog();
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    final File image = File(pickedFile.path);
    cropImage(image);
  }

  openGallery() async {
    imagePicker.dismissDialog();
    final  pickedFile = await picker.getImage(source: ImageSource.gallery);
    final File image = File(pickedFile.path);
    cropImage(image);
  }

  void init() {
    imagePicker = new ImagePickerDialog(this, _controller);
    imagePicker.initState();
  }

  Future cropImage(File image) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: image.path,
      //ratioX: 1.0,
      //ratioY: 1.0,
      aspectRatioPresets: [
        CropAspectRatioPreset.square
      ],
      maxWidth: 2300,
      maxHeight: 2300,
    );
    _listener.userImage(croppedFile);
  }

  showDialog(BuildContext context) {
    imagePicker.getImage(context);
  }
}

abstract class ImagePickerListener {
  userImage(File _image);
}