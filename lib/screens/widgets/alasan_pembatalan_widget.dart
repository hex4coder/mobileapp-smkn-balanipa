import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';

class AlasanPembatalanWidget extends StatefulWidget {
  const AlasanPembatalanWidget({super.key});

  @override
  State<AlasanPembatalanWidget> createState() => _AlasanPembatalanWidgetState();
}

class _AlasanPembatalanWidgetState extends State<AlasanPembatalanWidget> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text("Alasan Pembatalan"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: "Masukkan alasan disini...",
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (controller.text.isEmpty) {
              Fluttertoast.showToast(msg: "Alasan harus disertakan");
            } else {
              Get.back(result: controller.text);
            }
          },
          child: const Text(
            "OK",
            style: TextStyle(
              color: kPrimaryColor,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text(
            "Batal",
            style: TextStyle(
              color: Colors.amber,
            ),
          ),
        ),
      ],
    );
  }
}
