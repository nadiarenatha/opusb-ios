import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/data_login.dart';
import '../../services/data_login_service.dart';
import '../../shared/constants.dart';
import '../../shared/functions/flutter_secure_storage.dart';

part 'data_login_state.dart';

class DataLoginCubit extends Cubit<DataLoginState> {
  final log = getLogger('DataLoginCubit');

  DataLoginCubit() : super(DataLoginInitial());

  Future<dynamic> dataLogin({required int id}) async {
    log.i('DataLoginCubit');
    try {
      emit(DataLoginInProgress());

      // Fetch the list of OpenInvoiceAccesses
      // final List<DataLoginAccesses> response =
      //     await sl<DataLoginService>().getdatalogin(id: id);

      // // Extract necessary fields from the userData
      // final active = response.first.active;
      // final phone = response.first.phone;
      // final employee = response.first.employee;
      // final firstName = response.first.firstName;
      // final lastName = response.first.lastName;
      // final email = response.first.email;
      // final businessUnit = response.first.businessUnit;
      // final ownerCode = response.first.ownerCode;
      // final waVerified = response.first.waVerified;
      // final contractFlag = response.first.contractFlag;
      // final name = response.first.name;

      final DataLoginAccesses response =
          await sl<DataLoginService>().getdatalogin(id: id);

      // Extract necessary fields from the response
      final active = response.active;
      final phone = response.phone;
      final employee = response.employee;
      final firstName = response.firstName;
      final lastName = response.lastName;
      final email = response.email;
      final businessUnit = response.businessUnit;
      final ownerCode = response.ownerCode;
      final waVerified = response.waVerified;
      final contractFlag = response.contractFlag;
      final name = response.name;
      final nik = response.nik;
      final npwp = response.npwp;
      final assigner = response.assigner;
      final city = response.city;

      log.i('Active: $active');
      log.i('Phone: $phone');
      log.i('Employee: $employee');
      log.i('First Name: $firstName');
      log.i('Last Name: $lastName');
      log.i('Email: $email');
      log.i('Business Unit: $businessUnit');
      log.i('Owner Code: $ownerCode');
      log.i('WA Verified: $waVerified');
      log.i('Contract Flag: $contractFlag');
      log.i('Name: $name');
      log.i('NIK: $nik');
      log.i('NPWP: $npwp');
      log.i('assigner: $assigner');
      log.i('city: $city');

      // Save details using your saveAuthData method
      await saveAuthData(AuthKey.active, active.toString());
      await saveAuthData(AuthKey.phone, phone.toString());
      await saveAuthData(AuthKey.employee, employee.toString());
      await saveAuthData(AuthKey.firstName, firstName.toString());
      await saveAuthData(AuthKey.lastName, lastName.toString());
      await saveAuthData(AuthKey.email, email.toString());
      await saveAuthData(AuthKey.businessUnit, businessUnit.toString());
      await saveAuthData(AuthKey.ownerCode, ownerCode.toString());
      await saveAuthData(AuthKey.waVerified, waVerified.toString());
      await saveAuthData(AuthKey.contractFlag, contractFlag.toString());
      await saveAuthData(AuthKey.name, name.toString());
      await saveAuthData(AuthKey.assigner, assigner.toString());
      await saveAuthData(AuthKey.city, city.toString());

      // emit(DataLoginSuccess(response: response));
      // if (!isClosed) {
      //   emit(DataLoginSuccess(response: response));
      // }
      final flagEmployeeString = await storage.read(
        key: AuthKey.employee.toString(),
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );

      log.i('flagEmployeeString: $flagEmployeeString');

      final flagEmployee = flagEmployeeString == 'true';

      if (flagEmployee) {
        emit(DataLoginRoleNotSupported());
      } else {
        if (!isClosed) {
          emit(DataLoginSuccess(response: response));
        }
      }
      return flagEmployee;
    } catch (e) {
      log.e('DataLoginCubit error: $e');
      emit(DataLoginFailure('$e'));
    }
  }

  Future<void> updateDataLogin(
      int id,
      bool active,
      String phone,
      String city,
      String nik,
      String address,
      String position,
      bool employee,
      // bool vendor,
      int failedLoginCount,
      int concurrentUserAccess,
      String lastLoginDate,
      int userId,
      String userLogin,
      String firstName,
      String lastName,
      String email,
      int adOrganizationId,
      String adOrganizationName,
      String name,
      String businessUnit,
      String entitas,
      String ownerCode,
      String picName,
      bool waVerified,
      bool contractFlag,
      String npwp,
      bool assigner) async {
    try {
      emit(DataLoginInProgress());
      // await sl<DataLoginService>().updateDataLogin(id: id, updatedData: updatedData);
      final response = await sl<DataLoginService>().updateDataLogin(
          id: id,
          active: active,
          phone: phone,
          city: city,
          nik: nik,
          address: address,
          position: position,
          employee: employee,
          // vendor: vendor,
          failedLoginCount: failedLoginCount,
          concurrentUserAccess: concurrentUserAccess,
          lastLoginDate: lastLoginDate,
          userId: userId,
          userLogin: userLogin,
          firstName: firstName,
          lastName: lastName,
          email: email,
          adOrganizationId: adOrganizationId,
          adOrganizationName: adOrganizationName,
          name: name,
          businessUnit: businessUnit,
          entitas: entitas,
          ownerCode: ownerCode,
          picName: picName,
          waVerified: waVerified,
          contractFlag: contractFlag,
          npwp: npwp,
          assigner: assigner);
      emit(DataLoginUpdatedSuccess(response: response));
    } catch (e) {
      emit(DataLoginFailure('Failed to update data: $e'));
    }
  }
}
