part of 'hubungi_kami_cubit.dart';

abstract class HubungiKamiState extends Equatable {
  const HubungiKamiState();

  @override
  List<Object> get props => [];
}

class HubungiKamiInitial extends HubungiKamiState {}

class HubungiKamiSuccess extends HubungiKamiState {
  final List<HubungiKamiAccesses> response;

  const HubungiKamiSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response
      ];
}

class HubungiKamiInProgress extends HubungiKamiState {}

class HubungiKamiFailure extends HubungiKamiState {
  final String message;

  const HubungiKamiFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Log
class LogNiagaSuccess extends HubungiKamiState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends HubungiKamiState {}

class LogNiagaFailure extends HubungiKamiState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}