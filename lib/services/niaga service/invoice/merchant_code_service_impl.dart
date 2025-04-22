import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/niaga/merchant_code.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import 'merchant_code_service.dart';

class MerchantCodeServiceImpl implements MerchantCodeService {
  final log = getLogger('MerchantCodeServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  MerchantCodeServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<MerchantCodeAccesses>> getMerchantCode() async {
    List<MerchantCodeAccesses> listMerchantCode = [];

    try {
      log.i('Making API request to get merchant code...');

      final response =
          await dio.post('ad-reference-lists/find-by-value/espayMerchantCode');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          listMerchantCode = (response.data as List)
              .map((jsonItem) => MerchantCodeAccesses.fromJson(jsonItem))
              .toList();
          log.i("Parsed Merchant Code List: ${listMerchantCode.toString()}");
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to load Merchant Code');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listMerchantCode;
  }
}
