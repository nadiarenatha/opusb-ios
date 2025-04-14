import '../../../model/niaga/daftar-pesanan/detail_header.dart';

abstract class DetailPesananHeaderService {
  Future<List<DetailHeaderAccesses>> getDetailHeader({int? id});
}
