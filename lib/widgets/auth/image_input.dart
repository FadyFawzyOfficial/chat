import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function({File? imageFile}) onPickImage;

  const ImageInput({super.key, required this.onPickImage});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File? _imageFile;

  @override
  Widget build(context) {
    return Material(
      elevation: 3,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: _pickImage,
        child: CircleAvatar(
          radius: 48,
          backgroundColor: Colors.transparent,
          backgroundImage: _imageFile == null ? null : FileImage(_imageFile!),
          child: const Icon(Icons.add_a_photo_rounded),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final imagePicker = ImagePicker();
    final imageXFile = await imagePicker.pickImage(
      source: ImageSource.camera,
      //* This should give us much smaller image which is way faster to upload &
      //* a way smaller to store on Firebase Storage.
      //? We don't need high resolution, super large image if we just going to use
      //? a tiny image.
      //! It will be good enough for view a tiny user image in ChatScreen
      imageQuality: 50,
      //! Automatically Crop it to a max width of 200, so that our image isn't too big
      maxWidth: 200,
    );

    if (imageXFile != null) {
      final imageFile = File(imageXFile.path);
      setState(() => _imageFile = imageFile);
      widget.onPickImage(imageFile: imageFile);
    }
  }
}
