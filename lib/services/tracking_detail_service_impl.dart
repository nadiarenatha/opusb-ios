import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/model/tracking_detail.dart';
import 'package:niaga_apps_mobile/services/tracking_detail_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

class TrackingDetailServiceImpl implements TrackingDetailService {
  final log = getLogger('TrackingDetailServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  TrackingDetailServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<TrackingDetailAccesses>> gettrackingdetail(
      {int? mePackingListId}) async {
    List<TrackingDetailAccesses> listTrackingDetail = [];

    try {
      final response = await dio.get(
        'me-traffics?mePackingListId.equals=$mePackingListId',
      );
      print("Response: ${response.statusCode} - ${response.data}");

      if (response.statusCode == 200) {
        var data = response.data as List;
        listTrackingDetail =
            data.map((i) => TrackingDetailAccesses.fromJson(i)).toList();
        listTrackingDetail.sort((a, b) => a.id!.compareTo(b.id!)); 

        print('Filtered Tracking Detail List: $listTrackingDetail');
      } else {
        log.e('Failed to fetch tracking detail list');
      }
    } on DioException catch (e) {
      log.e('Error fetching tracking detail list: $e');
      // Handle Dio errors here
      throw e;
    }

    return listTrackingDetail;
  }
}
