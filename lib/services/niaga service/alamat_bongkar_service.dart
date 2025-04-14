import '../../model/niaga/alamat.dart';
import '../../model/niaga/alamat_bongkar.dart';

abstract class AlamatBongkarService {
  // Future<List<AlamatAccesses>> getalamatBongkar(AlamatAccesses credential);
  Future<List<AlamatBongkarAccesses>> getalamatBongkar(String port, String kota);
}
