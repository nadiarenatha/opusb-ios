part of 'kebijakan_privasi_cubit.dart';

abstract class KebijakanPrivasiState extends Equatable {
  const KebijakanPrivasiState();

  @override
  List<Object> get props => [];
}

class KebijakanPrivasiInitial extends KebijakanPrivasiState {}

class KebijakanPrivasiSuccess extends KebijakanPrivasiState {
  final List<KebijakanAccesses> response;

  const KebijakanPrivasiSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

class KebijakanPrivasiInProgress extends KebijakanPrivasiState {}

class KebijakanPrivasiFailure extends KebijakanPrivasiState {
  final String message;

  const KebijakanPrivasiFailure(this.message);

  @override
  List<Object> get props => [message];
}
