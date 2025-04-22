part of 'invoice_niaga_cubit.dart';

abstract class InvoiceNiagaState extends Equatable {
  const InvoiceNiagaState();

  @override
  List<Object> get props => [];
}

class OpenInvoiceInitial extends InvoiceNiagaState {}

class OpenInvoiceSuccess extends InvoiceNiagaState {
  final List<OpenInvoiceAccesses> response;
  final int totalPages;

  const OpenInvoiceSuccess({
    required this.response,
    required this.totalPages,
    //   required this.clientId,
  });

  @override
  // List<Object> get props => [response, totalPages];
  List<Object> get props => [response];
}

class OpenInvoiceInProgress extends InvoiceNiagaState {}

class OpenInvoiceFailure extends InvoiceNiagaState {
  final String message;

  const OpenInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

class CloseInvoiceSuccess extends InvoiceNiagaState {
  final List<OpenInvoiceAccesses> response;
  final int totalPages; // Add totalPages here

  const CloseInvoiceSuccess({
    required this.response,
    required this.totalPages, // Add totalPages here
  });

  @override
  List<Object> get props => [response, totalPages];
  // List<Object> get props => [response];
}

class CloseInvoiceInProgress extends InvoiceNiagaState {}

class CloseInvoiceFailure extends InvoiceNiagaState {
  final String message;

  const CloseInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

//DOWNLOAD PDF

class DownloadInvoiceSuccess extends InvoiceNiagaState {
  final String invoiceNumber;

  const DownloadInvoiceSuccess({
    required this.invoiceNumber,
  });

  @override
  List<Object> get props => [invoiceNumber];
}

class DownloadInvoiceInProgress extends InvoiceNiagaState {}

class DownloadInvoiceFailure extends InvoiceNiagaState {
  final String message;

  const DownloadInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Detail Invoice LCL
class DetailInvoiceLCLSuccess extends InvoiceNiagaState {
  final DetailInvoiceLCLAccesses response;

  const DetailInvoiceLCLSuccess({required this.response});

  @override
  List<Object> get props => [response];
  // List<Object> get props => [response];
}

class DetailInvoiceLCLInProgress extends InvoiceNiagaState {}

class DetailInvoiceLCLFailure extends InvoiceNiagaState {
  final String message;

  const DetailInvoiceLCLFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Detail Invoice FCL
class DetailInvoiceFCLSuccess extends InvoiceNiagaState {
  final DetailInvoiceFCLAccesses response;

  const DetailInvoiceFCLSuccess({required this.response});

  @override
  List<Object> get props => [response];
  // List<Object> get props => [response];
}

class DetailInvoiceFCLInProgress extends InvoiceNiagaState {}

class DetailInvoiceFCLFailure extends InvoiceNiagaState {
  final String message;

  const DetailInvoiceFCLFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Search Invoice
class SearchInvoiceSuccess extends InvoiceNiagaState {
  final List<OpenInvoiceAccesses> response;
  final int totalPages;

  const SearchInvoiceSuccess({
    required this.response,
    required this.totalPages,
  });

  @override
  List<Object> get props => [response];
}

class SearchInvoiceInProgress extends InvoiceNiagaState {}

class SearchInvoiceFailure extends InvoiceNiagaState {
  final String message;

  const SearchInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Invoice On Process
class InvoiceOnProcessSuccess extends InvoiceNiagaState {
  final List<OpenInvoiceAccesses> response;
  final int totalPages;

  const InvoiceOnProcessSuccess({
    required this.response,
    required this.totalPages,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [response];
}

class InvoiceOnProcessInProgress extends InvoiceNiagaState {}

class InvoiceOnProcessFailure extends InvoiceNiagaState {
  final String message;

  const InvoiceOnProcessFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG UNPAID INVOICE
class LogUnpaidNiagaSuccess extends InvoiceNiagaState {
  final LogNiagaAccesses response;

  const LogUnpaidNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogUnpaidNiagaInProgress extends InvoiceNiagaState {}

class LogUnpaidNiagaFailure extends InvoiceNiagaState {
  final String message;

  const LogUnpaidNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG PAID INVOICE
class LogPaidNiagaSuccess extends InvoiceNiagaState {
  final LogNiagaAccesses response;

  const LogPaidNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogPaidNiagaInProgress extends InvoiceNiagaState {}

class LogPaidNiagaFailure extends InvoiceNiagaState {
  final String message;

  const LogPaidNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG On Process INVOICE
class LogOnProcessNiagaSuccess extends InvoiceNiagaState {
  final LogNiagaAccesses response;

  const LogOnProcessNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogOnProcessNiagaInProgress extends InvoiceNiagaState {}

class LogOnProcessNiagaFailure extends InvoiceNiagaState {
  final String message;

  const LogOnProcessNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG Detail INVOICE LCL
class LogDetailInvoiceLCLSuccess extends InvoiceNiagaState {
  final LogNiagaAccesses response;

  const LogDetailInvoiceLCLSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogDetailInvoiceLCLInProgress extends InvoiceNiagaState {}

class LogDetailInvoiceLCLFailure extends InvoiceNiagaState {
  final String message;

  const LogDetailInvoiceLCLFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG Detail INVOICE FCL
class LogDetailInvoiceFCLSuccess extends InvoiceNiagaState {
  final LogNiagaAccesses response;

  const LogDetailInvoiceFCLSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogDetailInvoiceFCLInProgress extends InvoiceNiagaState {}

class LogDetailInvoiceFCLFailure extends InvoiceNiagaState {
  final String message;

  const LogDetailInvoiceFCLFailure(this.message);

  @override
  List<Object> get props => [message];
}

//get merchant code
class MerchantCodeSuccess extends InvoiceNiagaState {
  final List<MerchantCodeAccesses> response;

  const MerchantCodeSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class MerchantCodeInProgress extends InvoiceNiagaState {}

class MerchantCodeFailure extends InvoiceNiagaState {
  final String message;

  const MerchantCodeFailure(this.message);

  @override
  List<Object> get props => [message];
}
