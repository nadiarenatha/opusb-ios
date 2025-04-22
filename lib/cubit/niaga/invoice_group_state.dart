part of 'invoice_group_cubit.dart';

abstract class InvoiceGroupState extends Equatable {
  const InvoiceGroupState();

  @override
  List<Object> get props => [];
}

class InvoiceGroupInitial extends InvoiceGroupState {}

//Single Invoice
class SingleInvoiceSuccess extends InvoiceGroupState {
  final DetailInvoiceGroupAccess? response;

  const SingleInvoiceSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response ?? Object(),
      ];
}

class SingleInvoiceInProgress extends InvoiceGroupState {}

class SingleInvoiceFailure extends InvoiceGroupState {
  final String message;

  const SingleInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Multiple invoice
class MultipleInvoiceSuccess extends InvoiceGroupState {
  // final List<InvoiceGroupAccesses> response;
  final DetailInvoiceGroupAccess? response;

  const MultipleInvoiceSuccess({
    required this.response,
  });

  @override
  // List<Object> get props => [response];
  List<Object> get props => [
        response ?? Object(),
      ];
}

class MultipleInvoiceInProgress extends InvoiceGroupState {}

class MultipleInvoiceFailure extends InvoiceGroupState {
  final String message;

  const MultipleInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Delete Multiple Invoice
class DeleteInvoiceSuccess extends InvoiceGroupState {
  final DeleteInvoiceAccess? response;

  const DeleteInvoiceSuccess({
    required this.response,
  });

  @override
  // List<Object> get props => [response];
  List<Object> get props => [
        response ?? Object(),
      ];
}

class DeleteInvoiceInProgress extends InvoiceGroupState {}

class DeleteInvoiceFailure extends InvoiceGroupState {
  final String message;

  const DeleteInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Delete Single Invoice
class DeleteSingleInvoiceSuccess extends InvoiceGroupState {
  final DeleteInvoiceAccess? response;

  const DeleteSingleInvoiceSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response ?? Object(),
      ];
}

class DeleteSingleInvoiceInProgress extends InvoiceGroupState {}

class DeleteSingleInvoiceFailure extends InvoiceGroupState {
  final String message;

  const DeleteSingleInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Get Bank Code
class BankCodeSuccess extends InvoiceGroupState {
  final List<BankCodeAccesses> response;

  const BankCodeSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class BankCodeInProgress extends InvoiceGroupState {}

class BankCodeFailure extends InvoiceGroupState {
  final String message;

  const BankCodeFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Klik Bayar Sekarang
class BayarSekarangSuccess extends InvoiceGroupState {
  final DeleteInvoiceAccess? response;

  const BayarSekarangSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response ?? Object(),
      ];
}

class BayarSekarangInProgress extends InvoiceGroupState {}

class BayarSekarangFailure extends InvoiceGroupState {
  final String message;

  const BayarSekarangFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Get Detail Multiple Invoice
class DetailMultipleInvoiceSuccess extends InvoiceGroupState {
  final List<DetailEspayInvoiceGroupAccesses> response;

  const DetailMultipleInvoiceSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class DetailMultipleInvoiceInProgress extends InvoiceGroupState {}

class DetailMultipleInvoiceFailure extends InvoiceGroupState {
  final String message;

  const DetailMultipleInvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}

//get merchant code
class MerchantCodeGroupSuccess extends InvoiceGroupState {
  final List<MerchantCodeAccesses> response;

  const MerchantCodeGroupSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class MerchantCodeGroupInProgress extends InvoiceGroupState {}

class MerchantCodeGroupFailure extends InvoiceGroupState {
  final String message;

  const MerchantCodeGroupFailure(this.message);

  @override
  List<Object> get props => [message];
}
