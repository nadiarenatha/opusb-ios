import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../model/jadwal_kapal.dart';
import '../model/packing_list.dart';
import '../services/jadwal_kapal_service.dart';

part 'jadwal_kapal_state.dart';

class JadwalKapalCubit extends Cubit<JadwalKapalState> {
  final log = getLogger('JadwalKapalCubit');

  JadwalKapalCubit() : super(JadwalKapalInitial());

  Future<dynamic> jadwalKapal() async {
    log.i('jadwalkapal');
    try {
      emit(JadwalKapalInProgress());

      final List<JadwalKapalAccesses> response =
          await sl<JadwalKapalService>().getjadwalkapal(
              // LoginCredential(),
              );

      emit(JadwalKapalSuccess(response: response));
    } catch (e) {
      log.e('jadwalkapal error: $e');
      emit(JadwalKapalFailure('$e'));
    }
  }
}
