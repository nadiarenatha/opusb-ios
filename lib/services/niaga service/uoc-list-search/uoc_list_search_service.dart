import '../../../model/niaga/uoc_list_search.dart';

abstract class UOCListSearchService {
  Future<List<UOCListSearchAccesses>> getUOCListSearch(
      String kota, String port);
}
