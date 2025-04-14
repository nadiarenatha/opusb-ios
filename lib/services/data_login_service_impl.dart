import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../model/data_login.dart';
import 'data_login_service.dart';

class DataLoginServiceImpl implements DataLoginService {
  final log = getLogger('DataLoginServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  DataLoginServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  // Future<List<DataLoginAccesses>> getdatalogin({int? id}) async {
  //   List<DataLoginAccesses> listDataLogin = [];
  //   try {
  //     final response = await dio.get(
  //       'ad-users/$id',
  //     );
  //     print("ini res nya: " + response.data.toString());

  //     if (response.statusCode == 200) {
  //       // Assuming response.data is a list of JSON objects
  //       final List<dynamic> responseData = response.data;

  //       // Parse the response data into List<DataLoginAccesses>
  //       listDataLogin = responseData
  //           .map((json) =>
  //               DataLoginAccesses.fromJson(json as Map<String, dynamic>))
  //           .toList();

  //       log.i('Successfully fetched data login list');
  //     } else {
  //       log.e('Failed to fetch invoice list');
  //     }
  //   } on DioException catch (e) {
  //     log.e('Error fetching packing list: $e');
  //     // Throw or handle the error as needed
  //   }

  //   // print(listPacking[0].toString());
  //   return listDataLogin;
  // }

  Future<DataLoginAccesses> getdatalogin({required int id}) async {
    try {
      // Make the API call
      final response = await dio.get('ad-users/$id');
      log.i('Response received: ${response.data}');

      if (response.statusCode == 200) {
        // Assuming response.data is a single JSON object
        final responseData = response.data;

        // Parse the response data into a DataLoginAccesses object
        final dataLoginAccess = DataLoginAccesses.fromJson(responseData);

        log.i('Successfully parsed data login');
        return dataLoginAccess;
      } else {
        log.e('Failed to fetch data login: ${response.statusCode}');
        throw Exception('Failed to fetch data login');
      }
    } on DioException catch (e) {
      log.e('Error fetching data login: $e');
      throw Exception('Error fetching data login: $e');
    }
  }

  Future<DataLoginAccesses> updateDataLogin({
    required int id,
    required bool active,
    required String phone,
    required String city,
    required String nik,
    required String address,
    required String position,
    required bool employee,
    required int failedLoginCount,
    required int concurrentUserAccess,
    required String lastLoginDate,
    required int userId,
    required String userLogin,
    required String firstName,
    required String lastName,
    required String email,
    required int adOrganizationId,
    required String adOrganizationName,
    required String name,
    required String businessUnit,
    required String entitas,
    required String ownerCode,
    required String picName,
    required bool waVerified,
    required bool contractFlag,
    required String npwp,
    required bool assigner,
  }) async {
    try {
      log.i(
        'ad-users',
      );
      final response = await dio.put('ad-users', data: {
        'id': id,
        'active': active,
        'phone': phone,
        'city': city,
        'nik': nik,
        'address': address,
        'position': position,
        'employee': employee,
        'failedLoginCount': failedLoginCount,
        'concurrentUserAccess': concurrentUserAccess,
        'lastLoginDate': lastLoginDate, // Ensure proper format for DateTime
        'userId': id,
        'userLogin': userLogin,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'adOrganizationId': adOrganizationId,
        'adOrganizationName': adOrganizationName,
        'name': name,
        'businessUnit': businessUnit,
        'entitas': entitas,
        'ownerCode': ownerCode,
        'picName': picName,
        'waVerified': waVerified,
        'contractFlag': contractFlag,
        'npwp': npwp,
        'assigner': assigner,
      });

      log.i('Update Response: ${response.data}');

      if (response.statusCode == 200) {
        log.i('Data successfully updated');
        return DataLoginAccesses.fromJson(
            response.data); // Ensure this method exists and works correctly
      } else {
        log.e('Failed to update data: ${response.statusCode}');
        throw Exception('Failed to update data');
      }
    } on DioException catch (e) {
      log.e('Error updating data: $e');
      throw Exception('Error updating data: $e');
    }
  }
}
