import '../../../model/niaga/cari-barang-profil/pencarian_barang.dart';
abstract class SearchPencarianBarangService {
  Future<List<PencarianBarangAccesses>> searchPencarianBarang(
      // {String? email, int? page, int? size}
      {int? page,
      String? noResi,
      String? penerima,
      // String? tanggalMasuk
      String? tglAwal,
      String? tglAkhir
      });
}
