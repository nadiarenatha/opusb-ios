import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';

import '../../model/id_account.dart';
import '../../services/id_account_service.dart';
import '../../shared/constants.dart';
import '../../shared/functions/flutter_secure_storage.dart';

part 'id_account_state.dart';

class IdAccountCubit extends Cubit<IdAccountState> {
  final log = getLogger('IdAccountCubit');

  IdAccountCubit() : super(IdAccountInitial());

  Future<void> getIdAccount() async {
    log.i('Fetching ID Account in IdAccountCubit');
    try {
      emit(IdAccountInProgress());

      // Fetch the list of IdAccountAccesses
      final List<IdAccountAccesses> response = await sl<IdAccountService>().getIdAccount();
      log.i('Fetched accounts: $response');

      // Assuming you're fetching the first account's ID
      if (response.isNotEmpty && response.first.id != null) {
        int accountId = response.first.id!;
        log.i('Account ID nya: $accountId');

        await saveAuthData(AuthKey.id, accountId.toString());
        log.i('Saved AuthKey: ${AuthKey.id}, Value: $accountId');
        final savedUserId = await storage.read(key: AuthKey.id.toString(), 
        aOptions: const AndroidOptions(
            encryptedSharedPreferences: true,
          ),);
        // log.i('Saved AuthKey: ${AuthKey.id}, Value: $accountId');
        log.i('User ID saved: $savedUserId');

        emit(IdAccountSuccess(response: response));
      } else {
        log.e('No ID found');
        emit(IdAccountFailure('No valid ID found in the response'));
      }
    } catch (e) {
      log.e('IdAccountCubit error: $e');
      // emit(IdAccountFailure('$e'));
      if (!isClosed) {
        emit(IdAccountFailure('$e'));
      }
    }
  }
}