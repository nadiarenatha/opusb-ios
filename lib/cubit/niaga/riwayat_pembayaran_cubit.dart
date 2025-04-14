import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/address.dart';
import '../../model/niaga/riwayat_pembayaran.dart';
import '../../services/niaga service/riwayat_pembayaran_service.dart';

part 'riwayat_pembayaran_state.dart';

class RiwayatPembayaranCubit extends Cubit<RiwayatPembayaranState> {
  final log = getLogger('RiwayatPembayaranCubit');

  RiwayatPembayaranCubit() : super(RiwayatPembayaranInitial());

  Future<dynamic> riwayatPembayaran() async {
    log.i('RiwayatPembayaranCubit');
    try {
      emit(RiwayatPembayaranInProgress());

      final List<RiwayatPembayaranAccesses> response =
          await sl<RiwayatPembayaranService>().getRiwayatPembayaran();

      emit(RiwayatPembayaranSuccess(response: response));
    } catch (e) {
      log.e('RiwayatPembayaranCubit error: $e');
      emit(RiwayatPembayaranFailure('$e'));
    }
  }
}
