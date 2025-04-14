import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/port_asal_fcl.dart';
import '../../model/niaga/port_tujuan_fcl.dart';
import '../../services/niaga service/order-online/port_asal_fcl_service.dart';
import '../../services/niaga service/order-online/port_tujuan_fcl_service.dart';

part 'order_online_fcl_state.dart';

class OrderOnlineFCLCubit extends Cubit<OrderOnlineFCLState> {
  final log = getLogger('OrderOnlineFCLCubit');

  OrderOnlineFCLCubit() : super(OrderOnlineFCLInitial());

  // Method to fetch port asal FCL data
  Future<void> fetchPortAsalFCL() async {
    log.i('Fetching Port Asal FCL Data');
    try {
      emit(PortAsalFCLInProgress());

      // Fetch the list of PortAsalFCLAccesses
      final List<PortAsalFCLAccesses> response =
          await sl<PortAsalFCLService>().getPortAsalFCL();

      emit(PortAsalFCLSuccess(response: response));
    } catch (e) {
      log.e('Error fetching Port Asal FCL data: $e');
      emit(PortAsalFCLFailure('Error: $e'));
    }
  }

  // Method to save selected PortAsal based on KotaAsal
  void saveSelectedPortAsal(String selectedKotaAsal) {
    final currentState = state;
    log.i('Current State before processing: $currentState');

    if (currentState is PortAsalFCLSuccess) {
      // Find the corresponding port based on the selected KotaAsal
      final selectedPortAsal = currentState.response.firstWhere(
        (port) => port.kotaAsal == selectedKotaAsal,
        orElse: () => PortAsalFCLAccesses(), // Default value if not found
      );
      log.i('Port Asal yang dipilih: ${selectedPortAsal.portAsal}');

      emit(PortAsalFCLSelected(portAsal: selectedPortAsal.portAsal ?? ''));

      log.i('State after emitting PortAsalFCLSelected: $state');
    }
  }
  
  //NEW
  Future<void> fetchPortTujuanFCL(String portAsal) async {
    log.i('Fetching Port Tujuan FCL based on $portAsal');
    try {
      emit(PortTujuanFCLInProgress());

      final List<PortTujuanFCLAccesses> response =
          await sl<PortTujuanFCLService>().getPortTujuanFCL(portAsal);

      // Log the raw response list for debugging
      log.i('Fetched Port Tujuan list: $response');

      if (response.isEmpty) {
        emit(PortTujuanFCLFailure('No port data available for $portAsal'));
      } else {
        emit(PortTujuanFCLSuccess(response: response));
      }
    } catch (e) {
      log.e('Error fetching Port Tujuan FCL: $e');
      emit(PortTujuanFCLFailure('Error: $e'));
    }
  }

  //LCL
  Future<void> fetchPortAsalLCL() async {
    log.i('Fetching Port Asal LCL Data');
    try {
      emit(PortAsalLCLInProgress());

      // Fetch the list of PortAsalFCLAccesses
      final List<PortAsalFCLAccesses> response =
          await sl<PortAsalFCLService>().getPortAsalLCL();

      emit(PortAsalLCLSuccess(response: response));
    } catch (e) {
      log.e('Error fetching Port Asal LCL data: $e');
      emit(PortAsalLCLFailure('Error: $e'));
    }
  }

  //LCL
  void saveSelectedPortAsalLCL(String selectedKotaAsal) {
    final currentState = state;
    log.i('Current State before processing: $currentState');

    if (currentState is PortAsalLCLSuccess) {
      // Find the corresponding port based on the selected KotaAsal
      final selectedPortAsal = currentState.response.firstWhere(
        (port) => port.kotaAsal == selectedKotaAsal,
        orElse: () => PortAsalFCLAccesses(), // Default value if not found
      );
      log.i('Port Asal yang dipilih: ${selectedPortAsal.portAsal}');

      emit(PortAsalLCLSelected(portAsal: selectedPortAsal.portAsal ?? ''));

      log.i('State after emitting PortAsalLCLSelected: $state');
    }
  }

  //LCL
  Future<void> fetchPortTujuanLCL(String portAsal) async {
    log.i('Fetching Port Tujuan LCL based on $portAsal');
    try {
      emit(PortTujuanLCLInProgress());

      final List<PortTujuanFCLAccesses> response =
          await sl<PortTujuanFCLService>().getPortTujuanLCL(portAsal);

      // Log the raw response list for debugging
      log.i('Fetched Port Tujuan list: $response');

      if (response.isEmpty) {
        emit(PortTujuanLCLFailure('No port data available for $portAsal'));
      } else {
        emit(PortTujuanLCLSuccess(response: response));
      }
    } catch (e) {
      log.e('Error fetching Port Tujuan LCL: $e');
      emit(PortTujuanLCLFailure('Error: $e'));
    }
  }
}
