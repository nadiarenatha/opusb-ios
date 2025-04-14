part of 'barang_dashboard_cubit.dart';

abstract class BarangDashboardState extends Equatable {
  const BarangDashboardState();

  @override
  List<Object> get props => [];
}

class BarangDashboardInitial extends BarangDashboardState {}

class BarangDashboardSuccess extends BarangDashboardState {
  final List<BarangDashboardAccesses> response;

  const BarangDashboardSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response
      ];
}

class BarangDashboardInProgress extends BarangDashboardState {}

class BarangDashboardFailure extends BarangDashboardState {
  final String message;

  const BarangDashboardFailure(this.message);

  @override
  List<Object> get props => [message];
}

//INVOICE
class InvoiceSummarySuccess extends BarangDashboardState {
  final InvoiceSummaryAccesses? response;

  const InvoiceSummarySuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        // response
        response ?? Object(),
      ];
}

class InvoiceSummaryInProgress extends BarangDashboardState {}

class InvoiceSummaryFailure extends BarangDashboardState {
  final String message;

  const InvoiceSummaryFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Log
class LogNiagaSuccess extends BarangDashboardState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends BarangDashboardState {}

class LogNiagaFailure extends BarangDashboardState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}