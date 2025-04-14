// import 'package:niaga_apps_mobile/model/account_m.dart';
import 'package:niaga_apps_mobile/model/auth_response.dart';
import 'package:niaga_apps_mobile/model/login/login_accesses.dart';
import 'package:niaga_apps_mobile/model/login/login_account.dart';
import 'package:niaga_apps_mobile/model/login/login_organizations.dart';
import 'package:niaga_apps_mobile/model/login_credential.dart';

abstract class ReportWarehouseService {
  Future<bool> downloadReportWarehousePdf();
}
