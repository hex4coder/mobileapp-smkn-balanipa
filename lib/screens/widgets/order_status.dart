import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';

class OrderStatusWidget extends StatefulWidget {
  const OrderStatusWidget(
      {required this.text,
      required this.icon,
      required this.isSelected,
      required this.onTap,
      this.activeColor = kPrimaryColor,
      super.key});

  final String text;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Color activeColor;

  @override
  State<OrderStatusWidget> createState() => _OrderStatusWidgetState();
}

class _OrderStatusWidgetState extends State<OrderStatusWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: widget.isSelected ? widget.activeColor : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              size: 20,
              color: widget.isSelected ? Colors.white : Colors.grey,
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              widget.text,
              style: TextStyle(
                  fontSize: 12,
                  color: widget.isSelected ? Colors.white : Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
