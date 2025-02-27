import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/auth.dart';
import 'package:myapp/screens/pages/login_page.dart';
import 'package:myapp/screens/pages/orders_page.dart';

class OrderStatus {
  String text;
  IconData icon;
  String code;
  Color activeColor;
  OrderStatus(
      {required this.text,
      required this.icon,
      required this.code,
      this.activeColor = kPrimaryColor});
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetX<AuthController>(builder: (controller) {
          if (controller.isLoggedIn) return const MyOrdersPage();

          return const LoginPage();
        }),
      ),
    );
  }
}
