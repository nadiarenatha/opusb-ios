import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/model/invoice.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../services/invoice_service.dart';

part 'invoice_state.dart';

class InvoiceCubit extends Cubit<InvoiceState> {
  final log = getLogger('InvoiceCubit');

  InvoiceCubit() : super(InvoiceInitial());

  Future<dynamic> invoice() async {
    log.i('invoice');
    try {
      emit(InvoiceInProgress());
      final List<InvoiceAccesses> response =
          await sl<InvoiceService>().getinvoice(
              // LoginCredential(),
              );

      emit(InvoiceSuccess(response: response));
    } catch (e) {
      log.e('invoice error: $e');
      emit(InvoiceFailure('$e'));
    }
  }
}
