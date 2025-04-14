import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/model/login/login_account.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../model/niaga/login_credential_niaga.dart';
import '../../model/niaga/login_token_niaga.dart';
import '../../model/niaga/refresh_token.dart';
import '../../services/niaga service/auth_niaga_service_niaga.dart';
import '../../services/niaga service/refresh_token_service.dart';
import '../../shared/constants.dart';
import '../auth_cubit.dart';

part 'auth_niaga_state.dart';

// class AuthNiagaCubit extends Cubit<AuthNiagaState> {
//   final log = getLogger('AuthNiagaCubit');
//   String? niagaToken; // Token for AuthNiagaCubit

//   AuthNiagaCubit() : super(AuthNiagaInitial());

//   Future<void> authenticateNiaga(String username, String password) async {
//     log.i('authenticateNiaga($username)');
//     try {
//       emit(AuthNiagaInProgress());

//       final response = await sl<AuthNiagaService>().authenticateNiaga(
//         LoginCredentialNiaga(username: username, password: password),
//       );

//       niagaToken = response.accessToken; // Store the token

//       emit(AuthNiagaAuthenticationSuccess(response: response));
//     } catch (e) {
//       log.e('authenticate error: $e');
//       emit(AuthNiagaFailure('$e'));
//     }
//   }

//   // Method to get the stored token
//   String? getToken() {
//     return niagaToken;
//   }
// }

class AuthNiagaCubit extends Cubit<AuthNiagaState> {
  String? niagaToken;
  String? niagaRefreshToken;
  int? niagaExpiredAt;
  // tokenRetrievedAt = DateTime.now(); // Save the current time during login
  DateTime? tokenRetrievedAt;
  final storage = FlutterSecureStorage();

  AuthNiagaCubit() : super(AuthNiagaInitial());

  Future<void> authenticateNiaga() async {
    try {
      emit(AuthNiagaInProgress());
      final response = await sl<AuthNiagaService>().authenticateNiaga(LoginTokenNiaga());

      // Assign values from response
      niagaToken = response.accessToken;
      niagaRefreshToken = response.refreshToken;
      // niagaExpiredAt = response.expiredAt;
      // Save the current time during login
      tokenRetrievedAt = DateTime.now();

      // Save niagaToken to secure storage
      await storage.write(
        key: AuthKey.niagaToken.toString(),
        value: niagaToken.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      // Print debug statements to verify values
      print("Access Token: $niagaToken");
      print("Refresh Token: $niagaRefreshToken");
      print("Expired At: $niagaExpiredAt");

      // Emit success state with response
      emit(AuthNiagaAuthenticationSuccess(response: response));
    } catch (e) {
      emit(AuthNiagaFailure('$e'));
      print("Error: $e");
    }
  }

  //Refresh Token Niaga
//   Future<void> refreshNiaga() async {
//   if (tokenRetrievedAt == null) {
//     print("Token retrieval time is not set.");
//     return;
//   }

//   final currentTime = DateTime.now();
//   final elapsedTime = currentTime.difference(tokenRetrievedAt!).inMinutes; // Time difference in minutes

//   if (elapsedTime >= 60) { // Check if 1 hour has passed
//     print("Access token expired. Refreshing...");
//     try {
//       emit(RefreshTokenNiagaInProgress());

//       final response = await sl<RefreshTokenNiagaService>().refreshTokenNiaga(niagaRefreshToken!);

//       niagaToken = response.refreshToken; 

//       print("New Access Token: $niagaToken");
//     } catch (e) {
//       emit(RefreshTokenFailure('$e'));
//       print("Error refreshing token: $e");
//     }
//   } else {
//     print("Access token is still valid.");
//   }
// }

//2
Future<void> refreshNiaga() async {
    if (tokenRetrievedAt == null) {
      print("Token retrieval time is not set.");
      return;
    }

    final currentTime = DateTime.now();
    final elapsedTime = currentTime.difference(tokenRetrievedAt!).inMinutes;

    if (elapsedTime >= 60 && elapsedTime < 120) {
      // Access token expired but refresh token is still valid
      print("Access token expired. Refreshing...");
      try {
        emit(RefreshTokenNiagaInProgress());

        final response = await sl<RefreshTokenNiagaService>().refreshTokenNiaga(niagaRefreshToken!);

        niagaToken = response.refreshToken; // Update the access token
        tokenRetrievedAt = currentTime; // Update token retrieval time

        print("New Access Token: $niagaToken");
        emit(RefreshTokenSuccess(response: response));
      } catch (e) {
        emit(RefreshTokenFailure('$e'));
        print("Error refreshing token: $e");
      }
    } else if (elapsedTime >= 120) {
      // Both access token and refresh token expired; get a new refresh token
      print("Both access and refresh tokens expired. Generating new tokens...");
      try {
        emit(RefreshTokenNiagaInProgress());

        final response = await sl<RefreshTokenNiagaService>().refreshTokenNiaga(niagaRefreshToken!);

        niagaRefreshToken = response.refreshToken;
        tokenRetrievedAt = currentTime; // Update token retrieval time

        print("New Refresh Token: $niagaRefreshToken");
        emit(RefreshTokenSuccess(response: response));
      } catch (e) {
        emit(RefreshTokenFailure('$e'));
        print("Error generating new tokens: $e");
      }
    } else {
      print("Access token is still valid.");
    }
  }

  Future<String?> getValidAccessToken() async {
    await refreshNiaga(); // Refresh token if expired
    return niagaToken; // Return the current or new token
  }
}