import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/dashboard/kantor_cabang.dart';
import '../../model/niaga/log_niaga.dart';
import '../../services/niaga service/kantor_cabang_service.dart';

part 'kantor_cabang_state.dart';

class KantorCabangCubit extends Cubit<KantorCabangState> {
  final log = getLogger('KantorCabangCubit');

  KantorCabangCubit() : super(KantorCabangInitial());

  // Method to fetch simulasi harga data
  Future<void> kantorcabang() async {
    log.i('Fetching Kantor Cabang Data');
    try {
      emit(KantorCabangInProgress());

      // Fetch the list of KantorCabangAccesses
      final List<KantorCabangAccesses> response =
          await sl<KantorCabangService>().getKantorCabang(
      );

      emit(KantorCabangSuccess(response: response));
    } catch (e) {
      log.e('Error fetching kantor cabang data: $e');
      emit(KantorCabangFailure('Error: $e'));
    }
  }

  Future<void> logKantorCabang() async {
    log.i('logKantorCabang');
    try {
      emit(LogNiagaInProgress()); 

      final LogNiagaAccesses response =
          await sl<LogNiagaService2>().logNiaga();

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }
}
