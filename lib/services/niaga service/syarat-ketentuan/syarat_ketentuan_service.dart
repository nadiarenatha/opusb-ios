import '../../../model/niaga/syarat_ketentuan.dart';

abstract class SyaratKetentuanService {
  Future<List<SyaratKetentuanAccesses>> getSyaratKetentuan(bool active);
}
