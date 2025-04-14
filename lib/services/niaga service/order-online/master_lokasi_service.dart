import '../../../model/niaga/master_lokasi.dart';

abstract class MasterLokasiMuatService {
  Future<List<MasterLokasiAccesses>> getMasterLokasiMuat(String port);
}
