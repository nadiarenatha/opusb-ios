import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/otp/wa_push_otp.dart';
import '../../services/niaga service/otp/wa_push_otp_service.dart';

part 'wa_push_otp_state.dart';

class WAPushOTPCubit extends Cubit<WAPushOTPState> { 
  final log = getLogger('WAPushOTPCubit');

  WAPushOTPCubit() : super(WAPushOTPInitial());

  Future<void> waPushOtp(String no, String email) async {
    log.i('waPushOtp($no)');
    try {
      emit(WAPushOTPInProgress());

      final response = await sl<WAPushOTPService>().waPushOtp(
        WAPushOTPNiaga(no: no, email: email),
      );

      emit(WAPushOTPSuccess(response: response));
    } catch (e) {
      log.e('waPushOtp error: $e');
      emit(WAPushOTPFailure('$e'));
    }
  }
}
