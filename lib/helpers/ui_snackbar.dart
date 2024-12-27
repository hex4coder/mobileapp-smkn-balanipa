import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';

// berisi utility untuk membuat helper snackbar
class UiSnackbar {
  // untuk menampilkan pesan success
  static void success(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: kPrimaryColor,
      icon: const Icon(
        Icons.check_circle,
        color: Colors.white,
      ),
    );
  }

  // untuk menampilkan pesan kesalahan
  static void error(String title, String message) {
    Get.snackbar(
      title,
      message,
      colorText: Colors.white,
      backgroundColor: const Color.fromARGB(255, 136, 19, 11),
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
    );
  }
}
