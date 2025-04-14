import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_ptd_cosd_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';
import '../../../model/niaga/tracking/ptp-cosd/ptd-cosd/tracking_ptd_cosd.dart';

class TrackingNiagaPTDCOSDServiceImpl implements TrackingNiagaPTDCOSDService {
  final log = getLogger('TrackingNiagaPTDCOSDServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  TrackingNiagaPTDCOSDServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<TrackingPtdCosdAccesses>> getTrackingPTDCOSD(String noPL) async {
    List<TrackingPtdCosdAccesses> listTrackingPTDCOSD = [];

    try {
      // Log before making the request
      log.i('Making API request to get tracking PTD COSD...');
      log.i('api/v1/tracking?no=$noPL');

      final response = await dio.get(
        // 'api/v1/tracking?no=PL%2FSBY%2F51AR-BA%2F2024.02%2F184082',
        'api/v1/tracking?no=$noPL',
      );
      // Log the entire response
      log.i("Response status code: ${response.statusCode}");
      log.i("Full Response: ${response.data}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to the TrackingPtdCosdAccesses model
        final trackingData = TrackingPtdCosdAccesses.fromJson(response.data);

        // Add the deserialized data to the list
        listTrackingPTDCOSD.add(trackingData);
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

    return listTrackingPTDCOSD;
  }
}
