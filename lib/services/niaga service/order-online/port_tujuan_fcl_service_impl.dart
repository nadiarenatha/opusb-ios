import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/order-online/port_tujuan_fcl_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../../model/niaga/port_tujuan_fcl.dart';
import 'dart:convert';

import '../../../shared/constants.dart'; // Import for JSON decoding

class PortTujuanFCLServiceImpl implements PortTujuanFCLService {
  final log = getLogger('PortTujuanFCLServiceImpl');
  final Dio dio;
  final FlutterSecureStorage storage;

  PortTujuanFCLServiceImpl({
    required this.dio,
    required this.storage,
  });

  @override
  Future<List<PortTujuanFCLAccesses>> getPortTujuanFCL(String portAsal) async {
    List<PortTujuanFCLAccesses> listPortTujuan = [];

    try {
      log.i('Making API request to get port tujuan FCL based on $portAsal...');

      final endpoint =
          'api/v1/port/order?jenis_port=TUJUAN&port_asal=$portAsal&jenis_pengiriman=FCL';

      final fullUrlPortTujuanFCL = '${dio.options.baseUrl}$endpoint';
      log.i('Constructed Full URL popular destination: $fullUrlPortTujuanFCL');

      await storage.write(
        key: AuthKey.fullUrlPortTujuanFCL.toString(),
        value: fullUrlPortTujuanFCL.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      // final response = await dio.get(
      //     'api/v1/port/order?jenis_port=TUJUAN&port_asal=$portAsal&jenis_pengiriman=FCL');

      final response = await dio.get(endpoint);

      // Log the full response for debugging
      log.i('portAsal value: $portAsal');
      log.i(
          'API request URL: api/v1/port/order?jenis_port=TUJUAN&port_asal=$portAsal&jenis_pengiriman=FCL');
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      // if (response.statusCode == 200) {
      //   // dynamic responseData = response.data;
      //   final List<dynamic> responseData = response.data;

      //   listPortTujuan = responseData
      //       .map((json) => PortTujuanFCLAccesses.fromJson(json))
      //       .toList();
      //   // Log the parsed data
      //   log.i('Parsed Port Asal FCL List: $listPortTujuan');
      // } else {
      //   throw Exception(
      //       'Failed to load port tujuan FCL with status code: ${response.statusCode}');
      // }
      if (response.statusCode == 200) {
        final dynamic responseData = response.data;

        if (responseData is List) {
          listPortTujuan = responseData
              .map((json) => PortTujuanFCLAccesses.fromJson(json))
              .toList();
          log.i('portAsal value: $portAsal');
          log.i('Parsed Port Tujuan FCL List: $listPortTujuan');
        } else if (responseData is String) {
          throw Exception('API returned a string: $responseData');
        } else {
          throw Exception(
              'Unexpected response format: ${responseData.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load port tujuan FCL with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        // log.e('Dio response: ${e.response}');
        log.e('Dio response status code: ${e.response?.statusCode}');
        log.e('Dio response data: ${e.response?.data}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listPortTujuan;
  }

  Future<List<PortTujuanFCLAccesses>> getPortTujuanLCL(String portAsal) async {
    List<PortTujuanFCLAccesses> listPortTujuan = [];

    try {
      log.i('Making API request to get port tujuan LCL based on $portAsal...');

      final endpoint =
          'api/v1/port/order?jenis_port=TUJUAN&port_asal=$portAsal&jenis_pengiriman=LCL';

      final fullUrlPortTujuanLCL = '${dio.options.baseUrl}$endpoint';
      log.i('Constructed Full URL popular destination: $fullUrlPortTujuanLCL');

      await storage.write(
        key: AuthKey.fullUrlPortTujuanLCL.toString(),
        value: fullUrlPortTujuanLCL.toString(),
        aOptions: const AndroidOptions(encryptedSharedPreferences: true),
      );

      // final response = await dio.get(
      //     'api/v1/port/order?jenis_port=TUJUAN&port_asal=$portAsal&jenis_pengiriman=LCL');

      final response = await dio.get(endpoint);

      // Log the full response for debugging
      log.i('portAsal value: $portAsal');
      log.i(
          'API request URL: api/v1/port/order?jenis_port=TUJUAN&port_asal=$portAsal&jenis_pengiriman=LCL');
      log.i("Full Response: ${response.toString()}");
      log.i("Response status code: ${response.statusCode}");

      // if (response.statusCode == 200) {
      //   // dynamic responseData = response.data;
      //   final List<dynamic> responseData = response.data;

      //   listPortTujuan = responseData
      //       .map((json) => PortTujuanFCLAccesses.fromJson(json))
      //       .toList();
      //   // Log the parsed data
      //   log.i('Parsed Port Asal FCL List: $listPortTujuan');
      // } else {
      //   throw Exception(
      //       'Failed to load port tujuan FCL with status code: ${response.statusCode}');
      // }
      if (response.statusCode == 200) {
        final dynamic responseData = response.data;

        if (responseData is List) {
          listPortTujuan = responseData
              .map((json) => PortTujuanFCLAccesses.fromJson(json))
              .toList();
          log.i('portAsal value: $portAsal');
          log.i('Parsed Port Tujuan LCL List: $listPortTujuan');
        } else if (responseData is String) {
          throw Exception('API returned a string: $responseData');
        } else {
          throw Exception(
              'Unexpected response format: ${responseData.runtimeType}');
        }
      } else {
        throw Exception(
            'Failed to load port tujuan LCL with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log.e('DioException occurred: $e');
      if (e.response != null) {
        // log.e('Dio response: ${e.response}');
        log.e('Dio response status code: ${e.response?.statusCode}');
        log.e('Dio response data: ${e.response?.data}');
      }
    } catch (e) {
      log.e('Unexpected error: $e');
    }

    return listPortTujuan;
  }
}
