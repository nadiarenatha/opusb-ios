import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/espay.dart';
import '../../model/niaga/fee_espay.dart';
import '../../services/niaga service/espay_service.dart';
import '../../services/niaga service/fee_espay_service.dart';

part 'espay_state.dart';

class EspayCubit extends Cubit<EspayState> {
  final log = getLogger('EspayCubit');

  EspayCubit() : super(EspayInitial());

  Future<void> espayValidation(
      String noInvoice,
      String totalInvoice,
      String name,
      String value,
      int userId,
      String orderNumber,
      String invoiceNumber,
      String packingListNumber,
      String ruteTujuan,
      String tipePengiriman,
      String volume,
      String merchantId,
      String subMerchantId,
      String cabang) async {
    log.i('espayValidation()');

    try {
      emit(EspayInProgress());

      final EspayResponse response = await sl<EspayPaymentService>()
          .espayPaymentValidation(
              noInvoice,
              totalInvoice,
              name,
              value,
              userId,
              orderNumber,
              invoiceNumber,
              packingListNumber,
              ruteTujuan,
              tipePengiriman,
              volume,
              merchantId,
              subMerchantId,
              cabang);

      if (response.webRedirectUrl != null &&
          response.webRedirectUrl!.isNotEmpty) {
        log.i('Payment validation successful.');
        emit(EspaySuccess(response));
      } else {
        log.e('Payment validation failed: Missing redirect URL.');
        emit(EspayFailure('Missing redirect URL.'));
      }
    } catch (e) {
      log.e('Espay error: $e');
      emit(EspayFailure(e.toString()));
    }
  }

  //Get Fee Espay
  Future<dynamic> feeEspay() async {
    log.i('FeeEspayCubit');
    try {
      emit(FeeEspayInProgress());

      final List<FeeEspayAccesses> response =
          await sl<FeeEspayService>().getFeeEspay();

      emit(FeeEspaySuccess(response: response));
    } catch (e) {
      log.e('FeeEspayCubit error: $e');
      emit(FeeEspayFailure('$e'));
    }
  }
}
