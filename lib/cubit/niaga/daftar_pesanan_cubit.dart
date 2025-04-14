import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/daftar-pesanan/daftar_pesanan.dart';
import '../../model/niaga/daftar-pesanan/data_pesanan.dart';
import '../../model/niaga/daftar-pesanan/detail_header.dart';
import '../../model/niaga/daftar-pesanan/detail_line.dart';
import '../../model/niaga/daftar-pesanan/ulasan.dart';
import '../../services/niaga service/daftar-pesanan/daftar_pesanan_service.dart';
import '../../services/niaga service/daftar-pesanan/detail_header_pesanan_service.dart';
import '../../services/niaga service/daftar-pesanan/detail_line_pesanan_service.dart';
import '../../services/niaga service/daftar-pesanan/hasil_ulasan_service.dart';
import '../../services/niaga service/daftar-pesanan/pesanan_cancel_service.dart';
import '../../services/niaga service/daftar-pesanan/pesanan_completed_service.dart';
import '../../services/niaga service/daftar-pesanan/search_cancel_service.dart';
import '../../services/niaga service/daftar-pesanan/search_completed_service.dart';
import '../../services/niaga service/daftar-pesanan/search_progresss_service.dart';
import '../../services/niaga service/daftar-pesanan/ulasan_service.dart';
import 'package:intl/intl.dart';

part 'daftar_pesanan_state.dart';

class DaftarPesananCubit extends Cubit<DaftarPesananState> {
  final log = getLogger('DaftarPesananCubit');

  DaftarPesananCubit() : super(DaftarPesananInitial());

  //On Progress
  Future<dynamic> daftarpesananOnProgress(
      {int pageIndex = 0,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName}) async {
    log.i('daftar pesanan On Progress');
    log.i('Fetching data daftar pesanan On Progress for page: $pageIndex');
    try {
      emit(DaftarPesananInProgress());

      final List<DataPesananAccesses> response =
          await sl<DaftarPesananService>().getDaftarPesanan(
              page: pageIndex,
              orderNumber: orderNumber,
              orderService: orderService,
              shipmentType: shipmentType,
              originalCity: originalCity,
              destinationCity: destinationCity,
              cargoReadyDate: cargoReadyDate,
              firstName: firstName);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPages ?? 0 : 0;

      for (DataPesananAccesses pesananAccess in response) {
        List<DaftarPesananAccesses> daftarPesanan = pesananAccess.content;

        // Loop through each invoice item and access the statusPayment field
        for (DaftarPesananAccesses item in daftarPesanan) {
          log.i(
              'Order Number: ${item.orderNumber}, Status ID: ${item.statusId}, Status: ${item.status}, Total: ${item.amount}');
        }
      }

      emit(DaftarPesananSuccess(response: response, totalPages: totalPages));
    } catch (e) {
      log.e('Daftar Pesanan on progress error: $e');
      emit(DaftarPesananFailure('$e'));
    }
  }

  //Completed
  Future<dynamic> daftarpesananCompleted({int pageIndex = 0}) async {
    log.i('daftar pesanan Completed');
    log.i('Fetching data daftar pesanan Completed for page: $pageIndex');
    try {
      emit(DaftarPesananCompletedInProgress());

      final List<DataPesananAccesses> response =
          await sl<PesananCompletedService>()
              .getPesananCompleted(page: pageIndex);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPages ?? 0 : 0;

      for (DataPesananAccesses pesananAccess in response) {
        List<DaftarPesananAccesses> daftarPesanan = pesananAccess.content;

        // Loop through each invoice item and access the statusPayment field
        for (DaftarPesananAccesses item in daftarPesanan) {
          log.i(
              'Order Number: ${item.orderNumber}, Status ID: ${item.statusId}, Status: ${item.status}, Total: ${item.amount}');
        }
      }

      emit(DaftarPesananCompletedSuccess(
          response: response, totalPages: totalPages));
    } catch (e) {
      log.e('Daftar Pesanan Completed error: $e');
      emit(DaftarPesananCompletedFailure('$e'));
    }
  }

  //Cancel
  Future<dynamic> daftarpesananCancel({int pageIndex = 0}) async {
    log.i('daftar pesanan Cancel');
    log.i('Fetching data daftar pesanan Cancel for page: $pageIndex');
    try {
      emit(DaftarPesananCancelInProgress());

      final List<DataPesananAccesses> response =
          await sl<PesananCancelService>().getPesananCancel(page: pageIndex);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPages ?? 0 : 0;

      for (DataPesananAccesses pesananAccess in response) {
        List<DaftarPesananAccesses> daftarPesanan = pesananAccess.content;

        // Loop through each invoice item and access the statusPayment field
        for (DaftarPesananAccesses item in daftarPesanan) {
          log.i(
              'Order Number: ${item.orderNumber}, Status ID: ${item.statusId}, Status: ${item.status}, Total: ${item.amount}');
        }
      }

      emit(DaftarPesananCancelSuccess(
          response: response, totalPages: totalPages));
    } catch (e) {
      log.e('Daftar Pesanan Cancel error: $e');
      emit(DaftarPesananCancelFailure('$e'));
    }
  }

  //Search On Progress
  Future<dynamic> searchPesananOnProgress(
      {int pageIndex = 0,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName}) async {
    log.i('search pesanan On Progress');
    log.i('Fetching data search pesanan On Progress for page: $pageIndex');
    try {
      emit(SearchPesananInProgress());

      final List<DataPesananAccesses> response =
          await sl<SearchProgressService>().getSearchProgress(
              page: pageIndex,
              orderNumber: orderNumber,
              orderService: orderService,
              shipmentType: shipmentType,
              originalCity: originalCity,
              destinationCity: destinationCity,
              cargoReadyDate: cargoReadyDate,
              firstName: firstName);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPages ?? 0 : 0;

      for (DataPesananAccesses pesananAccess in response) {
        List<DaftarPesananAccesses>? daftarPesanan = pesananAccess.content;

        // Loop through each invoice item and access the statusPayment field
        for (DaftarPesananAccesses item in daftarPesanan) {
          log.i(
              'Order Number: ${item.orderNumber}, Status ID: ${item.statusId}, Status: ${item.status}, Total: ${item.amount}');
        }
      }

      emit(SearchPesananSuccess(response: response, totalPages: totalPages));
    } catch (e) {
      log.e('Search Pesanan on progress error: $e');
      emit(SearchPesananFailure('$e'));
    }
  }

  //Search Completed
  Future<dynamic> searchPesananCompleted(
      {int pageIndex = 0,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName}) async {
    log.i('search pesanan Completed');
    log.i('Fetching data search pesanan Completed for page: $pageIndex');
    try {
      emit(SearchPesananCompletedInProgress());

      final List<DataPesananAccesses> response =
          await sl<SearchCompletedService>().getSearchCompleted(
              page: pageIndex,
              orderNumber: orderNumber,
              orderService: orderService,
              shipmentType: shipmentType,
              originalCity: originalCity,
              destinationCity: destinationCity,
              cargoReadyDate: cargoReadyDate,
              firstName: firstName);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPages ?? 0 : 0;

      for (DataPesananAccesses pesananAccess in response) {
        List<DaftarPesananAccesses> daftarPesanan = pesananAccess.content;

        // Loop through each invoice item and access the statusPayment field
        for (DaftarPesananAccesses item in daftarPesanan) {
          log.i(
              'Order Number: ${item.orderNumber}, Status ID: ${item.statusId}, Status: ${item.status}, Total: ${item.amount}');
        }
      }

      emit(SearchPesananCompletedSuccess(
          response: response, totalPages: totalPages));
    } catch (e) {
      log.e('Search Pesanan Completed error: $e');
      emit(SearchPesananCompletedFailure('$e'));
    }
  }

  //Search Cancel
  Future<dynamic> searchPesananCancel(
      {int pageIndex = 0,
      String? orderNumber,
      String? orderService,
      String? shipmentType,
      String? originalCity,
      String? destinationCity,
      String? cargoReadyDate,
      String? firstName}) async {
    log.i('search pesanan Cancel');
    log.i('Fetching data search pesanan Cancel for page: $pageIndex');
    try {
      emit(SearchPesananCancelInProgress());

      final List<DataPesananAccesses> response = await sl<SearchCancelService>()
          .getSearchCancel(
              page: pageIndex,
              orderNumber: orderNumber,
              orderService: orderService,
              shipmentType: shipmentType,
              originalCity: originalCity,
              destinationCity: destinationCity,
              cargoReadyDate: cargoReadyDate,
              firstName: firstName);

      final int totalPages =
          response.isNotEmpty ? response[0].totalPages ?? 0 : 0;

      for (DataPesananAccesses pesananAccess in response) {
        List<DaftarPesananAccesses> daftarPesanan = pesananAccess.content;

        // Loop through each invoice item and access the statusPayment field
        for (DaftarPesananAccesses item in daftarPesanan) {
          log.i(
              'Order Number: ${item.orderNumber}, Status ID: ${item.statusId}, Status: ${item.status}, Total: ${item.amount}');
        }
      }

      emit(SearchPesananCancelSuccess(
          response: response, totalPages: totalPages));
    } catch (e) {
      log.e('Search Pesanan Cancel error: $e');
      emit(SearchPesananCancelFailure('$e'));
    }
  }

  //Ulasan
  Future<void> addUlasan(
      int userId,
      String orderNumber,
      String email,
      int rating,
      String customerFeedback,
      String createdDate,
      String createdBy) async {
    log.i('AddUlasanCubit');
    try {
      emit(AddUlasanInProgress());

      final sysdate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

      final addingAddressResponse = await sl<UlasanService>().ulasanPesanan(
          userId,
          orderNumber,
          email,
          rating,
          customerFeedback,
          sysdate,
          createdBy);

      emit(AddUlasanSuccess(response: addingAddressResponse));
    } catch (e) {
      log.e('AddUlasanCubit error: $e');
      emit(AddUlasanFailure('$e'));
    }
  }

  //Detail Line
  Future<void> detailLinePesanan({int? id}) async {
    log.i('linedetail');
    try {
      emit(DetailLinePesananInProgress());

      final List<DetailLineAccesses> response =
          await sl<DetailPesananLineService>().getDetailLine(id: id);

      emit(DetailLinePesananSuccess(response: response));
    } catch (e) {
      log.e('line detail pesanan error: $e');

      emit(DetailLinePesananFailure(e.toString()));
    }
  }

  //Detail Header
  Future<void> detailHeaderPesanan({int? id}) async {
    log.i('Headerdetail');
    try {
      emit(DetaiHeaderPesananInProgress());

      final List<DetailHeaderAccesses> response =
          await sl<DetailPesananHeaderService>().getDetailHeader(id: id);

      emit(DetaiHeaderPesananSuccess(response: response));
    } catch (e) {
      log.e('header detail pesanan error: $e');

      emit(DetaiHeaderPesananFailure(e.toString()));
    }
  }

  //Get Ulasan
  Future<void> getUlasan(String? orderNumber) async {
    log.i('GetUlasanCubit');
    try {
      emit(GetUlasanInProgress());

      final List<UlasanAccesses> response = await sl<HasilUlasanService>()
          .hasilUlasanPesanan(orderNumber: orderNumber);

      emit(GetUlasanSuccess(response: response));
    } catch (e) {
      log.e('GetUlasanCubit error: $e');
      emit(GetUlasanFailure('$e'));
    }
  }
}
