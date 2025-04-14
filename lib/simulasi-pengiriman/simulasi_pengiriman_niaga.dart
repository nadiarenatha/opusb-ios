import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/order_online_fcl_cubit.dart';
import '../cubit/niaga/simulasi_harga_cubit.dart';
import '../model/niaga/port_asal_fcl.dart';
import '../model/niaga/port_tujuan_fcl.dart';
import '../model/niaga/simulasi_harga.dart';
import '../order/menu_order_niaga.dart';
import '../pemesanan/cek_detail_simulasi.dart';
import '../pemesanan/cek_harga_detail_barang.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:dropdown_search/dropdown_search.dart';

class SimulasiPengirimanNiagaPage extends StatefulWidget {
  const SimulasiPengirimanNiagaPage({Key? key}) : super(key: key);

  @override
  State<SimulasiPengirimanNiagaPage> createState() =>
      _SimulasiPengirimanNiagaPageState();
}

class _SimulasiPengirimanNiagaPageState
    extends State<SimulasiPengirimanNiagaPage> {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  String? selectedKotaAsal;
  String? selectedKotaTujuan;
  String? selectedPortAsal;
  String? selectedPortTujuan;
  List<String> kotaAsalList = [];
  List<String> kotaTujuanList = [];
  Map<String, List<String>> kotaTujuanMap = {}; // Map kotaAsal to kotaTujuan
  List<PortAsalFCLAccesses> portAsalModellist = [];
  List<PortTujuanFCLAccesses> portTujuanModellist = [];
  Map<String, String> portAsalToKotaAsalMap = {}; // Maps portAsal to kotaAsal
  bool isFetchingKotaTujuan = false;
  bool isFetchingKotaTujuanLCL = false;

  //LCL
  Map<String, String> kotaTujuanToPortTujuanMapLCL = {};
  Map<String, String> portAsalToKotaAsalLCLMap = {};
  List<String> kotaAsalLCLList = [];
  String? selectedKotaTujuanLCL;
  List<String> kotaTujuanListLCL = [];
  String? selectedPortAsalLCL;
  String? selectedKotaAsalLCL;
  String? selectedPortTujuanLCL;

  bool _showCekHarga = false;
  String? jenisPengiriman;
  List<SimulasiHargaAccesses> hargaModellist = [];
  String failureMessages = '';

  String? _savedTipePengiriman;

  String? selectedTipePengiriman;
  final List<String> tipePengirimanList = [
    'FCL (Full Container Load)',
    'LCL (Less Container Load)',
  ];

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
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortAsalFCL();
  }

  void fetchKotaTujuan(String portAsal) {
    print("Fetching Kota Tujuan for Port Asal: $portAsal");
    setState(() {
      isFetchingKotaTujuan = true;
    });
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortTujuanFCL(portAsal);
  }

  void fetchKotaTujuanLCL(String portAsalLCL) {
    print("Fetching Kota Tujuan for Port Asal: $portAsalLCL");
    setState(() {
      isFetchingKotaTujuanLCL = true;
    });
    BlocProvider.of<OrderOnlineFCLCubit>(context)
        .fetchPortTujuanLCL(portAsalLCL);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //FCL
  void simulateHarga() {
    if (selectedPortAsal != null && selectedPortTujuan != null) {
      _savedTipePengiriman =
          (selectedTipePengiriman == 'FCL (Full Container Load)')
              ? 'FCL'
              : (selectedTipePengiriman == 'LCL (Less Container Load)')
                  ? 'LCL'
                  : '';
      context.read<SimulasiHargaCubit>().simulasiHarga(
            portAsal: selectedPortAsal!,
            portTujuan: selectedPortTujuan!,
            jenisPengiriman: _savedTipePengiriman ?? '',
          );
    } else {}
  }

  //LCL
  void simulateHargaLCL() {
    print('port asal LCL: $selectedPortAsalLCL');
    selectedPortTujuanLCL = kotaTujuanToPortTujuanMapLCL[selectedKotaTujuanLCL];
    print('port tujuan LCL: $selectedPortTujuanLCL');

    if (selectedPortAsalLCL != null && selectedPortTujuanLCL != null) {
      _savedTipePengiriman =
          (selectedTipePengiriman == 'FCL (Full Container Load)')
              ? 'FCL'
              : (selectedTipePengiriman == 'LCL (Less Container Load)')
                  ? 'LCL'
                  : '';

      context.read<SimulasiHargaCubit>().simulasiHarga(
            portAsal: selectedPortAsalLCL!,
            portTujuan: selectedPortTujuanLCL!,
            jenisPengiriman: _savedTipePengiriman ?? '',
          );
    } else {
      // Handle the case when either selectedPortAsalLCL or selectedPortTujuanLCL is null
      // print('Error: Port Asal / Port Tujuan belum diinput untuk LCL');
    }
  }

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  // String? selectedKotaAsal;
  // final List<String> kotaAsalList = [
  //   'Jakarta',
  //   'Semarang',
  //   'Surabaya',
  // ];

  // String? selectedKotaTujuan;
  // final List<String> kotaTujuanList = [
  //   'Solo',
  //   'Medan',
  //   'Biak',
  // ];

  // String? selectedTipePengiriman;
  // final List<String> tipePengirimanList = [
  //   'FCL (Full Container Load)',
  //   'LCL (Less Container Load)',
  // ];

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          0.07 * MediaQuery.of(context).size.height,
        ),
        child: AppBar(
          backgroundColor: Colors.white,
          //untuk ubah warna back color di My Invoice
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
                  "Simulasi Harga Pengiriman",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.red[900],
                    fontFamily: 'Poppins Extra Bold',
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          //agar tulisan di appbar berada di tengah tinggi bar
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: BlocConsumer<OrderOnlineFCLCubit, OrderOnlineFCLState>(
        listener: (context, state) {
          if (state is PortAsalFCLSuccess) {
            print("Kota Asal: ${state.response}");
            setState(() {
              portAsalToKotaAsalMap = {
                for (var port in state.response)
                  port.portAsal ?? '': port.kotaAsal ?? ''
              };

              // Populate kotaAsalList with portAsal
              kotaAsalList = portAsalToKotaAsalMap.keys
                  .where((portAsal) => portAsal.isNotEmpty)
                  .toList();

              // Reset the selected Kota Tujuan when Kota Asal changes
              selectedKotaTujuan = null;
              kotaTujuanList = [];
              //NEW
              selectedPortAsal = null;
              selectedPortTujuan = null;
            });
          }
          if (state is PortTujuanFCLSuccess) {
            print("Kota Tujuan fetched successfully: ${state.response}");
            setState(() {
              isFetchingKotaTujuan = false;

              kotaTujuanList = state.response
                  .map((port) => port.kotaTujuan ?? '')
                  .where((kota) => kota.isNotEmpty)
                  .toList();
            });
          }
          if (state is PortTujuanFCLInProgress) {
            setState(() {
              isFetchingKotaTujuan = true;
            });
          }
          if (state is PortTujuanFCLFailure) {
            setState(() {
              isFetchingKotaTujuan = false;
            });
          }
          if (state is PortAsalLCLSuccess) {
            print("Kota Asal: ${state.response}");
            setState(() {
              // Populate portAsalToKotaAsalMap for mapping
              portAsalToKotaAsalLCLMap = {
                for (var port in state.response)
                  port.portAsal ?? '': port.kotaAsal ?? ''
              };

              // Populate kotaAsalList with portAsal
              kotaAsalLCLList = portAsalToKotaAsalLCLMap.keys
                  .where((portAsal) => portAsal.isNotEmpty)
                  .toList();

              // Reset the selected Kota Tujuan when Kota Asal changes
              selectedKotaTujuanLCL = null;
              kotaTujuanListLCL = [];

              selectedPortTujuanLCL = null;
              selectedPortAsal = null;
            });
          }
          if (state is PortTujuanLCLSuccess) {
            print("Kota Tujuan fetched successfully: ${state.response}");
            setState(() {
              isFetchingKotaTujuanLCL = false;

              kotaTujuanToPortTujuanMapLCL = {
                for (var port in state.response)
                  port.kotaTujuan ?? '': port.portTujuan ?? ''
              };

              kotaTujuanList = kotaTujuanToPortTujuanMapLCL.keys
                  .where((kotaTujuan) => kotaTujuan.isNotEmpty)
                  .toList();
            });
          }
          if (state is PortTujuanLCLInProgress) {
            setState(() {
              isFetchingKotaTujuanLCL = true;
            });
          }
          if (state is PortTujuanLCLFailure) {
            setState(() {
              isFetchingKotaTujuanLCL = false;
            });
          }
        },
        builder: (context, state) {
          if (state is PortAsalFCLInProgress ||
              state is PortAsalLCLInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return BlocConsumer<SimulasiHargaCubit, SimulasiHargaState>(
              listener: (context, state) {
            if (state is SimulasiHargaSuccess) {
              hargaModellist.clear();
              hargaModellist = state.response;
              print('Ini respon di body nya: $hargaModellist');
              print('Ini respon di harga nya: ${hargaModellist.first.harga}');
            }
            // else if (state is SimulasiHargaFailure) {
            //   // Display the failure message in the UI
            //   final failureMessage = state.errorMessage;
            //   setState(() {
            //     // Set the failure message to display in the widget
            //     failureMessages = failureMessage;
            //   });
            // }
          }, builder: (context, state) {
            if (state is SimulasiHargaInProgress) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber[600],
                ),
              );
            }
            return Stack(children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(26.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Jasa',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontFamily: 'Poppins Med',
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontFamily: 'Poppins Med',
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6), // Reduced padding
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedTipePengiriman,
                              hint: Text(
                                'Pilih tipe pengiriman',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Poppins Regular',
                                ), // Reduced font size
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  // selectedTipePengiriman = newValue;
                                  selectedTipePengiriman = newValue;

                                  // Set jenis_pengiriman based on the selected value
                                  if (newValue == 'FCL (Full Container Load)') {
                                    jenisPengiriman =
                                        'FCL'; // Set jenis_pengiriman to FCL
                                  } else if (newValue ==
                                      'LCL (Less Container Load)') {
                                    jenisPengiriman =
                                        'LCL'; // Set jenis_pengiriman to LCL
                                    BlocProvider.of<OrderOnlineFCLCubit>(
                                            context)
                                        .fetchPortAsalLCL();
                                  }
                                });
                              },
                              items: tipePengirimanList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(
                                          fontSize: 14)), // Reduced font size
                                );
                              }).toList(),
                              decoration: InputDecoration(
                                // Reduced content padding
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 6),
                                border: InputBorder
                                    .none, // Remove the default border
                              ),
                              iconSize:
                                  20, // Reduce the size of the dropdown arrow
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Kota Asal',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontFamily: 'Poppins Med',
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontFamily: 'Poppins Med',
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          //FCL
                          // if (selectedTipePengiriman ==
                          //     'FCL (Full Container Load)')
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownSearch<String>(
                              items: selectedTipePengiriman ==
                                      'FCL (Full Container Load)'
                                  ? kotaAsalList.map((portAsal) {
                                      return portAsalToKotaAsalMap[portAsal] ??
                                          '';
                                    }).toList()
                                  : selectedTipePengiriman ==
                                          'LCL (Less Container Load)'
                                      ? kotaAsalLCLList.map((portAsal) {
                                          return portAsalToKotaAsalLCLMap[
                                                  portAsal] ??
                                              '';
                                        }).toList()
                                      : [],
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Pilih Kota Asal",
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins Regular',
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 12.0),
                                ),
                              ),
                              onChanged: (String? newValue) {
                                // Handle selection
                                print("Selected Kota Asal: $newValue");
                                setState(() {
                                  if (selectedTipePengiriman ==
                                      'FCL (Full Container Load)') {
                                    selectedPortAsal =
                                        portAsalToKotaAsalMap.keys.firstWhere(
                                      (portAsal) =>
                                          portAsalToKotaAsalMap[portAsal] ==
                                          newValue,
                                      orElse: () => '',
                                    );
                                    selectedKotaAsal = newValue;

                                    // Reset the selected Kota Tujuan when Kota Asal changes
                                    selectedKotaTujuan = null;
                                    kotaTujuanList = [];
                                    //NEW
                                    selectedPortTujuan = null;
                                    if (selectedPortAsal != null) {
                                      fetchKotaTujuan(selectedPortAsal!);
                                    }
                                  } else {
                                    // Reverse lookup to get the corresponding portAsal from kotaAsal
                                    selectedPortAsalLCL =
                                        portAsalToKotaAsalLCLMap.keys
                                            .firstWhere(
                                      (portAsal) =>
                                          portAsalToKotaAsalLCLMap[portAsal] ==
                                          newValue,
                                      orElse: () => '',
                                    );
                                    selectedKotaAsalLCL = newValue;

                                    print(
                                        'Port Asal LCL nya: $selectedPortAsalLCL');

                                    // Reset the selected Kota Tujuan when Kota Asal changes
                                    selectedKotaTujuanLCL = null;
                                    kotaTujuanListLCL = [];
                                    if (selectedPortAsalLCL != null) {
                                      fetchKotaTujuanLCL(selectedPortAsalLCL!);
                                    }
                                  }
                                });
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                              ),
                              selectedItem: selectedTipePengiriman ==
                                      'FCL (Full Container Load)'
                                  ? selectedKotaAsal
                                  : selectedTipePengiriman ==
                                          'LCL (Less Container Load)'
                                      ? selectedKotaAsalLCL
                                      : null,
                            ),
                          ),
                          //LCL
                          // if (selectedTipePengiriman ==
                          //     'LCL (Less Container Load)')
                          //   Container(
                          //     height: 40,
                          //     padding: EdgeInsets.symmetric(horizontal: 6),
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Colors.black),
                          //       borderRadius: BorderRadius.circular(5.0),
                          //     ),
                          //     child: DropdownSearch<String>(
                          //       items: kotaAsalLCLList.map((portAsal) {
                          //         return portAsalToKotaAsalLCLMap[portAsal] ??
                          //             '';
                          //       }).toList(),
                          //       dropdownDecoratorProps: DropDownDecoratorProps(
                          //         dropdownSearchDecoration: InputDecoration(
                          //           hintText: "Pilih Kota Asal",
                          //           hintStyle: TextStyle(
                          //             fontSize: 12,
                          //             fontFamily: 'Poppins Regular',
                          //             color: Colors.grey,
                          //           ),
                          //           border: InputBorder.none,
                          //           contentPadding: EdgeInsets.symmetric(
                          //               horizontal: 10.0, vertical: 11.0),
                          //         ),
                          //       ),
                          //       onChanged: (String? newValue) {
                          //         // Handle selection
                          //         print("Selected Kota Asal: $newValue");
                          //         setState(() {
                          //           // Reverse lookup to get the corresponding portAsal from kotaAsal
                          //           selectedPortAsalLCL =
                          //               portAsalToKotaAsalLCLMap.keys
                          //                   .firstWhere(
                          //             (portAsal) =>
                          //                 portAsalToKotaAsalLCLMap[portAsal] ==
                          //                 newValue,
                          //             orElse: () => '',
                          //           );
                          //           selectedKotaAsalLCL = newValue;

                          //           // Reset the selected Kota Tujuan when Kota Asal changes
                          //           selectedKotaTujuanLCL = null;
                          //           kotaTujuanListLCL = [];
                          //           if (selectedPortAsalLCL != null) {
                          //             fetchKotaTujuanLCL(selectedPortAsalLCL!);
                          //           }
                          //         });
                          //       },
                          //       popupProps: PopupProps.menu(
                          //         showSearchBox: true,
                          //         constraints: BoxConstraints(maxHeight: 200),
                          //       ),
                          //       selectedItem:
                          //           selectedKotaAsal, // No default selection
                          //     ),
                          //   ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text(
                                'Kota Tujuan',
                                style: TextStyle(
                                  color: Color(0xFF333333),
                                  fontFamily: 'Poppins Med',
                                  fontSize: 13,
                                ),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                  color: Colors.red[900],
                                  fontFamily: 'Poppins Med',
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          //FCL
                          // if (selectedTipePengiriman ==
                          //     'FCL (Full Container Load)')
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: DropdownSearch<String>(
                              items: kotaTujuanList,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Pilih Kota Tujuan",
                                  hintStyle: TextStyle(
                                    fontSize: 13,
                                    fontFamily: 'Poppins Regular',
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 12.0),
                                ),
                              ),
                              onChanged: selectedTipePengiriman ==
                                      'FCL (Full Container Load)'
                                  ? isFetchingKotaTujuan
                                      ? null
                                      : (String? newValue) {
                                          print(
                                              "Selected Kota Tujuan: $newValue");
                                          if (newValue != null) {
                                            setState(() {
                                              selectedKotaTujuan = newValue;
                                              final currentState = BlocProvider
                                                      .of<OrderOnlineFCLCubit>(
                                                          context)
                                                  .state;
                                              if (currentState
                                                  is PortTujuanFCLSuccess) {
                                                final matchingPort =
                                                    currentState.response
                                                        .firstWhere(
                                                  (port) =>
                                                      port.kotaTujuan ==
                                                      newValue,
                                                  orElse: () =>
                                                      PortTujuanFCLAccesses(
                                                          kotaTujuan: '',
                                                          portTujuan: ''),
                                                );
                                                selectedPortTujuan =
                                                    matchingPort.portTujuan
                                                                ?.isNotEmpty ==
                                                            true
                                                        ? matchingPort
                                                            .portTujuan
                                                        : null;
                                              }
                                            });
                                          }
                                        }
                                  : selectedTipePengiriman ==
                                          'LCL (Less Container Load)'
                                      ? isFetchingKotaTujuanLCL
                                          ? null
                                          : (String? newValue) {
                                              // Handle selection
                                              print(
                                                  "Selected Kota Tujuan: $newValue");
                                              setState(() {
                                                selectedKotaTujuanLCL =
                                                    newValue;

                                                if (newValue != null &&
                                                    kotaTujuanToPortTujuanMapLCL
                                                        .containsKey(
                                                            newValue)) {
                                                  String?
                                                      selectedPortTujuanLCL =
                                                      kotaTujuanToPortTujuanMapLCL[
                                                          newValue];
                                                  print(
                                                      "Corresponding Port Tujuan: $selectedPortTujuanLCL");
                                                }
                                              });
                                            }
                                      : null,
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                              ),
                              selectedItem: selectedTipePengiriman ==
                                      'FCL (Full Container Load)'
                                  ? selectedKotaTujuan
                                  : selectedTipePengiriman ==
                                          'LCL (Less Container Load)'
                                      ? selectedKotaTujuanLCL
                                      : null,
                            ),
                          ),
                          //LCL
                          // if (selectedTipePengiriman ==
                          //     'LCL (Less Container Load)')
                          //   Container(
                          //     height: 40,
                          //     padding: EdgeInsets.symmetric(horizontal: 6),
                          //     decoration: BoxDecoration(
                          //         color: Colors.white,
                          //         border: Border.all(color: Colors.black),
                          //         borderRadius: BorderRadius.circular(5.0)),
                          //     child: DropdownSearch<String>(
                          //       items: kotaTujuanList,
                          //       dropdownDecoratorProps: DropDownDecoratorProps(
                          //         dropdownSearchDecoration: InputDecoration(
                          //           hintText: "Pilih Kota Tujuan",
                          //           hintStyle: TextStyle(
                          //             fontSize: 12,
                          //             fontFamily: 'Poppins Regular',
                          //             color: Colors.grey,
                          //           ),
                          //           border: InputBorder.none,
                          //           contentPadding: EdgeInsets.symmetric(
                          //               horizontal: 10.0, vertical: 11.0),
                          //         ),
                          //       ),
                          //       onChanged: isFetchingKotaTujuanLCL
                          //           ? null
                          //           : (String? newValue) {
                          //               // Handle selection
                          //               print(
                          //                   "Selected Kota Tujuan: $newValue");
                          //               setState(() {
                          //                 selectedKotaTujuanLCL = newValue;

                          //                 if (newValue != null &&
                          //                     kotaTujuanToPortTujuanMap
                          //                         .containsKey(newValue)) {
                          //                   String? selectedPortTujuan =
                          //                       kotaTujuanToPortTujuanMap[
                          //                           newValue];
                          //                   print(
                          //                       "Corresponding Port Tujuan: $selectedPortTujuan");
                          //                 }
                          //               });
                          //             },
                          //       popupProps: PopupProps.menu(
                          //         showSearchBox: true,
                          //       ),
                          //       selectedItem:
                          //           selectedKotaTujuan, // No default selection
                          //     ),
                          //   ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    // SizedBox(height: 20),
                    // Center(
                    //   child: _showCekHarga
                    //       ? Material(
                    //           borderRadius: BorderRadius.circular(7.0),
                    //           color: Colors.white,
                    //           shadowColor: Colors.grey[350],
                    //           elevation: 5,
                    //           child: OutlinedButton(
                    //             style: OutlinedButton.styleFrom(
                    //               minimumSize: Size(200, 50),
                    //               side: BorderSide(
                    //                   color: Colors.red[900]!, width: 2),
                    //               shape: RoundedRectangleBorder(
                    //                 borderRadius: BorderRadius.circular(7.0),
                    //               ),
                    //               backgroundColor: Colors.white,
                    //             ),
                    //             onPressed: () {
                    //               // Navigator.of(context).pop();
                    //               setState(() {
                    //                 _showCekHarga = false;
                    //                 // Optionally reset form fields or do other refresh actions here
                    //               });
                    //             },
                    //             child: Text(
                    //               'Kembali',
                    //               style: TextStyle(
                    //                   fontSize: 18, color: Colors.red[900]),
                    //             ),
                    //           ),
                    //         )
                    //       : Material(
                    //           borderRadius: BorderRadius.circular(7.0),
                    //           color: Colors.red[900],
                    //           shadowColor: Colors.grey[350],
                    //           elevation: 5,
                    //           child: MaterialButton(
                    //             minWidth: 200,
                    //             height: 50,
                    //             onPressed: () {
                    //               setState(() {
                    //                 _showCekHarga = true;
                    //                 simulateHarga();
                    //               });
                    //             },
                    //             child: Text(
                    //               'Cek Harga',
                    //               style: TextStyle(
                    //                   fontSize: 18, color: Colors.white),
                    //             ),
                    //           ),
                    //         ),
                    // ),
                    SizedBox(
                      width: 360,
                      height: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Colors.red[900],
                        // shadowColor: Colors.grey[350],
                        // elevation: 5,
                        child: MaterialButton(
                          onPressed: () {
                            setState(() {
                              _showCekHarga = true;
                              // simulateHarga();
                              if (selectedTipePengiriman ==
                                  'FCL (Full Container Load)') {
                                simulateHarga();
                              } else if (selectedTipePengiriman ==
                                  'LCL (Less Container Load)') {
                                print('Tes Cek Harga LCL');
                                simulateHargaLCL();
                              }
                            });
                          },
                          child: Text(
                            'Cek Harga',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontFamily: 'Poppins Med',
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    if (_showCekHarga && hargaModellist.isNotEmpty)
                        cekSimulasiHarga(context, hargaModellist[0].harga.toString())
                    //NEW
                    // if (_showCekHarga)
                    //   cekHarga(
                    //       context,
                    //       state is SimulasiHargaSuccess &&
                    //               hargaModellist.isNotEmpty
                    //           ? hargaModellist[0].harga.toString()
                    //           : null,
                    //       state is SimulasiHargaFailure
                    //           ? state.errorMessage
                    //           : null),
                  ],
                ),
              ),
              if (isFetchingKotaTujuan)
                ModalBarrier(
                  dismissible: false,
                  color: Colors.black.withOpacity(0.2),
                ),
              if (isFetchingKotaTujuan)
                Center(
                  child: CircularProgressIndicator(),
                ),
              if (isFetchingKotaTujuanLCL)
                ModalBarrier(
                  dismissible: false,
                  color: Colors.black.withOpacity(0.2),
                ),
              if (isFetchingKotaTujuanLCL)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ]);
          });
        },
      ),
    );
  }
}
