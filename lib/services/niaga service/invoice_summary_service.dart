import '../../model/niaga/invoice_summary.dart';
import '../../model/niaga/log_niaga.dart';

abstract class InvoiceSummaryService {
  Future<InvoiceSummaryAccesses?> getInvoiceSummary();
}

abstract class LogNiagaService12 {
  Future<LogNiagaAccesses> logNiaga();
}