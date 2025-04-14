import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/push_order_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/push_order.dart';

import '../../../shared/constants.dart';

class PushOrderServiceImpl implements PushOrderService {
  final log = getLogger('PushOrderServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PushOrderServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PushOrderAccesses>> getPushOrder(
      String noOrderOnline, int point) async {
    List<PushOrderAccesses> listpushOrder = [];

    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to push order with email: $email');
      log.i('Making API request to push order...');

      final response = await dio.post(
        'api/v1/push/order/new',
        data: {
          'no_order_online': noOrderOnline,
          'email': email,
          'point': point,
        },
      );

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        log.i("Success: Order pushed successfully.");
      } else {
        log.e("Error: ${response.statusCode} - ${response.statusMessage}");
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listpushOrder;
  }
}
