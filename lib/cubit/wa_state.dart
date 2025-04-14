part of 'wa_cubit.dart';

abstract class WAState extends Equatable {
  const WAState();

  @override
  List<Object> get props => [];
}

class WAInitial extends WAState {}

class SendWhatsappSuccess extends WAState {
  @override
  List<Object> get props => [];
}

class SendWhatsappInProgress extends WAState {}

class SendWhatsappFailure extends WAState {
  final String message;

  const SendWhatsappFailure(this.message);

  @override
  List<Object> get props => [message];
}
