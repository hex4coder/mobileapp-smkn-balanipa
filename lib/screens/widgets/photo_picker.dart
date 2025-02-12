import 'dart:io';

// image picker
import 'package:image_picker/image_picker.dart';


import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';

class PhotoPicker extends StatefulWidget {
  const PhotoPicker({required this.onChanged, super.key});

  final ValueChanged<File?> onChanged;

  @override
  State<PhotoPicker> createState() => _PhotoPickerState();
}

class _PhotoPickerState extends State<PhotoPicker> {


  File? file;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [


        // image container
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: file != null ? Colors.transparent : Colors.white,
            image: file == null
                ? null
                : DecorationImage(
                    image: FileImage(file!),
                    fit: BoxFit.cover,
                  ),
          ),
        ),

        // remove button
        if (file != null) ...[Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              setState(() {
                file = null;
                widget.onChanged(null);
                });

              },
            icon: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
          ),
        ),
        ],


        // jika file tidak ada, munculkan tombol kamera dan galery.
        if(file == null) ...[Positioned(
            child: 
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
            children: [

            const Text("Sertakan bukti transfer!"),


            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () async {

                    final XFile? pickedFile = await _picker.pickImage(
                        source: ImageSource.camera,
                      );

                      if(pickedFile != null) {
                        setState(() {
                          file = File(pickedFile.path);
                          widget.onChanged(file);
                        });
                      }                    
                    },
                  icon: const Icon(
                    Icons.camera_alt,
                    color: kPrimaryColor,
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                    onPressed: () async {
                      final XFile? pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                    );

                      if(pickedFile != null) {
                        setState(() {
                          file = File(pickedFile.path);
                          widget.onChanged(file);
                        });
          
                      }

                      },
                    icon: const Icon(
                      Icons.image,
                      color: kPrimaryColor,
                    ),
                  ),
                 ],
               ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
