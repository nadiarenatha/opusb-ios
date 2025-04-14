part of 'uoc_list_search_cubit.dart';

abstract class UOCListSearchState extends Equatable {
  const UOCListSearchState();

  @override
  List<Object> get props => [];
}

class UOCListSearchInitial extends UOCListSearchState {}

class UOCListSearchMuatSuccess extends UOCListSearchState {
  final List<UOCListSearchAccesses> response;

  const UOCListSearchMuatSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response
      ];
}

class UOCListSearchMuatInProgress extends UOCListSearchState {}

class UOCListSearchMuatFailure extends UOCListSearchState {
  final String message;

  const UOCListSearchMuatFailure(this.message);

  @override
  List<Object> get props => [message];
}

//Bongkar
class UOCListSearchBongkarSuccess extends UOCListSearchState {
  final List<UOCListSearchAccesses> response;

  const UOCListSearchBongkarSuccess({
    required this.response,
    //   required this.clientId,
  });

  @override
  List<Object> get props => [
        // response,
        response
      ];
}

class UOCListSearchBongkarInProgress extends UOCListSearchState {}

class UOCListSearchBongkarFailure extends UOCListSearchState {
  final String message;

  const UOCListSearchBongkarFailure(this.message);

  @override
  List<Object> get props => [message];
}

//UOC UNTUK CREATE ACCOUNT
class UOCCreateAccountSuccess extends UOCListSearchState {
  final List<UOCListSearchAccesses> response;

  const UOCCreateAccountSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [response];
}

class UOCCreateAccountInProgress extends UOCListSearchState {}

class UOCCreateAccountFailure extends UOCListSearchState {
  final String message;

  const UOCCreateAccountFailure(this.message);

  @override
  List<Object> get props => [message];
}
