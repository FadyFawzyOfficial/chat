import 'package:flutter/material.dart';

class ImageInput extends StatefulWidget {
  const ImageInput({super.key});

  @override
  State<ImageInput> createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  @override
  Widget build(context) {
    return Material(
      elevation: 3,
      shape: const CircleBorder(),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: () {},
        child: const CircleAvatar(
          radius: 48,
          backgroundColor: Colors.transparent,
          child: Icon(Icons.add_a_photo_rounded),
        ),
      ),
    );
  }
}
