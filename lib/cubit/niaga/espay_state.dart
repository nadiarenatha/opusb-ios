part of 'espay_cubit.dart';

abstract class EspayState extends Equatable {
  const EspayState();

  @override
  List<Object?> get props => [];
}

class EspayInitial extends EspayState {}

class EspayInProgress extends EspayState {}

class EspaySuccess extends EspayState {
  final EspayResponse espayResponse;

  const EspaySuccess(this.espayResponse);

  @override
  List<Object?> get props => [espayResponse];
}

class EspayFailure extends EspayState {
  final String error;

  const EspayFailure(this.error);

  @override
  List<Object?> get props => [error];
}

//Get Fee Espay
class FeeEspayInProgress extends EspayState {}

class FeeEspaySuccess extends EspayState {
  final List<FeeEspayAccesses> response;

  const FeeEspaySuccess({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

class FeeEspayFailure extends EspayState {
  final String error;

  const FeeEspayFailure(this.error);

  @override
  List<Object?> get props => [error];
}
