import '../../../model/niaga/tentang_niaga.dart';

abstract class TentangNiagaService {
  Future<List<TentangNiagaAccesses>> getTentangNiaga(bool active);
}
