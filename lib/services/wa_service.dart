// import 'package:niaga_apps_mobile/model/account_m.dart';

abstract class WAService {
  Future<bool> sendwhatsapp(
      {String? portAsal,
      String? portTujuan,
      String? shippingLine,
      String? vesselName,
      String? voyageNo,
      String? rutePanjang,
      String? tglClosing,
      String? etd,
      String? eta});
}
