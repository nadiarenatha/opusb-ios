part of 'invoice_detail_cubit.dart';

abstract class InvoiceDetailState extends Equatable {
  const InvoiceDetailState();

  @override
  List<Object> get props => [];
}

class InvoiceDetailInitial extends InvoiceDetailState {}

class InvoiceDetailSuccess extends InvoiceDetailState {
  final List<InvoiceDetailAccesses> response;

  const InvoiceDetailSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class InvoiceDetailsSuccess extends InvoiceDetailState {
  final List<InvoiceDetailAccesses> response;

  const InvoiceDetailsSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class InvoiceDetailInProgress extends InvoiceDetailState {}

class InvoiceDetailFailure extends InvoiceDetailState {
  final String message;

  const InvoiceDetailFailure(this.message);

  @override
  List<Object> get props => [message];
}
