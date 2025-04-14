import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/order.dart';
import '../../model/niaga/push_order.dart';
import '../../services/niaga service/order-online/create_order_fcl_service.dart';
import 'package:intl/intl.dart';

import '../../services/niaga service/order-online/create_order_lcl_service.dart';
import '../../services/niaga service/order-online/push_order_service.dart';

part 'create_order_state.dart';

class CreateOrderCubit extends Cubit<CreateOrderState> {
  final log = getLogger('CreateOrderCubit');

  CreateOrderCubit() : super(CreateOrderInitial());

  //Create Order FCL
  Future<dynamic> createOrderFCL(
      String email,
      String createdBy,
      int userId,
      String createdDate,
      String businessUnit,
      String portAsal,
      String portTujuan,
      String originalCity,
      String originalAddress,
      String originalPicName,
      String originalPicNumber,
      String cargoReadyDate,
      String destinationCity,
      String destinationAddress,
      String destinationPicName,
      String destinationPicNumber,
      String contractNo,
      String komoditi,
      String productDescription,
      String containerSize,
      int quantity,
      int amount,
      String loctidUocAsal,
      String loctidUocTujuan,
      String loctidPortAsal,
      String loctidPortTujuan,
      bool point,
      int price,
      double userTotalWeight,
      bool flagPaymentWa,
      bool paymentStatus,
      int pointUse,
      int amountCargo,
      String etd) async {
    log.i('CreateOrderFCLCubit');

    try {
      emit(CreateOrderFCLInProgress());

      final sysdate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

      final OrderAccesses response = await sl<CreateOrderFCLService>()
          .createOrderFCL(
              email,
              createdBy,
              userId,
              sysdate,
              businessUnit,
              portAsal,
              portTujuan,
              originalCity,
              originalAddress,
              originalPicName,
              originalPicNumber,
              cargoReadyDate,
              destinationCity,
              destinationAddress,
              destinationPicName,
              destinationPicNumber,
              contractNo,
              komoditi,
              productDescription,
              containerSize,
              quantity,
              amount,
              loctidUocAsal,
              loctidUocTujuan,
              loctidPortAsal,
              loctidPortTujuan,
              point,
              price,
              userTotalWeight,
              flagPaymentWa,
              paymentStatus,
              pointUse,
              amountCargo,
              etd);

      emit(CreateOrderFCLSuccess(response: response));
    } catch (e) {
      log.e('CreateOrderFCLCubit error: $e');
      emit(CreateOrderFCLFailure('$e'));
    }
  }

  //Create Order LCL
  Future<dynamic> createOrderLCL(
      String email,
      String createdBy,
      int userId,
      String createdDate,
      String businessUnit,
      String portAsal,
      String portTujuan,
      String originalCity,
      String originalAddress,
      String cargoReadyDate,
      String destinationCity,
      String destinationAddress,
      String destinationPicName,
      String destinationPicNumber,
      String contractNo,
      String komoditi,
      String productDescription,
      int quantity,
      int amount,
      double userPanjang,
      double userLebar,
      double userTinggi,
      double userTotalVolume,
      int userTotalWeight,
      String uom,
      bool point,
      String locidUocAsal,
      String locidUocTujuan,
      String locidPortAsal,
      String locidPortTujuan,
      int price,
      int pointUse,
      int amountCargo) async {
    log.i('CreateOrderLCLCubit');

    try {
      emit(CreateOrderLCLInProgress());

      final sysdate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

      final OrderAccesses response = await sl<CreateOrderLCLService>()
          .createOrderLCL(
              email,
              createdBy,
              userId,
              sysdate,
              businessUnit,
              portAsal,
              portTujuan,
              originalCity,
              originalAddress,
              cargoReadyDate,
              destinationCity,
              destinationAddress,
              destinationPicName,
              destinationPicNumber,
              contractNo,
              komoditi,
              productDescription,
              quantity,
              amount,
              userPanjang,
              userLebar,
              userTinggi,
              userTotalVolume,
              userTotalWeight,
              uom,
              point,
              locidUocAsal,
              locidUocTujuan,
              locidPortAsal,
              locidPortTujuan,
              price,
              pointUse,
              amountCargo);

      emit(CreateOrderLCLSuccess(response: response));
    } catch (e) {
      log.e('CreateOrderLCLCubit error: $e');
      emit(CreateOrderLCLFailure('$e'));
    }
  }

  //Push Order FCL LCL
  Future<dynamic> pushOrder(String noOrderOnline, int point) async {
    log.i('PushOrderCubit');

    try {
      emit(PushOrderInProgress());

      final List<PushOrderAccesses> response =
          await sl<PushOrderService>().getPushOrder(noOrderOnline, point);

      emit(PushOrderSuccess(response: response));
    } catch (e) {
      log.e('PushOrderCubit error: $e');
      emit(PushOrderFailure('$e'));
    }
  }
}
