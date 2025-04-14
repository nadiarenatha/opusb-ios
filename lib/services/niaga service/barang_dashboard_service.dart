import '../../model/niaga/barang_dashboard.dart';
import '../../model/niaga/log_niaga.dart';

abstract class BarangDashboardService {
  Future<List<BarangDashboardAccesses>> getBarangDashboard();
}

abstract class LogNiagaService11 {
  Future<LogNiagaAccesses> logNiaga();
}