import '../../../model/niaga/daftar-pesanan/detail_line.dart';

abstract class DetailPesananLineService {
  Future<List<DetailLineAccesses>> getDetailLine({int? id});
}
