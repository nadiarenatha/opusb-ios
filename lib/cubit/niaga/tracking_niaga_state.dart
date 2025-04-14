part of 'tracking_niaga_cubit.dart';

abstract class TrackingNiagaState extends Equatable {
  const TrackingNiagaState();

  @override
  List<Object> get props => [];
}

class TrackingNiagaInitial extends TrackingNiagaState {}

// PTP COSD
class TrackingPTPCOSDSuccess extends TrackingNiagaState {
  final List<TrackingPtpCosdAccesses> response;

  const TrackingPTPCOSDSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingPTPCOSDInProgress extends TrackingNiagaState {}

class TrackingPTPCOSDFailure extends TrackingNiagaState {
  final String message;

  const TrackingPTPCOSDFailure(this.message);

  @override
  List<Object> get props => [message];
}

// DTD COSL
class TrackingDTDCOSLSuccess extends TrackingNiagaState {
  final List<TrackingDtdCoslAccesses> response;

  const TrackingDTDCOSLSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingDTDCOSLInProgress extends TrackingNiagaState {}

class TrackingDTDCOSLFailure extends TrackingNiagaState {
  final String message;

  const TrackingDTDCOSLFailure(this.message);

  @override
  List<Object> get props => [message];
}

// DTP COSL
class TrackingDTPCOSLSuccess extends TrackingNiagaState {
  final List<TrackingDtpCoslAccesses> response;

  const TrackingDTPCOSLSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingDTPCOSLInProgress extends TrackingNiagaState {}

class TrackingDTPCOSLFailure extends TrackingNiagaState {
  final String message;

  const TrackingDTPCOSLFailure(this.message);

  @override
  List<Object> get props => [message];
}

// PTD COSD
class TrackingPTDCOSDSuccess extends TrackingNiagaState {
  final List<TrackingPtdCosdAccesses> response;

  const TrackingPTDCOSDSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingPTDCOSDInProgress extends TrackingNiagaState {}

class TrackingPTDCOSDFailure extends TrackingNiagaState {
  final String message;

  const TrackingPTDCOSDFailure(this.message);

  @override
  List<Object> get props => [message];
}

// PTD COSL
class TrackingPTDCOSLSuccess extends TrackingNiagaState {
  final List<TrackingPtdCoslAccesses> response;

  const TrackingPTDCOSLSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingPTDCOSLInProgress extends TrackingNiagaState {}

class TrackingPTDCOSLFailure extends TrackingNiagaState {
  final String message;

  const TrackingPTDCOSLFailure(this.message);

  @override
  List<Object> get props => [message];
}

// PTP COSL
class TrackingPTPCOSLSuccess extends TrackingNiagaState {
  final List<TrackingPtpCoslAccesses> response;

  const TrackingPTPCOSLSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingPTPCOSLInProgress extends TrackingNiagaState {}

class TrackingPTPCOSLFailure extends TrackingNiagaState {
  final String message;

  const TrackingPTPCOSLFailure(this.message);

  @override
  List<Object> get props => [message];
}

//ASTRA MOTOR
class TrackingAstraMotorSuccess extends TrackingNiagaState {
  final List<TrackingAstraAccesses> response;

  const TrackingAstraMotorSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingAstraMotorInProgress extends TrackingNiagaState {}

class TrackingAstraMotorFailure extends TrackingNiagaState {
  final String message;

  const TrackingAstraMotorFailure(this.message);

  @override
  List<Object> get props => [message];
}

//PENCARIAN TRACKING
class TrackingPencarianBarangSuccess extends TrackingNiagaState {
  final String? keterangan;
  final String? noPl;
  final HeaderTrackingAccesses response;

  const TrackingPencarianBarangSuccess({
    required this.keterangan,
    required this.noPl,
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingPencarianBarangInProgress extends TrackingNiagaState {}

class TrackingPencarianBarangFailure extends TrackingNiagaState {
  final String message;

  const TrackingPencarianBarangFailure(this.message);

  @override
  List<Object> get props => [message];
}