import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/order.dart';
import '../../../shared/constants.dart';
import 'create_order_fcl_service.dart';
import 'package:intl/intl.dart';

class CreateOrderFCLServiceImpl implements CreateOrderFCLService {
  final log = getLogger('CreateOrderFCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  CreateOrderFCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<OrderAccesses> createOrderFCL(
      String email,
      String createdBy,
      int userId,
      String createdDate,
      String businessUnit,
      String portAsal,
      String portTujuan,
      String originalCity,
      String originalAddress,
      String originalPicName,
      String originalPicNumber,
      String cargoReadyDate,
      String destinationCity,
      String destinationAddress,
      String destinationPicName,
      String destinationPicNumber,
      String contractNo,
      String komoditi,
      String productDescription,
      String containerSize,
      int quantity,
      int amount,
      String loctidUocAsal,
      String loctidUocTujuan,
      String loctidPortAsal,
      String loctidPortTujuan,
      bool point,
      int price,
      double userTotalWeight,
      bool flagPaymentWa,
      bool paymentStatus,
      int pointUse,
      int amountCargo,
      String etd) async {
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

      log.i('Making API request to get ownerCode FCL : $ownerCode');
      log.i('Making API request to get create order FCL');

      final header = {
        'email': email,
        'createdBy': email,
        'userId': userId,
        'createdDate': sysdate,
        'businessUnit': businessUnit,
        'portAsal': portAsal,
        'portTujuan': portTujuan,
        'ownerCode': ownerCode,
        'orderService': 'FCL',
        'shipmentType': 'DTD',
        'originalCity': originalCity,
        'originalAddress': originalAddress,
        'originalPicName': originalPicName,
        'originalPicNumber': originalPicNumber,
        'cargoReadyDate': cargoReadyDate,
        'destinationCity': destinationCity,
        'destinationAddress': destinationAddress,
        'destinationPicName': destinationPicName,
        'destinationPicNumber': destinationPicNumber,
        'contractNo': contractNo,
        'loctidUocAsal': loctidUocAsal,
        'loctidUocTujuan': loctidUocTujuan,
        'loctidPortAsal': loctidPortAsal,
        'loctidPortTujuan': loctidPortTujuan,
        'point': point,
        'deploy': 'false',
        'reviseOrder': 'false',
        'revisePrice': 'false',
        'reviseUpdate': 'false',
        'pointUse': pointUse,
        'etd': etd,
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
          'containerSize': containerSize,
          'quantity': quantity,
          'amount': amount,
          'statusId': 'SO01',
          'price': price,
          'flagPaymentWa': flagPaymentWa,
          'paymentStatus': paymentStatus,
          'userTotalWeight': userTotalWeight,
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
