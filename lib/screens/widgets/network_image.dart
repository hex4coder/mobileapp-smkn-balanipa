import 'package:flutter/material.dart';
import 'package:myapp/configs/server.dart';

class UiNetImage extends StatelessWidget {
  const UiNetImage(
      {required this.pathImage,
      this.fit = BoxFit.cover,
      this.isFullURL = false,
      this.autoSize = false,
      this.size = const Size(300, 200),
      super.key});

  final String pathImage;
  final BoxFit fit;
  final bool isFullURL;
  final bool autoSize;
  final Size size;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      isFullURL ? pathImage : ServerConfig.getImageUrl(pathImage),
      fit: fit,
      width: autoSize ? double.infinity : size.width,
      height: autoSize ? double.infinity :  size.height,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return SizedBox(
          width: autoSize ? double.infinity : size.width,
          height: autoSize ? double.infinity :  size.height,
          child: Column(
            children: [
              CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
              const SizedBox(
                height: 2,
              ),
              const Text(
                "loading",
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                ),
              )
            ],
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}
