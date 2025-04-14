import '../../model/niaga/riwayat_pembayaran.dart';

abstract class RiwayatPembayaranService {
  Future<List<RiwayatPembayaranAccesses>> getRiwayatPembayaran();
}
