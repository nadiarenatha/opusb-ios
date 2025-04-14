part of 'tracking_detail_cubit.dart';

abstract class TrackingDetailState extends Equatable {
  const TrackingDetailState();

  @override
  List<Object> get props => [];
}

class TrackingDetailInitial extends TrackingDetailState {}

class TrackingDetailSuccess extends TrackingDetailState {
  final List<TrackingDetailAccesses> response;

  const TrackingDetailSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class TrackingDetailsSuccess extends TrackingDetailState {
  final List<TrackingDetailAccesses> response;

  const TrackingDetailsSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class TrackingDetailInProgress extends TrackingDetailState {}

class TrackingDetailFailure extends TrackingDetailState {
  final String message;

  const TrackingDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
