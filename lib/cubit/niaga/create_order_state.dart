part of 'create_order_cubit.dart';

abstract class CreateOrderState extends Equatable {
  const CreateOrderState();

  @override
  List<Object> get props => [];
}

class CreateOrderInitial extends CreateOrderState {}

//Create Order FCL
class CreateOrderFCLSuccess extends CreateOrderState {
  final OrderAccesses response;

  const CreateOrderFCLSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class CreateOrderFCLInProgress extends CreateOrderState {}

class CreateOrderFCLFailure extends CreateOrderState {
  final String message;

  const CreateOrderFCLFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Create Order LCL
class CreateOrderLCLSuccess extends CreateOrderState {
  final OrderAccesses response;

  const CreateOrderLCLSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class CreateOrderLCLInProgress extends CreateOrderState {}

class CreateOrderLCLFailure extends CreateOrderState {
  final String message;

  const CreateOrderLCLFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Push Order FCL LCL
class PushOrderSuccess extends CreateOrderState {
  final List<PushOrderAccesses> response;

  const PushOrderSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class PushOrderInProgress extends CreateOrderState {}

class PushOrderFailure extends CreateOrderState {
  final String message;

  const PushOrderFailure(this.message);

  @override
  List<Object> get props => [message];
}
