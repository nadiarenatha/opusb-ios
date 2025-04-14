import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/syarat_create_user.dart';
import '../../services/niaga service/create-user/syarat_ketentuan_service.dart';

part 'syarat_create_user_state.dart';

class SyaratCreateUserCubit extends Cubit<SyaratCreateUserState> {
  final log = getLogger('SyaratCreateUserCubit');

  SyaratCreateUserCubit() : super(SyaratCreateUserInitial());

  Future<dynamic> syaratCreateUser(bool active) async {
    log.i('SyaratCreateUserCubit');
    try {
      emit(SyaratCreateUserInProgress());

      final List<SyaratCreateUserAccesses> response =
          await sl<SyaratCreateUserService>().getSyaratCreateUser(active);

      emit(SyaratCreateUserSuccess(response: response));
    } catch (e) {
      log.e('SyaratCreateUserCubit error: $e');
      emit(SyaratCreateUserFailure('$e'));
    }
  }
}
