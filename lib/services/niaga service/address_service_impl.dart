import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'dart:convert';

import '../../../shared/constants.dart';
import '../../model/niaga/address.dart';
import 'address_service.dart';

class AddressServiceImpl implements AddressService {
  final log = getLogger('AddressServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  AddressServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<AddressAccesses>> getAddress() async {
    List<AddressAccesses> listAddress = [];

    try {
      final email = await storage.read(
        key: AuthKey.email.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      log.i('Making API request to get address...');
      log.i('Making API request to get address with email: $email...');
      log.i('bhp-addresses?email.equals=$email');

      final response = await dio.get('bhp-addresses?email.equals=$email');

      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          // Map the response data to your model
          listAddress = (response.data as List)
              .map((jsonItem) => AddressAccesses.fromJson(jsonItem))
              .toList();
          log.i("Parsed Address List: ${listAddress.toString()}");
        } else {
          log.e('Unexpected response format: ${response.data}');
        }
      } else {
        throw Exception('Failed to load address');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        log.e('Dio response: ${e.response}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listAddress;
  }
}
