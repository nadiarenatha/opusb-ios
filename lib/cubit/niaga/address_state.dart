part of 'address_cubit.dart';

abstract class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

class AddressInitial extends AddressState {}

class AddressSuccess extends AddressState {
  final List<AddressAccesses> response;

  const AddressSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class AddressInProgress extends AddressState {}

class AddressFailure extends AddressState {
  final String message;

  const AddressFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Add Address
class AddAddressSuccess extends AddressState {
  final AddressAccesses response;

  const AddAddressSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class AddAddressInProgress extends AddressState {}

class AddAddressFailure extends AddressState {
  final String message;

  const AddAddressFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Get Tipe Alamat
class TipeAlamatSuccess extends AddressState {
  final List<TipeAlamatAccesses> response;

  const TipeAlamatSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class TipeAlamatInProgress extends AddressState {}

class TipeAlamatFailure extends AddressState {
  final String message;

  const TipeAlamatFailure(this.message);

  @override
  List<Object> get props => [message];
}
