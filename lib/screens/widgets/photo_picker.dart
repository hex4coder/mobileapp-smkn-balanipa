import 'dart:io';

import 'package:flutter/material.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({required this.onChanged, super.key});

  final ValueChanged<File?> onChanged;

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {
  File? file;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: file != null ? Colors.transparent : Colors.grey,
            image: file == null
                ? null
                : DecorationImage(
                    image: FileImage(file!),
                  ),
          ),
        ),

        // remove button
        Positioned(
          top: 5,
          right: 5,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
