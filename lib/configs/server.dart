// server configurations
import 'package:flutter/material.dart';

class ServerConfig {
  // base url
  // static String kServerBaseAPI = "https://ecom-api.smknbalanipa.sch.id";
//  static String kServerBaseAPI = "http://10.0.2.2:3001";
  static String kServerBaseAPI = "http://89.116.20.48:3000";

  // default network image for no image
  static String kNoImage =
      "https://upload.wikimedia.org/wikipedia/commons/thumb/6/65/No-Image-Placeholder.svg/330px-No-Image-Placeholder.svg.png?20200912122019";

  // price conversion
  static String convertPrice(int currentPrice) {
    String newPrice = "";

    // bahagia dalam 1000
    double p = currentPrice / 1000;
    String ps = p.toString();
    if (ps.endsWith(".0")) {
      ps = ps.replaceAll(".0", "");
    }
    newPrice = "Rp. ${ps}K";

    return newPrice;
  }

  // get image url
  static String getImageUrl(String filename, {bool externalUrl = false}) {
    if (externalUrl) {
      return filename;
    }

    if (filename.contains("/")) {
      filename = filename.replaceAll("/", "");
    }

    String baseUriImage = "${ServerConfig.kServerBaseAPI}/images/";
    return baseUriImage + filename;
  }

  // format string to capitalize
  static String capitalize(String fromString) {
    String toString = fromString.substring(0, 1).toUpperCase() +
        fromString.substring(1).toLowerCase();
    return toString;
  }

  static Color getColorByStatus(String lowerStatus, {bool foreground = false}) {
    Color color = Colors.amber;

    if (lowerStatus == "dibatalkan") color = Colors.red;
    if (lowerStatus == "sedang diproses") color = Colors.blue;
    if (lowerStatus == "dibatalkan") color = Colors.red;
    if (lowerStatus == "sudah dikirim") color = Colors.indigo;
    if (lowerStatus == "selesai") color = Colors.green;

    if (!foreground) color = color.withOpacity(.12);

    return color;
  }
}
