import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/niaga/uoc_list_search.dart';
import '../../services/niaga service/uoc-list-search/uoc_create_account_service.dart';
import '../../services/niaga service/uoc-list-search/uoc_list_search_service.dart';

part 'uoc_list_search_state.dart';

class UOCListSearchCubit extends Cubit<UOCListSearchState> {
  final log = getLogger('UOCListSearchCubit');

  UOCListSearchCubit() : super(UOCListSearchInitial());

  Future<dynamic> uOCListSearchMuat(String kota, String port) async {
    log.i('UOCListSearchCubitMuat');
    try {
      emit(UOCListSearchMuatInProgress());

      final List<UOCListSearchAccesses> response =
          await sl<UOCListSearchService>().getUOCListSearch(kota, port);

      emit(UOCListSearchMuatSuccess(response: response));
    } catch (e) {
      log.e('UOCListSearchCubitMuat error: $e');
      emit(UOCListSearchMuatFailure('$e'));
    }
  }

  Future<dynamic> uOCListSearchBongkar(String kota, String port) async {
    log.i('UOCListSearchCubitBongkar');
    try {
      emit(UOCListSearchBongkarInProgress());

      final List<UOCListSearchAccesses> response =
          await sl<UOCListSearchService>().getUOCListSearch(kota, port);

      emit(UOCListSearchBongkarSuccess(response: response));
    } catch (e) {
      log.e('UOCListSearchCubitBongkar error: $e');
      emit(UOCListSearchBongkarFailure('$e'));
    }
  }

  //UOC UNTUK CREATE ACCOUNT
  Future<List<UOCListSearchAccesses>?> uOCCreateAccount(String filter) async {
    log.i('uOCCreateAccountCubit');
    try {
      emit(UOCCreateAccountInProgress());

      // Fetch data from the service
      final List<UOCListSearchAccesses> response =
          await sl<UOCCreateAccountService>().getUOCCreateAccount(filter);

      if (response.isEmpty) {
        log.w('Received an empty response');
        emit(UOCCreateAccountFailure(
            'Masukan minimal 4 karakter untuk memulai'));
        return []; // Return an empty list
      }

      emit(UOCCreateAccountSuccess(response: response));
      return response; // Return the successful response
    } catch (e, stacktrace) {
      log.e('Error fetching UOC data: $e\n$stacktrace');
      emit(UOCCreateAccountFailure('Terjadi kesalahan. Silakan coba lagi.'));
      return null; // Return null in case of an error
    }
  }
}
