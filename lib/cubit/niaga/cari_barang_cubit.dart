// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:niaga_apps_mobile/servicelocator.dart';
// import 'package:niaga_apps_mobile/shared/widget/logger.dart';
// import '../../model/niaga/pencarian-barang/cari_barang.dart';
// import '../../model/niaga/pencarian-barang/detail_data.dart';
// import '../../services/niaga service/warehouse/detail_warehouse_service.dart';

// part 'cari_barang_state.dart';

// class CariBarangCubit extends Cubit<CariBarangState> {
//   final log = getLogger('CariBarangCubit');

//   CariBarangCubit() : super(CariBarangInitial());

//   Future<dynamic> cariBarang(String? asnNo) async {
//     log.i('CariBarangCubit');
//     try {
//       emit(CariBarangInProgress());

//       // Fetch the list of OpenInvoiceAccesses
//       final List<CariBarangAccesses> response =
//           await sl<DetailWarehouseService>().getDetailWarehouse(asnNo: asnNo);

//       // Process each CariBarangAccesses item and access the nested list
//       for (CariBarangAccesses detailwarehouseAccess in response) {
//         List<DetailDataAccesses> detailwarehouseItems = detailwarehouseAccess.data;

//         // Example: Log details from each item in the nested list
//         for (DetailDataAccesses item in detailwarehouseItems) {
//           log.i('ASN No: ${item.deskripsi}, Tujuan: ${item.volume}');
//           // You can process each item further as needed
//         }
//       }

//       emit(CariBarangSuccess(response: response));
//     } catch (e) {
//       log.e('CariBarangCubit error: $e');
//       emit(CariBarangFailure('$e'));
//     }
//   }
// }
