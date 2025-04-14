import '../../../model/niaga/uoc_list_search.dart';

abstract class UOCCreateAccountService {
  Future<List<UOCListSearchAccesses>> getUOCCreateAccount(String filter);
}
