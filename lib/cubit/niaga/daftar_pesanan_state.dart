part of 'daftar_pesanan_cubit.dart';

abstract class DaftarPesananState extends Equatable {
  const DaftarPesananState();

  @override
  List<Object> get props => [];
}

class DaftarPesananInitial extends DaftarPesananState {}

//On Progress
class DaftarPesananSuccess extends DaftarPesananState {
  final List<DataPesananAccesses> response;
  final int totalPages;

  const DaftarPesananSuccess({
    required this.response,
    required this.totalPages,
  });

  @override
  List<Object> get props => [response];
}

class DaftarPesananInProgress extends DaftarPesananState {}

class DaftarPesananFailure extends DaftarPesananState {
  final String message;

  const DaftarPesananFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Completed
class DaftarPesananCompletedSuccess extends DaftarPesananState {
  final List<DataPesananAccesses> response;
  final int totalPages;

  const DaftarPesananCompletedSuccess({
    required this.response,
    required this.totalPages,
  });

  @override
  List<Object> get props => [response];
}

class DaftarPesananCompletedInProgress extends DaftarPesananState {}

class DaftarPesananCompletedFailure extends DaftarPesananState {
  final String message;

  const DaftarPesananCompletedFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Cancel
class DaftarPesananCancelSuccess extends DaftarPesananState {
  final List<DataPesananAccesses> response;
  final int totalPages;

  const DaftarPesananCancelSuccess({
    required this.response,
    required this.totalPages,
  });

  @override
  List<Object> get props => [response];
}

class DaftarPesananCancelInProgress extends DaftarPesananState {}

class DaftarPesananCancelFailure extends DaftarPesananState {
  final String message;

  const DaftarPesananCancelFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Search On Progress
class SearchPesananSuccess extends DaftarPesananState {
  final List<DataPesananAccesses> response;
  final int totalPages;

  const SearchPesananSuccess({
    required this.response,
    required this.totalPages,
  });

  @override
  List<Object> get props => [response];
}

class SearchPesananInProgress extends DaftarPesananState {}

class SearchPesananFailure extends DaftarPesananState {
  final String message;

  const SearchPesananFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Search Completed
class SearchPesananCompletedSuccess extends DaftarPesananState {
  final List<DataPesananAccesses> response;
  final int totalPages;

  const SearchPesananCompletedSuccess({
    required this.response,
    required this.totalPages,
  });

  @override
  List<Object> get props => [response];
}

class SearchPesananCompletedInProgress extends DaftarPesananState {}

class SearchPesananCompletedFailure extends DaftarPesananState {
  final String message;

  const SearchPesananCompletedFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Search Cancel
class SearchPesananCancelSuccess extends DaftarPesananState {
  final List<DataPesananAccesses> response;
  final int totalPages;

  const SearchPesananCancelSuccess({
    required this.response,
    required this.totalPages,
  });

  @override
  List<Object> get props => [response];
}

class SearchPesananCancelInProgress extends DaftarPesananState {}

class SearchPesananCancelFailure extends DaftarPesananState {
  final String message;

  const SearchPesananCancelFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Ulasan
class AddUlasanSuccess extends DaftarPesananState {
  final UlasanAccesses response;

  const AddUlasanSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class AddUlasanInProgress extends DaftarPesananState {}

class AddUlasanFailure extends DaftarPesananState {
  final String message;

  const AddUlasanFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Detail Line
class DetailLinePesananSuccess extends DaftarPesananState {
  final List<DetailLineAccesses> response;

  const DetailLinePesananSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [];
}

class DetailLinePesananInProgress extends DaftarPesananState {}

class DetailLinePesananFailure extends DaftarPesananState {
  final String message;

  const DetailLinePesananFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Detail Header
class DetaiHeaderPesananSuccess extends DaftarPesananState {
  final List<DetailHeaderAccesses> response;

  const DetaiHeaderPesananSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [];
}

class DetaiHeaderPesananInProgress extends DaftarPesananState {}

class DetaiHeaderPesananFailure extends DaftarPesananState {
  final String message;

  const DetaiHeaderPesananFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Get Ulasan
class GetUlasanSuccess extends DaftarPesananState {
  final List<UlasanAccesses> response;

  const GetUlasanSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class GetUlasanInProgress extends DaftarPesananState {}

class GetUlasanFailure extends DaftarPesananState {
  final String message;

  const GetUlasanFailure(this.message);

  @override
  List<Object> get props => [message];
}
