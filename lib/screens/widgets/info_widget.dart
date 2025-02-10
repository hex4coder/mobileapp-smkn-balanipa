import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';

class InfoWidget extends StatelessWidget {
  const InfoWidget({
    required this.title,
    required this.icon,
    required this.content,
    super.key,
  });

  final String title;
  final IconData icon;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListTile(
          title: Row(
            children: [
              Icon(
                icon,
                color: kPrimaryColor,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 2,
              ),
              const Divider(),
              content,
            ],
          ),
        ),
      ),
    );
  }
}
