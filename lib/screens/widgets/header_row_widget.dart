import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';

class HeaderRowWidget extends StatelessWidget {
  const HeaderRowWidget({
    required this.onTap,
    required this.title,
    this.labelTap = "Semua",
    super.key,
  });

  final String labelTap;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            labelTap,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: kPrimaryColor,
            ),
          ),
        ),
      ],
    );
  }
}
