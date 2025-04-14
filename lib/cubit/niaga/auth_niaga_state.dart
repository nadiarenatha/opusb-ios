part of 'auth_niaga_cubit.dart';

abstract class AuthNiagaState extends Equatable {
  const AuthNiagaState();

  @override
  List<Object?> get props => [];
}

class AuthNiagaInitial extends AuthNiagaState {}

class AuthNiagaInProgress extends AuthNiagaState {}

class AuthNiagaFailure extends AuthNiagaState {
  final String error;

  const AuthNiagaFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class AuthNiagaAuthenticationSuccess extends AuthNiagaState {
  // final LoginCredentialNiaga response;
  final LoginTokenNiaga response;

  const AuthNiagaAuthenticationSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

//Refresh Token Niaga
class RefreshTokenNiagaInProgress extends AuthNiagaState {}

class RefreshTokenFailure extends AuthNiagaState {
  final String error;

  const RefreshTokenFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class RefreshTokenSuccess extends AuthNiagaState {
  // final LoginCredentialNiaga response;
  final RefreshTokenNiaga response;

  const RefreshTokenSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}