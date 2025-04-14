part of 'riwayat_pembayaran_cubit.dart';

abstract class RiwayatPembayaranState extends Equatable {
  const RiwayatPembayaranState();

  @override
  List<Object> get props => [];
}

class RiwayatPembayaranInitial extends RiwayatPembayaranState {}

class RiwayatPembayaranSuccess extends RiwayatPembayaranState {
  final List<RiwayatPembayaranAccesses> response;

  const RiwayatPembayaranSuccess({
    required this.response,
  });

  @override
  List<Object> get props => [
        response,
      ];
}

class RiwayatPembayaranInProgress extends RiwayatPembayaranState {}

class RiwayatPembayaranFailure extends RiwayatPembayaranState {
  final String message;

  const RiwayatPembayaranFailure(this.message);

  @override
  List<Object> get props => [message];
}
