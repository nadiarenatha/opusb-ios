part of 'alamat_cubit.dart';

abstract class AlamatNiagaState extends Equatable {
  const AlamatNiagaState();

  @override
  List<Object> get props => [];
}

class AlamatNiagaInitial extends AlamatNiagaState {}

//Alamat Bongkar
class AlamatBongkarNiagaSuccess extends AlamatNiagaState {
  final List<AlamatBongkarAccesses> response;

  const AlamatBongkarNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        // response,
        response,
      ];
}

class AlamatBongkarNiagaInProgress extends AlamatNiagaState {}

class AlamatBongkarNiagaFailure extends AlamatNiagaState {
  final String message;

  const AlamatBongkarNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Alamat Muat FCL
class AlamatMuatNiagaSuccess extends AlamatNiagaState {
  final List<AlamatAccesses> response;

  const AlamatMuatNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class AlamatMuatNiagaInProgress extends AlamatNiagaState {}

class AlamatMuatNiagaFailure extends AlamatNiagaState {
  final String message;

  const AlamatMuatNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Alamat Muat LCL
class AlamatMuatLCLNiagaSuccess extends AlamatNiagaState {
  final List<AlamatMuatLCLAccesses> response;

  const AlamatMuatLCLNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class AlamatMuatLCLNiagaInProgress extends AlamatNiagaState {}

class AlamatMuatLCLNiagaFailure extends AlamatNiagaState {
  final String message;

  const AlamatMuatLCLNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Master Lokasi Muat
class MasterLokasiMuatInProgress extends AlamatNiagaState {}

class MasterLokasiMuatSuccess extends AlamatNiagaState {
  final List<MasterLokasiAccesses> response;

  const MasterLokasiMuatSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class MasterLokasiMuatFailure extends AlamatNiagaState {
  final String message;

  const MasterLokasiMuatFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Master Lokasi Bongkar
class MasterLokasiBongkarInProgress extends AlamatNiagaState {}

class MasterLokasiBongkarSuccess extends AlamatNiagaState {
  final List<MasterLokasiBongkarAccesses> response;

  const MasterLokasiBongkarSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class MasterLokasiBongkarFailure extends AlamatNiagaState {
  final String message;

  const MasterLokasiBongkarFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Log
class LogNiagaSuccess extends AlamatNiagaState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends AlamatNiagaState {}

class LogNiagaFailure extends AlamatNiagaState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}