import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/niaga/daftar_pesanan_cubit.dart';
import '../cubit/niaga/order_online_fcl_cubit.dart';
import '../model/niaga/daftar-pesanan/daftar_pesanan.dart';
import '../model/niaga/port_asal_fcl.dart';
import '../model/niaga/port_tujuan_fcl.dart';
import '../ulasan/detail_pesanan.dart';
import '../ulasan/ulasan.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

import 'detail_invoice_resi_order_niaga.dart';
import 'home_niaga.dart';

class OrderHomeNiagaPage extends StatefulWidget {
  const OrderHomeNiagaPage({Key? key}) : super(key: key);

  @override
  State<OrderHomeNiagaPage> createState() => _OrderHomeNiagaPageState();
}

class _OrderHomeNiagaPageState extends State<OrderHomeNiagaPage>
    with SingleTickerProviderStateMixin {
  @override
  late TabController _tabController;

  //untuk pagination
  // int currentPageIndex = 0;
  int currentPageIndex = 0;
  int itemsPerPage = 5; // Number of items per page
  int _totalPages = 0; // Store total pages from API
  int _currentPage = 1; // Track the current page
  int totalPages = 0; // Declare totalPages as a class-level variable
  int pageIndex = 0;
  int visiblePages = 5; // Number of visible page numbers
  ScrollController _scrollController = ScrollController();

  List<DaftarPesananAccesses> onProgress = [];
  List<DaftarPesananAccesses> completed = [];
  List<DaftarPesananAccesses> cancel = [];

  TextEditingController _noOrder = TextEditingController();

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
  String? selectedPortTujuan;

  bool noResultsOnProgress = false;
  bool noResultsCompleted = false;
  bool noResultsCancel = false;

  bool _isSearchButtonClickedOnProgress = false;

  bool _isFetching = false;

  TextEditingController _pageController = TextEditingController();

  String? _savedShipmentType;
  String? _savedOrderService;

  String? selectedTipePengiriman;
  final List<String> tipePengirimanList = [
    'FCL (Full Container Load)',
    'LCL (Less Container Load)',
  ];

  String? selectedJasa;
  final List<String> jasaList = [
    'DTD (Door to Door)',
    'PTD (Port to Door)',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          _handleTabChange(_tabController.index);
        }
      });
    _scrollController = ScrollController();

    _fetchDataForPage(currentPageIndex);
  }

  void _fetchDataForPage(int pageIndex) {
    if (_tabController.index == 0) {
      BlocProvider.of<DaftarPesananCubit>(context)
          // .daftarpesananOnProgress(pageIndex: pageIndex);
          .searchPesananOnProgress(
        pageIndex: pageIndex,
        orderService: _savedOrderService,
        shipmentType: _savedShipmentType,
      );
    } else if (_tabController.index == 1) {
      BlocProvider.of<DaftarPesananCubit>(context)
          // .daftarpesananCompleted(pageIndex: pageIndex);
          .searchPesananCompleted(pageIndex: pageIndex);
    } else if (_tabController.index == 2) {
      BlocProvider.of<DaftarPesananCubit>(context)
          // .daftarpesananCancel(pageIndex: pageIndex);
          .searchPesananCancel(pageIndex: pageIndex);
    }
    setState(() {
      _currentPage = pageIndex;
      currentPageIndex = pageIndex;
      print('_currentPage nya: $_currentPage');
      print('currentPageIndex nya: $currentPageIndex');
    });
  }

  int getStartPageIndex() {
    return ((currentPageIndex ~/ visiblePages) * visiblePages).toInt();
  }

  int getEndPageIndex() {
    int endPage = (getStartPageIndex() + visiblePages).toInt();
    return endPage > _totalPages ? _totalPages : endPage;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabChange(int index) {
    if (index == 0) {
      onProgress.clear();
      _fetchDataForPage(currentPageIndex);
    } else if (index == 1) {
      completed.clear();
      _fetchDataForPage(currentPageIndex);
    } else if (index == 2) {
      cancel.clear();
      _fetchDataForPage(currentPageIndex);
    }
  }

  void _copyToClipboardTransfer(String text, BuildContext context) {
    Clipboard.setData(ClipboardData(text: text));
    final snackBar = SnackBar(
      content: Text('Copied to Clipboard'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future searchPage() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  //untuk memberi border melengkung
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //untuk mengatur letak dari close icon
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  title: Row(
                    //supaya berada di kanan
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: searchPagination()),
            ),
          ));

  searchPagination() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 5),
          Table(
            columnWidths: {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(4),
            },
            children: [
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      "Menuju Halaman",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppinss'),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 2.0),
                    child: Text(':',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: 2.0, horizontal: 10.0),
                      child: TextField(
                        controller: _pageController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 13),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize:
                                _pageController.text.length > 5 ? 10.0 : 12.0,
                            fontFamily: 'Montserrat'),
                        onChanged: (value) {
                          // Handle the input value if needed
                        },
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 10),
          Table(
            columnWidths: {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(4),
            },
            children: [
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      "Halaman Terakhir",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'Poppinss'),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 2.0),
                    child: Text(':',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                    child: Text(_totalPages.toString(),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontFamily: 'Poppinss')),
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Flexible(
                child: SizedBox(
                  width: 80,
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.white,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(100, 50),
                        side: BorderSide(color: Colors.red[900]!, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () {
                        int pageNumber =
                            int.tryParse(_pageController.text) ?? 1;
                        if (pageNumber > 0 && pageNumber <= _totalPages) {
                          setState(() {
                            currentPageIndex = pageNumber - 1;
                            _fetchDataForPage(pageNumber - 1);
                            _scrollController.animateTo(
                              0.0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          });
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text(
                        'Find',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red[900],
                            fontFamily: 'Poppins Med'), // Smaller font
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: SizedBox(
                  width: 90,
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.red[900],
                    child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          letterSpacing: 1.5,
                          fontSize: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void fetchKotaTujuan(String portAsal) {
    print("Fetching Kota Tujuan for Port Asal: $portAsal"); // Debugging line
    // Fetch the kotaTujuan based on the selected portAsal
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortTujuanFCL(portAsal);
  }

  Future infoOrder() => showDialog(
      context: context,
      builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  //untuk memberi border melengkung
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  //untuk mengatur letak dari close icon
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  title: Row(
                    //supaya berada di kanan
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: order()),
            ),
          ));

  order() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tombol ulasan berlaku 30 hari terhitung setelah pembayaran berhasil dilakukan',
            style: TextStyle(fontSize: 12, fontFamily: 'Poppins Med'),
          ),
          SizedBox(height: 15),
          Center(
            child: SizedBox(
              width: 150,
              height: 35,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future searchOrder() => showDialog(
      context: context,
      builder: (context) =>
          BlocConsumer<OrderOnlineFCLCubit, OrderOnlineFCLState>(
              listener: (context, state) {
            if (state is PortAsalFCLSuccess) {
              print("Kota Asal: ${state.response}");
              setState(() {
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
          }, builder: (context, state) {
            return SingleChildScrollView(
              child: AlertDialog(
                //untuk memberi border melengkung
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
                //untuk mengatur letak dari close icon
                titlePadding: EdgeInsets.zero,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                title: Row(
                  //supaya berada di kanan
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        })
                  ],
                ),
                content: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 900, maxWidth: 300),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "No Order",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppin',
                            fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          border: Border.all(
                            color: Colors.black, // Set border color
                            width: 1.0, // Set border width
                          ),
                        ),
                        child: TextFormField(
                          controller: _noOrder,
                          decoration: InputDecoration(
                            hintText: 'Masukkan nomor order',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10.0),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Jasa",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppin',
                            fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedJasa,
                          hint: Text(
                            'Pilih jasa',
                            style: TextStyle(
                              fontSize: 13,
                              fontFamily: 'Poppins Regular',
                            ), // Reduced font size
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedJasa = newValue;

                              // Set jenis_pengiriman based on the selected value
                              // if (newValue == 'FCL (Full Container Load)') {
                              //   jenisPengiriman =
                              //       'FCL'; // Set jenis_pengiriman to FCL
                              // } else if (newValue ==
                              //     'LCL (Less Container Load)') {
                              //   jenisPengiriman =
                              //       'LCL'; // Set jenis_pengiriman to LCL
                              // }
                            });
                          },
                          items: jasaList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      fontSize: 14)), // Reduced font size
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6),
                            border:
                                InputBorder.none, // Remove the default border
                          ),
                          iconSize: 20, // Reduce the size of the dropdown arrow
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Tipe Pengiriman",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppin',
                            fontSize: 14),
                      ),
                      SizedBox(height: 8),
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
                              selectedTipePengiriman = newValue;

                              // Set jenis_pengiriman based on the selected value
                              // if (newValue == 'FCL (Full Container Load)') {
                              //   jenisPengiriman =
                              //       'FCL'; // Set jenis_pengiriman to FCL
                              // } else if (newValue ==
                              //     'LCL (Less Container Load)') {
                              //   jenisPengiriman =
                              //       'LCL'; // Set jenis_pengiriman to LCL
                              // }
                            });
                            print(
                                'Tipe Pengiriman yang dipilih: $selectedTipePengiriman');
                          },
                          items: tipePengirimanList
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value,
                                  style: TextStyle(
                                      fontSize: 14)), // Reduced font size
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            // Reduced content padding
                            contentPadding: EdgeInsets.symmetric(horizontal: 6),
                            border:
                                InputBorder.none, // Remove the default border
                          ),
                          iconSize: 20, // Reduce the size of the dropdown arrow
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        "Kota Asal",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppin',
                            fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
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
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 14.0),
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
                      Text(
                        "Kota Tujuan",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Poppin',
                            fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6),
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
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 14.0),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            print("Selected Kota Tujuan: $newValue");

                            // Check if newValue is not null and is in the map
                            if (newValue != null) {
                              setState(() {
                                selectedKotaTujuan = newValue;

                                // Print the current map
                                print(
                                    "kotaTujuanToPortTujuanMap: $kotaTujuanToPortTujuanMap");

                                // Get the corresponding portTujuan from the map
                                if (kotaTujuanToPortTujuanMap
                                    .containsKey(newValue)) {
                                  selectedPortTujuan =
                                      kotaTujuanToPortTujuanMap[newValue];
                                  print(
                                      "Corresponding Port Tujuan: $selectedPortTujuan");
                                } else {
                                  print(
                                      "Port Tujuan not found for selected Kota Tujuan");
                                  selectedPortTujuan =
                                      null; // Reset if not found
                                }
                              });
                            }
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
                      Center(
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Colors.red[900],
                          child: MaterialButton(
                            onPressed: () {
                              setState(() {
                                _isSearchButtonClickedOnProgress = true;
                                noResultsOnProgress = false;
                              });
                              performSearch();
                              if (_noOrder.text.isEmpty &&
                                  (selectedTipePengiriman?.isEmpty ?? true) &&
                                  (selectedJasa?.isEmpty ?? true)) {
                                context
                                    .read<DaftarPesananCubit>()
                                    .searchPesananOnProgress();
                              }
                            },
                            child: Text(
                              'Terapkan',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            );
          }));

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage()),
    );
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Daftar Pesanan",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[900],
                        fontFamily: 'Poppins Extra Bold'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Color.fromARGB(255, 184, 33, 22),
                      width: 2.0, // Border width
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.black,
                    ),
                    iconSize: 24,
                    onPressed: () {
                      _noOrder.text = '';
                      setState(() {
                        selectedTipePengiriman = null;
                        selectedJasa = null;
                        selectedKotaAsal = null; // Clear the selected Kota Asal
                        // Clear the selected Kota Tujuan
                        selectedKotaTujuan = null;
                        kotaTujuanList =
                            []; // Clear the Kota Tujuan list as well
                      });
                      context.read<OrderOnlineFCLCubit>().fetchPortAsalFCL();
                      searchOrder();
                    },
                  ),
                ),
              ],
            ),
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
          ),
        ),
        body: BlocConsumer<DaftarPesananCubit, DaftarPesananState>(
          listener: (context, state) async {
            if (state is DaftarPesananSuccess) {
              setState(() {
                _totalPages = state.totalPages;
                print("Total Pages Daftar Pesanan On Progress: $_totalPages");
                onProgress = state.response
                    .expand((pesananAccess) => pesananAccess.content)
                    .toList();
                print('On Progress nya : $onProgress');
                onProgress
                    .sort((a, b) => b.createdDate!.compareTo(a.createdDate!));

                noResultsOnProgress = _totalPages == 0;
              });
            } else if (state is SearchPesananCompletedSuccess) {
              setState(() {
                _totalPages = state.totalPages;
                print("Total Pages Daftar Pesanan Completed: $_totalPages");
                completed = state.response
                    .expand((pesananAccess) => pesananAccess.content)
                    .toList();
                completed
                    .sort((a, b) => b.createdDate!.compareTo(a.createdDate!));

                print('Completed nya : $completed');
              });
            } else if (state is SearchPesananCancelSuccess) {
              setState(() {
                _totalPages = state.totalPages;
                print("Total Pages Daftar Pesanan Cancel: $_totalPages");
                cancel = state.response
                    .expand((pesananAccess) => pesananAccess.content)
                    .toList();
                cancel.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
                print('Cancel nya : $cancel');
              });
            } else if (state is SearchPesananSuccess) {
              setState(() {
                onProgress.clear();

                _totalPages = state.totalPages;
                print("Total Pages Daftar Pesanan On Progress: $_totalPages");
                onProgress = state.response
                    .expand((pesananAccess) => pesananAccess.content)
                    .toList();
                print('On Progress Search nya : $onProgress');
              });
            } else if (state is SearchPesananFailure) {
              onProgress.clear();
              noResultsOnProgress = true;
            } else if (state is SearchPesananCompletedFailure) {
              completed.clear();
              noResultsCompleted = true;
            } else if (state is SearchPesananCancelFailure) {
              cancel.clear();
              noResultsCancel = true;
            }
          },
          builder: (context, state) {
            if (state is DaftarPesananInProgress ||
                state is DaftarPesananCompletedInProgress ||
                state is DaftarPesananCancelInProgress ||
                state is SearchPesananInProgress ||
                state is SearchPesananCompletedInProgress ||
                state is SearchPesananCancelInProgress) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber[600],
                ),
              );
            }
            return DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  // Your TabBar
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.red[900],
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                        child: Text(
                          'On Progress',
                          style: TextStyle(
                              fontFamily: _tabController.index == 0
                                  ? 'Poppins Bold'
                                  : 'Poppins Med',
                              fontSize: 13),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Completed',
                          style: TextStyle(
                              fontFamily: _tabController.index == 1
                                  ? 'Poppins Bold'
                                  : 'Poppins Med',
                              fontSize: 13),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                              fontFamily: _tabController.index == 2
                                  ? 'Poppins Bold'
                                  : 'Poppins Med',
                              fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // On Progress
                        Column(
                          children: [
                            if (onProgress.isEmpty &&
                                _isSearchButtonClickedOnProgress == false)
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
                                  Text(
                                    'Hubungi admin untuk detail selengkapnya',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        color: Colors.grey,
                                        fontSize: 11),
                                  ),
                                ],
                              )),
                            if (_isSearchButtonClickedOnProgress == true &&
                                onProgress.isEmpty)
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 20),
                                    SizedBox(
                                      child: Image.asset(
                                        'assets/pencarian daftar harga.png',
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Text(
                                      'Data tidak ditemukan',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Ubah parameter pencarian untuk mencari data yang ditampilkan',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900,
                                          color: Colors.grey,
                                          fontSize: 11),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              )
                            else if (_isSearchButtonClickedOnProgress == true ||
                                onProgress.isNotEmpty)
                              Expanded(child: _buildOrderList(onProgress)),
                          ],
                        ),
                        // Completed Tab
                        Column(
                          children: [
                            if (completed.isEmpty)
                              Image.asset('assets/pencarian daftar harga.png'),
                            if (completed.isEmpty) SizedBox(height: 15),
                            if (completed.isEmpty)
                              Text(
                                'TIdak ada data yang dapat ditampilkan',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            if (completed.isEmpty) SizedBox(height: 10),
                            if (completed.isEmpty)
                              Text(
                                'Hubungi admin untuk detail selengkapnya',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey),
                              ),
                            Expanded(child: _buildOrderList(completed)),
                          ],
                        ),
                        // Cancel Tab
                        Column(
                          children: [
                            if (cancel.isEmpty)
                              Image.asset('assets/pencarian daftar harga.png'),
                            if (cancel.isEmpty) SizedBox(height: 15),
                            if (cancel.isEmpty)
                              Text(
                                'TIdak ada data yang dapat ditampilkan',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            if (cancel.isEmpty) SizedBox(height: 10),
                            if (cancel.isEmpty)
                              Text(
                                'Hubungi admin untuk detail selengkapnya',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey),
                              ),
                            Expanded(child: _buildOrderList(cancel)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (_totalPages > 1)
                    Container(
                      color: Colors.white,
                      height: 50,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            //search icon
                            IconButton(
                              icon: Icon(Icons.search, color: Colors.black),
                              iconSize: 20,
                              onPressed: () {
                                _pageController.text = '';
                                searchPage();
                              },
                            ),
                            // Double Arrow Back
                            SizedBox(
                              height: 60,
                              child: IconButton(
                                icon:
                                    Icon(Icons.first_page, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    if (currentPageIndex != 0) {
                                      currentPageIndex = 0;
                                      _fetchDataForPage(0); // First page
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                            //single arrow back
                            SizedBox(
                              height: 60,
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios),
                                iconSize: 20,
                                onPressed: () {
                                  setState(() {
                                    if (currentPageIndex > 0) {
                                      currentPageIndex--;
                                      _fetchDataForPage(currentPageIndex);
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                  print(
                                      "currentPageIndex minus: $currentPageIndex");
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller: _scrollController,
                                itemCount:
                                    getEndPageIndex() - getStartPageIndex(),
                                itemBuilder: (context, pageIndex) {
                                  int actualPageIndex =
                                      getStartPageIndex() + pageIndex;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentPageIndex = actualPageIndex;
                                        _fetchDataForPage(currentPageIndex);
                                      });
                                      // print(
                                      //     "Start Page Index: ${getStartPageIndex()}");
                                      // print(
                                      //     "End Page Index: ${getEndPageIndex()}");
                                      // print(
                                      //     "Current Page Index: $currentPageIndex");
                                      // if (currentPageIndex != actualPageIndex) {
                                      //   _fetchDataForPage(actualPageIndex);
                                      // }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        width:
                                            30, // Width of each page indicator
                                        decoration: BoxDecoration(
                                          color: actualPageIndex ==
                                                  currentPageIndex
                                              ? Colors.blue[300]
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${actualPageIndex + 1}', // Display page number
                                            style: TextStyle(
                                              color: actualPageIndex ==
                                                      currentPageIndex
                                                  ? Colors.white
                                                  : Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            //single arrow forward
                            SizedBox(
                              height: 50,
                              child: IconButton(
                                icon: Icon(Icons.arrow_forward_ios),
                                iconSize: 20,
                                onPressed: () {
                                  setState(() {
                                    if (currentPageIndex < _totalPages - 1) {
                                      currentPageIndex++;
                                      _fetchDataForPage(currentPageIndex);
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                  print(
                                      "currentPageIndex plus: $currentPageIndex");
                                },
                              ),
                            ),
                            // Double Arrow Forward
                            SizedBox(
                              height: 50,
                              child: IconButton(
                                icon:
                                    Icon(Icons.last_page, color: Colors.black),
                                onPressed: () {
                                  setState(() {
                                    if (currentPageIndex != _totalPages - 1) {
                                      currentPageIndex = _totalPages - 1;
                                      _fetchDataForPage(
                                          _totalPages - 1); // Last page
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderList(List<DaftarPesananAccesses> orders) {
    return ListView.builder(
      itemCount: orders.length,
      itemBuilder: (context, index) {
        var orderItem = orders[index];
        return
            // Expanded(
            //   child:
            _buildInvoiceCard(context, orderItem);
        // );
      },
    );
  }

  Widget _buildInvoiceCard(
      BuildContext context, DaftarPesananAccesses ordersItem) {
    return Container(
      margin: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey, // Red border color
          width: 2.0, // Border width
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(ordersItem.orderNumber.toString(),
                        style: TextStyle(
                            color: Colors.blue[800],
                            fontSize: 14,
                            fontFamily: 'Poppinss')),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        _copyToClipboardTransfer(
                            ordersItem.orderNumber.toString(), context);
                      },
                      child: Icon(
                        Icons.copy,
                        size: 16.0,
                        color: Colors.red[900],
                      ),
                    ),
                  ],
                ),
                if (ordersItem.statusId == 'SO06')
                  GestureDetector(
                      onTap: () {
                        infoOrder();
                      },
                      child: SizedBox(
                          height: 40, child: Image.asset('assets/info.png'))),
              ],
            ),
            if (ordersItem.statusId != 'SO06') SizedBox(height: 15),
            Table(
              columnWidths: {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(5),
              },
              children: [
                TableRow(children: [
                  //jasa
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'Jasa',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        ':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 2.0),
                        child: Text(ordersItem.orderService.toString(),
                            style: TextStyle(
                                fontFamily: 'Poppins Med', fontSize: 12))),
                  )
                ]),
                //total volume
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'Tipe Pengiriman',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        ':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          child: Text(ordersItem.shipmentType.toString(),
                              style: TextStyle(
                                  fontFamily: 'Poppins Med', fontSize: 12))))
                ]),
                //kota asal
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'Kota Asal',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        ':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          child: Text(ordersItem.originalCity.toString(),
                              style: TextStyle(
                                  fontFamily: 'Poppins Med', fontSize: 12))))
                ]),
                //kota tujuan
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'Kota Tujuan',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        ':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          child: Text(ordersItem.destinationCity.toString(),
                              style: TextStyle(
                                  fontFamily: 'Poppins Med', fontSize: 12))))
                ]),
                //total
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'Harga Total',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        ':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  ),
                  TableCell(
                      child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 2.0),
                          child: Text(ordersItem.formattedAmount,
                              style: TextStyle(
                                  fontFamily: 'Poppins Med', fontSize: 12))))
                ]),
              ],
            ),
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                if (ordersItem.statusId == 'SO04') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            DetaiInvoiceResiOrderPage(detailResi: ordersItem)),
                  );
                }
              },
              child: Text(
                ordersItem.status.toString(),
                style: TextStyle(
                  fontFamily: 'Poppins Med',
                  fontSize: 13,
                  color: ordersItem.statusId == 'SO04'
                      ? Color.fromARGB(255, 14, 17, 223)
                      : Colors.yellow[900],
                  decoration: ordersItem.statusId == 'SO04'
                      ? TextDecoration.underline
                      : TextDecoration.none,
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (ordersItem.statusId == 'SO06')
                  Flexible(
                    child: SizedBox(
                      width: 100,
                      height: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Colors.red[900],
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      UlasanNiagaPage(pesanan: ordersItem)),
                            );
                          },
                          child: Text(
                            'Ulasan',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'Poppins Med'),
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    width: 100,
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.red[900]!, // Red border color
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(7.0),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => DetailPesananNiagaPage(
                                      detail: ordersItem)),
                            );
                          },
                          child: Text(
                            'Detail',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.red[900],
                                fontFamily: 'Poppins Med'),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void performSearch() {
    String searchTextNoOrder = _noOrder.text.trim().toUpperCase();

    print('No Order adalah: $searchTextNoOrder');

    // Capture selected Tipe Pengiriman dan Jasa
    // String searchTipePengiriman = '';
    // if (selectedTipePengiriman == 'FCL (Full Container Load)') {
    //   searchTipePengiriman = 'FCL';
    // } else if (selectedTipePengiriman == 'LCL (Less Container Load)') {
    //   searchTipePengiriman = 'LCL';
    // }
    // // String searchJasa = selectedJasa?.toUpperCase() ?? '';
    // String searchJasa = '';
    // if (selectedJasa == 'DTD (Door to Door)') {
    //   searchJasa = 'DTD';
    // } else if (selectedJasa == 'PTD (Port to Door)') {
    //   searchJasa = 'PTD';
    // }

    _savedOrderService = (selectedTipePengiriman == 'FCL (Full Container Load)')
        ? 'FCL'
        : (selectedTipePengiriman == 'LCL (Less Container Load)')
            ? 'LCL'
            : '';

    _savedShipmentType = (selectedJasa == 'DTD (Door to Door)')
        ? 'DTD'
        : (selectedJasa == 'PTD (Port to Door)')
            ? 'PTD'
            : '';

    print('Tipe Pengiriman adalah: $_savedOrderService');
    print('Jasa adalah: $_savedShipmentType');

    if (searchTextNoOrder.isEmpty &&
        _savedOrderService!.isEmpty &&
        _savedShipmentType!.isEmpty) {
      onProgress.clear();
      // completePacking.clear();
      // Close the dialog if no search terms are provided
      Navigator.of(context).pop();
      return;
    }

    BlocProvider.of<DaftarPesananCubit>(context).searchPesananOnProgress(
      pageIndex: pageIndex,
      orderNumber: searchTextNoOrder,
      // orderNumber: _noOrder.text.trim().toUpperCase(),
      orderService: _savedOrderService,
      shipmentType: _savedShipmentType,
      originalCity: '',
      destinationCity: '',
      cargoReadyDate: '',
      firstName: '',
    );

    //ON PROGRESS
    onProgress.where((item) {
      bool matchesSearch = true;

      if (searchTextNoOrder.isNotEmpty) {
        matchesSearch = item.orderNumber != null &&
            item.orderNumber!
                .toUpperCase()
                .contains(searchTextNoOrder.toUpperCase());
      }
      if (_savedOrderService!.isNotEmpty) {
        matchesSearch = item.orderService != null &&
            item.orderService!
                .toUpperCase()
                .contains(_savedOrderService.toString());
      }
      if (_savedShipmentType!.isNotEmpty) {
        matchesSearch = item.shipmentType != null &&
            item.shipmentType!
                .toUpperCase()
                .contains(_savedShipmentType.toString());
      }

      return matchesSearch;
    }).toList();

    noResultsOnProgress = onProgress.isEmpty;

    Navigator.of(context).pop();
  }
}
