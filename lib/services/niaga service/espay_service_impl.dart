import 'dart:convert'; // Import dart:convert to use jsonEncode and jsonDecode
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:intl/intl.dart';
import '../../shared/constants.dart';

import '../../model/niaga/espay.dart';
import 'espay_service.dart'; // Import your model

class EspayPaymentServiceImpl implements EspayPaymentService {
  final log = getLogger('EspayPaymentServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  EspayPaymentServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<EspayResponse> espayPaymentValidation(
      String noInvoice,
      String totalInvoice,
      String name,
      String value,
      int userId,
      String orderNumber,
      String invoiceNumber,
      String packingListNumber,
      String ruteTujuan,
      String tipePengiriman,
      String volume,
      String merchantId,
      String subMerchantId,
      String cabang
      ) async {
    log.i('espayPaymentValidation()');
    log.i(
        'espayPaymentValidation called with noInvoice: $noInvoice, totalInvoice: $totalInvoice, name: $name, value: $value, orderNumber: $orderNumber, invoiceNumber: $invoiceNumber, packingListNumber: $packingListNumber, ruteTujuan: $ruteTujuan, tipePengiriman: $tipePengiriman, volume: $volume, merchantId: $merchantId, subMerchantId: $subMerchantId');
    log.i('Base URL: ${dio.options.baseUrl}');
    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      final ownerCode = await storage.read(
        key: AuthKey.ownerCode.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to Espay with Email: $email');
      log.i('Making API request to Espay with userId: $userId');
      log.i('Making API request to Espay with owner code: $ownerCode');

      final sysdate = DateTime.now();
      final validUpTo = sysdate.add(const Duration(hours: 7));
      // final validUpTo = DateTime.now().add(Duration(days: 1)).toIso8601String();
      // final validUpTo = DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(
      //       DateTime.now().add(Duration(days: 1)),
      //     ) +
      //     "+07:00";
      final formattedValidUpTo =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss").format(validUpTo) + "+07:00";
      log.i('Valid sampai: $formattedValidUpTo');

      final response = await dio.post(
        'bhp-order-payments/generate-cc-url',
        data: {
          // "partnerReferenceNo": "02.NL-SBY.2025.FEB/001024",//
          "partnerReferenceNo": noInvoice, //
          // "merchantId": "SGWNIAGALOGISTIK",
          "merchantId": merchantId,
          // "subMerchantId": "60e83314016d7595781e1ea3d94a76d4",
          "subMerchantId": subMerchantId,
          // "amount": {"value": "100000.00", "currency": "IDR"}, //
          "amount": {"value": totalInvoice, "currency": "IDR"}, //
          "urlParam": {
            // "url": "https://elogistic-dev.opusb.co.id",
            "url": "https://dev-apps.niaga-logistics.com",
            "type": "PAY_RETURN",
            "isDeeplink": "N"
          },
          // "validUpTo": "2024-09-11T17:59:59+07:00",
          "validUpTo": formattedValidUpTo,
          "payOptionDetails": {
            // "payMethod": "008", //
            "payMethod": value, //
            // "payOption": "CREDITCARD", //
            "payOption": name, //
            // "transAmount": {"value": "100000.00", "currency": "IDR"},//
            "transAmount": {"value": totalInvoice, "currency": "IDR"}, //
            "feeAmount": {"value": "0.00", "currency": "IDR"}
          },
          // "additionalInfo": {"payType": "REDIRECT"}
          "additionalInfo": {
            "payType": "REDIRECT",
            "userId": userId,
            "email": email,
            "orderNumber": orderNumber,
            "invoiceNumber": invoiceNumber,
            "packingListNumber": packingListNumber,
            "ruteTujuan": ruteTujuan,
            "tipePengiriman": tipePengiriman,
            "volume": volume,
            "cabang": cabang,
            "ownerCode": ownerCode
          }
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      log.i("Response status code: ${response.statusCode}");
      log.i("Response data: ${response.data}");
      log.i("Sending validation request with:");
      log.i("noInvoice: $noInvoice");
      log.i("totalInvoice: $totalInvoice");
      log.i("bankCode: $value");
      log.i("productCode: $name");
      log.i("orderNumber: $orderNumber");
      log.i("invoiceNumber: $invoiceNumber");
      log.i("packingListNumber: $packingListNumber");
      log.i("ruteTujuan: $ruteTujuan");
      log.i("tipePengiriman: $tipePengiriman");
      log.i("volume: $volume");
      log.i("merchantId: $merchantId");
      log.i("subMerchantId: $subMerchantId");
      log.i("subMerchantId: $subMerchantId");
      log.i("cabang: $cabang");

      if (response.statusCode == 200) {
        // Assuming 200 is the success HTTP status
        final espayResponse = EspayResponse.fromJson(response.data);
        if (espayResponse.responseCode == "2005400") {
          // Check your specific response code
          log.i('Payment validation successful.');
          return espayResponse;
        } else {
          log.e('Payment validation failed: ${espayResponse.responseMessage}');
          throw Exception(
              'Payment validation failed: ${espayResponse.responseMessage}');
        }
        // return EspayResponse.fromJson(response.data);
      } else {
        log.e(
            'Failed to send payment request. Status code: ${response.statusCode}');
        throw Exception(
            'Failed to send payment request. Please try again later.');
      }
    } on DioError catch (e) {
      log.e('Dio error: ${e.response?.data}');
      log.e('Status code: ${e.response?.statusCode}');
      log.e('Headers: ${e.response?.headers}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      log.e('Unexpected error: $e');
      throw Exception('An unexpected error occurred.');
    }
  }
}
