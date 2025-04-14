import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/popular_destination.dart';
import '../../services/niaga service/popular_destination_service.dart';

part 'popular_destination_state.dart';

class PopularDestinationCubit extends Cubit<PopularDestinationState> {
  final log = getLogger('PopularDestinationCubit');

  PopularDestinationCubit() : super(PopularDestinationInitial());

  Future<dynamic> popularDestination() async {
    log.i('PopularDestinationCubit');
    try {
      emit(PopularDestinationInProgress());

      // Fetch the list of OpenInvoiceAccesses
      final List<PopularDestinationAccesses> response =
          await sl<PopularDestinationService>().getPopularDestination();

      emit(PopularDestinationSuccess(response: response));
    } catch (e) {
      log.e('PopularDestinationCubit error: $e');
      emit(PopularDestinationFailure('$e'));
    }
  }

  Future<void> logPopularDestinationNiaga() async {
    log.i('LogNiagaCubit');
    try {
      emit(LogNiagaInProgress()); 

      final LogNiagaAccesses response =
          await sl<LogNiagaService>().logNiaga();

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }
}
