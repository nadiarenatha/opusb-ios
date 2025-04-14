part of 'syarat_ketentuan_cubit.dart';

abstract class SyaratKetentuanState extends Equatable {
  const SyaratKetentuanState();

  @override
  List<Object> get props => [];
}

class SyaratKetentuanInitial extends SyaratKetentuanState {}

class SyaratKetentuanSuccess extends SyaratKetentuanState {
  final List<SyaratKetentuanAccesses> response;

  const SyaratKetentuanSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

class SyaratKetentuanInProgress extends SyaratKetentuanState {}

class SyaratKetentuanFailure extends SyaratKetentuanState {
  final String message;

  const SyaratKetentuanFailure(this.message);

  @override
  List<Object> get props => [message];
}
