import '../model/id_account.dart';

abstract class IdAccountService {
  Future<List<IdAccountAccesses>> getIdAccount();
}
