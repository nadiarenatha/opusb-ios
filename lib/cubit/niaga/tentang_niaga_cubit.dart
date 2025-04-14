import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/tentang_niaga.dart';
import '../../services/niaga service/tentang-niaga/tentang_niaga_service.dart';

part 'tentang_niaga_state.dart';

class TentangNiagaCubit extends Cubit<TentangNiagaState> {
  final log = getLogger('TentangNiagaCubit');

  TentangNiagaCubit() : super(TentangNiagaInitial());

  Future<dynamic> tentangNiaga(bool active) async {
    log.i('TentangNiagaCubit');
    try {
      emit(TentangNiagaInProgress());

      final List<TentangNiagaAccesses> response =
          await sl<TentangNiagaService>().getTentangNiaga(active);

      emit(TentangNiagaSuccess(response: response));
    } catch (e) {
      log.e('TentangNiagaCubit error: $e');
      emit(TentangNiagaFailure('$e'));
    }
  }
}
