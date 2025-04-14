import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/detail-warehouse/barang_gudang.dart';
import '../../model/niaga/detail-warehouse/data_barang_gudang.dart';
import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/warehouse_detail_niaga.dart';
import '../../model/niaga/warehouse_niaga.dart';
import '../../services/niaga service/warehouse/detail_warehouse_service.dart';
import '../../services/niaga service/warehouse/report_warehouse_service.dart';
import '../../services/niaga service/warehouse/search_warehouse_service.dart';
import '../../services/niaga service/warehouse/warehouse_service.dart';

part 'warehouse_niaga_state.dart';

class WarehouseNiagaCubit extends Cubit<WarehouseNiagaState> {
  final log = getLogger('WarehouseNiagaCubit');

  WarehouseNiagaCubit() : super(WarehouseNiagaInitial());

  Future<dynamic> warehouseNiaga({
    int pageIndex = 1,
    String? customerDistribusi,
    String? tujuan,
    // String? tanggalMasuk,
    String? tglAwal,
    String? tglAkhir,
  }) async {
    log.i('WarehouseNiagaCubit');
    log.i('Fetching data warehouse for page: $pageIndex');
    try {
      emit(WarehouseNiagaInProgress());

      // Set other fields to empty strings based on the provided search field
      if (tglAwal != null && tglAwal.isNotEmpty) {
        // If searching by tanggalMasuk, set customerDistribusi and tujuan to ''
        customerDistribusi = '';
        tujuan = '';
      } else if (customerDistribusi != null && customerDistribusi.isNotEmpty) {
        // If searching by customerDistribusi, set tanggalMasuk and tujuan to ''
        tglAwal = '';
        tujuan = '';
      } else if (tujuan != null && tujuan.isNotEmpty) {
        // If searching by tujuan, set tanggalMasuk and customerDistribusi to ''
        tglAwal = '';
        customerDistribusi = '';
      }

      // Debugging: Log the query parameters
      log.i('customerDistribusi nya: $customerDistribusi');
      log.i('tujuan nya: $tujuan');
      log.i('tanggalMasuk nya: $tglAwal');

      // Fetch the list of OpenInvoiceAccesses
      // final List<WarehouseNiagaAccesses> response =
      //     await sl<WarehouseService>().getwarehouse(page: pageIndex);

      final List<WarehouseNiagaAccesses> response =
          await sl<WarehouseService>().getwarehouse(
              page: pageIndex,
              customerDistribusi: customerDistribusi,
              tujuan: tujuan,
              // tanggalMasuk: tanggalMasuk
              tglAwal: tglAwal,
              tglAkhir: tglAkhir);

      // final int totalPages = response[0].totalPage ?? 0;
      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      // Process each WarehouseNiagaAccesses item and access the nested list
      for (WarehouseNiagaAccesses warehouseAccess in response) {
        List<WarehouseItemAccesses> warehouseItems = warehouseAccess.data;

        // Example: Log details from each item in the nested list
        for (WarehouseItemAccesses item in warehouseItems) {
          log.i('ASN No: ${item.asnNo}, Tujuan: ${item.tujuan}');
          // You can process each item further as needed
        }
      }

      emit(WarehouseNiagaSuccess(response: response, totalPages: totalPages));
    } catch (e) {
      log.e('WarehouseNiagaCubit error: $e');
      emit(WarehouseNiagaFailure('$e'));
    }
  }

  Future<void> downloadwarehouse(String ownerCode) async {
    log.i('Starting download for warehouse owner code: $ownerCode');
    try {
      emit(DownloadWarehouseInProgress());

      // Attempt to download the invoice PDF
      bool success =
          await sl<ReportWarehouseService>().downloadReportWarehousePdf();

      if (success) {
        emit(DownloadWarehouseSuccess(ownerCode: ownerCode));
      } else {
        emit(DownloadWarehouseFailure(
            'Failed to download PDF for warehouse owner code: $ownerCode'));
      }
    } catch (e) {
      log.e('Error during download: $e');
      emit(DownloadWarehouseFailure('$e'));
    }
  }

  Future<void> detailwarehouseNiaga({String? asnNo}) async {
    log.i('DetailWarehouseNiagaCubit');

    try {
      emit(WarehouseDetailNiagaInProgress());

      // Fetch the list of BarangGudangDataAccesses
      final List<BarangGudangDataAccesses> response =
          await sl<DetailWarehouseService>().getDetailWarehouse(asnNo: asnNo);

      emit(WarehouseDetailNiagaSuccess(response: response));
      try {
        logDetailWarehouse(asnNo: asnNo);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('WarehouseDetailNiagaCubit error: $e');
      emit(WarehouseDetailNiagaFailure('$e'));
    }
  }

  Future<dynamic> searchWarehouseNiaga({
    int pageIndex = 1,
    String? customerDistribusi,
    String? tujuan,
    // String? tanggalMasuk,
    String? tglAwal,
    String? tglAkhir,
  }) async {
    log.i('SearchWarehouseNiagaCubit');
    log.i('Fetching data search warehouse for page: $pageIndex');

    try {
      emit(SearchWarehouseNiagaInProgress());

      // Set other fields to empty strings based on the provided search field
      if (tglAwal != null && tglAwal.isNotEmpty) {
        // If searching by tanggalMasuk, set customerDistribusi and tujuan to ''
        customerDistribusi = '';
        tujuan = '';
      } else if (customerDistribusi != null && customerDistribusi.isNotEmpty) {
        // If searching by customerDistribusi, set tanggalMasuk and tujuan to ''
        tglAwal = '';
        tujuan = '';
      } else if (tujuan != null && tujuan.isNotEmpty) {
        // If searching by tujuan, set tanggalMasuk and customerDistribusi to ''
        tglAwal = '';
        customerDistribusi = '';
      }

      // Debugging: Log the query parameters
      log.i('customerDistribusi nya: $customerDistribusi');
      log.i('tujuan nya: $tujuan');
      log.i('tanggalMasuk nya: $tglAwal');

      // Fetch the list of WarehouseNiagaAccesses using the service
      final List<WarehouseNiagaAccesses> response =
          await sl<SearchWarehouseService>().searchwarehouse(
              page: pageIndex,
              customerDistribusi: customerDistribusi,
              tujuan: tujuan,
              // tanggalMasuk: tanggalMasuk
              tglAwal: tglAwal,
              tglAkhir: tglAkhir);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      // Process each WarehouseNiagaAccesses item and log details
      for (WarehouseNiagaAccesses warehouseAccess in response) {
        List<WarehouseItemAccesses> warehouseItems = warehouseAccess.data;

        for (WarehouseItemAccesses item in warehouseItems) {
          log.i('ASN No: ${item.asnNo}, Tujuan: ${item.tujuan}');
        }
      }

      emit(SearchWarehouseNiagaSuccess(
          response: response, totalPages: totalPages));
      try {
        logWarehouse(
          pageIndex: pageIndex,
          customerDistribusi: customerDistribusi,
          tujuan: tujuan,
          tglAwal: tglAwal,
          tglAkhir: tglAkhir,
        );
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('SearchWarehouseNiagaCubit error: $e');
      emit(SearchWarehouseNiagaFailure('$e'));
    }
  }

  //LOG WAREHOUSE
  Future<void> logWarehouse({
    int pageIndex = 1,
    String? customerDistribusi,
    String? tujuan,
    // String? tanggalMasuk,
    String? tglAwal,
    String? tglAkhir,
  }) async {
    log.i('LogNiagaCubit');
    try {
      emit(LogWarehouseNiagaInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService6>()
          .logNiaga(pageIndex, customerDistribusi, tujuan, tglAwal, tglAkhir);

      emit(LogWarehouseNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogWarehouseNiagaFailure('$e'));
    }
  }

  //LOG DETAIL WAREHOUSE
  Future<void> logDetailWarehouse({String? asnNo}) async {
    log.i('LogNiagaCubit');
    try {
      emit(LogNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService10>().logNiaga(asnNo);

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }
}
