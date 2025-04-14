part of 'id_account_cubit.dart';

abstract class IdAccountState extends Equatable {
  const IdAccountState();

  @override
  List<Object> get props => [];
}

class IdAccountInitial extends IdAccountState {}

class IdAccountSuccess extends IdAccountState {
  final List<IdAccountAccesses> response;

  const IdAccountSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response
      ];
}

class IdAccountInProgress extends IdAccountState {}

class IdAccountFailure extends IdAccountState {
  final String message;

  const IdAccountFailure(this.message);

  @override
  List<Object> get props => [message];
}