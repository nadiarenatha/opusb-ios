//3
import 'dart:convert'; // Import dart:convert to use jsonEncode and jsonDecode
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/payment_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

class PaymentServiceImpl implements PaymentService {
  final log = getLogger('PaymentServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PaymentServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<String> paymentvalidation({
    required String serverKey,
    required Map<String, dynamic> requestBody,
  }) async {
    log.i('paymentvalidation()');
    log.i(dio.options.baseUrl);
    try {
      final res = await dio.post(
        // 'messages',
        'https://app.sandbox.midtrans.com/snap/v1/transactions', // Replace with your actual endpoint URL
        data:
            jsonEncode(requestBody), // Use jsonEncode to encode the requestBody
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Basic ' + base64Encode(utf8.encode(serverKey)),
          },
        ),
      );

      log.i("Response data: ${res.data}");

      if (res.statusCode == 201) {
        log.i('Message sent successfully');
        final Map<String, dynamic> responseData = res.data;
        return responseData['redirect_url'];
      } else {
        log.i('Failed to send message');
        return 'Failed to send message';
      }
    } on DioError catch (e) {
      log.e('Dio error: ${e.response?.data}');
      log.e('Status code: ${e.response?.statusCode}');
      log.e('Headers: ${e.response?.headers}');
      throw e; // Re-throwing the exception to handle it higher up
    } catch (e) {
      log.e('Error: $e');
      throw Exception('Failed to communicate with server');
    }
  }
}
