import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/otp/wa_push_otp.dart';
import '../../model/niaga/otp/wa_verifikasi.dart';
import '../../services/niaga service/otp/update_flag_wa_service.dart';
import '../../services/niaga service/otp/update_flag_wa_service_impl.dart';
import '../../services/niaga service/otp/wa_push_otp_service.dart';
import '../../services/niaga service/otp/wa_verifikasi_service.dart';
import '../../shared/constants.dart';
import '../../shared/functions/flutter_secure_storage.dart';

part 'wa_verifikasi_state.dart';

class WAVerifikasiCubit extends Cubit<WAVerifikasiState> {
  final log = getLogger('WAVerifikasiCubit');

  WAVerifikasiCubit() : super(WAVerifikasiInitial());

  Future<void> waVerifikasi(String no, String email, String otp) async {
    log.i('waVerifikasi($no)');
    log.i('waVerifikasi($email)');
    log.i('waVerifikasi($otp)');
    try {
      emit(WAVerifikasiInProgress());

      final response = await sl<WAVerifikasiService>().waVerifikasi(
        WAVerifikasiNiaga(no: no, email: email, otp: otp),
      );

      // emit(WAVerifikasiSuccess(response: response));

      // // After successful OTP verification, update waVerified flag
      // await updateContractFlag();

      print('Response Status Code: ${response.statusCode}');
      print('Full Response: ${response.toString()}');
      log.i('Response Status Code: ${response.statusCode}');
      log.i('Full Response: ${response.toString()}');

      if (response.statusCode == 200) {
        // Handle success response when response.data is a String
        if (response.data == "success") {
          // if (response.data is String && response.data == "success") {
          emit(WAVerifikasiSuccess(response: response.data));
          print('ini response nya : $response');
          // await updateWAVerfied(true);
          await updateWAVerfied();
        } else {
          emit(WAVerifikasiFailure("Unexpected response format"));
        }
      } else {
        emit(WAVerifikasiFailure(
            "Verifikasi gagal dengan status ${response.statusCode}"));
      }
    } catch (e) {
      log.e('waVerifikasi error: $e');
      emit(WAVerifikasiFailure('$e'));
    }
  }

  // Future<void> updateWAVerfied(bool flag) async {
  //   try {
  //     // Emit updating state
  //     emit(WAVerifikasiFlagUpdating());

  //     // Retrieve email from secure storage
  //     final email = await storage.read(
  //       key: AuthKey.email.toString(),
  //       aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  //     );

  //     log.i("Retrieved email: $email");

  //     if (email == null) {
  //       log.e("Email is null; cannot proceed with WA verification update.");
  //       emit(WAVerifikasiFailure("Email not found in secure storage"));
  //       return;
  //     }

  //     log.i('Updating WA Verified for email: $email');

  //     // Make the PUT request
  //     // final response = await sl<WAVerifikasiService>().updateupdateWAVerfied();
  //     final response = await sl<UpdateFlagWAService>().updateupdateWAVerfied();

  //     // Check the response status code
  //     if (response.statusCode == 200) {
  //       // Update the flag in secure storage
  //       await storage.write(
  //         key: AuthKey.waVerified.toString(),
  //         value: flag.toString(),
  //         aOptions: const AndroidOptions(encryptedSharedPreferences: true),
  //       );

  //       log.i("WA Verified updated to: $flag");
  //       emit(WAVerifikasiFlagUpdated());
  //     } else {
  //       log.e("Failed to update WA Verified: ${response.statusCode}");
  //       emit(WAVerifikasiFailure("Failed with status ${response.statusCode}"));
  //     }
  //   } catch (e) {
  //     log.e("Error updating WA Verified: $e");
  //     emit(WAVerifikasiFailure("Error: $e"));
  //   }
  // }

  Future<void> updateWAVerfied() async {
    try {
      emit(WAVerifikasiFlagUpdating());

      final response = await sl<UpdateFlagWAService>().updateWAVerfied();

      // Check the result in WAVerifiedAccesses instead of checking response.data directly
      if (response.userLogin != null) {
        emit(WAVerifikasiFlagUpdated());
        log.i("WA Verified flag successfully updated.");
      } else {
        log.e("Failed to update WA Verified");
        emit(WAVerifikasiFailure("Failed to update WA Verified"));
      }
    } catch (e) {
      log.e("Error updating WA Verified: $e");
      emit(WAVerifikasiFailure("Error: $e"));
    }
  }
}
