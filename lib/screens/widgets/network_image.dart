import 'package:flutter/material.dart';
import 'package:myapp/configs/server.dart';

class UiNetImage extends StatelessWidget {
  const UiNetImage(
      {required this.pathImage,
      this.fit = BoxFit.cover,
      this.isFullURL = false,
      super.key});

  final String pathImage;
  final BoxFit fit;
  final bool isFullURL;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      isFullURL ? pathImage : ServerConfig.getImageUrl(pathImage),
      fit: fit,
      width: 300,
      height: 200,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return SizedBox(
          width: 300,
          height: 200,
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
