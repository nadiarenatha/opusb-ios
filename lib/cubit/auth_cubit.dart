import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/auth_response.dart';
import 'package:niaga_apps_mobile/model/login_credential.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/services/auth_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final log = getLogger('AuthCubit');
  String? authToken; // Token for AuthCubit

  AuthCubit() : super(AuthInitial());

  Future<void> authenticate(String username, String password) async {
    log.i('authenticate($username)');
    try {
      emit(AuthInProgress());

      final AuthResponse response = await sl<AuthService>().authenticate(
        LoginCredential(username: username, password: password),
      );
      authToken = response.token; // Store the token

      await storage.write(
        key: AuthKey.token.toString(),
        value: authToken,
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );

      await storage.write(
        key: AuthKey.tokenExpiryTime.toString(),
        value: DateTime.now().toIso8601String(),
        aOptions: const AndroidOptions(
          encryptedSharedPreferences: true,
        ),
      );

      emit(AuthAuthenticationSuccess(token: authToken));
    } catch (e) {
      log.e('authenticate error: $e');
      emit(AuthFailure('$e'));
    }
  }

  // Method to get the stored token
  String? getToken() {
    return authToken;
  }
}
