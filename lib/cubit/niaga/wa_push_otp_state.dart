part of 'wa_push_otp_cubit.dart';

abstract class WAPushOTPState extends Equatable {
  const WAPushOTPState();

  @override
  List<Object?> get props => [];
}

class WAPushOTPInitial extends WAPushOTPState {}

class WAPushOTPInProgress extends WAPushOTPState {}

class WAPushOTPFailure extends WAPushOTPState {
  final String error;

  const WAPushOTPFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class WAPushOTPSuccess extends WAPushOTPState {
  final WAPushOTPNiaga response;

  const WAPushOTPSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}
