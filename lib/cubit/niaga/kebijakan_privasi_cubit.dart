import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/kebijakan.dart';
import '../../services/niaga service/kebijakan-privasi/kebijakan_service.dart';

part 'kebijakan_privasi_state.dart';

class KebijakanPrivasiCubit extends Cubit<KebijakanPrivasiState> {
  final log = getLogger('KebijakanPrivasiCubit');

  KebijakanPrivasiCubit() : super(KebijakanPrivasiInitial());

  Future<dynamic> kebijakanPrivasi(bool active) async {
    log.i('KebijakanPrivasiCubit');
    try {
      emit(KebijakanPrivasiInProgress());

      final List<KebijakanAccesses> response =
          await sl<KebijakanPrivasiService>().getKebijakan(active);

      emit(KebijakanPrivasiSuccess(response: response));
    } catch (e) {
      log.e('KebijakanPrivasiCubit error: $e');
      emit(KebijakanPrivasiFailure('$e'));
    }
  }
}
