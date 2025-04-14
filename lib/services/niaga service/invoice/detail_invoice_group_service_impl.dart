import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../../model/niaga/detail_espay_invoice_group.dart';
import 'detail_invoice_group_service.dart';

class DetailInvoiceGroupServiceImpl implements DetailInvoiceGroupService {
  final log = getLogger('DetailInvoiceGroupServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DetailInvoiceGroupServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<DetailEspayInvoiceGroupAccesses>> getDetailInvoiceGroup(
      String noInvGroup) async {
    List<DetailEspayInvoiceGroupAccesses> listDetailInvoiceGroup = [];

    try {
      log.i('Making API request to get detail Invoice Group...');
      log.i('api/v1/get_detail_invoice_group?no_invoice_group=$noInvGroup');

      final response = await dio.post(
        'api/v1/get_detail_invoice_group?no_invoice_group=$noInvGroup',
      );

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {

        final List<dynamic> responseData = response.data;

        if (responseData.isNotEmpty) {
          listDetailInvoiceGroup = responseData
              .map((item) => DetailEspayInvoiceGroupAccesses.fromJson(item))
              .toList();
          log.i("Parsed data length: ${listDetailInvoiceGroup.length}");
        } else {
          log.w("No data found in response.");
        }
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

    return listDetailInvoiceGroup;
  }
}
