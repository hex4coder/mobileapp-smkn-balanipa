import 'package:get/get.dart';
import 'package:myapp/helpers/api_http.dart';
import 'package:myapp/models/promo_code.dart';

class PromoCodeController extends GetxController {
  late ApiHttp _apiHttp;

  //constructor
  @override
  void onInit() {
    _apiHttp = Get.find();
    super.onInit();
  }

  // get promocode
  Future<PromoCode?> checkPromo(String code) async {
    // buat path untuk cek kode promo
    String promoPath = "/check-promo/$code";

    // call api
    final r = await _apiHttp.get(promoPath);

    // check error
    if (r.isError) {
      return null;
    }

    // success
    final PromoCode promoCode = PromoCode.fromJson(r.data);
    return promoCode;
  }
}
