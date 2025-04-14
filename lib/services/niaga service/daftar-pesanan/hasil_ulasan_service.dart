import '../../../model/niaga/daftar-pesanan/ulasan.dart';

abstract class HasilUlasanService {
  Future<List<UlasanAccesses>> hasilUlasanPesanan({String? orderNumber});
}
