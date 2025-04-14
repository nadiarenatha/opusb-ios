part of 'contract_cubit.dart';

abstract class ContractNiagaState extends Equatable {
  const ContractNiagaState();

  @override
  List<Object> get props => [];
}

class ContractNiagaInitial extends ContractNiagaState {}

//Container Size
class ContainerSizeNiagaSuccess extends ContractNiagaState {
  final List<ContainerSizeAccesses> response;

  const ContainerSizeNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        // response,
        response,
      ];
}

class ContainerSizeNiagaInProgress extends ContractNiagaState {}

class ContainerSizeNiagaFailure extends ContractNiagaState {
  final String message;

  const ContainerSizeNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Contract FCL
class ContractNiagaSuccess extends ContractNiagaState {
  final List<ContractAccesses> response;

  const ContractNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        // response,
        response,
      ];
}

class ContractNiagaInProgress extends ContractNiagaState {}

class ContractNiagaFailure extends ContractNiagaState {
  final String message;

  const ContractNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Cek Contract FCL
class ContractFCLNiagaSuccess extends ContractNiagaState {
  final List<ContractAccesses> response;

  const ContractFCLNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        // response,
        response,
      ];
}

class ContractFCLNiagaInProgress extends ContractNiagaState {}

class ContractFCLNiagaFailure extends ContractNiagaState {
  final String errorMessage;

  const ContractFCLNiagaFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}


//Contract LCL
class ContractLCLNiagaSuccess extends ContractNiagaState {
  final List<ContractLCLAccesses> response;

  const ContractLCLNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        // response,
        response,
      ];
}

class ContractLCLNiagaInProgress extends ContractNiagaState {}

class ContractLCLNiagaFailure extends ContractNiagaState {
  final String errorMessage;

  const ContractLCLNiagaFailure(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}

//Cek Harga FCL
class CekHargaFCLNiagaSuccess extends ContractNiagaState {
  // final List<CekHargaFCLAccesses> response;
  final CekHargaFCLAccesses? response;

  const CekHargaFCLNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        // response,
        response ?? Object(),
      ];
}

class CekHargaFCLNiagaInProgress extends ContractNiagaState {}

class CekHargaFCLNiagaFailure extends ContractNiagaState {
  final String message;

  const CekHargaFCLNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Cek Harga LCL
class CekHargaLCLNiagaSuccess extends ContractNiagaState {
  final CekHargaLCLAccesses? response;

  const CekHargaLCLNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        // response,
        response ?? Object(),
      ];
}

class CekHargaLCLNiagaInProgress extends ContractNiagaState {}

class CekHargaLCLNiagaFailure extends ContractNiagaState {
  final String message;

  const CekHargaLCLNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//UOM
class UOMNiagaSuccess extends ContractNiagaState {
  final List<UOMAccesses> response;

  const UOMNiagaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        // response,
        response,
      ];
}

class UOMNiagaInProgress extends ContractNiagaState {}

class UOMNiagaFailure extends ContractNiagaState {
  final String message;

  const UOMNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Cek Poin
class CekPoinSuccess extends ContractNiagaState {
  final PoinAccesses? response;

  const CekPoinSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response ?? Object(),
      ];
}

class CekPoinInProgress extends ContractNiagaState {}

class CekPoinFailure extends ContractNiagaState {
  final String message;

  const CekPoinFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG CEK POIN
class LogNiagaSuccess extends ContractNiagaState {
  final LogNiagaAccesses response;

  const LogNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogNiagaInProgress extends ContractNiagaState {}

class LogNiagaFailure extends ContractNiagaState {
  final String message;

  const LogNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG CONTRACT FCL
class LogContractNiagaSuccess extends ContractNiagaState {
  final LogNiagaAccesses response;

  const LogContractNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogContractNiagaInProgress extends ContractNiagaState {}

class LogContractNiagaFailure extends ContractNiagaState {
  final String message;

  const LogContractNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG UOM
class LogUOMNiagaSuccess extends ContractNiagaState {
  final LogNiagaAccesses response;

  const LogUOMNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogUOMNiagaInProgress extends ContractNiagaState {}

class LogUOMNiagaFailure extends ContractNiagaState {
  final String message;

  const LogUOMNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG Cek Harga LCL
class LogCekHargaLCLNiagaSuccess extends ContractNiagaState {
  final LogNiagaAccesses response;

  const LogCekHargaLCLNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogCekHargaLCLNiagaInProgress extends ContractNiagaState {}

class LogCekHargaLCLNiagaFailure extends ContractNiagaState {
  final String message;

  const LogCekHargaLCLNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}

//LOG Cpntract LCL
class LogContractLCLNiagaSuccess extends ContractNiagaState {
  final LogNiagaAccesses response;

  const LogContractLCLNiagaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class LogContractLCLNiagaInProgress extends ContractNiagaState {}

class LogContractLCLNiagaFailure extends ContractNiagaState {
  final String message;

  const LogContractLCLNiagaFailure(this.message);

  @override
  List<Object> get props => [message];
}
