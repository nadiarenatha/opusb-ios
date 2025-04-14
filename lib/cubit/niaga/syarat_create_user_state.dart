part of 'syarat_create_user_cubit.dart';

abstract class SyaratCreateUserState extends Equatable {
  const SyaratCreateUserState();

  @override
  List<Object> get props => [];
}

class SyaratCreateUserInitial extends SyaratCreateUserState {}

class SyaratCreateUserSuccess extends SyaratCreateUserState {
  final List<SyaratCreateUserAccesses> response;

  const SyaratCreateUserSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

class SyaratCreateUserInProgress extends SyaratCreateUserState {}

class SyaratCreateUserFailure extends SyaratCreateUserState {
  final String message;

  const SyaratCreateUserFailure(this.message);

  @override
  List<Object> get props => [message];
}
