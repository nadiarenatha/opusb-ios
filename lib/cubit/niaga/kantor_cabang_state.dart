part of 'kantor_cabang_cubit.dart';

abstract class KantorCabangState extends Equatable {
  const KantorCabangState();

  @override
  List<Object?> get props => [];
}

class KantorCabangInitial extends KantorCabangState {}

class KantorCabangInProgress extends KantorCabangState {}

class KantorCabangSuccess extends KantorCabangState {
  final List<KantorCabangAccesses> response;

  const KantorCabangSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class KantorCabangFailure extends KantorCabangState {
  final String errorMessage;

  const KantorCabangFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

//Log
class LogNiagaSuccess extends KantorCabangState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends KantorCabangState {}

class LogNiagaFailure extends KantorCabangState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}