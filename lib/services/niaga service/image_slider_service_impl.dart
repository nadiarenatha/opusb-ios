import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/image_slider.dart';
import 'image_slider_service.dart';

class ImageSliderServiceImpl implements ImageSliderService {
  final log = getLogger('ImageSliderServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  ImageSliderServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<ImageSliderAccesses>> getImageSlider(bool active) async {
    List<ImageSliderAccesses> listImageSlider = [];

    try {
      log.i('Making API request to get image slider...');
      log.i('bhp-articles?active.equals=${active.toString()}');

      final response = await dio.get('bhp-articles?active.equals=${active.toString()}');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        listImageSlider =
            data.map((json) => ImageSliderAccesses.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load image slider');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listImageSlider;
  }
}
