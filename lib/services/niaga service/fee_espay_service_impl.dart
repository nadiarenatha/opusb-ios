import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/fee_espay.dart';
import 'fee_espay_service.dart';

class FeeEspayServiceImpl implements FeeEspayService {
  final log = getLogger('FeeEspayServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  FeeEspayServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<FeeEspayAccesses>> getFeeEspay() async {
    List<FeeEspayAccesses> listFeeEspay = [];

    try {
      log.i('Making API request to get fee espay...');
      log.i('ad-reference-lists/find-by-value/feeEspay');

      final response = await dio.post(
        'ad-reference-lists/find-by-value/feeEspay',
      );

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = response.data as List;
        listFeeEspay = data.map((e) => FeeEspayAccesses.fromJson(e)).toList();

        log.i("Parsed FeeEspayAccesses list: $listFeeEspay");
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

    return listFeeEspay;
  }
}
