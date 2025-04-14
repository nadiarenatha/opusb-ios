part of 'popular_destination_cubit.dart';

abstract class PopularDestinationState extends Equatable {
  const PopularDestinationState();

  @override
  List<Object> get props => [];
}

class PopularDestinationInitial extends PopularDestinationState {}

class PopularDestinationSuccess extends PopularDestinationState {
  final List<PopularDestinationAccesses> response;

  const PopularDestinationSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response
      ];
}

class PopularDestinationInProgress extends PopularDestinationState {}

class PopularDestinationFailure extends PopularDestinationState {
  final String message;

  const PopularDestinationFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Log
class LogNiagaSuccess extends PopularDestinationState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends PopularDestinationState {}

class LogNiagaFailure extends PopularDestinationState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}