import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/cari-barang-profil/detail_cari_barang.dart';
import '../../model/niaga/cari-barang-profil/detail_data_barang.dart';
import '../../model/niaga/cari-barang-profil/pencarian_barang.dart';
import '../../model/niaga/log_niaga.dart';
import '../../services/niaga service/pencarian barang/detail_pencarian_barang_service.dart';
import '../../services/niaga service/pencarian barang/pencarian_barang_service.dart';
import '../../services/niaga service/pencarian barang/search_pencarian_barang_service.dart';

part 'pencarian_barang_state.dart';

class PencarianBarangCubit extends Cubit<PencarianBarangState> {
  final log = getLogger('PencarianBarangCubit');

  PencarianBarangCubit() : super(PencarianBarangInitial());

  Future<dynamic> pencarianBarang({int pageIndex = 1}) async {
    log.i('pencarianBarang');
    log.i('Fetching data pencarian barang for page: $pageIndex');
    try {
      emit(PencarianBarangInProgress());

      // Fetch the list of OpeninvoiceCloseAccesses
      final List<PencarianBarangAccesses> response =
          await sl<PencarianBarangService>().getcaribarang(page: pageIndex);

      // final int totalPages = response[0].totalPage ?? 0;
      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      for (PencarianBarangAccesses cariBarangAccess in response) {
        List<DetailDataBarangAccesses> cariBarangItems = cariBarangAccess.data;

        // Loop through each invoice item and access the statusPayment field
        for (DetailDataBarangAccesses item in cariBarangItems) {
          log.i(
              'No Resi: ${item.noResi}, Nama Penerima: ${item.penerima}, Tanggal Masuk: ${item.sendAsnDate}');
          // You can also process or store the statusPayment value as needed
        }
      }

      emit(PencarianBarangSuccess(response: response, totalPages: totalPages));
      // emit(OpenInvoiceSuccess(response: response));
    } catch (e) {
      log.e('Pencarian Barang error: $e');
      emit(PencarianBarangFailure('$e'));
    }
  }

  //pencarian barang detail
  Future<dynamic> detailPencarianBarang({required String noResi}) async {
    log.i('detailPencarianBarang');
    log.i('Fetching data detail pencarian barang dengan no resi: $noResi');
    try {
      emit(DetailPencarianBarangInProgress());

      final List<DetailJenisBarangAccesses> response =
          await sl<DetailPencarianBarangService>()
              .getDetailCariBarang(noResi: noResi);

      emit(DetailPencarianBarangSuccess(response: response, noResi: noResi));
      try {
        logDetailPencarianBarang(noResi: noResi);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('Detail Pencarian Barang error: $e');
      emit(DetailPencarianBarangFailure('$e'));
    }
  }

  Future<dynamic> searchPencarianBarang({
    int pageIndex = 1,
    String? noResi,
    String? penerima,
    // String? tanggalMasuk,
    String? tglAwal,
    String? tglAkhir,
  }) async {
    log.i('SearchPencarianBarangCubit');
    log.i('Fetching data search pencarian barang for page: $pageIndex');

    try {
      emit(SearchPencarianBarangInProgress());

      // Set other fields to empty strings based on the provided search field
      if (tglAwal != null && tglAwal.isNotEmpty) {
        // If searching by tanggalMasuk, set noResi and tujuan to ''
        noResi = '';
        penerima = '';
      } else if (noResi != null && noResi.isNotEmpty) {
        // If searching by noResi, set tanggalMasuk and penerima to ''
        tglAwal = '';
        penerima = '';
      } else if (penerima != null && penerima.isNotEmpty) {
        // If searching by penerima, set tanggalMasuk and noResi to ''
        tglAwal = '';
        noResi = '';
      }

      // Debugging: Log the query parameters
      log.i('noResi nya: $noResi');
      log.i('penerima nya: $penerima');
      log.i('tanggalMasuk nya: $tglAwal');

      // Fetch the list of WarehouseNiagaAccesses using the service
      final List<PencarianBarangAccesses> response =
          await sl<SearchPencarianBarangService>().searchPencarianBarang(
              page: pageIndex,
              noResi: noResi,
              penerima: penerima,
              // tanggalMasuk: tanggalMasuk
              tglAwal: tglAwal,
              tglAkhir: tglAkhir);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      // Process each WarehouseNiagaAccesses item and log details
      for (PencarianBarangAccesses warehouseAccess in response) {
        List<DetailDataBarangAccesses> warehouseItems = warehouseAccess.data;

        for (DetailDataBarangAccesses item in warehouseItems) {
          log.i(
              'No Resi: ${item.noResi}, Nama Penerima: ${item.penerima}, Tanggal Masuk: ${item.sendAsnDate}');
        }
      }

      emit(SearchPencarianBarangSuccess(
          response: response, totalPages: totalPages));
      try {
        logPencarianBarang(
          pageIndex: pageIndex,
          noResi: noResi,
          penerima: penerima,
          tglAwal: tglAwal,
          tglAkhir: tglAkhir,
        );
      } catch (e) {
        log.e('Error logPencarianBarang: $e');
      }
    } catch (e) {
      log.e('SearchPencarianBarangCubit error: $e');
      emit(SearchPencarianBarangFailure('$e'));
    }
  }

  //LOG PENCARIAN BARANG
  Future<void> logPencarianBarang({
    int pageIndex = 1,
    String? noResi,
    String? penerima,
    String? tglAwal,
    String? tglAkhir,
  }) async {
    log.i('LogNiagaCubit');
    try {
      emit(LogNiagaInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService7>()
          .logNiaga(pageIndex, noResi, penerima, tglAwal, tglAkhir);

      emit(LogNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogNiagaFailure('$e'));
    }
  }

  //LOG DETAIL PENCARIAN BARANG
  Future<void> logDetailPencarianBarang({String? noResi}) async {
    log.i('LogNiagaCubit');
    try {
      emit(LogDetailPencarianNiagaInProgress());

      final LogNiagaAccesses response =
          await sl<LogNiagaService9>().logNiaga(noResi);

      emit(LogDetailPencarianNiagaSuccess(response: response));
    } catch (e) {
      log.e('LogNiagaCubit error: $e');
      emit(LogDetailPencarianNiagaFailure('$e'));
    }
  }
}
