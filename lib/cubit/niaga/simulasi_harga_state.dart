part of 'simulasi_harga_cubit.dart';

abstract class SimulasiHargaState extends Equatable {
  const SimulasiHargaState();

  @override
  List<Object?> get props => [];
}

class SimulasiHargaInitial extends SimulasiHargaState {}

class SimulasiHargaInProgress extends SimulasiHargaState {}

class SimulasiHargaSuccess extends SimulasiHargaState {
  final List<SimulasiHargaAccesses> response;

  const SimulasiHargaSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class SimulasiHargaFailure extends SimulasiHargaState {
  final String errorMessage;

  const SimulasiHargaFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

//Log
class LogSimulasiHargaNiagaSuccess extends SimulasiHargaState {
  final LogNiagaAccesses response;

  const LogSimulasiHargaNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogSimulasiHargaNiagaInProgress extends SimulasiHargaState {}

class LogSimulasiHargaNiagaFailure extends SimulasiHargaState {
  final String message;

  const LogSimulasiHargaNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}