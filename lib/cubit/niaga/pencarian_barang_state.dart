part of 'pencarian_barang_cubit.dart';

abstract class PencarianBarangState extends Equatable {
  const PencarianBarangState(); 

  @override
  List<Object> get props => [];
}

class PencarianBarangInitial extends PencarianBarangState {}

class PencarianBarangSuccess extends PencarianBarangState {
  final List<PencarianBarangAccesses> response;
  final int totalPages;

  const PencarianBarangSuccess({
    required this.response,
    required this.totalPages,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response, totalPages
      ];
}

class PencarianBarangInProgress extends PencarianBarangState {}

class PencarianBarangFailure extends PencarianBarangState {
  final String message;

  const PencarianBarangFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Detail Pencarian Barang
class DetailPencarianBarangSuccess extends PencarianBarangState {
  final List<DetailJenisBarangAccesses> response;
  final String noResi;

  const DetailPencarianBarangSuccess({
    required this.response,
    required this.noResi,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response, noResi
      ];
}

class DetailPencarianBarangInProgress extends PencarianBarangState {}

class DetailPencarianBarangFailure extends PencarianBarangState {
  final String message;

  const DetailPencarianBarangFailure(this.message);

  @override
  List<Object> get props => [message];
}

//SEARCH
class SearchPencarianBarangSuccess extends PencarianBarangState {
  final List<PencarianBarangAccesses> response;
  final int totalPages;

  const SearchPencarianBarangSuccess({
    required this.response,
    required this.totalPages,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response, totalPages
      ];
}

class SearchPencarianBarangInProgress extends PencarianBarangState {}

class SearchPencarianBarangFailure extends PencarianBarangState {
  final String message;

  const SearchPencarianBarangFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG PENCARIAN BARANG
class LogNiagaSuccess extends PencarianBarangState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends PencarianBarangState {}

class LogNiagaFailure extends PencarianBarangState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG DETAIL PENCARIAN BARANG
class LogDetailPencarianNiagaSuccess extends PencarianBarangState {
  final LogNiagaAccesses response;

  const LogDetailPencarianNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogDetailPencarianNiagaInProgress extends PencarianBarangState {}

class LogDetailPencarianNiagaFailure extends PencarianBarangState {
  final String message;

  const LogDetailPencarianNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}