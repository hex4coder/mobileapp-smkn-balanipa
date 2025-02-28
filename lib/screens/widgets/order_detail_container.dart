import 'package:flutter/material.dart';

class OrderDetailContainer extends StatelessWidget {
  OrderDetailContainer({
    super.key,
    required this.content,
    this.title = "Title",
    this.icon = Icons.details,
    this.actionWidget = const SizedBox(),
  });

  final String title;
  final IconData icon;
  final Widget actionWidget;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey[200],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                size: 20,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(title),
              const Spacer(),
              actionWidget,
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          const Divider(),
          const SizedBox(
            height: 5,
          ),
          Container(
            width: double.infinity,
            color: Colors.white,
            padding: const EdgeInsets.all(8),
            child: content,
          ),
        ],
      ),
    );
  }
}
