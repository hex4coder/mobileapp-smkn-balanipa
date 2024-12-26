import 'package:flutter/material.dart';
import 'package:myapp/configs/colors.dart';
import 'package:myapp/configs/server.dart';

class ProductWidget extends StatelessWidget {
  const ProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              // image: DecorationImage(image: )
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          width: 300,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Product Name",
                    maxLines: 1,
                    overflow: TextOverflow.clip,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black.withOpacity(.7),
                    ),
                  ),
                  Text(
                    "By : Marendeng",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black.withOpacity(.5),
                    ),
                  ),
                ],
              ),
              Text(
                ServerConfig.convertPrice(34000),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: kPrimaryColor,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
