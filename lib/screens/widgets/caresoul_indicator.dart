import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';

// indicator dari caresoul
class CaresoulIndicator extends StatelessWidget {
  const CaresoulIndicator({
    this.activeColor = kPrimaryColor,
    this.inActiveColor = const Color.fromARGB(255, 202, 223, 240),
    this.isActive = false,
    super.key,
  });

  final bool isActive;
  final Color activeColor;
  final Color inActiveColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: 5,
      width: isActive ? 15 : 5,
      decoration: BoxDecoration(
        color: isActive ? activeColor : inActiveColor,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}
