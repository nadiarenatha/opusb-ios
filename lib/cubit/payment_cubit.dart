import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/model/auth_response.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/services/payment_service.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  final log = getLogger('PaymentCubit');

  PaymentCubit() : super(PaymentInitial());

  Future<void> paymentvalidation({
    required String serverKey,
    required Map<String, dynamic> requestBody,
  }) async {
    log.i('paymentvalidation()');
    try {
      emit(PaymentInProgress());

      final response = await sl<PaymentService>().paymentvalidation(
        serverKey: serverKey,
        requestBody: requestBody,
      );

      emit(PaymentSuccess());
    } catch (e) {
      log.e('payment error: $e');
      emit(PaymentFailure('$e'));
    }
  }
}
