import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/alamat.dart';
import '../../model/niaga/alamat_bongkar.dart';
import '../../model/niaga/cek-harga/cek_harga_fcl.dart';
import '../../model/niaga/cek-harga/cek_harga_lcl.dart';
import '../../model/niaga/container_size.dart';
import '../../model/niaga/contract.dart';
import '../../model/niaga/contract_lcl.dart';
import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/poin.dart';
import '../../model/niaga/uom.dart';
import '../../services/niaga service/alamat_bongkar_service.dart';
import '../../services/niaga service/alamat_muat_service.dart';
import '../../services/niaga service/contract/cek_contract_fcl_service.dart';
import '../../services/niaga service/contract/cek_harga_fcl_service.dart';
import '../../services/niaga service/contract/cek_harga_lcl_service.dart';
import '../../services/niaga service/contract/container_size_service.dart';
import '../../services/niaga service/contract/contract_lcl_service.dart';
import '../../services/niaga service/contract/contract_service.dart';
import '../../services/niaga service/contract/poin_service.dart';
import '../../services/niaga service/contract/uom_service.dart';
import 'package:dio/dio.dart';

part 'contract_state.dart';

class ContractNiagaCubit extends Cubit<ContractNiagaState> {
  final log = getLogger('ContractNiagaCubit');

  ContractNiagaCubit() : super(ContractNiagaInitial());

  //Container Size
  Future<dynamic> containerSize() async {
    log.i('ContainerSizeNiagaCubit');
    log.i('Container Size');
    try {
      emit(ContainerSizeNiagaInProgress());

      final List<ContainerSizeAccesses> response =
          await sl<ContainerSizeService>().getContainerSize();

      emit(ContainerSizeNiagaSuccess(response: response));
      try {
        logContainerSize();
      } catch (e) {
        log.e('Error logContainerSize: $e');
      }
    } catch (e) {
      log.e('ContainerSizeNiagaCubit error: $e');
      emit(ContainerSizeNiagaFailure('$e'));
    }
  }

  //Contract FCL
  Future<dynamic> contract(String portAsal, String portTujuan, String uocAsal,
      String uocTujuan, int containerSize) async {
    log.i('ContractNiagaCubit(test) ');
    try {
      emit(ContractNiagaInProgress());

      final List<ContractAccesses> response = await sl<ContractService>()
          .getContract(portAsal, portTujuan, uocAsal, uocTujuan, containerSize);

      emit(ContractNiagaSuccess(response: response));
      try {
        logContractFCL(portAsal, portTujuan, uocAsal, uocTujuan, containerSize);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('ContractNiagaCubit error: $e');
      // emit(ContractNiagaFailure('$e'));
      emit(ContractNiagaFailure('Kontrak tidak tersedia!'));
    }
  }

  //Cek Contract FCL
  Future<dynamic> cekContractFCL(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan) async {
    log.i('ContractTESTFCLNiagaCubit');
    try {
      emit(ContractFCLNiagaInProgress());

      final List<ContractAccesses> response = await sl<ContractFCLService>()
          .getContractFCL(portAsal, portTujuan, uocAsal, uocTujuan);

      print('response: $response');

      if (response.isEmpty) {
        log.w('Received an empty response');
        emit(
            ContractFCLNiagaFailure('Maaf Area yang Anda Tuju Tidak Tercover'));
        return;
      }

      emit(ContractFCLNiagaSuccess(response: response));
      try {
        logCekContractFCL(portAsal, portTujuan, uocAsal, uocTujuan);
      } catch (e) {
        log.e('Error cek contract FCL: $e');
      }
    } catch (e) {
      log.e('ContractTESTFCLNiagaCubit error: $e');
      if (e is DioError && e.response?.statusCode == 404) {
        final responseData = e.response?.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          final message = responseData['message'] as String?;
          emit(ContractFCLNiagaFailure(message?.isNotEmpty == true
              ? message!
              : 'Maaf Area yang Anda Tuju Tidak Tercover.'));
        } else {
          emit(ContractFCLNiagaFailure('An unexpected error occurred.'));
        }
      } else {
        emit(
            ContractFCLNiagaFailure('Failed to fetch data. Please try again.'));
      }
    }
  }

  //Contract LCL
  Future<dynamic> contractLCL(
      String portAsal, String portTujuan, String uocTujuan) async {
    log.i('ContractLCLNiagaCubit');
    try {
      emit(ContractLCLNiagaInProgress());
      print('ContractLCLNiagaInProgress emitted');

      final List<ContractLCLAccesses> response = await sl<ContractLCLService>()
          .getContractLCL(portAsal, portTujuan, uocTujuan);

      print('response: $response');

      if (response.isEmpty) {
        log.w('Received an empty response');
        emit(
            ContractLCLNiagaFailure('Maaf Area yang Anda Tuju Tidak Tercover'));
        return;
      }

      emit(ContractLCLNiagaSuccess(response: response));
      try {
        logContractLCL(portAsal, portTujuan, uocTujuan);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('ContractNiagaCubit error: $e');
      // emit(ContractLCLNiagaFailure('An error occurred: $e'));
      if (e is DioError && e.response?.statusCode == 404) {
        final responseData = e.response?.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          final message = responseData['message'] as String?;
          // emit(SimulasiHargaFailure(message ?? 'An unexpected error occurred.'));
          emit(ContractLCLNiagaFailure(message?.isNotEmpty == true
              ? message!
              : 'Maaf Area yang Anda Tuju Tidak Tercover.'));
        } else {
          emit(ContractLCLNiagaFailure('An unexpected error occurred.'));
        }
      } else {
        emit(
            ContractLCLNiagaFailure('Failed to fetch data. Please try again.'));
      }
    }
  }

  //Cek Harga FCL
  Future<dynamic> cekHargaFCL(
      String noKontrak, int hargaKontrak, int qty) async {
    log.i('CekHargaFCLCubit ');
    try {
      emit(CekHargaFCLNiagaInProgress());

      final CekHargaFCLAccesses? response = await sl<CekHargaFCLService>()
          .getCekHargaFCL(noKontrak, hargaKontrak, qty);

      emit(CekHargaFCLNiagaSuccess(response: response));
      try {
        logCekHargaFCLNiaga(noKontrak, hargaKontrak, qty);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('CekHargaFCLCubit error: $e');
      emit(CekHargaFCLNiagaFailure('$e'));
      // emit(CekHargaFCLNiagaFailure('Kontrak LCL tidak tersedia!'));
    }
  }

  //Cek Harga LCL
  Future<dynamic> cekHargaLCL(
      String noKontrak, int hargaKontrak, double cbm) async {
    log.i('CekHargaLCLCubit ');
    try {
      emit(CekHargaLCLNiagaInProgress());

      final CekHargaLCLAccesses? response = await sl<CekHargaLCLService>()
          .getCekHargaLCL(noKontrak, hargaKontrak, cbm);

      emit(CekHargaLCLNiagaSuccess(response: response));
      try {
        logCekHargaLCLNiaga(noKontrak, hargaKontrak, cbm);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('CekHargaLCLCubit error: $e');
      emit(CekHargaLCLNiagaFailure('$e'));
    }
  }

  //UOM
  Future<dynamic> uomNiaga() async {
    log.i('uomNiagaCubit ');
    try {
      emit(UOMNiagaInProgress());

      final List<UOMAccesses> response = await sl<UOMService>().getUOM();

      emit(UOMNiagaSuccess(response: response));
      try {
        logUOMNiaga();
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('uomNiagaCubit error: $e');
      emit(UOMNiagaFailure('$e'));
    }
  }

  //Cek Poin
  Future<dynamic> cekPoin() async {
    log.i('CekPoinCubit ');
    try {
      emit(CekPoinInProgress());

      final PoinAccesses? response = await sl<PoinService>().getPoin();

      emit(CekPoinSuccess(response: response));
    } catch (e) {
      log.e('CekPoinCubit error: $e');
      emit(CekPoinFailure('$e'));
    }
  }

  //Log Cek Poin
  Future<void> logCekPoin() async {
    log.i('logCekPoin');
    try {
      emit(LogNiagaInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService8>().logNiaga();

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }

  //Log Container Size
  Future<void> logContainerSize() async {
    log.i('logContainerSize');
    try {
      emit(LogNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService14>().logNiaga();

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }

  //Log Contract FCL
  Future<void> logContractFCL(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan, int containerSize) async {
    log.i('logContractFCL');
    try {
      emit(LogContractNiagaInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService15>()
          .logNiaga(portAsal, portTujuan, uocAsal, uocTujuan, containerSize);

      emit(LogContractNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogContractNiagaFailure('$e'));
    }
  }

  //Log Cek Contract FCL
  Future<void> logCekContractFCL(String portAsal, String portTujuan,
      String uocAsal, String uocTujuan) async {
    log.i('logContractFCL');
    try {
      emit(LogContractNiagaInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService28>()
          .logNiaga(portAsal, portTujuan, uocAsal, uocTujuan);

      emit(LogContractNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogContractNiagaFailure('$e'));
    }
  }

  //LOG UOM
  Future<void> logUOMNiaga() async {
    log.i('LogUOMNiagaCubit');
    try {
      emit(LogUOMNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService17>().logNiaga();

      emit(LogUOMNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogUOMNiagaFailure('$e'));
    }
  }

  //LOG Cek Harga LCL
  Future<void> logCekHargaLCLNiaga(
      String noKontrak, int hargaKontrak, double cbm) async {
    log.i('LogCekHargaLCLNiagaCubit');
    try {
      emit(LogCekHargaLCLNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService18>().logNiaga(noKontrak, hargaKontrak, cbm);

      emit(LogCekHargaLCLNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogCekHargaLCLNiagaFailure('$e'));
    }
  }

  //LOG Cek Harga FCL
  Future<void> logCekHargaFCLNiaga(
      String noKontrak, int hargaKontrak, int qty) async {
    log.i('LogCekHargaLCLNiagaCubit');
    try {
      emit(LogCekHargaLCLNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService19>().logNiaga(noKontrak, hargaKontrak, qty);

      emit(LogCekHargaLCLNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogCekHargaLCLNiagaFailure('$e'));
    }
  }

  //Log Contract LCL
  Future<void> logContractLCL(
      String portAsal, String portTujuan, String uocTujuan) async {
    log.i('logContractLCL');
    try {
      emit(LogContractLCLNiagaInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService27>()
          .logNiaga(portAsal, portTujuan, uocTujuan);

      emit(LogContractLCLNiagaSuccess(response: response));
    } catch (e) {
      log.e('logContractLCL error: $e');
      emit(LogContractLCLNiagaFailure('$e'));
    }
  }
}
