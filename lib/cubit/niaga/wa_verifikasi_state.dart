part of 'wa_verifikasi_cubit.dart';

abstract class WAVerifikasiState extends Equatable {
  const WAVerifikasiState();

  @override
  List<Object?> get props => [];
}

class WAVerifikasiInitial extends WAVerifikasiState {}

class WAVerifikasiInProgress extends WAVerifikasiState {}

class WAVerifikasiFailure extends WAVerifikasiState {
  final String error;

  const WAVerifikasiFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class WAVerifikasiSuccess extends WAVerifikasiState {
  // final WAVerifikasiNiaga response;
  final String response;

  const WAVerifikasiSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class WAVerifikasiFlagUpdating extends WAVerifikasiState {}

class WAVerifikasiFlagUpdated extends WAVerifikasiState {}