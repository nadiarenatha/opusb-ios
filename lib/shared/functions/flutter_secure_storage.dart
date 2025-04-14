import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';


final log = getLogger('FSS_SharedFunc');
FlutterSecureStorage storage = const FlutterSecureStorage();

Future<dynamic> getAuthData(AuthKey key) async {
  log.i('getAuthData(${key.toString()})');
  var data = await storage.read(
    key: key.toString(),
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  log.d(data);
  return data;
}

Future<dynamic> saveAuthData(AuthKey key, String data) async {
  log.i('saveAuthData(key:$key , data:$data)');
  await storage.write(
    key: key.toString(),
    value: data,
    //* SET encryptedSharedPreferences to true for flutter V3
    aOptions: const AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
}

Future<void> clearLocalStorage() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}