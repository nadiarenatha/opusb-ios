part of 'register_cubit.dart';
//new

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object> get props => [];
}

class RegisterInitial extends RegisterState {}

class GenerateCaptchaSuccess extends RegisterState {
  // final RegisterGenerateCaptcha response;
  final GenerateValidateCaptcha response;

  const GenerateCaptchaSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [];
}

class ValidateCaptchaSuccess extends RegisterState {
  // final RegisterValidateCaptcha response;
  final GenerateValidateCaptcha response;

  const ValidateCaptchaSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class RegisteringAccountSuccess extends RegisterState {
  // final RegisterValidateCaptcha response;
  final RegisterCredential response;

  const RegisteringAccountSuccess({required this.response});

  @override
  List<Object> get props => [response];
}

class RegisterInProgress extends RegisterState {}

class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object> get props => [message];
}
