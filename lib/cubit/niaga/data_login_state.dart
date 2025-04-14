part of 'data_login_cubit.dart';

abstract class DataLoginState extends Equatable {
  const DataLoginState();

  @override
  List<Object> get props => [];
}

class DataLoginInitial extends DataLoginState {}

class DataLoginSuccess extends DataLoginState {
  // final List<DataLoginAccesses> response;
  final DataLoginAccesses response;

  const DataLoginSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response
      ];
}

class DataLoginInProgress extends DataLoginState {}

class DataLoginFailure extends DataLoginState {
  final String message;

  const DataLoginFailure(this.message);

  @override
  List<Object> get props => [message];
}

class DataLoginUpdatedSuccess extends DataLoginState {
  final DataLoginAccesses response;

  const DataLoginUpdatedSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class DataLoginRoleNotSupported extends DataLoginState {}
