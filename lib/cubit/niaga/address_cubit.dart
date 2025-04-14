import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/servicelocator.dart';
import 'package:niaga_apps_mobile/shared/widget/logger.dart';
import '../../model/niaga/address.dart';
import '../../model/niaga/tipe_alamat.dart';
import '../../services/niaga service/add_address_service.dart';
import '../../services/niaga service/address_service.dart';
import 'package:intl/intl.dart';

import '../../services/niaga service/tipe_alamat_service.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final log = getLogger('AddressCubit');

  AddressCubit() : super(AddressInitial());

  Future<dynamic> address() async {
    log.i('AddressCubit');
    try {
      emit(AddressInProgress());

      final List<AddressAccesses> response =
          await sl<AddressService>().getAddress();

      emit(AddressSuccess(response: response));
    } catch (e) {
      log.e('AddressCubit error: $e');
      emit(AddressFailure('$e'));
    }
  }

  //Add address
  Future<void> addAddress(
      String addressType,
      String email,
      String addressName,
      String picName,
      String picPhone,
      String city,
      String createdDate,
      String createdBy,
      String address1,
      String locationId) async {
    log.i('AddAddressCubit');
    try {
      emit(AddAddressInProgress());

      final sysdate =
          DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'").format(DateTime.now().toUtc());

      final addingAddressResponse = await sl<AddAddressService>().getAddresses(
        addressType,
        email,
        addressName,
        picName,
        picPhone,
        city,
        sysdate,
        createdBy,
        address1,
        locationId,
      );

      emit(AddAddressSuccess(response: addingAddressResponse));
    } catch (e) {
      log.e('AddAddressCubit error: $e');
      emit(AddAddressFailure('$e'));
    }
  }

  //Get Tipe Alamat
  Future<void> tipeAlamat() async {
    log.i('tipeAlamat');
    try {
      emit(TipeAlamatInProgress());

      final List<TipeAlamatAccesses> response =
          await sl<TipeAlamatService>().getTipeAlamat();

      emit(TipeAlamatSuccess(response: response));
    } catch (e) {
      log.e('tipe alamat error: $e');

      emit(TipeAlamatFailure(e.toString()));
    }
  }
}
