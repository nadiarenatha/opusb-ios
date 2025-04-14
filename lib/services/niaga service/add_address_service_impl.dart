import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../model/niaga/address.dart';
import 'package:intl/intl.dart';

import 'add_address_service.dart';

class AddAddressServiceImpl implements AddAddressService {
  final log = getLogger('AddAddressServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  AddAddressServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<AddressAccesses> getAddresses(
      String addressType,
      String email,
      String addressName,
      String picName,
      String picPhone,
      String city,
      String createdDate,
      String createdBy,
      String address1,
      String locationId) async {
    final sysdate =
        DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());
    log.i('Formatted sysdate: $sysdate');

    try {
      log.i('Making API request to post address...');

      final response = await dio.post('bhp-addresses', data: {
        'addressType': addressType,
        'email': email,
        'addressName': addressName,
        'picName': picName,
        'picPhone': picPhone,
        'city': city,
        'createdDate': sysdate,
        'createdBy': email,
        'address1': address1,
        'locationId': locationId,
      });

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 201) {
        // Parse response data into AddressAccesses object
        final addressAccesses = AddressAccesses.fromJson(response.data);
        return addressAccesses;
      } else {
        throw Exception(
            'Failed to load addresses. Status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
        throw Exception('API Error: ${e.response?.data['message']}');
      }
      throw Exception('Unexpected network error occurred');
    } catch (e) {
      log.e('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}
