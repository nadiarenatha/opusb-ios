import '../model/data_login.dart';

abstract class DataLoginService {
  Future<DataLoginAccesses> getdatalogin({required int id}); 
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
    required bool assigner
    });
}
