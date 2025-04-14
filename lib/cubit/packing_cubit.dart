import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:niaga_apps_mobile/cubit/packing_state.dart';
import 'package:niaga_apps_mobile/model/auth_response.dart';
import 'package:niaga_apps_mobile/model/login/login_account.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../model/packing_list.dart';
import '../services/packing_service.dart';

part 'packing_state.dart';

class PackingCubit extends Cubit<PackingState> {
  final log = getLogger('PackingCubit');

  PackingCubit() : super(PackingInitial());

  Future<dynamic> packinglist() async {
    log.i('packingList');
    try {
      emit(PackingInProgress());

      // final getCheckIn = await sl<TimesheetService>()
      //     .getDataCheckInOutTest(1041316, '2024-06-03');
      // if (getCheckIn) {
      //   emit(AuthAutoLoginDasboardSuccess());
      // }

      final List<PackingListAccesses> response =
          await sl<PackingService>().getpacking(
              // LoginCredential(),
              );
      // final PackingListAccesses response = await sl<PackingService>().packing(
      // // LoginCredential(),
      // );
      // final LoginAccount lAccount = await sl<PackingService>().getAccount();

      // final List<AccountM> role =
      //     await sl<AuthService>().getRoles(response.clients![0].id!);

      emit(PackingListSuccess(response: response));
    } catch (e) {
      log.e('packingList error: $e');
      emit(PackingListFailure('$e'));
    }
  }
}
