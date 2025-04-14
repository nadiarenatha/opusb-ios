import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/simulasi_harga.dart';
import '../../services/niaga service/simulasi_harga_service.dart';
import 'package:dio/dio.dart';

part 'simulasi_harga_state.dart';

class SimulasiHargaCubit extends Cubit<SimulasiHargaState> {
  final log = getLogger('SimulasiHargaCubit');

  SimulasiHargaCubit() : super(SimulasiHargaInitial());

  Future<void> simulasiHarga({
    required String portAsal,
    required String portTujuan,
    required String jenisPengiriman,
  }) async {
    log.i('Fetching Simulasi Harga Data');
    try {
      emit(SimulasiHargaInProgress());

      final List<SimulasiHargaAccesses> response =
          await sl<SimulasiHargaService>().getSimulasiHarga(
        portAsal,
        portTujuan,
        jenisPengiriman,
      );

      if (response.isEmpty) {
        log.w('Received an empty response');
        emit(SimulasiHargaFailure(
            'Call sales : https://linktr.ee/niagalogistics'));
        return;
      }

      for (var item in response) {
        log.i('Jenis Pengiriman: ${item.jenisPengiriman}');
        log.i('Harga: ${item.harga}');
      }

      emit(SimulasiHargaSuccess(response: response));
      // try {
      //   logSimulasiHarga(portAsal, portTujuan, jenisPengiriman);
      // } catch (e) {
      //   log.e('Error logUnCompletePacking: $e');
      // }
    } catch (e) {
      log.e('Error fetching Simulasi Harga data: $e');

      if (e is DioError && e.response?.statusCode == 404) {
        final responseData = e.response?.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          final message = responseData['message'] as String?;
          // emit(SimulasiHargaFailure(message ?? 'An unexpected error occurred.'));
          emit(SimulasiHargaFailure(message?.isNotEmpty == true
              ? message!
              : 'Call sales for more information.'));
        } else {
          emit(SimulasiHargaFailure('An unexpected error occurred.'));
        }
      } else {
        emit(SimulasiHargaFailure('Failed to fetch data. Please try again.'));
      }
    }
  }

  Future<void> logSimulasiHarga(
      String portAsal, String portTujuan, String jenisPengiriman) async {
    log.i('LogSimulasiHarga');
    try {
      emit(LogSimulasiHargaNiagaInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService3>()
          .logNiaga(portAsal, portTujuan, jenisPengiriman);

      emit(LogSimulasiHargaNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogSimulasiHargaNiagaCubit error: $e');
      emit(LogSimulasiHargaNiagaFailure('$e'));
    }
  }
}
