import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/packing_list.dart';
import 'package:niaga_apps_mobile/services/packing_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

class PackingServiceImpl implements PackingService {
  final log = getLogger('PackingServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PackingServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PackingListAccesses>> getpacking() async {
    List<PackingListAccesses> listPacking = [];
    try {
      final response = await dio.get(
        'me-packing-lists',
        data: {},
      );
      print("ini res nya: " + response.data.toString());

      if (response.statusCode == 200) {
        var data = response.data as List;
        listPacking = data.map((i) => PackingListAccesses.fromJson(i)).toList();
        listPacking = listPacking.reversed.toList();
        print('Packing List: $listPacking');
      } else {
        log.e('Failed to fetch packing list');
      }
    } on DioException catch (e) {
      log.e('Error fetching packing list: $e');
      // Throw or handle the error as needed
    }

    // print(listPacking[0].toString());
    return listPacking;
  }

  // @override
  // Future<LoginAccount> getAccount() async {
  //   log.i('getAccountServiceImpl()');
  //   LoginAccount loginAccount = LoginAccount();
  //   try {
  //     final response = await dio.get('account');
  //     if (response.statusCode == 200) {
  //       loginAccount = LoginAccount.fromJson(response.data);
  //       await saveAuthData(AuthKey.accountId, loginAccount.id!.toString());
  //     }
  //   } on DioException catch (e) {
  //     log.e(e);
  //     if (e.message != null) {
  //       log.e(e.message!);
  //     }
  //     if (e.error != null) {
  //       throw e.error!;
  //     }
  //   }
  //   return loginAccount;
  // }

  // @override
  // Future<List<LoginAccesses>> getListAccesses() async {
  //   log.i('getListAccessesServiceImpl()');
  //   List<LoginAccesses> listLoginAccesses = [];
  //   try {
  //     final result = await dio.get('accesses');
  //     if (result.statusCode == 200) {
  //       var data = (result.data as List);
  //       listLoginAccesses = data.map((i) => LoginAccesses.fromJson(i)).toList();
  //       listLoginAccesses = listLoginAccesses.reversed.toList();
  //     }
  //   } on DioError catch (e) {
  //     // throw e.error;
  //     if (e.error != null) {
  //       throw e.error!;
  //     }
  //   }
  //   return listLoginAccesses;
  // }

  // @override
  // Future<List<LoginOrganizations>> getListAdOrganizations(
  //   List<LoginAccesses> loginAccesses,
  // ) async {
  //   log.i('getListOrganizationsImpl()');
  //   List<LoginOrganizations> listOrganizations = [];
  //   try {
  //     // ignore: unused_local_variable
  //     String query = '';
  //     // double tes = 0;
  //     // tes.toInt();
  //     if (loginAccesses.isNotEmpty) {
  //       for (var e in loginAccesses) {
  //         if (e.accessType == 'ORG') {
  //           query += '&id.in=${e.adOrganizationId}';
  //         }
  //       }
  //       // loginAccesses.where((e) => e.accessType=='ORG').
  //     }
  //     String filter =
  //         'sort=name&sort=code&page=0&size=20&active.equals=true$query';
  //     final result = await dio.get('ad-organizations?$filter');
  //     if (result.statusCode == 200) {
  //       var data = (result.data as List);
  //       listOrganizations =
  //           data.map((i) => LoginOrganizations.fromJson(i)).toList();
  //       listOrganizations = listOrganizations.reversed.toList();
  //     }
  //   } on DioError catch (e) {
  //     // throw e.error;
  //     if (e.error != null) {
  //       throw e.error!;
  //     }
  //   }
  //   return listOrganizations;
  // }

  // @override
  // Future<List<LoginOrganizations>> getListScAuthorities(
  //   LoginAccount loginAccount,
  // ) async {
  //   log.i('getListScAuthoritiesImpl()');
  //   List<LoginOrganizations> listScAuthorities = [];
  //   try {
  //     // ignore: unused_local_variable
  //     String query = '';
  //     if (loginAccount.authorities!.isNotEmpty) {
  //       for (var e in loginAccount.authorities!) {
  //         query += '&authorityName.in=$e';
  //       }
  //     }
  //     String filter =
  //         'sort=authorityName&page=0&size=20&active.equals=true$query';

  //     final result = await dio.get('sc-authorities?$filter');
  //     if (result.statusCode == 200) {
  //       var data = (result.data as List);
  //       listScAuthorities =
  //           data.map((i) => LoginOrganizations.fromJson(i)).toList();
  //       listScAuthorities = listScAuthorities.reversed.toList();
  //     }
  //   } on DioError catch (e) {
  //     // throw e.error;
  //     if (e.error != null) {
  //       throw e.error!;
  //     }
  //   }
  //   return listScAuthorities;
  // }
}
