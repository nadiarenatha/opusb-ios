import '../../../model/niaga/jadwal-kapal/jadwal_kapal.dart';
import '../../../model/niaga/log_niaga.dart';

abstract class JadwalKapalNiagaService {
  Future<List<JadwalKapalNiagaAccesses>> getJadwalKapalNiaga(String portAsal, String portTujuan, String etdFrom);
}

abstract class LogNiagaService5 {
  Future<LogNiagaAccesses> logNiaga(String portAsal, String portTujuan, String etdFrom);
}
