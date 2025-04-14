import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/refresh_token_service.dart';
import 'package:niaga_apps_mobile/shared/constants.dart';
import 'package:niaga_apps_mobile/shared/functions/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/refresh_token.dart';

class RefreshTokenServiceNiagaImpl implements RefreshTokenNiagaService {
  final log = getLogger('RefreshTokenServiceNiagaImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  RefreshTokenServiceNiagaImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<RefreshTokenNiaga> refreshTokenNiaga(String refreshToken) async {
    log.i('Attempting to refresh token');
    log.i(dio.options.baseUrl);

    try {
      final response = await dio.post(
        'niaga/refresh-token',
        data: {
          'refresh_token': refreshToken,
        },
      );

      log.i("Full Response Data: ${response.data}");

      // Check if response contains expected fields
      if (response.statusCode == 200 && response.data != null) {
        final authNiagaResponse = RefreshTokenNiaga.fromJson(response.data);

        // Save the new refresh token to secure storage if necessary
        if (authNiagaResponse.refreshToken != null) {
          await storage.write(
            key: 'refresh_token',
            value: authNiagaResponse.refreshToken,
          );
        }

        // Assuming you receive an access token in the response
        final newAccessToken = response.data['refresh_token'];
        if (newAccessToken != null) {
          // Return a RefreshTokenNiaga instance populated with the new access token
          return RefreshTokenNiaga(
            refreshToken: newAccessToken,
            // Add any additional fields from response data here
          );
        } else {
          throw Exception("Access token not found in response");
        }
      } else {
        throw Exception("Failed to refresh token: Unexpected response structure");
      }
    } on DioException catch (e) {
      log.e("Error during token refresh: $e");
      if (e.message != null) {
        log.e(e.message!);
      }
      throw e; // Optionally rethrow the error
    }
  }
}
