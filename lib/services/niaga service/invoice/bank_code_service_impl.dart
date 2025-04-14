import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/bank_code.dart';
import 'bank_code_service.dart';

class BankCodeServiceImpl implements BankCodeService {
  final log = getLogger('BankCodeServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  BankCodeServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<BankCodeAccesses>> getBankCode(String name, String value) async {
    List<BankCodeAccesses> listBankCode = [];

    try {
      log.i('Making API request to get bank code...');

      final response =
          await dio.post('ad-reference-lists/find-by-value/bankCode');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Map the response data to your model
          listBankCode = (response.data as List)
              .map((jsonItem) => BankCodeAccesses.fromJson(jsonItem))
              .toList();
          log.i("Parsed Bank Code List: ${listBankCode.toString()}");
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to load Bank Code');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listBankCode;
  }
}
