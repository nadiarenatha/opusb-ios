// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:niaga_apps_mobile/model/invoice_detail.dart';
// import 'package:niaga_apps_mobile/shared/widget/logger.dart';

// import 'invoice_detail_service.dart';

// class InvoiceDetailServiceImpl implements InvoiceDetailService {
//   final log = getLogger('InvoiceDetailServiceImpl');
//   final Dio dio;
//   final FlutterSecureStorage storage;

//   InvoiceDetailServiceImpl({
//     required this.dio,
//     required this.storage,
//   });

//   @override
//   Future<List<InvoiceDetailAccesses>> getinvoicedetail(
//       {String? meInvoiceId}) async {
//     List<InvoiceDetailAccesses> listInvoiceDetail = [];
//     try {
//       final response = await dio.get(
//         'me-invoice-lines',
//         // data: {},
//         queryParameters:
//             meInvoiceId != null ? {'meInvoiceId': meInvoiceId} : {},
//       );
//       print("ini res nya: " + response.data.toString());

//       if (response.statusCode == 200) {
//         var data = response.data as List;
//         // listInvoiceDetail =
//         //     data.map((i) => InvoiceDetailAccesses.fromJson(i)).toList();
//         // listInvoiceDetail.sort((a, b) => a.id!.compareTo(b.id!));
//         // listInvoice = listInvoice.reversed.toList();

//         // Filter the list to get only items with matching meInvoiceId
//         listInvoiceDetail.retainWhere(
//             (element) => element.meInvoiceId == int.parse(meInvoiceId!));
//         print('Invoice List: $listInvoiceDetail');
//       } else {
//         log.e('Failed to fetch invoice detail list');
//       }
//     } on DioException catch (e) {
//       log.e('Error fetching invoice detail list: $e');
//       // Throw or handle the error as needed
//     }

//     // print(listPacking[0].toString());
//     return listInvoiceDetail;
//   }
// }

// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:niaga_apps_mobile/model/invoice_detail.dart'; // Assuming you have defined InvoiceDetailAccesses
// import 'package:niaga_apps_mobile/shared/widget/logger.dart';
// import 'invoice_detail_service.dart';

// class InvoiceDetailServiceImpl implements InvoiceDetailService {
//   final log = getLogger('InvoiceDetailServiceImpl');
//   final Dio dio;
//   final FlutterSecureStorage storage;

//   InvoiceDetailServiceImpl({
//     required this.dio,
//     required this.storage,
//   });

//   @override
//   Future<List<InvoiceDetailAccesses>> getinvoicedetail(
//       {int? meInvoiceId}) async {
//     List<InvoiceDetailAccesses> listInvoiceDetail = [];
//     try {
//       final response = await dio.get(
//         'me-invoice-lines',
//         queryParameters:
//             meInvoiceId != null ? {'meInvoiceId': meInvoiceId} : {},
//       );

//       print("Response: ${response.statusCode} - ${response.data}");

//       if (response.statusCode == 200) {
//         var data = response.data as List;
//         listInvoiceDetail =
//             data.map((i) => InvoiceDetailAccesses.fromJson(i)).toList();

//         // Filter the list to get only items with matching meInvoiceId
//         if (meInvoiceId != null) {
//           listInvoiceDetail
//               .retainWhere((element) => element.meInvoiceId == meInvoiceId);
//         }

//         print('Filtered Invoice List: $listInvoiceDetail');
//       } else {
//         log.e('Failed to fetch invoice detail list');
//       }
//     } on DioException catch (e) {
//       log.e('Error fetching invoice detail list: $e');
//       // Handle Dio errors here
//       throw e; // Optionally re-throw to propagate the error
//     }

//     return listInvoiceDetail;
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/invoice_detail.dart'; // Assuming you have defined InvoiceDetailAccesses
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'invoice_detail_service.dart';

class InvoiceDetailServiceImpl implements InvoiceDetailService {
  final log = getLogger('InvoiceDetailServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  InvoiceDetailServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<InvoiceDetailAccesses>> getinvoicedetail(
      {int? meInvoiceId}) async {
    List<InvoiceDetailAccesses> listInvoiceDetail = [];

    try {
      final response = await dio.get(
        'me-invoice-lines?meInvoiceId.equals=$meInvoiceId',
      );
      print("Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        var data = response.data as List;
        listInvoiceDetail =
            data.map((i) => InvoiceDetailAccesses.fromJson(i)).toList();

        print('Filtered Invoice Detail List: $listInvoiceDetail');
      } else {
        log.e('Failed to fetch invoice detail list');
      }
    } on DioException catch (e) {
      log.e('Error fetching invoice detail list: $e');
      // Handle Dio errors here
      throw e;
    }

    return listInvoiceDetail;
  }
}
