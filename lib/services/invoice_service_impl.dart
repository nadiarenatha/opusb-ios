import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/invoice.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import 'invoice_service.dart';

class InvoiceServiceImpl implements InvoiceService {
  final log = getLogger('InvoiceServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  InvoiceServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<InvoiceAccesses>> getinvoice() async {
    // Future<List<InvoiceAccesses>> getinvoice(
    //     {required int page, required int limit}) async {
    List<InvoiceAccesses> listInvoice = [];
    try {
      final response = await dio.get(
        'me-invoices',
        data: {},
      );
      print("ini res nya: " + response.data.toString());

      if (response.statusCode == 200) {
        var data = response.data as List;
        listInvoice = data.map((i) => InvoiceAccesses.fromJson(i)).toList();
        listInvoice.sort((a, b) => a.id!.compareTo(b.id!));
        // listInvoice = listInvoice.reversed.toList();
        print('Invoice List: $listInvoice');
      } else {
        log.e('Failed to fetch invoice list');
      }
    } on DioException catch (e) {
      log.e('Error fetching packing list: $e');
      // Throw or handle the error as needed
    }

    // print(listPacking[0].toString());
    return listInvoice;
  }
}
