import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/tracking/ptp-cosd/astra-motor/tracking_astra.dart';
import '../../model/niaga/tracking/ptp-cosd/dtd-cosl/tracking_dtd_cosl.dart';
import '../../model/niaga/tracking/ptp-cosd/dtp-cosl/tracking_dtp_cosl.dart';
import '../../model/niaga/tracking/ptp-cosd/header-tracking/detail_header.dart';
import '../../model/niaga/tracking/ptp-cosd/header-tracking/header_tracking.dart';
import '../../model/niaga/tracking/ptp-cosd/ptd-cosd/tracking_ptd_cosd.dart';
import '../../model/niaga/tracking/ptp-cosd/ptd-cosl/tracking_ptd_cosl.dart';
import '../../model/niaga/tracking/ptp-cosd/ptp-cosl/tracking_ptp_cosl.dart';
import '../../model/niaga/tracking/ptp-cosd/tracking_header.dart';
import '../../model/niaga/tracking/ptp-cosd/tracking_ptp_cosd.dart';
import '../../services/niaga service/tracking/tracking_astra_service.dart';
import '../../services/niaga service/tracking/tracking_dtd_cosl_service.dart';
import '../../services/niaga service/tracking/tracking_dtp_cosl_service.dart';
import '../../services/niaga service/tracking/tracking_pencarian_service.dart';
import '../../services/niaga service/tracking/tracking_ptd_cosd_service.dart';
import '../../services/niaga service/tracking/tracking_ptd_cosl_service.dart';
import '../../services/niaga service/tracking/tracking_ptp_cosl_service.dart';
import '../../services/niaga service/tracking/tracking_service.dart';

part 'tracking_niaga_state.dart';

class TrackingNiagaCubit extends Cubit<TrackingNiagaState> {
  final log = getLogger('TrackingNiagaCubit');

  TrackingNiagaCubit() : super(TrackingNiagaInitial());

  // DTD COSL
  Future<void> trackingDTDCOSL(String noPL) async {
    log.i('trackingDTDCOSL');
    try {
      emit(TrackingDTDCOSLInProgress());

      // Fetch the tracking data
      final List<TrackingDtdCoslAccesses> response =
          await sl<TrackingNiagaDTDCOSLService>().getTrackingDTDCOSL(noPL);

      // Log or process each section of the tracking data
      for (TrackingDtdCoslAccesses tracking in response) {
        // Access and log header data
        for (TrackingItemHeaderAccesses headerItem in tracking.header) {
          log.i(
              'Header No PL: ${headerItem.nopl}, Owner: ${headerItem.ownerName}');
        }

        // Access and log masuk niaga data
        log.i(
            'Pengambilan Customer - Nama Customer: ${tracking.pengambilanCustomer.namaCustomer}, '
            'Tanggal: ${tracking.pengambilanCustomer.tanggal}');

        // Access and log muat pelabuhan data
        log.i(
            'Muat Pelabuhan - Pelabuhan Asal: ${tracking.muatPelabuhan.pelabuhanAsal}, '
            'ETD: ${tracking.muatPelabuhan.etd}');

        // Access and log bongkar pelabuhan data
        log.i(
            'Bongkar Pelabuhan - Pelabuhan: ${tracking.bongkarPelabuhan.pelabuhan}, '
            'ETA: ${tracking.bongkarPelabuhan.eta}');

        log.i('Tiba - Nama Customer: ${tracking.tiba.namaCustomerTiba}, '
            'Tanggal Tiba: ${tracking.tiba.tanggalTiba}');
      }

      // Emit success state with the response
      emit(TrackingDTDCOSLSuccess(response: response));
    } catch (e) {
      log.e('Tracking error: $e');
      emit(TrackingDTDCOSLFailure('$e'));
    }
  }

  // DTP COSL
  Future<void> trackingDTPCOSL(String noPL) async {
    log.i('trackingDTDCOSL');
    try {
      emit(TrackingDTPCOSLInProgress());

      // Fetch the tracking data
      final List<TrackingDtpCoslAccesses> response =
          await sl<TrackingNiagaDTPCOSLService>().getTrackingDTPCOSL(noPL);

      // Log or process each section of the tracking data
      for (TrackingDtpCoslAccesses tracking in response) {
        // Access and log header data
        for (TrackingItemHeaderAccesses headerItem in tracking.header) {
          log.i(
              'Header No PL: ${headerItem.nopl}, Owner: ${headerItem.ownerName}');
        }

        // Access and log masuk niaga data
        log.i(
            'Pengambilan Customer - Nama Customer: ${tracking.pengambilanCustomer.namaCustomer}, '
            'Tanggal: ${tracking.pengambilanCustomer.tanggal}');

        // Access and log muat pelabuhan data
        log.i(
            'Muat Pelabuhan - Pelabuhan Asal: ${tracking.muatPelabuhan.pelabuhanAsal}, '
            'ETD: ${tracking.muatPelabuhan.etd}');

        // Access and log bongkar pelabuhan data
        log.i(
            'Bongkar Pelabuhan - Pelabuhan: ${tracking.bongkarPelabuhan.pelabuhan}, '
            'ETA: ${tracking.bongkarPelabuhan.eta}');
      }

      // Emit success state with the response
      emit(TrackingDTPCOSLSuccess(response: response));
    } catch (e) {
      log.e('Tracking error: $e');
      emit(TrackingDTPCOSLFailure('$e'));
    }
  }

  // PTD COSD
  Future<void> trackingPTDCOSD(String noPL) async {
    log.i('trackingPTDCOSD');
    try {
      emit(TrackingPTDCOSDInProgress());

      // Fetch the tracking data
      final List<TrackingPtdCosdAccesses> response =
          await sl<TrackingNiagaPTDCOSDService>().getTrackingPTDCOSD(noPL);

      // Log or process each section of the tracking data
      for (TrackingPtdCosdAccesses tracking in response) {
        // Access and log header data
        for (TrackingItemHeaderAccesses headerItem in tracking.header) {
          log.i(
              'Header No PL: ${headerItem.nopl}, Owner: ${headerItem.ownerName}');
        }

        // Access and log masuk niaga data
        log.i('Masuk Niaga - Gudang: ${tracking.masukNiaga.namaGudang}, '
            'Tanggal Masuk: ${tracking.masukNiaga.tglMasuk}');

        // Access and log keluar niaga data
        log.i('Keluar Niaga - Gudang: ${tracking.keluarNiaga.namaGudang}, '
            'Tanggal Keluar: ${tracking.keluarNiaga.tglKeluar}');

        // Access and log menuju pelabuhan data
        log.i(
            'Menuju Pelabuhan - Tanggal Menuju: ${tracking.menujuPelabuhan.tglMenujuPelabuhan}');

        // Access and log muat pelabuhan data
        log.i(
            'Muat Pelabuhan - Pelabuhan Asal: ${tracking.muatPelabuhan.pelabuhanAsal}, '
            'ETD: ${tracking.muatPelabuhan.etd}');

        // Access and log bongkar pelabuhan data
        log.i(
            'Bongkar Pelabuhan - Pelabuhan: ${tracking.bongkarPelabuhan.pelabuhan}, '
            'ETA: ${tracking.bongkarPelabuhan.eta}');

        log.i('Tiba - Nama Customer: ${tracking.tiba.namaCustomerTiba}, '
            'Tanggal Tiba: ${tracking.tiba.tanggalTiba}');
      }

      // Emit success state with the response
      emit(TrackingPTDCOSDSuccess(response: response));
    } catch (e) {
      log.e('Tracking error: $e');
      emit(TrackingPTDCOSDFailure('$e'));
    }
  }

  // PTD COSL
  Future<void> trackingPTDCOSL(String noPL) async {
    log.i('trackingPTDCOSL');
    try {
      emit(TrackingPTDCOSLInProgress());

      // Fetch the tracking data
      final List<TrackingPtdCoslAccesses> response =
          await sl<TrackingNiagaPTDCOSLService>().getTrackingPTDCOSL(noPL);

      // Log or process each section of the tracking data
      for (TrackingPtdCoslAccesses tracking in response) {
        // Access and log header data
        for (TrackingItemHeaderAccesses headerItem in tracking.header) {
          log.i(
              'Header No PL: ${headerItem.nopl}, Owner: ${headerItem.ownerName}');
        }

        // Access and log muat pelabuhan data
        log.i(
            'Muat Pelabuhan - Pelabuhan Asal: ${tracking.muatPelabuhan.pelabuhanAsal}, '
            'ETD: ${tracking.muatPelabuhan.etd}');

        // Access and log bongkar pelabuhan data
        log.i(
            'Bongkar Pelabuhan - Pelabuhan: ${tracking.bongkarPelabuhan.pelabuhan}, '
            'ETA: ${tracking.bongkarPelabuhan.eta}');

        log.i('Tiba - Nama Customer: ${tracking.tiba.namaCustomerTiba}, '
            'Tanggal Tiba: ${tracking.tiba.tanggalTiba}');
      }

      // Emit success state with the response
      emit(TrackingPTDCOSLSuccess(response: response));
    } catch (e) {
      log.e('Tracking error: $e');
      emit(TrackingPTDCOSLFailure('$e'));
    }
  }

  // PTP COSD
  Future<void> trackingPTPCOSD(String noPL) async {
    log.i('trackingPTPCOSD');
    try {
      emit(TrackingPTPCOSDInProgress());

      // Fetch the tracking data
      final List<TrackingPtpCosdAccesses> response =
          await sl<TrackingNiagaService>().getTrackingPTPCOSD(noPL);

      // Log or process each section of the tracking data
      for (TrackingPtpCosdAccesses tracking in response) {
        // Access and log header data
        for (TrackingItemHeaderAccesses headerItem in tracking.header) {
          log.i(
              'Header No PL: ${headerItem.nopl}, Owner: ${headerItem.ownerName}');
        }

        // Access and log masuk niaga data
        log.i('Masuk Niaga - Gudang: ${tracking.masukNiaga.namaGudang}, '
            'Tanggal Masuk: ${tracking.masukNiaga.tglMasuk}');

        // Access and log keluar niaga data
        log.i('Keluar Niaga - Gudang: ${tracking.keluarNiaga.namaGudang}, '
            'Tanggal Keluar: ${tracking.keluarNiaga.tglKeluar}');

        // Access and log menuju pelabuhan data
        log.i(
            'Menuju Pelabuhan - Tanggal Menuju: ${tracking.menujuPelabuhan.tglMenujuPelabuhan}');

        // Access and log muat pelabuhan data
        log.i(
            'Muat Pelabuhan - Pelabuhan Asal: ${tracking.muatPelabuhan.pelabuhanAsal}, '
            'ETD: ${tracking.muatPelabuhan.etd}');

        // Access and log bongkar pelabuhan data
        log.i(
            'Bongkar Pelabuhan - Pelabuhan: ${tracking.bongkarPelabuhan.pelabuhan}, '
            'ETA: ${tracking.bongkarPelabuhan.eta}');
      }

      // Emit success state with the response
      emit(TrackingPTPCOSDSuccess(response: response));
    } catch (e) {
      log.e('Tracking error: $e');
      emit(TrackingPTPCOSDFailure('$e'));
    }
  }

  //PTP COSL
  Future<void> trackingPTPCOSL(String noPL) async {
    log.i('trackingPTPCOSL');
    try {
      emit(TrackingPTPCOSLInProgress());

      // Fetch the tracking data
      final List<TrackingPtpCoslAccesses> response =
          await sl<TrackingNiagaPTPCOSLService>().getTrackingPTPCOSL(noPL);

      // Log or process each section of the tracking data
      for (TrackingPtpCoslAccesses tracking in response) {
        // Access and log header data
        for (TrackingItemHeaderAccesses headerItem in tracking.header) {
          log.i(
              'Header No PL: ${headerItem.nopl}, Owner: ${headerItem.ownerName}');
        }

        // Access and log muat pelabuhan data
        log.i(
            'Muat Pelabuhan - Pelabuhan Asal: ${tracking.muatPelabuhan.pelabuhanAsal}, '
            'ETD: ${tracking.muatPelabuhan.etd}');

        // Access and log bongkar pelabuhan data
        log.i(
            'Bongkar Pelabuhan - Pelabuhan: ${tracking.bongkarPelabuhan.pelabuhan}, '
            'ETA: ${tracking.bongkarPelabuhan.eta}');
      }

      // Emit success state with the response
      emit(TrackingPTPCOSLSuccess(response: response));
    } catch (e) {
      log.e('Tracking error: $e');
      emit(TrackingPTPCOSLFailure('$e'));
    }
  }

  //ASTRA MOTOR
  Future<void> trackingAstraMotor(String noPL) async {
    log.i('trackingAstraMotor');
    try {
      emit(TrackingAstraMotorInProgress());

      // Fetch the tracking data
      final List<TrackingAstraAccesses> response =
          await sl<TrackingNiagaAstraMotorService>().getTrackingAstraMotor(noPL);

      // Log or process each section of the tracking data
      for (TrackingAstraAccesses tracking in response) {
        // Access and log header data
        for (TrackingItemHeaderAccesses headerItem in tracking.header) {
          log.i(
              'Header No PL: ${headerItem.nopl}, Owner: ${headerItem.ownerName}');
        }

        // Access and log Pertama dari Astra
        log.i(
            'Dari Gudang Astra - Pertama dari Astra: ${tracking.dariGudangAstra.pertamaDariAstra}, '
            'Terakhir dari Astra: ${tracking.dariGudangAstra.terakhirDariAstra}');

        // Access and log Gudang Sby
        log.i(
            'Gudang Sby - Pertama dari Astra: ${tracking.gudangSby.pertamaGudangNiaga}, '
            'Terakhir dari Astra: ${tracking.gudangSby.pertamaGudangNiaga}');

        // Access and log bongkar pelabuhan data
        log.i(
            'Bongkar Pelabuhan - Pelabuhan: ${tracking.bongkarPelabuhan.pelabuhan}, '
            'ETA: ${tracking.bongkarPelabuhan.eta}');

        log.i('Tiba - Nama Customer: ${tracking.tiba.namaCustomerTiba}, '
            'Tanggal Tiba: ${tracking.tiba.tanggalTiba}');
      }

      // Emit success state with the response
      emit(TrackingAstraMotorSuccess(response: response));
    } catch (e) {
      log.e('Tracking Astra Motor error: $e');
      emit(TrackingAstraMotorFailure('$e'));
    }
  }

  //TRACKING PENCARIAN BARANG
  Future<void> trackingPencarianBarang(String noPL) async {
    log.i('trackingPencarianBarang');
    try {
      emit(TrackingPencarianBarangInProgress());

      // Fetch the tracking data
      final HeaderTrackingAccesses response =
          await sl<TrackingPencarianService>().getTrackingPencarian(noPL);

      // Extract the first item from the header list if available
      if (response.header.isNotEmpty) {
        final HeaderItemTrackingAccesses firstItem = response.header.first;

        // Extract the keterangan and no_pl
        final String? keterangan = firstItem.keterangan;
        final String? noPl = firstItem.noPl;

        // Log the extracted data for debugging
        log.i('Keterangan: $keterangan, No PL: $noPl');

        // Emit success state with the extracted values
        emit(TrackingPencarianBarangSuccess(
          keterangan: keterangan,
          noPl: noPl,
          response: response,
        ));
      }
    } catch (e) {
      log.e('Tracking Pencarian Barang error: $e');
      emit(TrackingPencarianBarangFailure('$e'));
    }
  }
}
