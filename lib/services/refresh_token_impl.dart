// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:niaga_apps_mobile/shared/constants.dart';

// class RefreshTokenServiceImpl {
//   final Dio dio;
//   final FlutterSecureStorage storage;

//   RefreshTokenServiceImpl({required this.dio, required this.storage});

//   Future<void> refreshToken() async {
//     try {
//       // Make a request to your refresh token endpoint
//       final response = await dio.post('/refresh-token', data: {
//         'refresh_token':
//             await storage.read(key: AuthKey.refreshToken.toString()),
//       });

//       final newToken = response.data['access_token'];
//       final newRefreshToken = response.data['refresh_token'];

//       // Save the new tokens
//       await storage.write(key: AuthKey.token.toString(), value: newToken);
//       await storage.write(
//           key: AuthKey.refreshToken.toString(), value: newRefreshToken);
//     } catch (e) {
//       // Handle error appropriately
//       throw Exception("Failed to refresh token");
//     }
//   }
// }
