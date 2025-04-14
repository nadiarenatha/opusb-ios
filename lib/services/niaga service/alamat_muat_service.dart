import '../../model/niaga/alamat.dart';

abstract class AlamatMuatService {
  Future<List<AlamatAccesses>> getalamatMuat(String port, String kota);
}
