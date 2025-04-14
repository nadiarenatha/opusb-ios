import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/model/niaga/port_tujuan_fcl.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/order_online_fcl_cubit.dart';
import '../model/niaga/port_asal_fcl.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'jadwal_kapal_niaga.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:math';

class MenuJadwalKapalNiagaPage extends StatefulWidget {
  const MenuJadwalKapalNiagaPage({Key? key}) : super(key: key);

  @override
  State<MenuJadwalKapalNiagaPage> createState() =>
      _MenuJadwalKapalNiagaPageState();
}

class _MenuJadwalKapalNiagaPageState extends State<MenuJadwalKapalNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  TextEditingController _dateController = TextEditingController();
  String? selectedKotaAsal;
  String? selectedKotaTujuan;
  String? selectedPortAsal;
  List<String> kotaAsalList = [];
  List<String> kotaTujuanList = [];
  Map<String, List<String>> kotaTujuanMap = {}; // Map kotaAsal to kotaTujuan
  List<PortAsalFCLAccesses> portAsalModellist = [];
  List<PortTujuanFCLAccesses> portTujuanModellist = [];
  Map<String, String> portAsalToKotaAsalMap = {}; // Maps portAsal to kotaAsal
  Map<String, String> kotaTujuanToPortTujuanMap =
      {}; // Maps kotaTujuan to portTujuan
  bool isFetchingKotaTujuan = false;

  @override
  void initState() {
    super.initState();
    // _logPortAsal();
    // _logPortTujuan();
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortAsalFCL();

    _dateController.addListener(() {
      String text = _dateController.text;

      // Remove any non-digit characters
      text = text.replaceAll(RegExp(r'[^0-9]'), '');

      // Automatically format the input as dd/mm/yyyy
      if (text.length >= 2 && text.length <= 4) {
        text = text.substring(0, 2) +
            (text.length >= 3 ? '/' + text.substring(2) : '');
      } else if (text.length > 4) {
        text = text.substring(0, 2) +
            '/' +
            text.substring(2, 4) +
            '/' +
            text.substring(4, min(8, text.length)); // Use min here
      }

      // Update the controller text with formatted date
      _dateController.value = _dateController.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    });
  }

  void fetchKotaTujuan(String portAsal) {
    print("Fetching Kota Tujuan for Port Asal: $portAsal"); // Debugging line
    setState(() {
      isFetchingKotaTujuan = true;
    });
    // Fetch the kotaTujuan based on the selected portAsal
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortTujuanFCL(portAsal);
  }

// Future<void> _logPortAsal() async {
//     final fullUrlPortAsalFCL = await storage.read(
//       key: AuthKey.fullUrlPortAsalFCL.toString(),
//       aOptions: const AndroidOptions(
//         encryptedSharedPreferences: true,
//       ),
//     );
//     if (fullUrlPortAsalFCL != null) {
//       print('Full Url nya port asal: $fullUrlPortAsalFCL');
//       BlocProvider.of<LogNiagaCubit>(context).logNiaga(fullUrlPortAsalFCL);
//     } else {
//       print('Full URL port asal is null. Ensure it has been saved.');
//     }
//   }

// Future<void> _logPortTujuan() async {
//     final fullUrlPortTujuanFCL = await storage.read(
//       key: AuthKey.fullUrlPortTujuanFCL.toString(),
//       aOptions: const AndroidOptions(
//         encryptedSharedPreferences: true,
//       ),
//     );
//     if (fullUrlPortTujuanFCL != null) {
//       print('Full Url nya port tujuan: $fullUrlPortTujuanFCL');
//       BlocProvider.of<LogNiagaCubit>(context).logNiaga(fullUrlPortTujuanFCL);
//     } else {
//       print('Full URL port tujuan is null. Ensure it has been saved.');
//     }
//   }

  @override
  void dispose() {
    // Perform any necessary cleanup
    _dateController.dispose();
    super.dispose();
  }

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  // String? selectedKotaAsal;
  // final List<String> kotaAsalList = [
  //   'Surabaya',
  //   'Jakarta',
  //   'Makassar',
  //   'Sorong'
  // ];

  // String? selectedKotaTujuan;
  // final List<String> kotaTujuanList = [
  //   'Semarang',
  //   'Bandung',
  //   'Jogjakarta',
  //   'Medan'
  // ];

  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(2000), // The earliest date the user can pick
      lastDate: DateTime(2101), // The latest date the user can pick
    );
    if (picked != null) {
      setState(() {
        // controller.text = "${picked.day}/${picked.month}/${picked.year}";
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().padLeft(4, '0')}";
      });
    }
  }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

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
                  "Jadwal Kapal",
                  style: TextStyle(
                      fontSize: 17,
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
      body: BlocConsumer<OrderOnlineFCLCubit, OrderOnlineFCLState>(
        listener: (context, state) {
          if (state is PortAsalFCLSuccess) {
            print("Kota Asal: ${state.response}");
            setState(() {
              // kotaAsalList = state.response
              //     .map((port) => port.portAsal ?? '')
              //     .where((kota) => kota.isNotEmpty)
              //     .toList();

              // Populate portAsalToKotaAsalMap for mapping
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
            });
          }
          if (state is PortTujuanFCLSuccess) {
            print("Kota Tujuan fetched successfully: ${state.response}");
            setState(() {
              isFetchingKotaTujuan = false;
              // kotaTujuanList = state.response
              //     .map((port) => port.kotaTujuan ?? '')
              //     .where((kota) => kota.isNotEmpty)
              //     .toList();

              //NEW
              // Map kotaTujuan to portTujuan
              kotaTujuanToPortTujuanMap = {
                for (var port in state.response)
                  port.kotaTujuan ?? '': port.portTujuan ?? ''
              };

              kotaTujuanList = kotaTujuanToPortTujuanMap.keys
                  .where((kotaTujuan) => kotaTujuan.isNotEmpty)
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
        },
        builder: (context, state) {
          if (state is PortAsalFCLInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Kota Asal',
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: 'Poppins Med',
                                fontSize: 13),
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
                      //==dropdown biasa
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 6),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       border: Border.all(color: Colors.black),
                      //       borderRadius: BorderRadius.circular(5.0)),
                      //   child: DropdownButtonFormField<String>(
                      //     value: selectedKotaAsal,
                      //     hint: Text('Pilih Kota Asal',
                      //         style: TextStyle(fontSize: 14)),
                      //     onChanged: (String? newValue) {
                      //       setState(() {
                      //         selectedKotaAsal = newValue;
                      //         selectedKotaTujuan =
                      //             null; // Reset the selected Kota Tujuan
                      //         kotaTujuanList =
                      //             []; // Clear the previous Kota Tujuan list
                      //         if (newValue != null) {
                      //           fetchKotaTujuan(newValue);
                      //         }
                      //       });
                      //     },
                      //     // items: kotaAsalList
                      //     //     .map<DropdownMenuItem<String>>((String value) {
                      //     //   return DropdownMenuItem<String>(
                      //     //     value: value,
                      //     //     child:
                      //     //         Text(value, style: TextStyle(fontSize: 14)),
                      //     //   );
                      //     // }).toList(),
                      //     items: kotaAsalList
                      //         .map<DropdownMenuItem<String>>((String portAsal) {
                      //       return DropdownMenuItem<String>(
                      //         value: portAsal, // Use portAsal as value
                      //         child: Text(portAsalToKotaAsalMap[portAsal] ?? '',
                      //             style: TextStyle(
                      //                 fontSize: 14)), // Display kotaAsal
                      //       );
                      //     }).toList(),
                      //     decoration: InputDecoration(
                      //         contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      //         border: InputBorder.none),
                      //     iconSize: 20,
                      //   ),
                      // ),
                      //dropdown search
                      Container(
                        // padding: EdgeInsets.symmetric(horizontal: 6),
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownSearch<String>(
                          items: kotaAsalList.map((portAsal) {
                            return portAsalToKotaAsalMap[portAsal] ?? '';
                          }).toList(),
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: "Pilih Kota Asal",
                              hintStyle: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins Regular',
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              // contentPadding: EdgeInsets.symmetric(
                              //     horizontal: 10.0, vertical: 14.0),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            // Handle selection
                            print("Selected Kota Asal: $newValue");
                            setState(() {
                              // Reverse lookup to get the corresponding portAsal from kotaAsal
                              selectedPortAsal =
                                  portAsalToKotaAsalMap.keys.firstWhere(
                                (portAsal) =>
                                    portAsalToKotaAsalMap[portAsal] == newValue,
                                orElse: () => '',
                              );
                              selectedKotaAsal = newValue;

                              // Reset the selected Kota Tujuan when Kota Asal changes
                              selectedKotaTujuan = null;
                              kotaTujuanList = [];
                              if (selectedPortAsal != null) {
                                fetchKotaTujuan(selectedPortAsal!);
                              }
                            });
                          },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                          ),
                          // selectedItem: null, // No default selection
                          selectedItem:
                              selectedKotaAsal, // No default selection
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Kota Tujuan',
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: 'Poppins Med',
                                fontSize: 13),
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
                      //dropdown biasa
                      // Container(
                      //   padding: EdgeInsets.symmetric(horizontal: 6),
                      //   decoration: BoxDecoration(
                      //       color: Colors.white,
                      //       border: Border.all(color: Colors.black),
                      //       borderRadius: BorderRadius.circular(5.0)),
                      //   child: DropdownButtonFormField<String>(
                      //     value: selectedKotaTujuan,
                      //     hint: Text('Pilih Kota Tujuan',
                      //         style: TextStyle(fontSize: 14)),
                      //     onChanged: (String? newValue) {
                      //       print("Selected Kota Tujuan: $newValue");
                      //       setState(() {
                      //         selectedKotaTujuan = newValue;
                      //       });
                      //     },
                      //     items: kotaTujuanList
                      //         .map<DropdownMenuItem<String>>((String value) {
                      //       return DropdownMenuItem<String>(
                      //         value: value,
                      //         child: Text(value, style: TextStyle(fontSize: 14)),
                      //       );
                      //     }).toList(),
                      //     decoration: InputDecoration(
                      //         contentPadding: EdgeInsets.symmetric(horizontal: 6),
                      //         border: InputBorder.none),
                      //     iconSize: 20,
                      //   ),
                      // ),
                      //dropdown search
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
                              // contentPadding: EdgeInsets.symmetric(
                              //     horizontal: 10.0, vertical: 14.0),
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8.0, vertical: 12.0),
                            ),
                          ),
                          onChanged: isFetchingKotaTujuan
                              ? null
                              : (String? newValue) {
                                  // Handle selection
                                  print("Selected Kota Tujuan: $newValue");
                                  setState(() {
                                    selectedKotaTujuan = newValue;

                                    //NEW
                                    // Get the corresponding portTujuan from the selected kotaTujuan
                                    if (newValue != null &&
                                        kotaTujuanToPortTujuanMap
                                            .containsKey(newValue)) {
                                      String? selectedPortTujuan =
                                          kotaTujuanToPortTujuanMap[newValue];
                                      print(
                                          "Corresponding Port Tujuan: $selectedPortTujuan");

                                      // Save or use the selected portTujuan as needed
                                    }
                                  });
                                },
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                          ),
                          // selectedItem: null, // No default selection
                          selectedItem:
                              selectedKotaTujuan, // No default selection
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Tanggal Pelayaran',
                            style: TextStyle(
                                color: Color(0xFF333333),
                                fontFamily: 'Poppins Med',
                                fontSize: 13),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              width: 320,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                  color: Colors.black, // Set border color here
                                  width: 1.0, // Set border width here
                                ),
                              ),
                              //untuk tulisan nama barang
                              child: TextFormField(
                                //controller 1 digunakan untuk input tgl di calendar
                                controller: _dateController,
                                keyboardType: TextInputType.number,
                                readOnly: true, // Make the field read-only
                                onTap: () =>
                                    _selectDate(context, _dateController),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "dd/mm/yyyy",
                                    hintStyle: TextStyle(
                                      fontSize: 13,
                                      fontFamily: 'Poppins Regular',
                                      color: Colors.grey,
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 12.0, vertical: 12.0),
                                    fillColor: Colors.grey[600],
                                    labelStyle:
                                        TextStyle(fontFamily: 'Montserrat'),
                                    suffixIcon: IconButton(
                                      icon: Icon(Icons.calendar_today),
                                      color: Colors.red[900],
                                      onPressed: () =>
                                          _selectDate(context, _dateController),
                                    )),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14.0,
                                    fontFamily: 'Montserrat'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 300),
                      Center(
                        child: SizedBox(
                          width: 360,
                          height: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.red[900],
                            child: MaterialButton(
                              onPressed: () {
                                String selectedPortAsal =
                                    this.selectedPortAsal ?? '';
                                // Get the selected port tujuan
                                // String selectedPortTujuan =
                                //     kotaTujuanToPortTujuanMap[
                                //             selectedKotaTujuan!] ??
                                //         '';
                                String selectedPortTujuan =
                                    selectedKotaTujuan != null
                                        ? (kotaTujuanToPortTujuanMap[
                                                selectedKotaTujuan] ??
                                            '')
                                        : '';
                                // String date = _dateController.text;
                                String date = _dateController.text.isEmpty
                                    ? ''
                                    : _dateController.text;

                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return JadwalKapalNiagaPage(
                                    // portAsal: selectedPortAsal ?? '',
                                    portAsal: selectedPortAsal,
                                    portTujuan: selectedPortTujuan,
                                    date: date,
                                    kotaAsal: selectedKotaAsal ?? '',
                                    kotaTujuan: selectedKotaTujuan ?? '',
                                  );
                                }));
                              },
                              child: Text(
                                'Cari Jadwal',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: 'Poppins Med',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
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
              if (state is PortAsalFCLInProgress)
                Center(
                  child: CircularProgressIndicator(),
                ),
            ],
          );
        },
      ),
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
      //           width: 23,
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
      //     selectedItemColor: Colors.grey[600],
      //     onTap: _onItemTapped,
      //   ),
      // )
    );
  }
}
