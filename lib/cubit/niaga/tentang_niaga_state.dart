part of 'tentang_niaga_cubit.dart';

abstract class TentangNiagaState extends Equatable {
  const TentangNiagaState();

  @override
  List<Object> get props => [];
}

class TentangNiagaInitial extends TentangNiagaState {}

class TentangNiagaSuccess extends TentangNiagaState {
  final List<TentangNiagaAccesses> response;

  const TentangNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

class TentangNiagaInProgress extends TentangNiagaState {}

class TentangNiagaFailure extends TentangNiagaState {
  final String message;

  const TentangNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}
