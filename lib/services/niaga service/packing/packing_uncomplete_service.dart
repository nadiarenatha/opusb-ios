import '../../../model/niaga/packing_niaga.dart';

abstract class PackingNiagaUnCompleteService {
  Future<List<PackingNiagaAccesses>> getPackingNiagaUnComplete({int? page});
}
