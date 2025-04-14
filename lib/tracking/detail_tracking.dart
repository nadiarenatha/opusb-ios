import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/tracking/menu_tracking_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/tracking_niaga_cubit.dart';
import '../model/niaga/packing_detail_niaga.dart';
import '../model/niaga/tracking/ptp-cosd/dtd-cosl/tracking_dtd_cosl.dart';
import '../model/niaga/tracking/ptp-cosd/dtp-cosl/tracking_dtp_cosl.dart';
import '../model/niaga/tracking/ptp-cosd/ptd-cosd/tracking_ptd_cosd.dart';
import '../model/niaga/tracking/ptp-cosd/ptd-cosl/tracking_ptd_cosl.dart';
import '../model/niaga/tracking/ptp-cosd/ptp-cosl/tracking_ptp_cosl.dart';
import '../model/niaga/tracking/ptp-cosd/tracking_ptp_cosd.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';

class DetailJenisTrackingNiaga extends StatefulWidget {
  final PackingItemAccesses tracking; 
  const DetailJenisTrackingNiaga({Key? key, required this.tracking})
      : super(key: key);

  @override
  State<DetailJenisTrackingNiaga> createState() =>
      _DetailJenisTrackingNiagaState();
}

class _DetailJenisTrackingNiagaState extends State<DetailJenisTrackingNiaga> {
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
  List<Map<String, String>> selectedItems = [];
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
    final String noPL = widget.tracking.noPL ?? '';
    if (widget.tracking.tipePengiriman == 'PTP-COSD') {
      BlocProvider.of<TrackingNiagaCubit>(context).trackingPTPCOSD(noPL);
    } else if (widget.tracking.tipePengiriman == 'PTP-COSL') {
      BlocProvider.of<TrackingNiagaCubit>(context).trackingPTPCOSL(noPL);
    } else if (widget.tracking.tipePengiriman == 'PTD-COSL') {
      BlocProvider.of<TrackingNiagaCubit>(context).trackingPTDCOSL(noPL);
    } else if (widget.tracking.tipePengiriman == 'DTD-COSL') {
      BlocProvider.of<TrackingNiagaCubit>(context).trackingDTDCOSL(noPL);
    } else if (widget.tracking.tipePengiriman == 'DTP-COSL') {
      BlocProvider.of<TrackingNiagaCubit>(context).trackingDTPCOSL(noPL);
    } else if (widget.tracking.tipePengiriman == 'PTD-COSD') {
      BlocProvider.of<TrackingNiagaCubit>(context).trackingPTDCOSD(noPL);
    }
    // BlocProvider.of<TrackingNiagaCubit>(context).trackingPTPCOSD(noPL);
    // BlocProvider.of<TrackingNiagaCubit>(context).trackingPTPCOSL(noPL);
    // BlocProvider.of<TrackingNiagaCubit>(context).trackingPTDCOSL(noPL);
    // BlocProvider.of<TrackingNiagaCubit>(context).trackingDTDCOSL(noPL);
    // BlocProvider.of<TrackingNiagaCubit>(context).trackingDTPCOSL(noPL);
    // BlocProvider.of<TrackingNiagaCubit>(context).trackingPTDCOSD(noPL);
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

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  void determineItemsBasedOnTipePengiriman() {
    selectedItems.clear();
    print('Tipe Pengiriman: ${widget.tracking.tipePengiriman}');
    switch (widget.tracking.tipePengiriman?.trim()) {
      case 'DTD-COSL':
        // selectedItems = itemsDtdCosl;
        if (dtdCoslList.isNotEmpty) {
          print('dtdCoslList is not empty, updating items...');
          updateItemsDtdCosl(dtdCoslList); // Pass the entire list
        } else {
          print('dtdCoslList is empty');
        }
        break;
      case 'DTP-COSL':
        // selectedItems = itemsDtpCosl;
        if (dtpCoslList.isNotEmpty) {
          print('dtpCoslList is not empty, updating items...');
          updateItemsDtpCosl(dtpCoslList); // Pass the entire list
        } else {
          print('dtpCoslList is empty');
        }
        break;
      case 'PTD-COSD':
        // selectedItems = itemsPtdCosd;
        if (ptdCosdList.isNotEmpty) {
          print('ptdCosdList is not empty, updating items...');
          updateItemsPtdCosd(ptdCosdList); // Pass the entire list
        } else {
          print('ptdCosdList is empty');
        }
        break;
      case 'PTD-COSL':
        // selectedItems = itemsPtdCosl;
        if (ptdCoslList.isNotEmpty) {
          print('ptdCoslList is not empty, updating items...');
          updateItemsPtdCosl(ptdCoslList); // Pass the entire list
        } else {
          print('ptdCoslList is empty');
        }
        break;
      case 'PTP-COSD':
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
      case 'PTP-COSL':
        // selectedItems = itemsPtpCosl;
        if (ptpCoslList.isNotEmpty) {
          print('ptpCoslList is not empty, updating items...');
          updateItemsPtpCosl(ptpCoslList); // Pass the entire list
        } else {
          print('ptpCoslList is empty');
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
    switch (widget.tracking.tipePengiriman?.trim()) {
      case 'PTP-COSD':
        if (ptpCosdList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = ptpCosdList.first.header.isNotEmpty
              ? ptpCosdList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'PTP-COSL':
        if (ptpCoslList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = ptpCoslList.first.header.isNotEmpty
              ? ptpCoslList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'DTD-COSL':
        if (dtdCoslList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = dtdCoslList.first.header.isNotEmpty
              ? dtdCoslList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'DTP-COSL':
        if (dtpCoslList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = dtpCoslList.first.header.isNotEmpty
              ? dtpCoslList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'PTD-COSD':
        if (ptdCosdList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = ptdCosdList.first.header.isNotEmpty
              ? ptdCosdList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      case 'PTD-CPSL':
        if (ptdCoslList.isNotEmpty) {
          // Access the header of the first element in the list
          ownerName = ptdCoslList.first.header.isNotEmpty
              ? ptdCoslList.first.header.first.ownerName ?? ''
              : 'Unknown';
        }
        break;
      default:
        ownerName = 'Unknown';
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // final headerItem =
    //     widget.tracking.header.isNotEmpty ? widget.tracking.header[0] : null;
    var tracking = widget.tracking;

    return Scaffold(
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
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Lacak Pengiriman",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[900],
                      fontFamily: 'Poppins Extra Bold'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: BlocConsumer<TrackingNiagaCubit, TrackingNiagaState>(
          listener: (context, state) {
        if (state is TrackingPTPCOSDFailure ||
            state is TrackingPTPCOSLFailure ||
            state is TrackingDTDCOSLFailure ||
            state is TrackingDTPCOSLFailure ||
            state is TrackingPTDCOSDFailure ||
            state is TrackingPTDCOSLFailure) {
          // Handle error state
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error ')),
          );
        } else if (state is TrackingPTPCOSDSuccess) {
          print('PTP-COSD Data: ${state.response}');
          ptpCosdList.clear();
          ptpCosdList = state.response;
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
        }
      }, builder: (context, state) {
        if (selectedItems.isEmpty) {
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
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Color.fromARGB(255, 196, 193, 193),
                            width: 1.0,
                          ),
                          // boxShadow: [
                          //   BoxShadow(
                          //     color: Color(
                          //         0xFFB0BEC5), // A color close to grey[350]
                          //     offset: Offset(0, 6),
                          //     blurRadius: 10,
                          //     spreadRadius: 1,
                          //   ),
                          // ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              Center(
                                child: Text(
                                  widget.tracking.noPL.toString(),
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontFamily: 'Poppins Bold',
                                      fontSize: 15),
                                ),
                                // Text(widget.invoice.invoiceNo!),
                              ),
                              SizedBox(height: 15),
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
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          widget.tracking.tipePengiriman
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    )
                                  ]),
                                  //baris ke 2 volume
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Volume',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                          widget.tracking.volume.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12)),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Rute Pengiriman',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                          widget.tracking.rute
                                              .toString(),
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12)),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Nama Kapal',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                          widget.tracking.vesselName.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12)),
                                    ))
                                  ]),
                                  TableRow(children: [
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          'Status',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          ':',
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12),
                                        ),
                                      ),
                                    ),
                                    TableCell(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                          widget.tracking.status.toString(),
                                          style: TextStyle(
                                              fontFamily: 'Poppins Med',
                                              fontSize: 12)),
                                    ))
                                  ]),
                                ],
                              ),
                              SizedBox(height: 30),
                              //tracking line
                              // Stack(
                              //   children: [
                              //     Row(
                              //       mainAxisAlignment: MainAxisAlignment.start,
                              //       children: [
                              //         Column(
                              //           children: List.generate(
                              //               itemsPtpCosd.length, (index)
                              //               {
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
                              //                     itemsPtpCosd.length -
                              //                         1) // Only add the divider if it's not the last item
                              //                   Container(
                              //                     height:
                              //                         65, // Adjust the height as needed
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
                              //             itemsPtpCosd.length, (index) {
                              //           return Padding(
                              //             padding: const EdgeInsets.only(
                              //                 bottom: 34.0),
                              //             child: Column(
                              //               crossAxisAlignment:
                              //                   CrossAxisAlignment.start,
                              //               children: [
                              //                 Text(itemsPtpCosd[index]
                              //                     ['title']!),
                              //                 SizedBox(height: 8),
                              //                 Text(
                              //                   itemsPtpCosd[index]
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
                              //               return Padding(
                              //                 padding: const EdgeInsets.only(
                              //                     right: 16.0, bottom: 60.0),
                              //                 child: Text(jamList[index]),
                              //               );
                              //             }),
                              //           ),
                              //         ),
                              //       ],
                              //     ),
                              //   ],
                              // ),
                              Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: List.generate(
                                          selectedItems.length, (index) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 31.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectedItems[index]['title']!,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins Med',
                                                    fontSize: 12),
                                              ),
                                              SizedBox(height: 7),
                                              Text(
                                                selectedItems[index]
                                                    ['subtitle']!,
                                                style: TextStyle(
                                                    fontFamily: 'Poppins Med',
                                                    fontSize: 10),
                                                maxLines: 2,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: List.generate(
                                              jamList.length, (index) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 16.0, bottom: 60.0),
                                              child: Text(
                                                jamList[index],
                                                style: TextStyle(
                                                    fontFamily: 'Poppins Med',
                                                    fontSize: 11),
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
              SizedBox(height: 10)
              // Additional containers (container 2, container 3, container 4)
            ],
          ),
        );
      }),
      // bottomNavigationBar: Container(
      //   decoration: BoxDecoration(
      //     boxShadow: [
      //       BoxShadow(
      //         color: Colors.grey.withOpacity(0.5), // Shadow color
      //         spreadRadius: 5, // How much the shadow spreads
      //         blurRadius: 7, // How soft the shadow looks
      //         offset: Offset(0, 3), // Changes position of the shadow
      //       ),
      //     ],
      //   ),
      //   child: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     items: <BottomNavigationBarItem>[
      //       const BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.dashboard,
      //           size: 27,
      //         ),
      //         label: 'Order',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: SizedBox(
      //           width: 23,
      //           child: ImageIcon(
      //             AssetImage('assets/tracking icon.png'),
      //           ),
      //         ),
      //         label: 'Tracking',
      //       ),
      //       // BottomNavigationBarItem(
      //       //   icon: Stack(
      //       //     alignment:
      //       //         Alignment.center, // Centers the icon inside the circle
      //       //     children: <Widget>[
      //       //       Container(
      //       //         height: 40, // Adjust size of the circle
      //       //         width: 40,
      //       //         decoration: BoxDecoration(
      //       //           color: Colors.red[900], // Red circle color
      //       //           shape: BoxShape.circle,
      //       //         ),
      //       //       ),
      //       //       Icon(
      //       //         Icons.home,
      //       //         color:
      //       //             Colors.white, // Icon color (optional for visibility)
      //       //       ),
      //       //     ],
      //       //   ),
      //       //   label: 'Home',
      //       // ),
      //       BottomNavigationBarItem(
      //         icon: Stack(
      //           alignment: Alignment.center,
      //           children: <Widget>[
      //             Container(
      //               height: 50, // Adjusted size of the circle
      //               width: 50,
      //               decoration: BoxDecoration(
      //                 color: Colors.red[900], // Red circle color
      //                 shape: BoxShape.circle,
      //               ),
      //             ),
      //             Icon(
      //               Icons.home,
      //               size: 28,
      //               color: Colors.white,
      //             ),
      //           ],
      //         ),
      //         label: '',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: SizedBox(
      //           width: 12,
      //           child: ImageIcon(
      //             AssetImage('assets/invoice icon.png'),
      //           ),
      //         ),
      //         label: 'Invoice',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: Icon(
      //           Icons.person,
      //           size: 27,
      //         ),
      //         label: 'Profil',
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     // selectedItemColor: Colors.grey[600],
      //     selectedItemColor: _selectedIndex == 1
      //         ? Colors.red[900] // Highlight the tracking icon in red
      //         : Colors.grey[600],
      //     onTap: _onItemTapped,
      //   ),
      // )
    );
  }
}
