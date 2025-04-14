import '../../../model/niaga/daftar-pesanan/ulasan.dart';

abstract class UlasanService {
  Future<UlasanAccesses> ulasanPesanan(
      int userId,
      String orderNumber,
      String email,
      int rating,
      String customerFeedback,
      String createdDate,
      String createdBy);
}
