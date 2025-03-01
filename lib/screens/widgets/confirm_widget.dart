import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';

class ConfirmWidget extends StatefulWidget {
  const ConfirmWidget(
      {super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  State<ConfirmWidget> createState() => _ConfirmWidgetState();
}

class _ConfirmWidgetState extends State<ConfirmWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(
        widget.title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: kPrimaryColor,
        ),
      ),
      content: Text(
        widget.description,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: "yes");
          },
          child: const Text(
            "Ya",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "Tidak",
            style: TextStyle(
              color: Colors.amber,
            ),
          ),
        ),
      ],
    );
  }
}
