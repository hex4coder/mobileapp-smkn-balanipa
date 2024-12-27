import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(const Duration(seconds: 1), () {
      Get.offAllNamed('/home');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.fromSize(
        size: MediaQuery.of(context).size,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/logo.png",
              width: 150,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "UPTD SMKN Balanipa",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text(
              "App Mobile",
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const Text(
              "Versi 1.0",
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
