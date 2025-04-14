import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/order.dart';
import '../../../shared/constants.dart';
import 'package:intl/intl.dart';

import 'create_order_lcl_service.dart';

class CreateOrderLCLServiceImpl implements CreateOrderLCLService {
  final log = getLogger('CreateOrderLCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  CreateOrderLCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<OrderAccesses> createOrderLCL(
      String email,
      String createdBy,
      int userId,
      String createdDate,
      String businessUnit,
      String portAsal,
      String portTujuan,
      String originalCity,
      String originalAddress,
      String cargoReadyDate,
      String destinationCity,
      String destinationAddress,
      String destinationPicName,
      String destinationPicNumber,
      String contractNo,
      String komoditi,
      String productDescription,
      int quantity,
      int amount,
      double userPanjang,
      double userLebar,
      double userTinggi,
      double userTotalVolume,
      int userTotalWeight,
      String uom,
      bool point,
      String locidUocAsal,
      String locidUocTujuan,
      String locidPortAsal,
      String locidPortTujuan,
      int price,
      int pointUse,
      int amountCargo) async {
    // final sysdate = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());
    log.i('Formatted sysdate nya: $sysdate');

    log.i('createOrderFCL');
    log.i(dio.options.baseUrl);

    try {
      final ownerCode = await storage.read(
            key: AuthKey.ownerCode.toString(),
            aOptions: const AndroidOptions(encryptedSharedPreferences: true),
          ) ??
          'ONLINE';

      log.i('Making API request to get ownerCode LCL : $ownerCode');
      log.i('Making API request to get create order LCL');

      final header = {
        'email': email,
        'createdBy': email,
        'userId': userId,
        'createdDate': sysdate,
        'businessUnit': businessUnit,
        'portAsal': portAsal,
        'portTujuan': portTujuan,
        'ownerCode': ownerCode,
        'orderService': 'LCL',
        'shipmentType': 'PTD',
        'originalCity': originalCity,
        'originalAddress': originalAddress,
        'cargoReadyDate': cargoReadyDate,
        'destinationCity': destinationCity,
        'destinationAddress': destinationAddress,
        'destinationPicName': destinationPicName,
        'destinationPicNumber': destinationPicNumber,
        'contractNo': contractNo,
        'point': point,
        'deploy': 'false',
        'reviseOrder': 'false',
        'revisePrice': 'false',
        'reviseUpdate': 'false',
        'loctidUocAsal': locidUocAsal,
        'loctidUocTujuan': locidUocTujuan,
        'loctidPortAsal': locidPortAsal,
        'loctidPortTujuan': locidPortTujuan,
        'pointUse': pointUse,
      };

      final lines = [
        {
          'email': email,
          'userId': userId,
          'createdBy': email,
          'createdDate': sysdate,
          'lineNumber': 1,
          'komoditi': komoditi,
          'productDescription': productDescription,
          'quantity': quantity,
          'amount': amount,
          'statusId': 'SO01',
          'userPanjang': userPanjang,
          'userLebar': userLebar,
          'userTinggi': userTinggi,
          'userTotalVolume': userTotalVolume,
          'userTotalWeight': userTotalWeight,
          'uom': uom,
          'price': price,
          'flagPaymentWa': 'false',
          'paymentStatus': 'false',
          'amountCargo': amountCargo,
        }
      ];

      final response = await dio.post(
        'bhp-order-create',
        data: {
          'header': header,
          'lines': lines,
        },
      );

      log.i("Response Niaga: " + response.data.toString());

      // Return the parsed response as needed
      return OrderAccesses.fromJson(response.data);
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
      rethrow;
    }
  }
}
