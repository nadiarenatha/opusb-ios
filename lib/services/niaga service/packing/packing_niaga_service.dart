import '../../../model/niaga/packing_niaga.dart';

// abstract class PackingNiagaService {
//   // Future<List<OpenInvoiceAccesses>> getopeninvoice();
//   Future<List<PackingNiagaAccesses>> getPackingNiaga(
//       // {String? email, int? page, int? size}
//       );
// }

abstract class PackingNiagaCompleteService {
  Future<List<PackingNiagaAccesses>> getPackingNiagaComplete({int? page});
}
