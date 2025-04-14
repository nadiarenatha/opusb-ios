import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/auth_response.dart';
import 'package:niaga_apps_mobile/model/login/login_accesses.dart';
import 'package:niaga_apps_mobile/model/login/login_account.dart';
import 'package:niaga_apps_mobile/model/login/login_organizations.dart';
import 'package:niaga_apps_mobile/model/login_credential.dart';
import 'package:niaga_apps_mobile/services/auth_service.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import 'package:niaga_apps_mobile/shared/functions/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

class AuthServiceImpl implements AuthService {
  final log = getLogger('AuthServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  AuthServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<AuthResponse> authenticate(LoginCredential credential) async {
    log.i('authenticate(${credential.toJson()})');
    log.i(dio.options.baseUrl);
    AuthResponse authResponse = AuthResponse(token: '');
    try {
      // d
      // final response =
      //     await dio.post('authenticate-email', data: credential.toJson());
      final response = await dio.post(
        'authenticate',
        data: {
          'username': credential.username,
          'password': credential.password,
        },
        // options: Options(
        //   headers: {
        //     'content-type': 'application/json',
        //     'Access-Control-Allow-Origin': 'true'
        //   },
        // ),
      );
      // print(response);
      print("ini res nya: " + response.data.toString());

      authResponse = AuthResponse.fromJson(response.data);
      await saveAuthData(AuthKey.token, authResponse.token!);
      // await saveAuthData(AuthKey.email, credential.email);
      // Context().photo =
      //     base64.decode(authResponse.mstPersonDTO.employeePhoto ?? '');

      // await saveAuthData(
      //     AuthKey.clients, authResponse.clients![0].id.toString());
      // await saveAuthData(AuthKey.clientsName, authResponse.clients![0].name!);
    } on DioException catch (e) {
      // throw e.error;
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
    }
    return authResponse;
  }

  @override
  Future<LoginAccount> getAccount() async {
    log.i('getAccountServiceImpl()');
    LoginAccount loginAccount = LoginAccount();
    try {
      final response = await dio.get('account');
      if (response.statusCode == 200) {
        loginAccount = LoginAccount.fromJson(response.data);
        await saveAuthData(AuthKey.accountId, loginAccount.id!.toString());
      }
    } on DioException catch (e) {
      log.e(e);
      if (e.message != null) {
        log.e(e.message!);
      }
      if (e.error != null) {
        throw e.error!;
      }
    }
    return loginAccount;
  }

  @override
  Future<List<LoginAccesses>> getListAccesses() async {
    log.i('getListAccessesServiceImpl()');
    List<LoginAccesses> listLoginAccesses = [];
    try {
      final result = await dio.get('accesses');
      if (result.statusCode == 200) {
        var data = (result.data as List);
        listLoginAccesses = data.map((i) => LoginAccesses.fromJson(i)).toList();
        listLoginAccesses = listLoginAccesses.reversed.toList();
      }
    } on DioError catch (e) {
      // throw e.error;
      if (e.error != null) {
        throw e.error!;
      }
    }
    return listLoginAccesses;
  }

  @override
  Future<List<LoginOrganizations>> getListAdOrganizations(
    List<LoginAccesses> loginAccesses,
  ) async {
    log.i('getListOrganizationsImpl()');
    List<LoginOrganizations> listOrganizations = [];
    try {
      // ignore: unused_local_variable
      String query = '';
      // double tes = 0;
      // tes.toInt();
      if (loginAccesses.isNotEmpty) {
        for (var e in loginAccesses) {
          if (e.accessType == 'ORG') {
            query += '&id.in=${e.adOrganizationId}';
          }
        }
        // loginAccesses.where((e) => e.accessType=='ORG').
      }
      String filter =
          'sort=name&sort=code&page=0&size=20&active.equals=true$query';
      final result = await dio.get('ad-organizations?$filter');
      if (result.statusCode == 200) {
        var data = (result.data as List);
        listOrganizations =
            data.map((i) => LoginOrganizations.fromJson(i)).toList();
        listOrganizations = listOrganizations.reversed.toList();
      }
    } on DioError catch (e) {
      // throw e.error;
      if (e.error != null) {
        throw e.error!;
      }
    }
    return listOrganizations;
  }

  @override
  Future<List<LoginOrganizations>> getListScAuthorities(
    LoginAccount loginAccount,
  ) async {
    log.i('getListScAuthoritiesImpl()');
    List<LoginOrganizations> listScAuthorities = [];
    try {
      // ignore: unused_local_variable
      String query = '';
      if (loginAccount.authorities!.isNotEmpty) {
        for (var e in loginAccount.authorities!) {
          query += '&authorityName.in=$e';
        }
      }
      String filter =
          'sort=authorityName&page=0&size=20&active.equals=true$query';

      final result = await dio.get('sc-authorities?$filter');
      if (result.statusCode == 200) {
        var data = (result.data as List);
        listScAuthorities =
            data.map((i) => LoginOrganizations.fromJson(i)).toList();
        listScAuthorities = listScAuthorities.reversed.toList();
      }
    } on DioError catch (e) {
      // throw e.error;
      if (e.error != null) {
        throw e.error!;
      }
    }
    return listScAuthorities;
  }
}
