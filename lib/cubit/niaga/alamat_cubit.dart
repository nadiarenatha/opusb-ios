import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/alamat.dart';
import '../../model/niaga/alamat_bongkar.dart';
import '../../model/niaga/alamat_muat_lcl.dart';
import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/master_lokasi.dart';
import '../../model/niaga/master_lokasi_bongkar.dart';
import '../../services/niaga service/alamat_bongkar_service.dart';
import '../../services/niaga service/alamat_muat_lcl_service.dart';
import '../../services/niaga service/alamat_muat_service.dart';
import '../../services/niaga service/order-online/master_lokasi_bongkar_service.dart';
import '../../services/niaga service/order-online/master_lokasi_service.dart';

part 'alamat_state.dart';

class AlamatNiagaCubit extends Cubit<AlamatNiagaState> {
  final log = getLogger('AlamatNiagaCubit');

  AlamatNiagaCubit() : super(AlamatNiagaInitial());

  //Alamat Bongkar
  Future<dynamic> alamatBongkar(String port, String kota) async {
    log.i('AlamatBongkarNiagaCubit');
    log.i('Detail Alamat Bongkar');
    try {
      emit(AlamatBongkarNiagaInProgress());

      final List<AlamatBongkarAccesses> response =
          await sl<AlamatBongkarService>().getalamatBongkar(port, kota);

      emit(AlamatBongkarNiagaSuccess(response: response));
    } catch (e) {
      log.e('AlamatBongkarNiagaCubit error: $e');
      emit(AlamatBongkarNiagaFailure('$e'));
    }
  }

  //Alamat Muat FCL
  Future<dynamic> alamatMuat(String port, String kota) async {
    log.i('AlamatMuatNiagaCubit');
    log.i('Detail Alamat Muat');
    try {
      emit(AlamatMuatNiagaInProgress());

      final List<AlamatAccesses> response =
          await sl<AlamatMuatService>().getalamatMuat(port, kota);

      emit(AlamatMuatNiagaSuccess(response: response));
    } catch (e) {
      log.e('AlamatMuatNiagaCubit error: $e');
      emit(AlamatMuatNiagaFailure('$e'));
    }
  }

  //Alamat Muat LCL
  Future<dynamic> alamatMuatLCL(String portCode) async {
    log.i('AlamatMuatLCLNiagaCubit');
    log.i('Detail Alamat Muat LCL');
    try {
      emit(AlamatMuatLCLNiagaInProgress());

      final List<AlamatMuatLCLAccesses> response =
          await sl<AlamatMuatLCLService>().getalamatMuatLCL(portCode);

      emit(AlamatMuatLCLNiagaSuccess(response: response));
    } catch (e) {
      log.e('AlamatMuatLCLNiagaCubit error: $e');
      emit(AlamatMuatLCLNiagaFailure('$e'));
    }
  }

  //Master Lokasi Muat
  Future<void> masterLokasiMuat(String port) async {
    log.i('Fetching Master Lokasi Muat Data for port: $port');

    try {
      emit(MasterLokasiMuatInProgress());

      final List<MasterLokasiAccesses> response =
          await sl<MasterLokasiMuatService>().getMasterLokasiMuat(port);

      emit(MasterLokasiMuatSuccess(response: response));
    } catch (e) {
      log.e('Error fetching Master Lokasi Muat data: $e');
      emit(MasterLokasiMuatFailure('Error: $e'));
    }
  }

  //Master Lokasi Bongkar
  Future<void> masterLokasiBongkar(String port) async {
    log.i('Fetching Master Lokasi Bongkar Data for port: $port');

    try {
      emit(MasterLokasiBongkarInProgress());

      final List<MasterLokasiBongkarAccesses> response =
          await sl<MasterLokasiBongkarService>().getMasterLokasiBongkar(port);

      emit(MasterLokasiBongkarSuccess(response: response));
    } catch (e) {
      log.e('Error fetching Master Lokasi Bongkar data: $e');
      emit(MasterLokasiBongkarFailure('Error: $e'));
    }
  }

  //Log Alamat Muat LCL
  Future<void> logAlamatMuatLCL(String portCode) async {
    log.i('logAlamatMuatLCL');
    try {
      emit(LogNiagaInProgress()); 

      final LogNiagaAccesses response =
          await sl<LogNiagaService16>().logNiaga(portCode);

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }
}
