part of 'jadwal_kapal_cubit.dart';

abstract class JadwalKapalState extends Equatable {
  const JadwalKapalState();

  @override
  List<Object> get props => [];
}

class JadwalKapalInitial extends JadwalKapalState {}

class JadwalKapalSuccess extends JadwalKapalState {
  // final AuthResponse response;
  // * =========================
  // final List<IdNamePair> response;
  // final int clientId;
  final List<JadwalKapalAccesses> response;

  const JadwalKapalSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class JadwalSuccess extends JadwalKapalState {
  final List<PackingListAccesses> response;

  const JadwalSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class JadwalKapalInProgress extends JadwalKapalState {}

class JadwalKapalFailure extends JadwalKapalState {
  final String message;

  const JadwalKapalFailure(this.message);

  @override
  List<Object> get props => [message];
}
