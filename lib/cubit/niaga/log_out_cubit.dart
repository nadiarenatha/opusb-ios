import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import 'package:equatable/equatable.dart';

import '../../model/niaga/login_token_niaga.dart';
import '../../services/niaga service/log_out_service.dart';

part 'log_out_state.dart';

class LogOutCubit extends Cubit<LogOutState> {
  final log = getLogger('LogOutCubit');

  LogOutCubit() : super(LogOutInitial());

  Future<void> logOutApp() async {
    log.i('logOutApp');
    try {
      emit(LogOutInProgress());

      final logOutResponse = await sl<LogOutService>().logOut(
        LoginTokenNiaga(),
      );

      emit(LogOutSuccess(response: logOutResponse));

      log.i('Log Out sukses');
    } catch (e) {
      log.e('Log Out error: $e');
      emit(LogOutFailure('error: $e'));
    }
  }
}
