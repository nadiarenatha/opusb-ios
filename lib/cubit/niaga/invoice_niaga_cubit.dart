import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/close_invoice_detail_niaga.dart';
import '../../model/niaga/close_invoice_niaga.dart';
import '../../model/niaga/detail-invoice/detail_invoice_fcl.dart';
import '../../model/niaga/detail-invoice/detail_invoice_lcl.dart';
import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/open_invoice_detail_niaga.dart';
import '../../model/niaga/open_invoice_niaga.dart';
import '../../services/niaga service/invoice/detail_invoice_fcl_service.dart';
import '../../services/niaga service/invoice/detail_invoice_lcl_service.dart';
import '../../services/niaga service/invoice/invoice_close_service.dart';
import '../../services/niaga service/invoice/invoice_onprocess_service.dart';
import '../../services/niaga service/invoice/invoice_open_service.dart';
import '../../services/niaga service/invoice/report_invoice_service.dart';
import '../../services/niaga service/invoice/search_invoice_service.dart';

part 'invoice_niaga_state.dart';

class InvoiceNiagaCubit extends Cubit<InvoiceNiagaState> {
  final log = getLogger('InvoiceNiagaCubit');

  InvoiceNiagaCubit() : super(OpenInvoiceInitial());

  //Unpaid Invoice
  Future<dynamic> openinvoice(
      {int pageIndex = 1, String? invoiceNumber, String? noJob}) async {
    log.i('openinvoice');
    log.i('Fetching data open invoice for page: $pageIndex');
    try {
      emit(OpenInvoiceInProgress());

      // Fetch the list of OpeninvoiceCloseAccesses
      final List<OpenInvoiceAccesses> response = await sl<InvoiceOpenService>()
          .getopeninvoice(
              page: pageIndex, invoiceNumber: invoiceNumber, noJob: noJob);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      for (OpenInvoiceAccesses invoiceAccess in response) {
        List<InvoiceItemAccesses> invoiceItems = invoiceAccess.data;

        // Loop through each invoice item and access the statusPayment field
        for (InvoiceItemAccesses item in invoiceItems) {
          log.i(
              'Invoice Number Paid: ${item.invoiceNumber}, Total Invoice Paid: ${item.totalInvoice}, Status Payment Paid: ${item.statusPayment}');
          // You can also process or store the statusPayment value as needed
        }
      }

      emit(OpenInvoiceSuccess(response: response, totalPages: totalPages));
      try {
        logUnpaidInvoice(pageIndex, invoiceNumber, noJob);
      } catch (e) {
        log.e('Error logUnpaidInvoice: $e');
      }
    } catch (e) {
      log.e('invoice Paid error: $e');
      emit(OpenInvoiceFailure('$e'));
    }
  }

  //Paid Invoice
  Future<dynamic> closeinvoice(
      {int pageIndex = 1, String? invoiceNumber, String? noJob}) async {
    log.i('closeinvoice');
    log.i('Fetching data for page close invoice: $pageIndex');
    try {
      emit(CloseInvoiceInProgress());

      // Fetch the list of OpenInvoiceAccesses
      final List<OpenInvoiceAccesses> response = await sl<InvoiceCloseService>()
          .getcloseinvoice(
              page: pageIndex, invoiceNumber: invoiceNumber, noJob: noJob);

      // final int totalPages = response[0].totalPage ?? 0;
      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      for (OpenInvoiceAccesses invoiceCloseAccess in response) {
        List<InvoiceItemAccesses> invoiceCloseItems = invoiceCloseAccess.data;

        // Loop through each invoice item and access the statusPayment field
        for (InvoiceItemAccesses item in invoiceCloseItems) {
          log.i(
              'Invoice Number UnPaid: ${item.invoiceNumber}, Total Invoice UnPaid: ${item.totalInvoice}, Status Payment UnPaid: ${item.statusPayment}');
          // You can also process or store the statusPayment value as needed
        }
      }

      emit(CloseInvoiceSuccess(response: response, totalPages: totalPages));
      try {
        logPaidInvoice(pageIndex, invoiceNumber, noJob);
      } catch (e) {
        log.e('Error logPaidInvoice: $e');
      }
    } catch (e) {
      log.e('invoice UnPaid error: $e');
      emit(CloseInvoiceFailure('$e'));
    }
  }

  Future<void> downloadinvoice(String invoiceNumber, String volume) async {
    log.i('Starting download for invoice number: $invoiceNumber');
    try {
      emit(DownloadInvoiceInProgress());

      // Attempt to download the invoice PDF
      bool success = await sl<ReportInvoiceService>()
          .downloadReportInvoicePdf(invoiceNumber, volume);

      if (success) {
        emit(DownloadInvoiceSuccess(invoiceNumber: invoiceNumber));
      } else {
        emit(DownloadInvoiceFailure(
            'Failed to download PDF for invoice number: $invoiceNumber'));
      }
    } catch (e) {
      log.e('Error during download: $e');
      emit(DownloadInvoiceFailure('$e'));
    }
  }

  Future<dynamic> detailInvoiceLCL(String invoiceNumber) async {
    // Pass invoiceNumber as parameter
    log.i('detailInvoiceLCL');
    try {
      emit(DetailInvoiceLCLInProgress());

      // Fetch the detail invoice using the provided invoice number
      final DetailInvoiceLCLAccesses response =
          await sl<DetailInvoiceLCLService>()
              .getDetailInvoiceLCL(invoiceNumber);

      // Emit success state with the fetched response
      emit(DetailInvoiceLCLSuccess(response: response));
      try {
        logDetaiInvoicelLCL(invoiceNumber);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('detail invoice LCL error: $e');
      emit(DetailInvoiceLCLFailure('$e'));
    }
  }

  Future<dynamic> detailInvoiceFCL(String invoiceNumber) async {
    // Pass invoiceNumber as parameter
    log.i('detailInvoiceFCL');
    try {
      emit(DetailInvoiceFCLInProgress());

      // Fetch the detail invoice using the provided invoice number
      final DetailInvoiceFCLAccesses response =
          await sl<DetailInvoiceFCLService>()
              .getDetailInvoiceFCL(invoiceNumber);

      // Emit success state with the fetched response
      emit(DetailInvoiceFCLSuccess(response: response));
      try {
        logDetaiInvoicelFCL(invoiceNumber);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('detail invoice FCL error: $e');
      emit(DetailInvoiceFCLFailure('$e'));
    }
  }

  //search invoice
  Future<dynamic> searchinvoice(
      {int pageIndex = 1, String? invoiceNumber, String? noJob}) async {
    log.i('searchinvoice');
    log.i('Fetching data search invoice for page: $pageIndex');
    try {
      emit(SearchInvoiceInProgress());

      log.i('Invoice Number nya: $invoiceNumber');
      log.i('No Job nya: $noJob');

      // Fetch the list of OpeninvoiceCloseAccesses
      final List<OpenInvoiceAccesses> response =
          await sl<SearchInvoiceService>().searchInvoice(
              page: pageIndex, invoiceNumber: invoiceNumber, noJob: noJob);

      // final int totalPages = response[0].totalPage ?? 0;
      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      for (OpenInvoiceAccesses invoiceAccess in response) {
        List<InvoiceItemAccesses> invoiceItems = invoiceAccess.data;

        // Loop through each invoice item and access the statusPayment field
        for (InvoiceItemAccesses item in invoiceItems) {
          log.i(
              'Invoice Number Paid: ${item.invoiceNumber}, Total Invoice Paid: ${item.totalInvoice}, Status Payment Paid: ${item.statusPayment}');
        }
      }

      emit(SearchInvoiceSuccess(response: response, totalPages: totalPages));
    } catch (e) {
      log.e('Search invoice error: $e');
      emit(SearchInvoiceFailure('$e'));
    }
  }

  //Invoice On Process
  Future<dynamic> invoiceOnProcess(
      {int pageIndex = 1, String? invoiceNumber, String? noJob}) async {
    log.i('invoiceOnProcess');
    log.i('Fetching data invoice on process for page: $pageIndex');
    try {
      emit(InvoiceOnProcessInProgress());

      // Fetch the list of OpeninvoiceCloseAccesses
      final List<OpenInvoiceAccesses> response =
          await sl<InvoiceOnProcessService>().getInvoiceOnProcess(
              page: pageIndex, invoiceNumber: invoiceNumber, noJob: noJob);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      for (OpenInvoiceAccesses invoiceAccess in response) {
        List<InvoiceItemAccesses> invoiceItems = invoiceAccess.data;

        // Loop through each invoice item and access the statusPayment field
        for (InvoiceItemAccesses item in invoiceItems) {
          log.i(
              'Invoice Number on Process: ${item.invoiceNumber}, Total Invoice on Process: ${item.totalInvoice}, Status Payment on Process: ${item.statusPayment}');
          // You can also process or store the statusPayment value as needed
        }
      }

      emit(InvoiceOnProcessSuccess(response: response, totalPages: totalPages));
    } catch (e) {
      log.e('invoice on process error: $e');
      emit(InvoiceOnProcessFailure('$e'));
    }
  }

  //Log Unpaid Invoice
  Future<void> logUnpaidInvoice(
      int? page, String? invoiceNumber, String? noJob) async {
    log.i('logUnpaidInvoice');
    try {
      emit(LogUnpaidNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService13>().logNiaga(page, invoiceNumber, noJob);

      emit(LogUnpaidNiagaSuccess(response: response));
    } catch (e) {
      log.e('logUnpaidInvoice error: $e');
      emit(LogUnpaidNiagaFailure('$e'));
    }
  }

  //Log Paid Invoice
  Future<void> logPaidInvoice(
      int? page, String? invoiceNumber, String? noJob) async {
    log.i('logPaidInvoice');
    try {
      emit(LogPaidNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService20>().logNiaga(page, invoiceNumber, noJob);

      emit(LogPaidNiagaSuccess(response: response));
    } catch (e) {
      log.e('logPaidInvoice error: $e');
      emit(LogPaidNiagaFailure('$e'));
    }
  }

  //Log On Process Invoice
  Future<void> logOnProcessInvoice(
      int? page, String? invoiceNumber, String? noJob) async {
    log.i('logOnProcessInvoice');
    try {
      emit(LogOnProcessNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService21>().logNiaga(page, invoiceNumber, noJob);

      emit(LogOnProcessNiagaSuccess(response: response));
      try {
        logOnProcessInvoice(page, invoiceNumber, noJob);
      } catch (e) {
        log.e('Error logPaidInvoice: $e');
      }
    } catch (e) {
      log.e('logOnProcessInvoice error: $e');
      emit(LogOnProcessNiagaFailure('$e'));
    }
  }

  //Log Detail Invoice LCL
  Future<void> logDetaiInvoicelLCL(String invoiceNumber) async {
    log.i('logDetaiInvoicelLCL');
    try {
      emit(LogDetailInvoiceLCLInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService24>().logNiaga(invoiceNumber);

      emit(LogDetailInvoiceLCLSuccess(response: response));
    } catch (e) {
      log.e('logDetaiInvoicelLCL error: $e');
      emit(LogDetailInvoiceLCLFailure('$e'));
    }
  }

  //Log Detail Invoice FCL
  Future<void> logDetaiInvoicelFCL(String invoiceNumber) async {
    log.i('logDetaiInvoicelFCL');
    try {
      emit(LogDetailInvoiceFCLInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService25>().logNiaga(invoiceNumber);

      emit(LogDetailInvoiceFCLSuccess(response: response));
    } catch (e) {
      log.e('logDetaiInvoicelFCL error: $e');
      emit(LogDetailInvoiceFCLFailure('$e'));
    }
  }
}
