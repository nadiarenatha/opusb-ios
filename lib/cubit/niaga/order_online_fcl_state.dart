part of 'order_online_fcl_cubit.dart';

abstract class OrderOnlineFCLState extends Equatable {
  const OrderOnlineFCLState();

  @override
  List<Object?> get props => [];
}

class OrderOnlineFCLInitial extends OrderOnlineFCLState {}

class PortAsalFCLInProgress extends OrderOnlineFCLState {}

class PortAsalFCLSuccess extends OrderOnlineFCLState {
  final List<PortAsalFCLAccesses> response;

  const PortAsalFCLSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class PortAsalFCLFailure extends OrderOnlineFCLState {
  final String errorMessage;

  const PortAsalFCLFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PortAsalFCLSelected extends OrderOnlineFCLState {
  final String portAsal;

  const PortAsalFCLSelected({required this.portAsal});

  @override
  List<Object?> get props => [portAsal];
}

class PortTujuanFCLInProgress extends OrderOnlineFCLState {}

class PortTujuanFCLSuccess extends OrderOnlineFCLState {
  final List<PortTujuanFCLAccesses> response;

  const PortTujuanFCLSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class PortTujuanFCLFailure extends OrderOnlineFCLState {
  final String errorMessage;

  const PortTujuanFCLFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PortTujuanFCLSelected extends OrderOnlineFCLState {
  final String portTujuan;

  const PortTujuanFCLSelected({required this.portTujuan});

  @override
  List<Object?> get props => [portTujuan];
}

//LCL
class PortAsalLCLInProgress extends OrderOnlineFCLState {}

class PortAsalLCLSuccess extends OrderOnlineFCLState {
  final List<PortAsalFCLAccesses> response;

  const PortAsalLCLSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class PortAsalLCLFailure extends OrderOnlineFCLState {
  final String errorMessage;

  const PortAsalLCLFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

//LCL
class PortAsalLCLSelected extends OrderOnlineFCLState {
  final String portAsal;

  const PortAsalLCLSelected({required this.portAsal});

  @override
  List<Object?> get props => [portAsal];
}

//LCL
class PortTujuanLCLInProgress extends OrderOnlineFCLState {}

class PortTujuanLCLSuccess extends OrderOnlineFCLState {
  final List<PortTujuanFCLAccesses> response;

  const PortTujuanLCLSuccess({required this.response});

  @override
  List<Object?> get props => [response];
}

class PortTujuanLCLFailure extends OrderOnlineFCLState {
  final String errorMessage;

  const PortTujuanLCLFailure(this.errorMessage);

  @override
  List<Object?> get props => [errorMessage];
}

class PortTujuanLCLSelected extends OrderOnlineFCLState {
  final String portTujuan;

  const PortTujuanLCLSelected({required this.portTujuan});

  @override
  List<Object?> get props => [portTujuan];
}