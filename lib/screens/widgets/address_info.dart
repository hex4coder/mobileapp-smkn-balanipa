import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/controllers/auth.dart';



class AddressWidget extends StatelessWidget {
  const AddressWidget({
    super.key,
    required this.authController,
  });

  final AuthController authController;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          title: const Row(
            children: [
              Icon(
                Icons.info,
                color: kPrimaryColor,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Alamat Lengkap",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(),
              Obx(() => Text(
                    authController.user?.address?.toAddress() ?? "",
                    style: const TextStyle(
                      fontSize: 12,
                      letterSpacing: .5,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
              const Divider(),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Pastikan alamat anda sudah benar!",
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
