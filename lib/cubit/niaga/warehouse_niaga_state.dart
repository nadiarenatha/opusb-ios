part of 'warehouse_niaga_cubit.dart';

abstract class WarehouseNiagaState extends Equatable {
  const WarehouseNiagaState(); 

  @override
  List<Object> get props => [];
}

class WarehouseNiagaInitial extends WarehouseNiagaState {}

class WarehouseNiagaSuccess extends WarehouseNiagaState {
  final List<WarehouseNiagaAccesses> response;
  final int totalPages;

  const WarehouseNiagaSuccess({
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

class WarehouseNiagaInProgress extends WarehouseNiagaState {}

class WarehouseNiagaFailure extends WarehouseNiagaState {
  final String message;

  const WarehouseNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//DOWNLOAD PDF

class DownloadWarehouseSuccess extends WarehouseNiagaState {
  final String ownerCode;

  const DownloadWarehouseSuccess({
    required this.ownerCode,
  });

  @override
  List<Object> get props => [ownerCode];
}

class DownloadWarehouseInProgress extends WarehouseNiagaState {}

class DownloadWarehouseFailure extends WarehouseNiagaState {
  final String message;

  const DownloadWarehouseFailure(this.message);

  @override
  List<Object> get props => [message];
}

//DETAIL WAREHOUSE
class WarehouseDetailNiagaSuccess extends WarehouseNiagaState {
  // final List<BarangGudangAccesses> response;
  final List<BarangGudangDataAccesses> response;
  // final int totalPages;

  const WarehouseDetailNiagaSuccess({
    required this.response,
    // required this.totalPages,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response
        // , totalPages
      ];
}

class WarehouseDetailNiagaInProgress extends WarehouseNiagaState {}

class WarehouseDetailNiagaFailure extends WarehouseNiagaState {
  final String message;

  const WarehouseDetailNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//SEARCH
class SearchWarehouseNiagaSuccess extends WarehouseNiagaState {
  final List<WarehouseNiagaAccesses> response;
  final int totalPages;

  const SearchWarehouseNiagaSuccess({
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

class SearchWarehouseNiagaInProgress extends WarehouseNiagaState {}

class SearchWarehouseNiagaFailure extends WarehouseNiagaState {
  final String message;

  const SearchWarehouseNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Log
class LogNiagaSuccess extends WarehouseNiagaState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends WarehouseNiagaState {}

class LogNiagaFailure extends WarehouseNiagaState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG WAREHOUSE
class LogWarehouseNiagaSuccess extends WarehouseNiagaState {
  final LogNiagaAccesses response;

  const LogWarehouseNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogWarehouseNiagaInProgress extends WarehouseNiagaState {}

class LogWarehouseNiagaFailure extends WarehouseNiagaState {
  final String message;

  const LogWarehouseNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}