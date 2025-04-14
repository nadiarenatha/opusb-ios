part of 'jadwal_kapal_cubit.dart';

abstract class JadwalKapalNiagaState extends Equatable {
  const JadwalKapalNiagaState();

  @override
  List<Object?> get props => [];
}

class JadwalKapalNiagaInitial extends JadwalKapalNiagaState {}

class JadwalKapalNiagaInProgress extends JadwalKapalNiagaState {}

class JadwalKapalNiagaSuccess extends JadwalKapalNiagaState {
  final List<JadwalKapalNiagaAccesses> response;

  const JadwalKapalNiagaSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class JadwalKapalNiagaFailure extends JadwalKapalNiagaState {
  final String errorMessage;

  const JadwalKapalNiagaFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class DownloadImageKapalInProgress extends JadwalKapalNiagaState {}

class DownloadImageKapalSuccess extends JadwalKapalNiagaState {}

class DownloadImageKapalFailure extends JadwalKapalNiagaState {
  final String error;

  DownloadImageKapalFailure(this.error);
}

//Log
class LogNiagaSuccess extends JadwalKapalNiagaState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends JadwalKapalNiagaState {}

class LogNiagaFailure extends JadwalKapalNiagaState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}