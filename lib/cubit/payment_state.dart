part of 'payment_cubit.dart';

abstract class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object> get props => [];
}

class PaymentInitial extends PaymentState {}

class PaymentSuccess extends PaymentState {
  @override
  List<Object> get props => [];
}

class AuthAuthorizationSuccess extends PaymentState {
  final AuthResponse response;

  const AuthAuthorizationSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class PaymentInProgress extends PaymentState {}

class PaymentFailure extends PaymentState {
  final String message;

  const PaymentFailure(this.message);

  @override
  List<Object> get props => [message];
}
