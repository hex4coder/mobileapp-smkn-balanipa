// server configurations

class ServerConfig {
  // base url
  final kServerBaseAPI = "https://ecom-api.smknbalanipa.sch.id";
  // static String kServerBaseAPI = "http://89.116.20.48:3000";

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
}
