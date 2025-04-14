import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/tracking/tracking_pencarian_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../model/niaga/tracking/ptp-cosd/header-tracking/detail_header.dart';
import '../../../model/niaga/tracking/ptp-cosd/header-tracking/header_tracking.dart';

class TrackingPencarianServiceImpl implements TrackingPencarianService {
  final log = getLogger('TrackingPencarianServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  TrackingPencarianServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<HeaderTrackingAccesses> getTrackingPencarian(String noPL) async {
    try {
      // Log before making the request
      log.i('Making API request to get header pencarian tracking...');
      log.i('api/v1/tracking?no=$noPL');

      final response = await dio.get(
        'api/v1/tracking?no=$noPL',
      );

      // Log the entire response
      log.i("Response status code: ${response.statusCode}");
      log.i("Full Response: ${response.data}");

      if (response.statusCode == 200) {
        // Parse the response data into HeaderTrackingAccesses
        final responseData = response.data;
        final headerTracking = HeaderTrackingAccesses.fromJson(responseData);

        // Log the parsed data
        log.i("Parsed header data: ${headerTracking.toJson()}");

        return headerTracking;
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

    // Return an empty instance in case of failure
    return HeaderTrackingAccesses(header: []);
  }
}
