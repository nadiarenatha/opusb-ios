import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../model/id_account.dart';
import 'id_account_service.dart';

// class IdAccountServiceImpl implements IdAccountService {
//   final log = getLogger('IdAccountServiceImpl');
//   final Dio dio;
//   final FlutterSecureStorage storage;

//   IdAccountServiceImpl({
//     required this.dio,
//     required this.storage,
//   });

//   @override
//   Future<List<IdAccountAccesses>> getIdAccount() async {
//     List<IdAccountAccesses> listIdAccount = [];
//     try {
//       final response = await dio.get(
//         'account',
//       );
//       print("ini res nya: " + response.data.toString());

//       if (response.statusCode == 200) {

//         final List<dynamic> accountList = response.data['accounts'] ?? [];

//         return accountList
//             .map((account) => IdAccountAccesses.fromJson(account))
//             .toList();

//         // log.i('Successfully fetched data login list');
//       } else {
//         log.e('Failed to fetch invoice list');
//       }
//     } on DioException catch (e) {
//       log.e('Error fetching packing list: $e');
//       // Throw or handle the error as needed
//     }
//     return [];
//   }
// }

class IdAccountServiceImpl implements IdAccountService {
  final log = getLogger('IdAccountServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  IdAccountServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<IdAccountAccesses>> getIdAccount() async {
    List<IdAccountAccesses> listIdAccount = [];
    try {
      final response = await dio.get('account');
      print("ini res nya: " + response.data.toString());

      if (response.statusCode == 200) {
        // Extract the id from the response and create an instance of IdAccountAccesses
        Map<String, dynamic> responseData = response.data;

        if (responseData.containsKey('id')) {
          // Create the IdAccountAccesses instance and add it to the list
          IdAccountAccesses account = IdAccountAccesses.fromJson(responseData);
          listIdAccount.add(account);
        } else {
          log.e('ID not found in the response');
        }
      } else {
        log.e('Failed to fetch account details');
      }
    } on DioException catch (e) {
      log.e('Error fetching account details: $e');
      // Throw or handle the error as needed
    }

    return listIdAccount;
  }
}
