part of 'check_email_cubit.dart';

abstract class CheckEmailState extends Equatable {
  const CheckEmailState();

  @override
  List<Object> get props => [];
}

class CheckEmailInitial extends CheckEmailState {}

class CheckEmailSuccess extends CheckEmailState {
  final EmailAccountAccesses response;

  const CheckEmailSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

class CheckEmailInProgress extends CheckEmailState {}

class CheckEmailFailure extends CheckEmailState {
  final String message;

  const CheckEmailFailure(this.message);

  @override
  List<Object> get props => [message];
}
