part of 'log_out_cubit.dart';

abstract class LogOutState extends Equatable {
  const LogOutState();

  @override
  List<Object> get props => [];
}

class LogOutInitial extends LogOutState {}

class LogOutSuccess extends LogOutState {
  final LoginTokenNiaga response;

  const LogOutSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogOutInProgress extends LogOutState {}

class LogOutFailure extends LogOutState {
  final String message;

  const LogOutFailure(this.message);

  @override
  List<Object> get props => [message];
}
