import '../../model/niaga/tipe_alamat.dart';

abstract class TipeAlamatService {
  Future<List<TipeAlamatAccesses>> getTipeAlamat();
}
