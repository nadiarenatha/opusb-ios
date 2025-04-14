import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/log_niaga.dart';
import '../../model/niaga/open_invoice_niaga.dart';
import '../../model/niaga/packing_detail_niaga.dart';
import '../../model/niaga/packing_niaga.dart';
import '../../services/niaga service/packing/packing_niaga_service.dart';
import '../../services/niaga service/packing/packing_uncomplete_service.dart';
import '../../services/niaga service/packing/report_packing_service.dart';
import '../../services/niaga service/packing/search_packing_service.dart';
import '../../services/niaga service/packing/search_packing_uncomplete_service.dart';

part 'packing_niaga_state.dart';

class PackingNiagaCubit extends Cubit<PackingNiagaState> {
  final log = getLogger('PackingNiagaCubit');

  PackingNiagaCubit() : super(PackingNiagaInitial());

  Future<void> packingNiagaComplete({int pageIndex = 0}) async {
    log.i('packingNiagaComplete');
    log.i('Fetching data packing complete for page: $pageIndex');
    try {
      emit(PackingNiagaCompleteInProgress());

      // Fetch the packing data
      final List<PackingNiagaAccesses> response =
          await sl<PackingNiagaCompleteService>()
              .getPackingNiagaComplete(page: pageIndex);

      if (response.isNotEmpty) {
        // Extract totalPage from the first element in the response
        final int totalPages = response[0].totalPage ?? 0;

        // Process packing items
        for (PackingNiagaAccesses packingAccess in response) {
          List<PackingItemAccesses> packingItems = packingAccess.data;
          for (PackingItemAccesses item in packingItems) {
            log.i(
                'Order Number: ${item.orderNo}, Container Number: ${item.containerNo}, ETA nya: ${item.etaDate}, ETD nya : ${item.etdDate}');
          }
        }

        // Emit success state with totalPages
        emit(PackingNiagaCompleteSuccess(
            response: response, totalPages: totalPages));
      } else {
        emit(PackingNiagaCompleteSuccess(response: [], totalPages: 0));
      }
    } catch (e) {
      log.e('PackingNiagaCubit error: $e');
      emit(PackingNiagaCompleteFailure('$e'));
    }
  }

  Future<void> packingNiagaUnComplete({int pageIndex = 0}) async {
    log.i('packingNiagaUnComplete');
    log.i('Fetching data packing uncomplete for page: $pageIndex');
    try {
      emit(PackingNiagaUnCompleteInProgress());

      // Fetch the packing data
      final List<PackingNiagaAccesses> response =
          await sl<PackingNiagaUnCompleteService>()
              .getPackingNiagaUnComplete(page: pageIndex);

      if (response.isNotEmpty) {
        // Extract totalPage from the first element in the response
        final int totalPages = response[0].totalPage ?? 0;

        // Process packing items
        for (PackingNiagaAccesses packingAccess in response) {
          List<PackingItemAccesses> packingItems = packingAccess.data;
          for (PackingItemAccesses item in packingItems) {
            log.i(
                'Order Number: ${item.orderNo}, Container Number: ${item.containerNo}');
          }
        }

        // Emit success state with totalPages
        emit(PackingNiagaUnCompleteSuccess(
            response: response, totalPages: totalPages));
      } else {
        emit(PackingNiagaUnCompleteSuccess(response: [], totalPages: 0));
      }
    } catch (e) {
      log.e('PackingNiagaCubit error: $e');
      emit(PackingNiagaUnCompleteFailure('$e'));
    }
  }

  Future<void> downloadpacking(String noPL, String tipePL) async {
    log.i('Starting download for tipe packing list: $tipePL');
    log.i('Starting download for tipe nomor list: $noPL');
    log.i(
        'https://elogistic-dev.opusb.co.id/api/report-packing-list?baseUrl=https://api-app.niaga-logistics.com/api/v1/packing-list/&no_pl=$noPL&tipe_pl=$tipePL');

    try {
      emit(DownloadPackingInProgress());

      // Attempt to download the invoice PDF
      bool success = await sl<ReportPackingService>()
          .downloadReportPackingPdf(noPL, tipePL);

      if (success) {
        emit(DownloadPackingSuccess(tipePL: tipePL));
      } else {
        emit(DownloadPackingFailure(
            'Failed to download PDF for nomor packing list: $noPL'));
      }
    } catch (e) {
      log.e('Error during download: $e');
      emit(DownloadPackingFailure('$e'));
    }
  }

  //SEARCH PACKING COMPLETE
  Future<dynamic> searchPackingComplete({
    int pageIndex = 1,
    String? noPL,
    String? containerNo,
    String? asal,
    String? tujuan,
    String? vesselName,
  }) async {
    log.i('searchPackingComplete');
    log.i('Fetching data search packing complete for page: $pageIndex');

    try {
      emit(SearchPackingCompleteInProgress());

      // Debugging: Log the query parameters
      log.i('No Packing List Complete nya: $noPL');
      log.i('No Container Complete nya: $containerNo');
      log.i('Asal Complete nya: $asal');
      log.i('Tujuan Complete nya: $tujuan');
      log.i('Nama Kapal Complete nya: $vesselName');

      // Fetch the list of WarehouseNiagaAccesses using the service
      final List<PackingNiagaAccesses> response =
          await sl<SearchPackingService>().searchPackingComplete(
              page: pageIndex,
              noPL: noPL,
              containerNo: containerNo,
              asal: asal,
              tujuan: tujuan,
              vesselName: vesselName);

      if (response.isNotEmpty) {
        // Extract totalPage from the first element in the response
        final int totalPages = response[0].totalPage ?? 0;

        // Process packing items
        for (PackingNiagaAccesses packingAccess in response) {
          List<PackingItemAccesses> packingItems = packingAccess.data;
          for (PackingItemAccesses item in packingItems) {
            log.i(
                'No Packing Complete: ${item.noPL}, No Container Complete: ${item.containerNo}, Asal Complete: ${item.asal}, Tujuan Complete: ${item.tujuan}, Nama Kapal Complete: ${item.vesselName}');
          }
        }

        emit(SearchPackingCompleteSuccess(
            response: response, totalPages: totalPages));
        try {
          logCompletePacking(
              pageIndex, noPL, containerNo, asal, tujuan, vesselName);
        } catch (e) {
          log.e('Error logUnCompletePacking: $e');
        }
      } else {
        emit(SearchPackingCompleteSuccess(response: [], totalPages: 0));
      }
    } catch (e) {
      log.e('SearchPackingCompleteCubit error: $e');
      emit(SearchPackingCompleteFailure('$e'));
    }
  }

  //SEARCH PACKING UNCOMPLETE
  Future<dynamic> searchPackingUnComplete({
    int pageIndex = 1,
    String? noPL,
    String? containerNo,
    String? asal,
    String? tujuan,
    String? vesselName,
  }) async {
    log.i('searchPackingUnComplete');
    log.i('Fetching data search packing uncomplete for page: $pageIndex');

    try {
      emit(SearchPackingUnCompleteInProgress());

      // Debugging: Log the query parameters
      log.i('No Packing List Uncomplete nya: $noPL');
      log.i('No Container Uncomplete nya: $containerNo');
      log.i('Asal Uncomplete nya: $asal');
      log.i('Tujuan Uncomplete nya: $tujuan');
      log.i('Nama Kapal Uncomplete nya: $vesselName');

      // Fetch the list of WarehouseNiagaAccesses using the service
      final List<PackingNiagaAccesses> response =
          await sl<SearchUncompletedPackingService>().searchPackingUnComplete(
              page: pageIndex,
              noPL: noPL,
              containerNo: containerNo,
              asal: asal,
              tujuan: tujuan,
              vesselName: vesselName);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPage ?? 0 : 0;

      // Process each WarehouseNiagaAccesses item and log details
      for (PackingNiagaAccesses warehouseAccess in response) {
        List<PackingItemAccesses> warehouseItems = warehouseAccess.data;

        for (PackingItemAccesses item in warehouseItems) {
          log.i(
              'No Packing Uncomplete: ${item.noPL}, No Container Uncomplete: ${item.containerNo}, Asal Uncomplete: ${item.asal}, Tujuan Uncomplete: ${item.tujuan}, Nama Kapal Uncomplete: ${item.vesselName}');
        }
      }

      emit(SearchPackingUnCompleteSuccess(
          response: response, totalPages: totalPages));
      try {
        logUnCompletePacking(
            pageIndex, noPL, containerNo, asal, tujuan, vesselName);
      } catch (e) {
        log.e('Error logUnCompletePacking: $e');
      }
    } catch (e) {
      log.e('SearchPackingUnCompleteCubit error: $e');
      emit(SearchPackingUnCompleteFailure('$e'));
    }
  }

  //Log Complete Packing
  Future<void> logCompletePacking(int? page, String? noPL, String? containerNo,
      String? asal, String? tujuan, String? vesselName) async {
    log.i('logCompletePacking');
    try {
      emit(LogCompletePackingInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService22>()
          .logNiaga(page, noPL, containerNo, asal, tujuan, vesselName);

      emit(LogCompletePackingSuccess(response: response));
    } catch (e) {
      log.e('logCompletePacking error: $e');
      emit(LogCompletePackingFailure('$e'));
    }
  }

  //Log UnComplete Packing
  Future<void> logUnCompletePacking(
      int? page,
      String? noPL,
      String? containerNo,
      String? asal,
      String? tujuan,
      String? vesselName) async {
    log.i('logUnCompletePacking');
    try {
      emit(LogUnCompletePackingInProgress());

      final LogNiagaAccesses response = await sl<LogNiagaService23>()
          .logNiaga(page, noPL, containerNo, asal, tujuan, vesselName);

      emit(LogUnCompletePackingSuccess(response: response));
    } catch (e) {
      log.e('logUnCompletePacking error: $e');
      emit(LogUnCompletePackingFailure('$e'));
    }
  }
}
