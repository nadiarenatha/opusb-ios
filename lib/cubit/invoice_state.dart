part of 'invoice_cubit.dart';

abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object> get props => [];
}

class InvoiceInitial extends InvoiceState {}

class InvoiceSuccess extends InvoiceState {
  final List<InvoiceAccesses> response;

  const InvoiceSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
      ];
}

class InvoicesSuccess extends InvoiceState {
  final List<InvoiceAccesses> response;

  const InvoicesSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class InvoiceInProgress extends InvoiceState {}

class InvoiceFailure extends InvoiceState {
  final String message;

  const InvoiceFailure(this.message);

  @override
  List<Object> get props => [message];
}
