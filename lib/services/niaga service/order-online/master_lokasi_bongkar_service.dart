import '../../../model/niaga/master_lokasi_bongkar.dart';

abstract class MasterLokasiBongkarService {
  Future<List<MasterLokasiBongkarAccesses>> getMasterLokasiBongkar(String port);
}
