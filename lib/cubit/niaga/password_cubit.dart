import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/change_password.dart';
import '../../model/forgot_password.dart';
import '../../servicelocator.dart';
import '../../services/niaga service/password/change_password_service.dart';
import '../../services/niaga service/password/forgot_password_service.dart';
import '../../shared/widget/logger.dart';

part 'password_state.dart';

class PasswordCubit extends Cubit<PasswordState> {
  final log = getLogger('PasswordCubit');

  PasswordCubit() : super(PasswordInitial());

  Future<void> changePasswordProfil(
      String currentPassword, String newPassword) async {
    log.i('changePassword($currentPassword)');

    if (currentPassword.isEmpty || newPassword.isEmpty) {
      log.e('Current or new password cannot be empty');
      emit(ChangePasswordFailure('Current or new password cannot be empty'));
      return; // Early return to avoid executing further code
    }

    try {
      emit(ChangePasswordInProgress());

      // Create a ChangePassword model instance
      final credential = ChangePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      await sl<ChangePasswordService>().changePasswordNiaga(credential);

      // Emit success if the password change was successful
      emit(ChangePasswordSuccess());
    }
    // catch (e) {
    //   log.e('changePassword error: $e');
    //   emit(ChangePasswordFailure(e.toString()));
    // }
    catch (e) {
      final errorMessage = e is DioException && e.response != null
          ? e.response!.data['title'] ?? 'An unknown error occurred'
          : e.toString();

      log.e('changePassword error: $errorMessage');
      emit(ChangePasswordFailure(errorMessage));
    }
  }

  //Forgot Password
  Future<void> forgotPassword(String email) async {
    log.i('forgotPassword($email)');

    if (email.isEmpty) {
      log.e('Email cannot be empty');
      emit(ForgotPasswordFailure('Email cannot be empty'));
      return; // Early return to avoid executing further code
    }

    try {
      emit(ForgotPasswordInProgress());

      // Create a ChangePassword model instance
      final credential = ForgotPassword(
        email: email,
      );

      await sl<ForgotPasswordService>().forgotPasswordNiaga(credential);

      // Emit success if the password change was successful
      emit(ForgotPasswordSuccess());
    } catch (e) {
      if (e.toString().contains('Incorrect password')) {
        log.e('Incorrect password provided');
        emit(ForgotPasswordFailure('Incorrect password provided'));
      } else {
        log.e('changePassword error: $e');
        emit(ForgotPasswordFailure(e.toString()));
      }
    }
  }
}
