import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/model/tracking_detail.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/services/tracking_detail_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

part 'tracking_detail_state.dart';

class TrackingDetailCubit extends Cubit<TrackingDetailState> {
  final log = getLogger('TrackingDetailCubit');

  TrackingDetailCubit() : super(TrackingDetailInitial());

  // Future<dynamic> invoice() async {
  Future<void> fetchTrackingDetail({int? mePackingListId}) async {
    log.i('trackingdetail');
    try {
      emit(TrackingDetailInProgress());
      final List<TrackingDetailAccesses> response =
          await sl<TrackingDetailService>().gettrackingdetail(
              // LoginCredential(),
              mePackingListId: mePackingListId);

      emit(TrackingDetailSuccess(response: response));
    } catch (e) {
      log.e('tracking detail error: $e');
      // emit(InvoiceDetailFailure('$e'));
      emit(TrackingDetailFailure(e.toString()));
    }
  }
}
