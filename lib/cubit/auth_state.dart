part of 'auth_cubit.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  //LIST ROLE
  // @override
  // List<Object> get props => [];
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthAuthenticationSuccess extends AuthState {
  // final AuthResponse response;
  // * =========================
  // final List<IdNamePair> response;
  // final int clientId;
  //get list role
  // final LoginAccount response;

  // const AuthAuthenticationSuccess({
  //   required this.response,
  //   //   required this.clientId,
  // });

  // @override
  // List<Object> get props => [
  //       // response,
  //     ];
  //NEW AUTH
  final String? token;

  const AuthAuthenticationSuccess({required this.token});

  @override
  List<Object?> get props => [token];
}

// class AuthCheckOTPSuccess extends AuthState {
//   final DataUser dataUserLogin;
//   const AuthCheckOTPSuccess({required this.dataUserLogin});
//   @override
//   List<Object> get props => [dataUserLogin];
// }

class AuthAuthorizationSuccess extends AuthState {
  final AuthResponse response;

  const AuthAuthorizationSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

// class AuthAutoLoginSuccess extends AuthState {}

// class AuthAutoLoginDasboardSuccess extends AuthState {}

// class AuthAuthenticationFailure extends AuthState {}

// class AuthAuthenticationOtpOngoingFailure extends AuthState {}

// class AuthAuthorizationFailure extends AuthState {}

class AuthInProgress extends AuthState {}

// class AuthHostNotSetFailure extends AuthState {}

// class AuthLogoutSuccess extends AuthState {}

class AuthFailure extends AuthState {
  final String message;

  const AuthFailure(this.message);

  @override
  List<Object> get props => [message];
}

// class AuthAuthorizationDataLoaded extends AuthState {
//   final int clientId;
//   final int roleId;
//   final int orgId;
//   final List<IdNamePair> roles;
//   final List<IdNamePair> orgs;

//   const AuthAuthorizationDataLoaded({
//     required this.clientId,
//     this.roleId = 0,
//     this.roles = const [],
//     this.orgId = 0,
//     this.orgs = const [],
//   });

//   @override
//   List<Object> get props => [clientId, roleId, roles, orgId, orgs];
// }

// class AuthMinVersionFailure extends AuthState {
//   final String message;

//   const AuthMinVersionFailure({required this.message});

//   @override
//   List<Object> get props => [message];
// }

// // * ===================================================

// class AuthResendOtpInProgress extends AuthState {}

// class AuthResendOtpSuccess extends AuthState {
//   final bool response;

//   const AuthResendOtpSuccess({required this.response});

//   @override
//   List<Object> get props => [response];
// }

// class AuthResendOtpFailure extends AuthState {
//   final String message;

//   const AuthResendOtpFailure(this.message);

//   @override
//   List<Object> get props => [message];
// }
