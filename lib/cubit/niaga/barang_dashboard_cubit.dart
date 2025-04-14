import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/barang_dashboard.dart';
import '../../model/niaga/invoice_summary.dart';
import '../../model/niaga/log_niaga.dart';
import '../../services/niaga service/barang_dashboard_service.dart';
import '../../services/niaga service/invoice_summary_service.dart';

part 'barang_dashboard_state.dart';

class BarangDashboardCubit extends Cubit<BarangDashboardState> {
  final log = getLogger('BarangDashboardCubit');

  BarangDashboardCubit() : super(BarangDashboardInitial());

  Future<dynamic> barangDashboard() async {
    log.i('BarangDashboardCubit');
    try {
      emit(BarangDashboardInProgress());

      // Fetch the list of OpenInvoiceAccesses
      final List<BarangDashboardAccesses> response =
          await sl<BarangDashboardService>().getBarangDashboard();

      emit(BarangDashboardSuccess(response: response));
    } catch (e) {
      log.e('BarangDashboardCubit error: $e');
      emit(BarangDashboardFailure('$e'));
    }
  }

  //invoice
  Future<dynamic> invoiceSummary() async {
    log.i('invoiceSummaryCubit');
    try {
      emit(InvoiceSummaryInProgress());

      // Fetch the list of OpenInvoiceAccesses
      final InvoiceSummaryAccesses? response =
          await sl<InvoiceSummaryService>().getInvoiceSummary();

      emit(InvoiceSummarySuccess(response: response));
    } catch (e) {
      log.e('invoiceSummaryCubit error: $e');
      emit(InvoiceSummaryFailure('$e'));
    }
  }

  //Log Barang Gudang
  Future<void> logBarangGudangDashboard() async {
    log.i('LogNiagaCubit');
    try {
      emit(LogNiagaInProgress()); 

      final LogNiagaAccesses response =
          await sl<LogNiagaService11>().logNiaga();

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }

  //Log Invoice
  Future<void> logInvoiceDashboard() async {
    log.i('LogNiagaCubit');
    try {
      emit(LogNiagaInProgress()); 

      final LogNiagaAccesses response =
          await sl<LogNiagaService12>().logNiaga();

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }
}
