import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/jadwal-kapal/jadwal_kapal.dart';
import '../../model/niaga/log_niaga.dart';
import '../../services/niaga service/jadwal-kapal/image_jadwal_kapal_service.dart';
import '../../services/niaga service/jadwal-kapal/jadwal_kapal_service.dart';

part 'jadwal_kapal_state.dart';

class JadwalKapalNiagaCubit extends Cubit<JadwalKapalNiagaState> {
  final log = getLogger('JadwalKapalNiagaCubit');

  JadwalKapalNiagaCubit() : super(JadwalKapalNiagaInitial());

  // Method to fetch port asal FCL data
  Future<void> jadwalKapalNiaga(
      String portAsal, String portTujuan, String etdFrom) async {
    log.i(
        'Fetching Jadwal Kapal Data for portAsal: $portAsal, portTujuan: $portTujuan, etdFrom: $etdFrom');

    try {
      emit(JadwalKapalNiagaInProgress());

      // Fetch the list of PortAsalFCLAccesses
      final List<JadwalKapalNiagaAccesses> response =
          await sl<JadwalKapalNiagaService>()
              .getJadwalKapalNiaga(portAsal, portTujuan, etdFrom);

      emit(JadwalKapalNiagaSuccess(response: response));
      try {
        logJadwalKapal(portAsal, portTujuan, etdFrom);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('Error fetching Jadwal Kapal data: $e');
      emit(JadwalKapalNiagaFailure('Error: $e'));
    }
  }

  Future<void> downloadImageKapal(String kotaAsal, String kotaTujuan,
      String portAsal, String portTujuan, String etdFrom) async {
    log.i('Starting download for kota asal: $kotaAsal');
    log.i('Starting download for kota tujuan: $kotaTujuan');
    log.i('Starting download for port asal: $portAsal');
    log.i('Starting download for port tujuan: $portTujuan');
    log.i('Starting download for etd from: $etdFrom');

    try {
      emit(DownloadImageKapalInProgress());

      // Attempt to download the image using the provided parameters
      bool downloadSuccess =
          await sl<ImageJadwalKapalService>().downloadImageJadwalKapal(
        kotaAsal,
        kotaTujuan,
        portAsal,
        portTujuan,
        etdFrom,
      );

      if (downloadSuccess) {
        emit(DownloadImageKapalSuccess());
      } else {
        emit(DownloadImageKapalFailure('Failed to download image'));
      }
    } catch (e) {
      log.e('Error during download image jadwal kapal: $e');
      emit(DownloadImageKapalFailure('$e'));
    }
  }

  Future<void> logJadwalKapal(
      String portAsal, String portTujuan, String etdFrom) async {
    log.i('LogNiagaCubit');
    try {
      emit(LogNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService5>().logNiaga(portAsal, portTujuan, etdFrom);

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }
}
