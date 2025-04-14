part of 'password_cubit.dart';

abstract class PasswordState {}

class PasswordInitial extends PasswordState {}

class ChangePasswordInProgress extends PasswordState {}

class ChangePasswordSuccess extends PasswordState {}

class ChangePasswordFailure extends PasswordState {
  final String error;
  ChangePasswordFailure(this.error);
}

class ChangePasswordIncorrectPassword extends PasswordState {}

//Forgot Password
class ForgotPasswordInProgress extends PasswordState {}

class ForgotPasswordSuccess extends PasswordState {}

class ForgotPasswordFailure extends PasswordState {
  final String error;
  ForgotPasswordFailure(this.error);
}
