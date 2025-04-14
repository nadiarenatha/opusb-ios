import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../model/niaga/check-email/email_account.dart';
import '../services/niaga service/check-account/check_email_service.dart';

part 'check_email_state.dart';

class CheckEmailCubit extends Cubit<CheckEmailState> {
  final log = getLogger('CheckEmailCubit');

  CheckEmailCubit() : super(CheckEmailInitial());

  Future<dynamic> checkEmail(String email) async {
    log.i('CheckEmailCubit');
    try {
      emit(CheckEmailInProgress());

      final EmailAccountAccesses response =
          await sl<CheckEmailService>().checkEmail(email);

      emit(CheckEmailSuccess(response: response));
      log.i('CheckEmailCubit success: $response');
      return response;
    } catch (e) {
      log.e('CheckEmailCubit error: $e');
      emit(CheckEmailFailure('$e'));
      return null;
    }
  }
}
