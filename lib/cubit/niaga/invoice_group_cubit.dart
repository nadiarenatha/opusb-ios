import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/model/niaga/merchant_code.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/services/niaga%20service/invoice/merchant_code_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/bank_code.dart';
import '../../model/niaga/delete_invoice.dart';
import '../../model/niaga/detail_espay_invoice_group.dart';
import '../../model/niaga/detail_invoice_group.dart';
import '../../model/niaga/invoice_group.dart';
import '../../services/niaga service/invoice/bank_code_service.dart';
import '../../services/niaga service/invoice/bayar_sekarang_service.dart';
import '../../services/niaga service/invoice/delete_invoice_service.dart';
import '../../services/niaga service/invoice/detail_invoice_group_service.dart';
import '../../services/niaga service/invoice/invoice_group_service.dart';
import '../../services/niaga service/invoice/invoice_single_service.dart';

part 'invoice_group_state.dart';

class InvoiceGroupCubit extends Cubit<InvoiceGroupState> {
  final log = getLogger('InvoiceGroupCubit');

  InvoiceGroupCubit() : super(InvoiceGroupInitial());

  //Single Invoice
  Future<dynamic> singleInvoice(String noInvoice, int totalInvoice,
      String noOrderBoon, String noOrderOnline) async {
    log.i('singleInvoice');
    log.i(
        'singleInvoice called with noInvoice: $noInvoice, totalInvoice: $totalInvoice');

    try {
      emit(SingleInvoiceInProgress());

      final invoiceList = [
        {
          "no_invoice": noInvoice,
          "total_invoice": totalInvoice,
          "no_order_boon": noOrderBoon,
          "no_order_online": noOrderOnline
        }
      ];

      final DetailInvoiceGroupAccess? response =
          await sl<SingleInvoiceService>().getSingleInvoice(invoiceList);

      emit(SingleInvoiceSuccess(response: response));
    } catch (e) {
      log.e('Single Invoice error: $e');
      emit(SingleInvoiceFailure('$e'));
    }
  }

  //Multiple invoice
  Future<dynamic> multipleInvoice(invoiceList) async {
    log.i('multipleInvoice');

    try {
      emit(MultipleInvoiceInProgress());

      final DetailInvoiceGroupAccess? response =
          await sl<InvoiceGroupService>().getInvoiceGroup(invoiceList);

      emit(MultipleInvoiceSuccess(response: response));
    } catch (e) {
      log.e('Multiple invoice error: $e');
      emit(MultipleInvoiceFailure('$e'));
    }
  }

  //Delete Multiple Invoice
  Future<dynamic> deleteInvoice(String noInvoiceGroup) async {
    log.i('deleteInvoice');

    try {
      emit(DeleteInvoiceInProgress());

      final DeleteInvoiceAccess? response =
          await sl<DeleteInvoiceService>().deleteInvoice(noInvoiceGroup);

      emit(DeleteInvoiceSuccess(response: response));
    } catch (e) {
      log.e('Delete invoice error: $e');
      emit(DeleteInvoiceFailure('$e'));
    }
  }

  //Delete Single Invoice
  Future<dynamic> deleteSingleInvoice(String noInvoiceGroup) async {
    log.i('deleteSingleInvoice');

    try {
      emit(DeleteSingleInvoiceInProgress());

      final DeleteInvoiceAccess? response =
          await sl<DeleteInvoiceService>().deleteInvoice(noInvoiceGroup);

      emit(DeleteSingleInvoiceSuccess(response: response));
    } catch (e) {
      log.e('Delete single invoice error: $e');
      emit(DeleteSingleInvoiceFailure('$e'));
    }
  }

  //Get Bank Code
  Future<dynamic> bankCode(String name, String value) async {
    log.i('BankCodeCubit');
    try {
      emit(BankCodeInProgress());

      final List<BankCodeAccesses> response =
          await sl<BankCodeService>().getBankCode(name, value);

      emit(BankCodeSuccess(response: response));
    } catch (e) {
      log.e('BankCodeCubit error: $e');
      emit(BankCodeFailure('$e'));
    }
  }

  //Klik Bayar Sekarang
  Future<dynamic> bayarSekarang(String noInvoiceGroup) async {
    log.i('deleteInvoice');

    try {
      emit(BayarSekarangInProgress());

      final DeleteInvoiceAccess? response =
          await sl<BayarSekarangService>().bayarSekarang(noInvoiceGroup);

      emit(BayarSekarangSuccess(response: response));
    } catch (e) {
      log.e('Bayar Sekarang error: $e');
      emit(BayarSekarangFailure('$e'));
    }
  }

  //Get Detail Multiple Invoice
  Future<dynamic> detailMultipleInvoice(String noInvGroup) async {
    log.i('detailMultipleInvoice');
    try {
      emit(DetailMultipleInvoiceInProgress());

      final List<DetailEspayInvoiceGroupAccesses> response =
          await sl<DetailInvoiceGroupService>()
              .getDetailInvoiceGroup(noInvGroup);

      emit(DetailMultipleInvoiceSuccess(response: response));
    } catch (e) {
      log.e('detailMultipleInvoice error: $e');
      emit(DetailMultipleInvoiceFailure('$e'));
    }
  }

  //get merchant code
  Future<dynamic> merchantCodeGroup() async {
    log.i('MerchantCodeCubit');
    try {
      emit(MerchantCodeGroupInProgress());

      final List<MerchantCodeAccesses> response =
          await sl<MerchantCodeService>().getMerchantCode();

      emit(MerchantCodeGroupSuccess(response: response));
    } catch (e) {
      log.e('MerchantCodeCubit error: $e');
      emit(MerchantCodeGroupFailure('$e'));
    }
  }
}
