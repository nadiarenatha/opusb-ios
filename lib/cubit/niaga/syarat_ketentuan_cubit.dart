import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/syarat_ketentuan.dart';
import '../../services/niaga service/syarat-ketentuan/syarat_ketentuan_service.dart';

part 'syarat_ketentuan_state.dart';

class SyaratKetentuanCubit extends Cubit<SyaratKetentuanState> {
  final log = getLogger('SyaratKetentuanCubit');

  SyaratKetentuanCubit() : super(SyaratKetentuanInitial());

  Future<dynamic> syaratKetentuan(bool active) async {
    log.i('SyaratKetentuanCubit');
    try {
      emit(SyaratKetentuanInProgress());

      final List<SyaratKetentuanAccesses> response =
          await sl<SyaratKetentuanService>().getSyaratKetentuan(active);

      emit(SyaratKetentuanSuccess(response: response));
    } catch (e) {
      log.e('SyaratKetentuanCubit error: $e');
      emit(SyaratKetentuanFailure('$e'));
    }
  }
}
