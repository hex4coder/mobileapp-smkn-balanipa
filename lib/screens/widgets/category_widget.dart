import 'package:flutter/material.dart';


class CategoryWidget extends StatelessWidget {
  const CategoryWidget(
      {super.key,
      required this.categoryPhoto,
      required this.categoryName,
      required this.onTap});

  final String categoryPhoto;
  final String categoryName;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox.fromSize(
          size: const Size.square(150),
          child: Card(
            color: Colors.white,
            shadowColor: Colors.black.withOpacity(.1),
            child: Image.asset(
              categoryPhoto,
              width: 50,
              height: 50,
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          categoryName,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Colors.black.withOpacity(.7),
          ),
        )
      ],
    );
  }
}
