// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:niaga_apps_mobile/model/auth_response.dart';
// import 'package:niaga_apps_mobile/servicelocator.dart';
// import 'package:niaga_apps_mobile/shared/widget/logger.dart';
// import '../services/wa_service.dart';
// part 'wa_state.dart';

// class WACubit extends Cubit<WAState> {
//   final log = getLogger('WACubit');

//   WACubit() : super(WAInitial());

//   Future<void> sendwhatsapp() async {
//     log.i('sendwhatsapp()');
//     try {
//       emit(SendWhatsappInProgress());

//       final response = await sl<WAService>().sendwhatsapp();

//       emit(SendWhatsappSuccess());
//     } catch (e) {
//       log.e('sendwhatsapp error: $e');
//       emit(SendWhatsappFailure('$e'));
//     }
//   }
// }

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../services/wa_service.dart';

part 'wa_state.dart';

class WACubit extends Cubit<WAState> {
  final log = getLogger('WACubit');

  WACubit() : super(WAInitial());

  Future<void> sendwhatsapp({
    required String portAsal,
    required String portTujuan,
    required String shippingLine,
    required String vesselName,
    required String voyageNo,
    required String rutePanjang,
    required String tglClosing,
    required String etd,
    required String eta,
  }) async {
    log.i('sendwhatsapp()');
    try {
      emit(SendWhatsappInProgress());

      // Call the service and pass the necessary parameters
      final response = await sl<WAService>().sendwhatsapp(
        portAsal: portAsal,
        portTujuan: portTujuan,
        shippingLine: shippingLine,
        vesselName: vesselName,
        voyageNo: voyageNo,
        rutePanjang: rutePanjang,
        tglClosing: tglClosing,
        etd: etd,
        eta: eta,
      );

      if (response) {
        emit(SendWhatsappSuccess());
      } else {
        emit(SendWhatsappFailure('Failed to send message'));
      }
    } catch (e) {
      log.e('sendwhatsapp error: $e');
      emit(SendWhatsappFailure('Error: $e'));
    }
  }
}
