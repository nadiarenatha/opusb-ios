import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/dashboard/hubungi_kami.dart';
import '../../model/niaga/log_niaga.dart';
import '../../services/niaga service/hubungi_kami_service.dart';

part 'hubungi_kami_state.dart';

class HubungiKamiCubit extends Cubit<HubungiKamiState> {
  final log = getLogger('HubungiKamiCubit');

  HubungiKamiCubit() : super(HubungiKamiInitial());

  Future<dynamic> hubungiKami() async {
    log.i('HubungiKamiCubit');
    try {
      emit(HubungiKamiInProgress());

      // Fetch the list of OpenInvoiceAccesses
      final List<HubungiKamiAccesses> response =
          await sl<HubungiKamiService>().getHubungiKami();

      emit(HubungiKamiSuccess(response: response));
    } catch (e) {
      log.e('HubungiKamiCubit error: $e');
      emit(HubungiKamiFailure('$e'));
    }
  }

  Future<void> logHubungiKamiNiaga() async {
    log.i('LogNiagaCubit');
    try {
      emit(LogNiagaInProgress()); 

      final LogNiagaAccesses response =
          await sl<LogNiagaService4>().logNiaga();

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }
}
