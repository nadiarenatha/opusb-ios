part of 'packing_niaga_cubit.dart';

abstract class PackingNiagaState extends Equatable {
  const PackingNiagaState();

  @override
  List<Object?> get props => [];
}

class PackingNiagaInitial extends PackingNiagaState {}

class PackingNiagaCompleteInProgress extends PackingNiagaState {}

class PackingNiagaCompleteSuccess extends PackingNiagaState {
  final List<PackingNiagaAccesses> response;
  final int totalPages;

  const PackingNiagaCompleteSuccess(
      {required this.response, required this.totalPages});

  @override
  List<Object?> get props => [response, totalPages];
}

class PackingNiagaCompleteFailure extends PackingNiagaState {
  final String error;

  const PackingNiagaCompleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}

//uncomplete
class PackingNiagaUnCompleteInProgress extends PackingNiagaState {}

class PackingNiagaUnCompleteSuccess extends PackingNiagaState {
  final List<PackingNiagaAccesses> response;
  final int totalPages;

  const PackingNiagaUnCompleteSuccess(
      {required this.response, required this.totalPages});

  @override
  List<Object?> get props => [response, totalPages];
}

class PackingNiagaUnCompleteFailure extends PackingNiagaState {
  final String error;

  const PackingNiagaUnCompleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}

//DOWNLOAD PDF

class DownloadPackingSuccess extends PackingNiagaState {
  final String tipePL;

  const DownloadPackingSuccess({
    required this.tipePL,
  });

  @override
  List<Object> get props => [tipePL];
}

class DownloadPackingInProgress extends PackingNiagaState {}

class DownloadPackingFailure extends PackingNiagaState {
  final String message;

  const DownloadPackingFailure(this.message);

  @override
  List<Object> get props => [message];
}

//SEARCH COMPLETE
class SearchPackingCompleteInProgress extends PackingNiagaState {}

class SearchPackingCompleteSuccess extends PackingNiagaState {
  final List<PackingNiagaAccesses> response;
  final int totalPages;

  const SearchPackingCompleteSuccess(
      {required this.response, required this.totalPages});

  @override
  List<Object?> get props => [response, totalPages];
}

class SearchPackingCompleteFailure extends PackingNiagaState {
  final String error;

  const SearchPackingCompleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}

//SEARCH UNCOMPLETE
class SearchPackingUnCompleteInProgress extends PackingNiagaState {}

class SearchPackingUnCompleteSuccess extends PackingNiagaState {
  final List<PackingNiagaAccesses> response;
  final int totalPages;

  const SearchPackingUnCompleteSuccess(
      {required this.response, required this.totalPages});

  @override
  List<Object?> get props => [response, totalPages];
}

class SearchPackingUnCompleteFailure extends PackingNiagaState {
  final String error;

  const SearchPackingUnCompleteFailure(this.error);

  @override
  List<Object?> get props => [error];
}

//LOG Complete Packing
class LogCompletePackingSuccess extends PackingNiagaState {
  final LogNiagaAccesses response;

  const LogCompletePackingSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogCompletePackingInProgress extends PackingNiagaState {}

class LogCompletePackingFailure extends PackingNiagaState {
  final String message;

  const LogCompletePackingFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG UnComplete Packing
class LogUnCompletePackingSuccess extends PackingNiagaState {
  final LogNiagaAccesses response;

  const LogUnCompletePackingSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogUnCompletePackingInProgress extends PackingNiagaState {}

class LogUnCompletePackingFailure extends PackingNiagaState {
  final String message;

  const LogUnCompletePackingFailure(this.message);

  @override
  List<Object> get props => [message];
}
