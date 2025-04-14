// import 'package:dio/dio.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:niaga_apps_mobile/shared/widget/logger.dart';
// import 'package:intl/intl.dart';

// import '../../model/niaga/log_niaga.dart';
// import 'log_niaga_service.dart';

// class LogNiagaServiceImpl implements LogNiagaService {
//   final log = getLogger('LogNiagaServiceImpl');
//   final Dio dio;
//   final FlutterSecureStorage storage;

//   LogNiagaServiceImpl({
//     required this.dio,
//     required this.storage,
//   });

//   @override 
//   Future<LogNiagaAccesses> logNiaga(String actionUrl) async {
//     final sysdate =
//         DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

//     log.i('Formatted sysdate: $sysdate');
//     log.i('actionUrl: $actionUrl');

//     // final fullUrl = 'https://api-app.niaga-logistics.com$actionUrl';
//     // log.i('Full actionUrl: $fullUrl');
//     try {
//       final response = await dio.post(
//         'bhp-activity-logs',
//         data: {
//           'actionUrl': actionUrl,
//           'requestBy': 'mobile',
//           'activityLogTime': sysdate,
//         },
//         options: Options(
//           headers: {
//             'Content-Type': 'application/json',
//           },
//         ),
//       );

//       log.i("Response data: ${response.data.toString()}");
//       log.i("Response status code: ${response.statusCode}");

//       // final logNiagaAccess = LogNiagaAccesses.fromJson(response.data);

//       // return logNiagaAccess;
//       if (response.statusCode == 201) {
//         log.i("Log successfully created!");
//         // Convert response data to model
//         final logNiagaAccess = LogNiagaAccesses.fromJson(response.data);
//         return logNiagaAccess;
//       } else {
//         throw Exception(
//             'Failed to log niaga: Unexpected status code ${response.statusCode}');
//       }
//     } on DioException catch (e) {
//       log.e(e);
//       if (e.message != null) {
//         log.e(e.message!);
//       }
//       if (e.error != null) {
//         throw e.error!;
//       }
//       throw Exception('Failed to get log niaga');
//     }
//   }
// }
