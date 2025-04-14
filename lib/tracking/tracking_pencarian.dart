import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/tracking/menu_tracking_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/packing_niaga_cubit.dart';
import '../cubit/niaga/tracking_niaga_cubit.dart';
import '../model/niaga/packing_detail_niaga.dart';
import '../model/niaga/tracking/ptp-cosd/astra-motor/tracking_astra.dart';
import '../model/niaga/tracking/ptp-cosd/dtd-cosl/tracking_dtd_cosl.dart';
import '../model/niaga/tracking/ptp-cosd/dtp-cosl/tracking_dtp_cosl.dart';
import '../model/niaga/tracking/ptp-cosd/header-tracking/detail_header.dart';
import '../model/niaga/tracking/ptp-cosd/ptd-cosd/tracking_ptd_cosd.dart';
import '../model/niaga/tracking/ptp-cosd/ptd-cosl/tracking_ptd_cosl.dart';
import '../model/niaga/tracking/ptp-cosd/ptp-cosl/tracking_ptp_cosl.dart';
import '../model/niaga/tracking/ptp-cosd/tracking_ptp_cosd.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';

class TrackingPencarianNiaga extends StatefulWidget {
  // final PackingItemAccesses tracking;
  // final String noPL;
  String noPL;
  // const TrackingPencarianNiaga({Key? key, required this.noPL})
  //     : super(key: key);
  TrackingPencarianNiaga({Key? key, required this.noPL}) : super(key: key);

  @override
  State<TrackingPencarianNiaga> createState() => _TrackingPencarianNiagaState();
}

class _TrackingPencarianNiagaState extends State<TrackingPencarianNiaga> {
  //untuk set navigasi bar dashboard, home, profile
  int _selectedIndex = 1;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  List<TrackingPtpCosdAccesses> ptpCosdList = [];
  List<TrackingPtpCoslAccesses> ptpCoslList = [];
  List<TrackingDtdCoslAccesses> dtdCoslList = [];
  List<TrackingDtpCoslAccesses> dtpCoslList = [];
  List<TrackingPtdCosdAccesses> ptdCosdList = [];
  List<TrackingPtdCoslAccesses> ptdCoslList = [];
  List<TrackingAstraAccesses> astraMotorList = [];
  List<Map<String, String>> selectedItems = [];
  HeaderItemTrackingAccesses? detailHeaderPencarian;
  List<PackingItemAccesses> detailTracking = [];
  int pageIndex = 1;
  List<PackingItemAccesses> onProgressPacking = [];
  List<PackingItemAccesses> completePacking = [];

  String ownerName = '';

//untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TrackingNiagaCubit>(context)
        .trackingPencarianBarang(widget.noPL);
    BlocProvider.of<PackingNiagaCubit>(context).searchPackingUnComplete(
        pageIndex: pageIndex,
        noPL: widget.noPL,
        containerNo: '',
        asal: '',
        tujuan: '',
        vesselName: '');

    BlocProvider.of<PackingNiagaCubit>(context).searchPackingComplete(
        pageIndex: pageIndex,
        noPL: widget.noPL,
        containerNo: '',
        asal: '',
        tujuan: '',
        vesselName: '');
  }

  // This function builds the items dynamically based on the model
  //PTP COSD
  List<Map<String, String>> buildItemsFromModel(
      TrackingPtpCosdAccesses accessData) {
    return [
      {
        'title': 'Masuk Niaga',
        'subtitle': accessData.masukNiaga.namaGudang ?? '',
        'time': accessData.masukNiaga.formattedTime
      },
      {
        'title': 'Keluar Niaga',
        'subtitle': accessData.keluarNiaga.namaGudang ?? '',
        'time': accessData.keluarNiaga.formattedTime
      },
      {
        'title': 'Menuju Pelabuhan',
        'subtitle': '',
        'time': accessData.menujuPelabuhan.formattedTime
      }, // No data
      {
        'title': 'Muat Pelabuhan',
        'subtitle': accessData.muatPelabuhan.pelabuhanAsal ?? '',
        'time': accessData.muatPelabuhan.formattedTime
      },
      {
        'title': 'Bongkar Pelabuhan',
        'subtitle': accessData.bongkarPelabuhan.pelabuhan ?? '',
        'time': accessData.bongkarPelabuhan.formattedTime
      },
    ];
  }

  //PTP COSL
  List<Map<String, String>> buildItemsFromModel2(
      TrackingPtpCoslAccesses accessData) {
    return [
      {
        'title': 'Muat Pelabuhan',
        'subtitle': accessData.muatPelabuhan.pelabuhanAsal ?? '',
        'time': accessData.muatPelabuhan.formattedTime
      },
      {
        'title': 'Bongkar Pelabuhan',
        'subtitle': accessData.bongkarPelabuhan.pelabuhan ?? '',
        'time': accessData.bongkarPelabuhan.formattedTime
      },
    ];
  }

  //PTD COSL
  List<Map<String, String>> buildItemsFromModel3(
      TrackingPtdCoslAccesses accessData) {
    return [
      {
        'title': 'Muat Pelabuhan',
        'subtitle': accessData.muatPelabuhan.pelabuhanAsal ?? '',
        'time': accessData.muatPelabuhan.formattedTime
      },
      {
        'title': 'Bongkar Pelabuhan',
        'subtitle': accessData.bongkarPelabuhan.pelabuhan ?? '',
        'time': accessData.bongkarPelabuhan.formattedTime
      },
      {
        'title': 'Tiba',
        'subtitle': accessData.tiba.namaCustomerTiba ?? '',
        'time': accessData.tiba.formattedTime
      },
    ];
  }

  //PTD COSD
  List<Map<String, String>> buildItemsFromModel4(
      TrackingPtdCosdAccesses accessData) {
    return [
      {
        'title': 'Masuk Niaga',
        'subtitle': accessData.masukNiaga.namaGudang ?? '',
        'time': accessData.masukNiaga.formattedTime
      },
      {
        'title': 'Keluar Niaga',
        'subtitle': accessData.keluarNiaga.namaGudang ?? '',
        'time': accessData.keluarNiaga.formattedTime
      },
      {
        'title': 'Menuju Pelabuhan',
        'subtitle': '',
        'time': accessData.menujuPelabuhan.formattedTime
      },
      {
        'title': 'Muat Pelabuhan',
        'subtitle': accessData.muatPelabuhan.pelabuhanAsal ?? '',
        'time': accessData.muatPelabuhan.formattedTime
      },
      {
        'title': 'Bongkar Pelabuhan',
        'subtitle': accessData.bongkarPelabuhan.pelabuhan ?? '',
        'time': accessData.bongkarPelabuhan.formattedTime
      },
      {
        'title': 'Tiba',
        'subtitle': accessData.tiba.namaCustomerTiba ?? '',
        'time': accessData.tiba.formattedTime
      },
    ];
  }

  //DTD COSL
  List<Map<String, String>> buildItemsFromModel5(
      TrackingDtdCoslAccesses accessData) {
    return [
      {
        'title': 'Pengambilan Customer',
        'subtitle': accessData.pengambilanCustomer.namaCustomer ?? '',
        'time': accessData.pengambilanCustomer.formattedTime
      },
      {
        'title': 'Muat Pelabuhan',
        'subtitle': accessData.muatPelabuhan.pelabuhanAsal ?? '',
        'time': accessData.muatPelabuhan.formattedTime
      },
      {
        'title': 'Bongkar Pelabuhan',
        'subtitle': accessData.bongkarPelabuhan.pelabuhan ?? '',
        'time': accessData.bongkarPelabuhan.formattedTime
      },
      {
        'title': 'Tiba',
        'subtitle': accessData.tiba.namaCustomerTiba ?? '',
        'time': accessData.tiba.formattedTime
      },
    ];
  }

  //DTP COSL
  List<Map<String, String>> buildItemsFromModel6(
      TrackingDtpCoslAccesses accessData) {
    return [
      {
        'title': 'Pengambilan Customer',
        'subtitle': accessData.pengambilanCustomer.namaCustomer ?? '',
        'time': accessData.pengambilanCustomer.formattedTime
      },
      {
        'title': 'Muat Pelabuhan',
        'subtitle': accessData.muatPelabuhan.pelabuhanAsal ?? '',
        'time': accessData.muatPelabuhan.formattedTime
      },
      {
        'title': 'Bongkar Pelabuhan',
        'subtitle': accessData.bongkarPelabuhan.pelabuhan ?? '',
        'time': accessData.bongkarPelabuhan.formattedTime
      },
    ];
  }

  //ASTRA MOTOR
  List<Map<String, String>> buildItemsFromModel7(
      TrackingAstraAccesses accessData) {
    return [
      {
        'title': 'Dari Gudang Astra',
        // 'subtitle':
        //     '${accessData.dariGudangAstra.formattedTimePertama} / ${accessData.dariGudangAstra.formattedTimeTerakhir}',
        'subtitle': '',
        'time':
            '${accessData.dariGudangAstra.formattedTimePertama} - ${accessData.dariGudangAstra.formattedTimeTerakhir}',
      },
      {
        'title': 'Gudang Sby',
        // 'subtitle':
        //     '${accessData.gudangSby.formattedTimePertamaNiaga} / ${accessData.gudangSby.formattedTimeTerakhirNiaga}',
        'subtitle': '',
        'time':
            '${accessData.gudangSby.formattedTimePertamaNiaga} - ${accessData.gudangSby.formattedTimeTerakhirNiaga}',
      },
      {
        'title': 'Pembagian Motor',
        'subtitle': '',
        // 'time': accessData.pembagianMotor.toString(),
        'time': accessData.pembagianMotor?.isNotEmpty == true
            ? accessData.pembagianMotor.toString()
            : '',
      },
      {
        'title': 'Keluar Gudang',
        'subtitle': '',
        // 'time': accessData.keluarGudang.toString(),
        'time': (accessData.keluarGudang?.isNotEmpty == true
            ? accessData.keluarGudang
            : '')!,
      },
      {
        'title': 'Menuju Pelabuhan',
        'subtitle': '',
        // 'time': accessData.menujuPelabuhan.toString()
        'time': (accessData.menujuPelabuhan?.isNotEmpty == true
            ? accessData.menujuPelabuhan
            : '')!,
      },
      {
        'title': 'Muat Pelabuhan',
        'subtitle': '',
        // 'time': accessData.muatPelabuhan.toString()
        'time': (accessData.muatPelabuhan?.isNotEmpty == true
            ? accessData.muatPelabuhan
            : '')!,
      },
      {
        'title': 'Bongkar Pelabuhan',
        'subtitle': accessData.bongkarPelabuhan.pelabuhan ?? '',
        // 'time': accessData.bongkarPelabuhan.formattedTime
        'time': accessData.bongkarPelabuhan.formattedTime ?? '',
      },
      {
        'title': 'Tiba',
        'subtitle': accessData.tiba.namaCustomerTiba ?? '',
        // 'time': accessData.tiba.formattedTime
        'time': accessData.tiba.formattedTime ?? '',
      },
    ];
  }

  //PTP COSD
  void updateItemsPtpCosd(List<TrackingPtpCosdAccesses> accessDataList) {
    // Clear previous selected items
    selectedItems.clear();
    jamList.clear();

    // Iterate through each item in ptpCosdList
    for (var accessData in accessDataList) {
      // Build items from each accessData model
      selectedItems.addAll(buildItemsFromModel(accessData));

      jamList.add(accessData.masukNiaga.formattedTime); // Add tglMasuk
      jamList.add(accessData.keluarNiaga.formattedTime); // Add tglKeluar
      jamList.add(
          accessData.menujuPelabuhan.formattedTime); // Add tglMenujuPelabuhan
      jamList.add(accessData.muatPelabuhan.formattedTime); // Add etd
      jamList.add(accessData.bongkarPelabuhan.formattedTime); // Add eta
    }

    print('Updated selected items ptp cosd: $selectedItems');
    print('Updated jamList: $jamList');
  }

  //PTP COSL
  void updateItemsPtpCosl(List<TrackingPtpCoslAccesses> accessDataList) {
    // Clear previous selected items
    selectedItems.clear();
    jamList.clear();

    // Iterate through each item in ptpCosdList
    for (var accessData in accessDataList) {
      // Build items from each accessData model
      selectedItems.addAll(buildItemsFromModel2(accessData));

      jamList.add(accessData.muatPelabuhan.formattedTime); // Add etd
      jamList.add(accessData.bongkarPelabuhan.formattedTime); // Add eta
    }

    print('Updated selected items ptp cosl: $selectedItems');
    print('Updated jamList: $jamList');
  }

  //PTD COSL
  void updateItemsPtdCosl(List<TrackingPtdCoslAccesses> accessDataList) {
    // Clear previous selected items
    selectedItems.clear();
    jamList.clear();

    // Iterate through each item in ptpCosdList
    for (var accessData in accessDataList) {
      // Build items from each accessData model
      selectedItems.addAll(buildItemsFromModel3(accessData));

      jamList.add(accessData.muatPelabuhan.formattedTime); // Add etd
      jamList.add(accessData.bongkarPelabuhan.formattedTime); // Add eta
      jamList.add(accessData.tiba.formattedTime); // Add eta
    }

    print('Updated selected items ptd cosl: $selectedItems');
    print('Updated jamList: $jamList');
  }

  //PTD COSD
  void updateItemsPtdCosd(List<TrackingPtdCosdAccesses> accessDataList) {
    // Clear previous selected items
    selectedItems.clear();
    jamList.clear();

    // Iterate through each item in ptpCosdList
    for (var accessData in accessDataList) {
      // Build items from each accessData model
      selectedItems.addAll(buildItemsFromModel4(accessData));

      jamList.add(accessData.masukNiaga.formattedTime); // Add tglMasuk
      jamList.add(accessData.keluarNiaga.formattedTime); // Add tglKeluar
      jamList.add(
          accessData.menujuPelabuhan.formattedTime); // Add tglMenujuPelabuhan
      jamList.add(accessData.muatPelabuhan.formattedTime); // Add etd
      jamList.add(accessData.bongkarPelabuhan.formattedTime); // Add eta
      jamList.add(accessData.tiba.formattedTime); //
    }

    print('Updated selected items ptd cosd: $selectedItems');
    print('Updated jamList: $jamList');
  }

  //DTD COSL
  void updateItemsDtdCosl(List<TrackingDtdCoslAccesses> accessDataList) {
    // Clear previous selected items
    selectedItems.clear();
    jamList.clear();

    // Iterate through each item in ptpCosdList
    for (var accessData in accessDataList) {
      // Build items from each accessData model
      selectedItems.addAll(buildItemsFromModel5(accessData));

      jamList.add(accessData.pengambilanCustomer.formattedTime);
      jamList.add(accessData.muatPelabuhan.formattedTime); // Add etd
      jamList.add(accessData.bongkarPelabuhan.formattedTime); // Add eta
      jamList.add(accessData.tiba.formattedTime); // Add eta
    }

    print('Updated selected items dtd cosl: $selectedItems');
    print('Updated jamList: $jamList');
  }

  //DTP COSL
  void updateItemsDtpCosl(List<TrackingDtpCoslAccesses> accessDataList) {
    // Clear previous selected items
    selectedItems.clear();
    jamList.clear();

    // Iterate through each item in ptpCosdList
    for (var accessData in accessDataList) {
      // Build items from each accessData model
      selectedItems.addAll(buildItemsFromModel6(accessData));

      jamList.add(accessData.pengambilanCustomer.formattedTime);
      jamList.add(accessData.muatPelabuhan.formattedTime); // Add etd
      jamList.add(accessData.bongkarPelabuhan.formattedTime);
    }

    print('Updated selected items dtp cosl: $selectedItems');
    print('Updated jamList: $jamList');
  }

  //ASTRA MOTOR
  void updateItemsAstraMotor(List<TrackingAstraAccesses> accessDataList) {
    // Clear previous selected items
    selectedItems.clear();
    jamList.clear();

    // Iterate through each item in ptpCosdList
    for (var accessData in accessDataList) {
      // Build items from each accessData model
      selectedItems.addAll(buildItemsFromModel7(accessData));

      // jamList.add(accessData.dariGudangAstra.formattedTimePertama);
      // jamList.add(accessData.dariGudangAstra.formattedTimeTerakhir);
      // jamList.add(accessData.gudangSby.formattedTimePertamaNiaga);
      // jamList.add(accessData.gudangSby.formattedTimeTerakhirNiaga);
      jamList.add(accessData.formattedTimeBagiMotor);
      jamList.add(accessData.formattedTimeKeluarGudang);
      jamList.add(accessData.formattedTimeMenujuPelabuhan);
      jamList.add(accessData.formattedTimeMuatPelabuhan);
      jamList.add(accessData.bongkarPelabuhan.formattedTime);
      jamList.add(accessData.tiba.formattedTime);
    }

    print('Updated selected items dtp cosl: $selectedItems');
    print('Updated jamList: $jamList');
    while (jamList.length < selectedItems.length) {
      jamList.add('-');
    }
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  void determineItemsBasedOnTipePengiriman() {
    selectedItems.clear();
    print('Tipe Pengiriman: ${detailHeaderPencarian!.keterangan}');
    switch (detailHeaderPencarian!.keterangan?.trim()) {
      case 'DTD - COSL':
        // selectedItems = itemsDtdCosl;
        if (dtdCoslList.isNotEmpty) {
          print('dtdCoslList is not empty, updating items...');
          updateItemsDtdCosl(dtdCoslList); // Pass the entire list
        } else {
          print('dtdCoslList is empty');
        }
        break;
      case 'DTP - COSL':
        // selectedItems = itemsDtpCosl;
        if (dtpCoslList.isNotEmpty) {
          print('dtpCoslList is not empty, updating items...');
          updateItemsDtpCosl(dtpCoslList); // Pass the entire list
        } else {
          print('dtpCoslList is empty');
        }
        break;
      case 'PTD - COSD':
        // selectedItems = itemsPtdCosd;
        if (ptdCosdList.isNotEmpty) {
          print('ptdCosdList is not empty, updating items...');
          updateItemsPtdCosd(ptdCosdList); // Pass the entire list
        } else {
          print('ptdCosdList is empty');
        }
        break;
      case 'PTD - COSL':
        // selectedItems = itemsPtdCosl;
        if (ptdCoslList.isNotEmpty) {
          print('ptdCoslList is not empty, updating items...');
          updateItemsPtdCosl(ptdCoslList); // Pass the entire list
        } else {
          print('ptdCoslList is empty');
        }
        break;
      case 'PTP - COSD':
        // selectedItems = itemsPtpCosd;
        // if (ptpCosdList.isNotEmpty) {
        //   updateItemsPtpCosd(ptpCosdList
        //       .first); // Use your logic to select the correct model data
        // }
        if (ptpCosdList.isNotEmpty) {
          print('ptpCosdList is not empty, updating items...');
          updateItemsPtpCosd(ptpCosdList); // Pass the entire list
        } else {
          print('ptpCosdList is empty');
        }
        break;
      case 'PTP - COSL':
        // selectedItems = itemsPtpCosl;
        if (ptpCoslList.isNotEmpty) {
          print('ptpCoslList is not empty, updating items...');
          updateItemsPtpCosl(ptpCoslList); // Pass the entire list
        } else {
          print('ptpCoslList is empty');
        }
        break;
      case 'PTD - COSD MOTOR':
        // selectedItems = itemsPtdCosl;
        if (astraMotorList.isNotEmpty) {
          print('astraMotorList is not empty, updating items...');
          updateItemsAstraMotor(astraMotorList); // Pass the entire list
          syncJamListWithSelectedItems();
        } else {
          print('astraMotorList is empty');
        }
        break;
      default:
        selectedItems = []; // Fallback if none match
        break;
    }
    print('Selected items length: ${selectedItems.length}');
  }

  // final List<Map<String, String>> itemsPtpCosd = [
  //   {'title': 'Masuk Niaga', 'subtitle': 'Gudang Niaga'},
  //   {'title': 'Keluar Niaga', 'subtitle': 'Gudang Niaga 2'},
  //   {'title': 'Menuju Pelabuhan', 'subtitle': 'Gudang Niaga 3'},
  //   {'title': 'Muat Pelabuhan', 'subtitle': 'SBY'},
  //   {'title': 'Bongkar Pelabuhan', 'subtitle': 'NBR'},
  // ];

  // final List<Map<String, String>> itemsPtpCosl = [
  //   {'title': 'Muat Pelabuhan', 'subtitle': 'SBY'},
  //   {'title': 'Bongkar Pelabuhan', 'subtitle': 'NBR'},
  // ];

  // final List<Map<String, String>> itemsDtdCosl = [
  //   {'title': 'Pengambilan Customer', 'subtitle': 'SBY'},
  //   {'title': 'Muat Pelabuhan', 'subtitle': 'NBR'},
  //   {'title': 'Bongkar Pelabuhan', 'subtitle': 'NBR'},
  //   {'title': 'Tiba', 'subtitle': 'NBR'},
  // ];

  // final List<Map<String, String>> itemsDtpCosl = [
  //   {'title': 'Pengambilan Customer', 'subtitle': 'SBY'},
  //   {'title': 'Muat Pelabuhan', 'subtitle': 'NBR'},
  //   {'title': 'Bongkar Pelabuhan', 'subtitle': 'NBR'},
  // ];

  // final List<Map<String, String>> itemsPtdCosd = [
  //   {'title': 'Masuk Niaga', 'subtitle': 'Gudang Niaga'},
  //   {'title': 'Keluar Niaga', 'subtitle': 'Gudang Niaga 2'},
  //   {'title': 'Menuju Pelabuhan', 'subtitle': 'Gudang Niaga 3'},
  //   {'title': 'Muat Pelabuhan', 'subtitle': 'SBY'},
  //   {'title': 'Bongkar Pelabuhan', 'subtitle': 'NBR'},
  //   {'title': 'Tiba', 'subtitle': 'NBR'},
  // ];

  // final List<Map<String, String>> itemsPtdCosl = [
  //   {'title': 'Muat Pelabuhan', 'subtitle': 'SBY'},
  //   {'title': 'Bongkar Pelabuhan', 'subtitle': 'NBR'},
  //   {'title': 'Tiba', 'subtitle': 'NBR'},
  // ];

  final List<String> jamList = [
    '20/02/2023',
    '21/02/2023',
    '22/02/2023',
    '23/02/2023',
    '24/02/2023',
  ];

  void updateOwnerNameFromList() {
    switch (detailHeaderPencarian!.keterangan?.trim()) {
      case 'PTP - COSD':
        if (ptpCosdList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = ptpCosdList.first.header.isNotEmpty
              ? ptpCosdList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'PTP - COSL':
        if (ptpCoslList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = ptpCoslList.first.header.isNotEmpty
              ? ptpCoslList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'DTD - COSL':
        if (dtdCoslList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = dtdCoslList.first.header.isNotEmpty
              ? dtdCoslList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'DTP - COSL':
        if (dtpCoslList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = dtpCoslList.first.header.isNotEmpty
              ? dtpCoslList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'PTD - COSD':
        if (ptdCosdList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = ptdCosdList.first.header.isNotEmpty
              ? ptdCosdList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'PTD - COSL':
        if (ptdCoslList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = ptdCoslList.first.header.isNotEmpty
              ? ptdCoslList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'PTD - COSD MOTOR':
        if (astraMotorList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = astraMotorList.first.header.isNotEmpty
              ? astraMotorList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      default:
        ownerName = 'Unknown';
        break;
    }
  }

  Future<bool> _onWillPop() async {
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => HomeNiagaPage()),
    // );
    Navigator.of(context).popUntil((route) => route.isFirst);
    return false; // Prevent default back navigation
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            0.07 * MediaQuery.of(context).size.height,
          ),
          child: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                // Navigator.pop(context, true);
                Navigator.of(context).popUntil((route) => route.isFirst);
                // Navigator.pushReplacement(
                //   context,
                //   MaterialPageRoute(builder: (context) => HomeNiagaPage()),
                // );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Lacak Pengiriman",
                    style: TextStyle(
                      fontSize: 17,
                      color: Colors.red[900],
                      fontFamily: 'Poppin',
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
          ),
        ),
        body: BlocConsumer<PackingNiagaCubit, PackingNiagaState>(
            listener: (context, state) {
          if (state is SearchPackingCompleteSuccess) {
            setState(() {
              completePacking.clear();

              // Convert List<CloseInvoiceAccesses> to List<packingItemAccesses>
              completePacking = state.response
                  .expand((packingAccess) => packingAccess.data)
                  .toList();
            });
          } else if (state is SearchPackingUnCompleteSuccess) {
            setState(() {
              onProgressPacking.clear();

              // Convert List<CloseInvoiceAccesses> to List<packingItemAccesses>
              onProgressPacking = state.response
                  .expand((packingAccess) => packingAccess.data)
                  .toList();
            });
          }
        }, builder: (context, state) {
          return BlocConsumer<TrackingNiagaCubit, TrackingNiagaState>(
              listener: (context, state) {
            if (state is TrackingPTPCOSDFailure ||
                state is TrackingPTPCOSLFailure ||
                state is TrackingDTDCOSLFailure ||
                state is TrackingDTPCOSLFailure ||
                state is TrackingPTDCOSDFailure ||
                state is TrackingPTDCOSLFailure ||
                state is TrackingAstraMotorFailure) {
              // Handle error state
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error ')),
              );
            } else if (state is TrackingPTPCOSDSuccess) {
              print('PTP-COSD Data: ${state.response}');
              ptpCosdList.clear();
              ptpCosdList = state.response;
              // ptpCosdList = state.response;
              determineItemsBasedOnTipePengiriman();
              updateOwnerNameFromList();
            } else if (state is TrackingPTPCOSLSuccess) {
              ptpCoslList.clear();
              ptpCoslList = state.response;
              determineItemsBasedOnTipePengiriman();
              updateOwnerNameFromList();
            } else if (state is TrackingDTDCOSLSuccess) {
              dtdCoslList.clear();
              dtdCoslList = state.response;
              determineItemsBasedOnTipePengiriman();
              updateOwnerNameFromList();
            } else if (state is TrackingDTPCOSLSuccess) {
              dtpCoslList.clear();
              dtpCoslList = state.response;
              determineItemsBasedOnTipePengiriman();
              updateOwnerNameFromList();
            } else if (state is TrackingPTDCOSDSuccess) {
              ptdCosdList.clear();
              ptdCosdList = state.response;
              determineItemsBasedOnTipePengiriman();
              updateOwnerNameFromList();
            } else if (state is TrackingPTDCOSLSuccess) {
              ptdCoslList.clear();
              ptdCoslList = state.response;
              determineItemsBasedOnTipePengiriman();
              updateOwnerNameFromList();
            } else if (state is TrackingAstraMotorSuccess) {
              astraMotorList.clear();
              astraMotorList = state.response;
              determineItemsBasedOnTipePengiriman();
              updateOwnerNameFromList();
            } else if (state is TrackingPencarianBarangSuccess) {
              if (state.response.header.isNotEmpty) {
                detailHeaderPencarian = state.response.header.first;

                if (detailHeaderPencarian?.keterangan == 'PTP - COSD') {
                  BlocProvider.of<TrackingNiagaCubit>(context)
                      .trackingPTPCOSD(widget.noPL);
                } else if (detailHeaderPencarian?.keterangan == 'PTP - COSL') {
                  BlocProvider.of<TrackingNiagaCubit>(context)
                      .trackingPTPCOSL(widget.noPL);
                } else if (detailHeaderPencarian?.keterangan == 'PTD - COSL') {
                  BlocProvider.of<TrackingNiagaCubit>(context)
                      .trackingPTDCOSL(widget.noPL);
                } else if (detailHeaderPencarian?.keterangan == 'DTD - COSL') {
                  BlocProvider.of<TrackingNiagaCubit>(context)
                      .trackingDTDCOSL(widget.noPL);
                } else if (detailHeaderPencarian?.keterangan == 'DTP - COSL') {
                  BlocProvider.of<TrackingNiagaCubit>(context)
                      .trackingDTPCOSL(widget.noPL);
                } else if (detailHeaderPencarian?.keterangan == 'PTD - COSD') {
                  BlocProvider.of<TrackingNiagaCubit>(context)
                      .trackingPTDCOSD(widget.noPL);
                } else if (detailHeaderPencarian?.keterangan ==
                    'PTD - COSD MOTOR') {
                  BlocProvider.of<TrackingNiagaCubit>(context)
                      .trackingAstraMotor(widget.noPL);
                }
              } else {
                detailHeaderPencarian = null; // Handle empty list case
              }
            }
          }, builder: (context, state) {
            if (selectedItems.isEmpty) {
              return Center(
                child: CircularProgressIndicator(), // Show a loading indicator
              );
            } else if (state is TrackingPencarianBarangInProgress) {
              return Center(
                child: CircularProgressIndicator(), // Show a loading indicator
              );
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                            alignment: Alignment.topCenter,
                            margin: EdgeInsets.all(16),
                            width: mediaQuery.size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(
                                      0xFFB0BEC5), // A color close to grey[350]
                                  offset: Offset(0, 6),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                children: [
                                  SizedBox(height: 25),
                                  Center(
                                    child: Text(
                                      detailHeaderPencarian?.noPl ?? 'N/A',
                                      // '',
                                      style: TextStyle(
                                          color: Colors.red[900],
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16),
                                    ),
                                    // Text(widget.invoice.invoiceNo!),
                                  ),
                                  SizedBox(height: 30),
                                  Table(
                                    columnWidths: {
                                      0: FlexColumnWidth(3),
                                      1: FlexColumnWidth(1),
                                      2: FlexColumnWidth(5),
                                    },
                                    children: [
                                      TableRow(children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                              'Tipe Pengiriman',
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(':'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                              detailHeaderPencarian
                                                      ?.keterangan ??
                                                  'N/A',
                                            ),
                                          ),
                                        )
                                      ]),
                                      //Volume
                                      if (completePacking.isNotEmpty &&
                                          completePacking.first.status ==
                                              'COMPLETE')
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Volume',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                              completePacking.isNotEmpty
                                                  ? completePacking
                                                          .first.volume ??
                                                      'N/A'
                                                  : 'N/A',
                                            ),
                                          ))
                                        ]),
                                      if (onProgressPacking.isNotEmpty &&
                                          onProgressPacking.first.status ==
                                              'UN_COMPLETE')
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Volume',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                              onProgressPacking.isNotEmpty
                                                  ? onProgressPacking
                                                          .first.volume ??
                                                      'N/A'
                                                  : 'N/A',
                                            ),
                                          ))
                                        ]),
                                      //baris ke 2 rute
                                      if (completePacking.isNotEmpty &&
                                          completePacking.first.status ==
                                              'COMPLETE')
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Rute Pengiriman',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(completePacking
                                                    .isNotEmpty
                                                ? completePacking.first.rute ??
                                                    'N/A'
                                                : 'N/A'),
                                          ))
                                        ]),
                                      if (onProgressPacking.isNotEmpty &&
                                          onProgressPacking.first.status ==
                                              'UN_COMPLETE')
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Rute Pengiriman',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                                onProgressPacking.isNotEmpty
                                                    ? onProgressPacking
                                                            .first.rute ??
                                                        'N/A'
                                                    : 'N/A'),
                                          ))
                                        ]),
                                      //baris ke 3 Kapal
                                      if (completePacking.isNotEmpty &&
                                          completePacking.first.status ==
                                              'COMPLETE')
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Nama Kapal',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                                completePacking.isNotEmpty
                                                    ? completePacking
                                                            .first.vesselName ??
                                                        'N/A'
                                                    : 'N/A'),
                                          ))
                                        ]),
                                      if (onProgressPacking.isNotEmpty &&
                                          onProgressPacking.first.status ==
                                              'UN_COMPLETE')
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Nama Kapal',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                                onProgressPacking.isNotEmpty
                                                    ? onProgressPacking
                                                            .first.vesselName ??
                                                        'N/A'
                                                    : 'N/A'),
                                          ))
                                        ]),
                                      //baris ke 4 nama status
                                      if (completePacking.isNotEmpty &&
                                          completePacking.first.status ==
                                              'COMPLETE')
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                                completePacking.isNotEmpty
                                                    ? completePacking
                                                            .first.status ??
                                                        'N/A'
                                                    : 'N/A'),
                                          ))
                                        ]),
                                      if (onProgressPacking.isNotEmpty &&
                                          onProgressPacking.first.status ==
                                              'UN_COMPLETE')
                                        TableRow(children: [
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                'Status',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 2.0),
                                              child: Text(
                                                ':',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal),
                                              ),
                                            ),
                                          ),
                                          TableCell(
                                              child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                                onProgressPacking.isNotEmpty
                                                    ? onProgressPacking
                                                            .first.status ??
                                                        'N/A'
                                                    : 'N/A'),
                                          ))
                                        ]),
                                    ],
                                  ),
                                  SizedBox(height: 60),
                                  // Stack(
                                  //   children: [
                                  //     Row(
                                  //       mainAxisAlignment:
                                  //           MainAxisAlignment.start,
                                  //       children: [
                                  //         Column(
                                  //           children: List.generate(
                                  //               selectedItems.length, (index) {
                                  //             return Column(
                                  //               children: [
                                  //                 Container(
                                  //                   width: 10,
                                  //                   height: 10,
                                  //                   decoration: BoxDecoration(
                                  //                     shape: BoxShape.circle,
                                  //                     color: Colors.red[900],
                                  //                   ),
                                  //                 ),
                                  //                 if (index !=
                                  //                     selectedItems.length - 1)
                                  //                   Container(
                                  //                     height: 65,
                                  //                     child: VerticalDivider(
                                  //                       color: Colors.grey[600],
                                  //                       thickness: 3,
                                  //                     ),
                                  //                   ),
                                  //               ],
                                  //             );
                                  //           }),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //     Padding(
                                  //       padding: const EdgeInsets.only(left: 30),
                                  //       child: Column(
                                  //         crossAxisAlignment:
                                  //             CrossAxisAlignment.start,
                                  //         children: List.generate(
                                  //             selectedItems.length, (index) {
                                  //           return Padding(
                                  //             padding: const EdgeInsets.only(
                                  //                 bottom: 34.0),
                                  //             child: Column(
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.start,
                                  //               children: [
                                  //                 Text(selectedItems[index]
                                  //                     ['title']!),
                                  //                 SizedBox(height: 8),
                                  //                 Text(
                                  //                   selectedItems[index]
                                  //                       ['subtitle']!,
                                  //                   maxLines: 2,
                                  //                 ),
                                  //               ],
                                  //             ),
                                  //           );
                                  //         }),
                                  //       ),
                                  //     ),
                                  //     Row(
                                  //       mainAxisAlignment: MainAxisAlignment.end,
                                  //       children: [
                                  //         Expanded(
                                  //           child: Column(
                                  //             crossAxisAlignment:
                                  //                 CrossAxisAlignment.end,
                                  //             children: List.generate(
                                  //                 jamList.length, (index) {
                                  //               String time =
                                  //                   index < jamList.length
                                  //                       ? jamList[index]
                                  //                       : '-';
                                  //               return Padding(
                                  //                 padding: const EdgeInsets.only(
                                  //                     right: 16.0, bottom: 60.0),
                                  //                 // child: Text(jamList[index]),
                                  //                  child: Text(time),
                                  //               );
                                  //             }),
                                  //           ),
                                  //         ),
                                  //       ],
                                  //     ),
                                  //   ],
                                  // ),
                                  //NEW
                                  Stack(
                                    children: [
                                      // Left: Dots and dividers
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Column(
                                            children: List.generate(
                                                selectedItems.length, (index) {
                                              return Column(
                                                children: [
                                                  Container(
                                                    width: 10,
                                                    height: 10,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.red[900],
                                                    ),
                                                  ),
                                                  if (index !=
                                                      selectedItems.length - 1)
                                                    Container(
                                                      height: 65,
                                                      child: VerticalDivider(
                                                        color: Colors.grey[600],
                                                        thickness: 3,
                                                      ),
                                                    ),
                                                ],
                                              );
                                            }),
                                          ),
                                        ],
                                      ),

                                      // Center: Title and Subtitle
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 30),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: List.generate(
                                              selectedItems.length, (index) {
                                            final item = selectedItems[index];
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 34.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Title
                                                  Text(
                                                    item['title']!,
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                  // Subtitle
                                                  Text(
                                                    item['subtitle']!.isNotEmpty
                                                        ? item['subtitle']!
                                                        : '',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey[700],
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            );
                                          }),
                                        ),
                                      ),

                                      // Right: Time
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: List.generate(
                                                  selectedItems.length,
                                                  (index) {
                                                final item =
                                                    selectedItems[index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 16.0,
                                                          bottom: 60.0),
                                                  child: Text(
                                                    item['time']!.isNotEmpty
                                                        ? item['time']!
                                                        : '-',
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      // fontStyle: FontStyle.italic,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                      ),
                    ],
                  ),
                  if (state is TrackingPTPCOSDFailure ||
                      state is TrackingPTPCOSLFailure ||
                      state is TrackingDTDCOSLFailure ||
                      state is TrackingDTPCOSLFailure ||
                      state is TrackingPTDCOSDFailure ||
                      state is TrackingPTDCOSLFailure)
                    Center(
                        child: Column(
                      children: [
                        SizedBox(height: 10),
                        SizedBox(
                          child: Image.asset(
                            'assets/pencarian daftar harga.png',
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Tidak ada data yang dapat ditampilkan',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )),
                  if (state is TrackingPTPCOSDFailure ||
                      state is TrackingPTPCOSLFailure ||
                      state is TrackingDTDCOSLFailure ||
                      state is TrackingDTPCOSLFailure ||
                      state is TrackingPTDCOSDFailure ||
                      state is TrackingPTDCOSLFailure)
                    Center(
                        child: Column(
                      children: [
                        SizedBox(height: 10),
                        SizedBox(
                          child: Image.asset(
                            'assets/pencarian daftar harga.png',
                          ),
                        ),
                        SizedBox(height: 15),
                        Text(
                          'Tidak ada data yang dapat ditampilkan',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )),
                  SizedBox(height: 15.0),
                  // Additional containers (container 2, container 3, container 4)
                ],
              ),
            );
          });
        }),
      ),
    );
  }

  void syncJamListWithSelectedItems() {
    if (jamList.length < selectedItems.length) {
      // Pad with default values
      jamList.addAll(
          List.generate(selectedItems.length - jamList.length, (index) => '-'));
    } else if (jamList.length > selectedItems.length) {
      // Trim excess values
      jamList.removeRange(selectedItems.length, jamList.length);
    }
  }
}
