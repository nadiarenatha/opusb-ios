import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/uoc-list-search/uoc_list_search_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../model/niaga/uoc_list_search.dart';

class UOCListSearchServiceImpl implements UOCListSearchService {
  final log = getLogger('UOCListSearchServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  UOCListSearchServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<UOCListSearchAccesses>> getUOCListSearch(
      String kota, String port) async {
    List<UOCListSearchAccesses> listUOCSearch = [];

    try {
      log.i('Making API request to get uoc list search...');
      log.i('api/v1/uoc/?kota=$kota&port=$port'); 

      final response = await dio.get('api/v1/uoc/?kota=$kota&port=$port');
      // Log the entire response
      log.i("Full Response: ${response.toString()}");
      // log.i("Full Response Data: ${response.data}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Deserialize the JSON response to PopularDestinationAccesses model
        if (response.data is List) {
          // Map the response data to your model
          listUOCSearch = (response.data as List)
              .map((jsonItem) => UOCListSearchAccesses.fromJson(jsonItem))
              .toList();
        }
        // else {
        //   log.e('Unexpected response format: ${response.data}');
        // }
        else if (response.data is Map && response.data['data'] is List) {
          // Handle a nested structure, if applicable
          listUOCSearch = (response.data['data'] as List)
              .map((jsonItem) => UOCListSearchAccesses.fromJson(jsonItem))
              .toList();
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to load UOC List Search');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listUOCSearch;
  }
}
