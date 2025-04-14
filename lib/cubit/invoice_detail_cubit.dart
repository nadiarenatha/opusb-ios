import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/model/invoice_detail.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../services/invoice_detail_service.dart';

part 'invoice_detail_state.dart';

class InvoiceDetailCubit extends Cubit<InvoiceDetailState> {
  final log = getLogger('InvoiceDetailCubit');

  InvoiceDetailCubit() : super(InvoiceDetailInitial());

  // Future<dynamic> invoice() async {
  Future<void> fetchInvoiceDetail({int? meInvoiceId}) async {
    log.i('invoicedetail');
    try {
      emit(InvoiceDetailInProgress());
      final List<InvoiceDetailAccesses> response =
          await sl<InvoiceDetailService>().getinvoicedetail(
              // LoginCredential(),
              meInvoiceId: meInvoiceId);

      emit(InvoiceDetailSuccess(response: response));
    } catch (e) {
      log.e('invoice detail error: $e');
      // emit(InvoiceDetailFailure('$e'));
      emit(InvoiceDetailFailure(e.toString()));
    }
  }
}
