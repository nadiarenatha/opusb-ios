part of 'packing_cubit.dart';

abstract class PackingState extends Equatable {
  const PackingState();

  @override
  List<Object> get props => [];
}

class PackingInitial extends PackingState {}

class PackingListSuccess extends PackingState {
  // final AuthResponse response;
  // * =========================
  // final List<IdNamePair> response;
  // final int clientId;
  final List<PackingListAccesses> response;

  const PackingListSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class PackingSuccess extends PackingState {
  final List<PackingListAccesses> response;

  const PackingSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class PackingInProgress extends PackingState {}

class PackingListFailure extends PackingState {
  final String message;

  const PackingListFailure(this.message);

  @override
  List<Object> get props => [message];
}
