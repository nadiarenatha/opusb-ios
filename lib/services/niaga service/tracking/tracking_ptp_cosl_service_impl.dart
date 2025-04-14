import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_ptp_cosl_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';
import '../../../model/niaga/tracking/ptp-cosd/ptp-cosl/tracking_ptp_cosl.dart';

class TrackingNiagaPTPCOSLServiceImpl implements TrackingNiagaPTPCOSLService {
  final log = getLogger('TrackingNiagaPTPCOSLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  TrackingNiagaPTPCOSLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<TrackingPtpCoslAccesses>> getTrackingPTPCOSL(String noPL) async {
    List<TrackingPtpCoslAccesses> listTrackingPTPCOSL = [];

    try {
      // Log before making the request
      log.i('Making API request to get tracking PTP COSL...');
      log.i('api/v1/tracking?no=$noPL');

      final response = await dio.get(
        // 'api/v1/tracking?no=PL%2FSBY%2F51AR-BA%2F2024.02%2F184082',
        'api/v1/tracking?no=$noPL',
      );
      // Log the entire response
      log.i("Response status code: ${response.statusCode}");
      log.i("Full Response: ${response.data}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to the TrackingPtpCoslAccesses model
        final trackingData = TrackingPtpCoslAccesses.fromJson(response.data);

        // Add the deserialized data to the list
        listTrackingPTPCOSL.add(trackingData);
      } else {
        throw Exception('Failed to load tracking data');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listTrackingPTPCOSL;
  }
}
