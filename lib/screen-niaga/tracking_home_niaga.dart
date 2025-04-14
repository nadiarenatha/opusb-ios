import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/niaga/order_online_fcl_cubit.dart';
import '../cubit/niaga/packing_niaga_cubit.dart';
import '../model/niaga/packing_detail_niaga.dart';
import '../model/niaga/packing_niaga.dart';
import '../model/niaga/port_asal_fcl.dart';
import '../model/niaga/port_tujuan_fcl.dart';
import '../tracking/detail_tracking.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/services.dart';

import 'home_niaga.dart';

class TrackingHomeNiagaPage extends StatefulWidget {
  final String resiNumber;
  const TrackingHomeNiagaPage({Key? key, required this.resiNumber})
      : super(key: key);
  // final String niagaToken;
  // const TrackingHomeNiagaPage({Key? key, required this.niagaToken}) : super(key: key);

  @override
  State<TrackingHomeNiagaPage> createState() => _TrackingHomeNiagaPageState();
}

// class _TrackingHomeNiagaPageState extends State<TrackingHomeNiagaPage> {
class _TrackingHomeNiagaPageState extends State<TrackingHomeNiagaPage>
    with SingleTickerProviderStateMixin {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  late TabController _tabController;
  late ScrollController _scrollController;
  //untuk pagination
  int currentPageIndex = 0;
  int itemsPerPage = 5; // Number of items per page
  int _totalPages = 0; // Store total pages from API
  int _currentPage = 1; // Track the current page
  int totalPages = 0; // Declare totalPages as a class-level variable
  int pageIndex = 0;
  int visiblePages = 5; // Number of visible page numbers

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
  bool noResultsComplete = false;

  bool _isSearchButtonClickedOnProgress = false;
  bool _isSearchButtonClickedComplete = false;

  List<PackingNiagaAccesses> invoiceModellist = [];
  List<PackingItemAccesses> onProgressPacking = [];
  List<PackingItemAccesses> completePacking = [];
  // List<PackingItemAccesses> filteredListUnpaid = [];
  // List<PackingItemAccesses> filteredListPaid = [];

  TextEditingController _NoContainerController = TextEditingController();
  TextEditingController _NoPackingListController = TextEditingController();
  TextEditingController _NamaKapalController = TextEditingController();
  TextEditingController _pageController = TextEditingController();

  String _noPackingList = '';
  String _noContainer = '';
  String _kotaAsal = '';
  String _kotaTujuan = '';
  String _namaKapal = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this)
      ..addListener(() {
        if (_tabController.indexIsChanging) {
          _handleTabChange(_tabController.index);
        }
      });
    _scrollController = ScrollController();

    // Load initial data
    _fetchDataForPage(currentPageIndex + 1);
  }

  void _fetchDataForPage(int pageIndex) {
    if (_tabController.index == 0) {
      // BlocProvider.of<PackingNiagaCubit>(context)
      //     .packingNiagaUnComplete(pageIndex: pageIndex);
      BlocProvider.of<PackingNiagaCubit>(context).searchPackingUnComplete(
          pageIndex: pageIndex,
          noPL: _noPackingList,
          containerNo: _noContainer,
          asal: _kotaAsal,
          tujuan: _kotaTujuan,
          vesselName: _namaKapal);
    } else if (_tabController.index == 1) {
      // BlocProvider.of<PackingNiagaCubit>(context)
      //     .packingNiagaComplete(pageIndex: pageIndex);
      BlocProvider.of<PackingNiagaCubit>(context).searchPackingComplete(
          pageIndex: pageIndex,
          noPL: _noPackingList,
          containerNo: _noContainer,
          asal: _kotaAsal,
          tujuan: _kotaTujuan,
          vesselName: _namaKapal);
    }
    setState(() {
      _currentPage = pageIndex;
      currentPageIndex = pageIndex - 1; // Adjust for zero-based index
    });
  }

  int getStartPageIndex() {
    return ((currentPageIndex ~/ visiblePages) * visiblePages).toInt();
  }

  int getEndPageIndex() {
    int endPage = (getStartPageIndex() + visiblePages).toInt();
    return endPage > _totalPages ? _totalPages : endPage;
  }

  void fetchKotaTujuan(String portAsal) {
    print("Fetching Kota Tujuan for Port Asal: $portAsal"); // Debugging line
    // Fetch the kotaTujuan based on the selected portAsal
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortTujuanFCL(portAsal);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabChange(int index) {
    if (index == 0) {
      onProgressPacking.clear(); // Clear previous data
      _fetchDataForPage(currentPageIndex + 1);
    } else if (index == 1) {
      completePacking.clear(); // Clear previous data
      _fetchDataForPage(currentPageIndex + 1);
    }
  }

  //untuk fungsi calendar pada pop up dialog search dengan nama _dateController
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
        controller.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future downloadSuccess() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => Center(
            child: SingleChildScrollView(
              child: AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0)),
                  titlePadding: EdgeInsets.zero,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25, vertical: 3),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: downloadfile()),
            ),
          ));

  downloadfile() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to start
        children: [
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/notif register.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Download Successful. The file has been saved to your device",
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
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
          SizedBox(height: 5),
        ],
      ),
    );
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
                            _fetchDataForPage(pageNumber);
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

  Future searchPacking() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
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
                content: search()),
          ));

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage()),
    );
    return false; // Prevent default back navigation
  }

  @override
  Widget build(BuildContext context) {
    // print('isSelected nya: ' + isSelected.toString());
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
                    "Tracking & Packing List",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.red[900],
                        fontFamily: 'Poppins Extra Bold'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  // width: 30,
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
                      _NoPackingListController.text = '';
                      _NoContainerController.text = '';
                      _NamaKapalController.text = '';

                      // Reset the selected Kota Asal and Kota Tujuan to null
                      setState(() {
                        selectedKotaAsal = null; // Clear the selected Kota Asal
                        selectedKotaTujuan =
                            null; // Clear the selected Kota Tujuan
                        kotaTujuanList =
                            []; // Clear the Kota Tujuan list as well
                      });
                      // Trigger the Bloc to fetch data for Kota Asal
                      context.read<OrderOnlineFCLCubit>().fetchPortAsalFCL();
                      searchPacking();
                    },
                  ),
                ),
              ],
            ),
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
          ),
        ),
        //untuk setting form
        body: BlocConsumer<PackingNiagaCubit, PackingNiagaState>(
          listener: (context, state) async {
            if (state is PackingNiagaUnCompleteSuccess) {
              // Extract totalPage and set the data
              setState(() {
                // _totalPages =
                //     state.response.first.totalPage ?? 0; // Store totalPage
                _totalPages = state.totalPages;
                print("Total Pages Packing Uncomplete: $_totalPages");
                // Convert List<PackingNiagaAccesses> to List<packingItemAccesses>
                onProgressPacking = state.response
                    .expand((packingAccess) => packingAccess.data)
                    .toList();

                noResultsOnProgress = _totalPages == 0;
              });
            } else if (state is PackingNiagaCompleteSuccess) {
              setState(() {
                // _totalPages = state.response.first.totalPage ?? 0;
                _totalPages = state.totalPages;
                print("Total Pages Packing Complete: $_totalPages");
                // Convert List<CloseInvoiceAccesses> to List<packingItemAccesses>
                completePacking = state.response
                    .expand((packingAccess) => packingAccess.data)
                    .toList();

                noResultsComplete = _totalPages == 0;
              });
            } else if (state is SearchPackingCompleteSuccess) {
              setState(() {
                completePacking.clear();
                // Access totalPages from SearchPackingCompleteSuccess
                _totalPages = state.totalPages;
                print("Total Pages Packing Complete: $_totalPages");

                // Convert List<CloseInvoiceAccesses> to List<packingItemAccesses>
                completePacking = state.response
                    .expand((packingAccess) => packingAccess.data)
                    .toList();
              });
            } else if (state is SearchPackingUnCompleteSuccess) {
              setState(() {
                onProgressPacking.clear();
                // Access totalPages from SearchPackingCompleteSuccess
                _totalPages = state.totalPages;
                print("Total Pages Packing UnComplete: $_totalPages");

                // Convert List<CloseInvoiceAccesses> to List<packingItemAccesses>
                onProgressPacking = state.response
                    .expand((packingAccess) => packingAccess.data)
                    .toList();
              });
            } else if (state is SearchPackingCompleteFailure) {
              completePacking.clear();
              noResultsComplete = true;
            } else if (state is SearchPackingUnCompleteFailure) {
              onProgressPacking.clear();
              noResultsOnProgress = true;
            } else if (state is DownloadPackingSuccess) {
              await downloadSuccess();
            }
          },
          builder: (context, state) {
            if (state is PackingNiagaCompleteInProgress ||
                state is PackingNiagaUnCompleteInProgress ||
                state is SearchPackingCompleteInProgress ||
                state is SearchPackingUnCompleteInProgress ||
                state is DownloadPackingInProgress) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber[600],
                ),
              );
            }
            return DefaultTabController(
              length: 2,
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
                              fontSize: 14),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Completed',
                          style: TextStyle(
                              fontFamily: _tabController.index == 1
                                  ? 'Poppins Bold'
                                  : 'Poppins Med',
                              fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  // Your TabBarView
                  // Expanded(
                  //   child: TabBarView(
                  //     controller: _tabController,
                  //     children: [
                  //       _buildPackingList(onProgressPacking),
                  //       _buildPackingList(completePacking),
                  //     ],
                  //   ),
                  // ),
                  //NEW
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // On Progress Tab
                        Column(
                          children: [
                            // if (onProgressPacking.isEmpty)
                            if (onProgressPacking.isEmpty &&
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
                            // _isSearchButtonClicked &&
                            //         _totalPages == 0 &&
                            //         noResultsOnProgress
                            if (_isSearchButtonClickedOnProgress == true &&
                                onProgressPacking.isEmpty)
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
                                onProgressPacking.isNotEmpty)
                              Expanded(
                                child: _buildPackingList(onProgressPacking),
                              ),
                          ],
                        ),
                        // Completed Tab
                        Column(
                          children: [
                            // if (completePacking.isEmpty)
                            if (completePacking.isEmpty &&
                                _isSearchButtonClickedComplete == false)
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
                                    ),
                                  ),
                                ],
                              )),
                            // if (_isSearchButtonClicked &&
                            //     _totalPages == 0 &&
                            //     noResultsComplete)
                            if (_isSearchButtonClickedComplete == true &&
                                completePacking.isEmpty)
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
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            else if (_isSearchButtonClickedComplete == true ||
                                completePacking.isNotEmpty)
                              Expanded(
                                child: _buildPackingList(completePacking),
                              ),
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
                                      _fetchDataForPage(1); // First page
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
                                      _fetchDataForPage(currentPageIndex + 1);
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
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                controller:
                                    _scrollController, // Attach the ScrollController here
                                itemCount:
                                    getEndPageIndex() - getStartPageIndex(),
                                itemBuilder: (context, pageIndex) {
                                  int actualPageIndex =
                                      getStartPageIndex() + pageIndex;
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        currentPageIndex = actualPageIndex;
                                        _fetchDataForPage(currentPageIndex + 1);
                                      });
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
                                              // ? Colors.blue[800]
                                              // : Colors.blue[600],
                                              ? Colors.blue[300]
                                              : Colors.grey[300],
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${actualPageIndex + 1}', // Display page number
                                            style: TextStyle(
                                              // color: Colors.white,
                                              color: actualPageIndex ==
                                                      currentPageIndex
                                                  // Active page text color
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
                                      _fetchDataForPage(currentPageIndex + 1);
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
                                          _totalPages); // Last page
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

  // List<String> kotaAsalList = ['Jakarta', 'Surabaya', 'Medan', 'Bandung'];
  // List<String> kotaTujuanList = ['Bali', 'Yogyakarta', 'Semarang', 'Malang'];

  Widget search() {
    return BlocConsumer<OrderOnlineFCLCubit, OrderOnlineFCLState>(
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
      },
      builder: (context, state) {
        return ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 990, maxWidth: 300),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "No Packing List",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Poppin', fontSize: 14),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black, // Set border color
                    width: 1.0, // Set border width
                  ),
                ),
                child: TextFormField(
                  controller: _NoPackingListController,
                  decoration: InputDecoration(
                    hintText: 'masukkan nomor packing list',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                "No Container",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Poppin', fontSize: 14),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black, // Set border color
                    width: 1.0, // Set border width
                  ),
                ),
                child: TextFormField(
                  controller: _NoContainerController,
                  decoration: InputDecoration(
                    hintText: 'masukkan nomor container',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Kota Asal Dropdown
              Text(
                "Kota Asal",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Poppin', fontSize: 14),
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
                      selectedPortAsal = portAsalToKotaAsalMap.keys.firstWhere(
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
                  selectedItem: selectedKotaAsal, // No default selection
                ),
              ),
              SizedBox(height: 20),
              // Kota Tujuan Dropdown
              Text(
                "Kota Tujuan",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Poppin', fontSize: 14),
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
                    // Handle selection
                    print("Selected Kota Tujuan: $newValue");
                    setState(() {
                      selectedKotaTujuan = newValue;

                      //NEW
                      // Get the corresponding portTujuan from the selected kotaTujuan
                      if (newValue != null &&
                          kotaTujuanToPortTujuanMap.containsKey(newValue)) {
                        String? selectedPortTujuan =
                            kotaTujuanToPortTujuanMap[newValue];
                        print("Corresponding Port Tujuan: $selectedPortTujuan");

                        // Save or use the selected portTujuan as needed
                      }
                    });
                  },
                  popupProps: PopupProps.menu(
                    showSearchBox: true,
                  ),
                  // selectedItem: null, // No default selection
                  selectedItem: selectedKotaTujuan, // No default selection
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Nama Kapal",
                style: TextStyle(
                    color: Colors.black, fontFamily: 'Poppin', fontSize: 14),
              ),
              SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    color: Colors.black, // Set border color
                    width: 1.0, // Set border width
                  ),
                ),
                child: TextFormField(
                  controller: _NamaKapalController,
                  decoration: InputDecoration(
                    hintText: 'masukkan nama kapal',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    border: InputBorder.none,
                  ),
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
                        // Set to true when button is clicked
                        _isSearchButtonClickedOnProgress = true;
                        _isSearchButtonClickedComplete = true;
                        noResultsOnProgress = false;
                        noResultsComplete = false;
                      });
                      performSearch();
                      if (_NoPackingListController.text.isEmpty &&
                          _NoContainerController.text.isEmpty &&
                          _NamaKapalController.text.isEmpty) {
                        context
                            .read<PackingNiagaCubit>()
                            .searchPackingComplete();
                        context
                            .read<PackingNiagaCubit>()
                            .searchPackingUnComplete();
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
              SizedBox(height: 10)
            ],
          ),
        );
      },
    );
  }

  void performSearch() {
    String searchTextNoPacking =
        _NoPackingListController.text.trim().toUpperCase();
    String searchTextNoContainer =
        _NoContainerController.text.trim().toUpperCase();
    String searchTextNamaKapal = _NamaKapalController.text.trim().toUpperCase();

    print('No Packing adalah: $searchTextNoPacking');
    print('No Container adalah: $searchTextNoContainer');
    print('Nama Kapal adalah: $searchTextNamaKapal');

    // Capture selected Kota Asal and Kota Tujuan
    String searchPortAsal = selectedPortAsal?.toUpperCase() ?? '';
    String searchPortTujuan = selectedPortTujuan?.toUpperCase() ?? '';

    print('Port Asal adalah: $searchPortAsal');
    print('Port Tujuan adalah: $searchPortTujuan');

    if (searchTextNoPacking.isEmpty &&
        searchTextNoContainer.isEmpty &&
        searchTextNamaKapal.isEmpty &&
        searchPortAsal.isEmpty &&
        searchPortTujuan.isEmpty) {
      onProgressPacking.clear();
      completePacking.clear();
      // Close the dialog if no search terms are provided
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _noPackingList = searchTextNoPacking;
      _noContainer = searchTextNoContainer;
      _kotaAsal = searchPortAsal;
      _kotaTujuan = searchPortTujuan;
      _namaKapal = searchTextNamaKapal;
    });

    BlocProvider.of<PackingNiagaCubit>(context).searchPackingComplete(
      noPL: searchTextNoPacking,
      containerNo: searchTextNoContainer,
      asal: searchPortAsal,
      tujuan: searchPortTujuan,
      vesselName: searchTextNamaKapal,
    );

    BlocProvider.of<PackingNiagaCubit>(context).searchPackingUnComplete(
      noPL: searchTextNoPacking,
      containerNo: searchTextNoContainer,
      asal: searchPortAsal,
      tujuan: searchPortTujuan,
      vesselName: searchTextNamaKapal,
    );

    //ON PROGRESS
    onProgressPacking.where((item) {
      bool matchesSearch = true;

      if (searchTextNoPacking.isNotEmpty) {
        matchesSearch = item.noPL != null &&
            item.noPL!
                .toUpperCase()
                .contains(searchTextNoPacking.toUpperCase());
      }
      if (searchTextNoContainer.isNotEmpty) {
        matchesSearch = item.containerNo != null &&
            item.containerNo!
                .toUpperCase()
                .contains(searchTextNoContainer.toUpperCase());
      }
      if (searchTextNamaKapal.isNotEmpty) {
        matchesSearch = item.vesselName != null &&
            item.vesselName!
                .toUpperCase()
                .contains(searchTextNamaKapal.toUpperCase());
      }
      if (searchPortAsal.isNotEmpty) {
        matchesSearch = item.asal != null &&
            item.asal!.toUpperCase().contains(searchPortAsal);
      }
      if (searchPortTujuan.isNotEmpty) {
        matchesSearch = item.tujuan != null &&
            item.tujuan!.toUpperCase().contains(searchPortTujuan);
      }

      return matchesSearch;
    }).toList();

    //COMPLETE
    completePacking.where((item) {
      bool matchesSearch = true;

      if (searchTextNoPacking.isNotEmpty) {
        matchesSearch = item.noPL != null &&
            item.noPL!
                .toUpperCase()
                .contains(searchTextNoPacking.toUpperCase());
      }
      if (searchTextNoContainer.isNotEmpty) {
        matchesSearch = item.containerNo != null &&
            item.containerNo!
                .toUpperCase()
                .contains(searchTextNoContainer.toUpperCase());
      }
      if (searchTextNamaKapal.isNotEmpty) {
        matchesSearch = item.vesselName != null &&
            item.vesselName!
                .toUpperCase()
                .contains(searchTextNamaKapal.toUpperCase());
      }

      return matchesSearch;
    }).toList();

    noResultsOnProgress = onProgressPacking.isEmpty;
    noResultsComplete = completePacking.isEmpty;

    Navigator.of(context).pop();
  }
}

Widget _buildPackingList(List<PackingItemAccesses> packing) {
  return ListView.builder(
    itemCount: packing.length,
    itemBuilder: (context, index) {
      var packingItem = packing[index];
      // return _buildInvoiceCard(packingItem);
      return _buildPackingCard(context, packingItem);
    },
  );
}

// Widget _buildInvoiceCard(packingItemAccesses packingItem) {
Widget _buildPackingCard(
    BuildContext context, PackingItemAccesses packingItem) {
  return Container(
    margin: EdgeInsets.all(12),
    // height: 200, // Adjust according to your UI
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(20),
      // boxShadow: [
      //   BoxShadow(
      //     color: Color(0xFFB0BEC5),
      //     offset: Offset(0, 6),
      //     blurRadius: 10,
      //     spreadRadius: 1,
      //   ),
      // ],
    ),
    child: Padding(
      padding: EdgeInsets.all(14.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            packingItem.noPL!,
            style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
                fontFamily: 'Poppins Med'),
          ),
          SizedBox(height: 20),
          Table(
            columnWidths: {
              0: FlexColumnWidth(4), // First column
              1: FlexColumnWidth(1), // Second column
              2: FlexColumnWidth(5), // Third column
              // 3: FlexColumnWidth(6), // Fourth column (if needed)
            },
            children: [
              // Type Pengiriman row
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text('Tipe Pengiriman',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(
                      ':',
                      style: TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(packingItem.tipePengiriman!,
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                // TableCell(child: SizedBox()), // Empty cell to balance the table
              ]),

              // Volume row with IconButton for ETA
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text('Volume',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(packingItem.volume.toString(),
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                // TableCell(
                //   child: Row(
                //     children: [
                //       IconButton(
                //         icon: Icon(Icons.calendar_today, size: 20),
                //         onPressed: () {
                //           // Handle ETA calendar action
                //         },
                //       ),
                //       Expanded(
                //         child: Text(packingItem.etaDate!,
                //         style: TextStyle(fontWeight: FontWeight.normal)),
                //       ),
                //     ],
                //   ),
                // ),
              ]),

              // Kota Asal row
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text('Rute Pengiriman',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text('${packingItem.asal!} - ${packingItem.tujuan!}',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
              ]),
              // Nama Kapal row
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text('Nama Kapal',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(packingItem.vesselName!,
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
              ]),
              // Status row
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text('Status',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(':',
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(packingItem.status!,
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12)),
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 10),
          // Row(
          //   children: [
          //     IconButton(
          //       icon: Icon(Icons.calendar_today, size: 20),
          //       onPressed: () {
          //         // Handle ETA calendar action
          //       },
          //     ),
          //     Expanded(
          //       child: Text('ETA ${packingItem.etaDate}',
          //           style: TextStyle(fontFamily: 'Poppinss', fontSize: 12)),
          //     ),
          //   ],
          // ),
          // Row(
          //   children: [
          //     IconButton(
          //       icon: Icon(Icons.calendar_today, size: 20),
          //       onPressed: () {
          //         // Handle ETA calendar action
          //       },
          //     ),
          //     Expanded(
          //       child: Text('ETD ${packingItem.etdDate}',
          //           style: TextStyle(fontFamily: 'Poppinss', fontSize: 12)),
          //     ),
          //   ],
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20),
                  SizedBox(width: 4.0),
                  Text(
                    'ETA ${packingItem.etaDate}',
                    style: TextStyle(fontFamily: 'Poppinss', fontSize: 12),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20),
                  SizedBox(width: 4.0),
                  Text(
                    'ETD ${packingItem.etdDate}',
                    style: TextStyle(fontFamily: 'Poppinss', fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 15),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.end,
          //   children: [
          //     SizedBox(
          //       width: 100, // Adjust width to make the button smaller
          //       child: Material(
          //         borderRadius: BorderRadius.circular(7.0),
          //         color: Colors.red[900],
          //         shadowColor: Colors.grey[350],
          //         elevation: 5,
          //         child: MaterialButton(
          //           padding: EdgeInsets.symmetric(
          //               vertical: 8, horizontal: 10), // Adjust padding for size
          //           onPressed: () async {
          //             final noPackingList = packingItem.noPL;
          //             final tipePackingList = packingItem.tipePL;

          //             if (noPackingList != null && tipePackingList != null) {
          //               BlocProvider.of<PackingNiagaCubit>(context)
          //                   .downloadpacking(noPackingList, tipePackingList);
          //             } else {
          //               ScaffoldMessenger.of(context).showSnackBar(
          //                 SnackBar(content: Text('Packing is missing')),
          //               );
          //             }
          //           },
          //           child: Text(
          //             'Download',
          //             style: TextStyle(fontSize: 16, color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ),
          //     SizedBox(width: 15),
          //     SizedBox(
          //       width: 100, // Adjust width to make the button smaller
          //       child: Material(
          //         borderRadius: BorderRadius.circular(7.0),
          //         color: Colors.red[900],
          //         shadowColor: Colors.grey[350],
          //         elevation: 5,
          //         child: MaterialButton(
          //           padding: EdgeInsets.symmetric(
          //               vertical: 8, horizontal: 10), // Adjust padding for size
          //           onPressed: () async {
          //             Navigator.push(context,
          //                 MaterialPageRoute(builder: (context) {
          //               return DetailJenisTrackingNiaga(tracking: packingItem);
          //             }));
          //           },
          //           child: Text(
          //             'Track',
          //             style: TextStyle(fontSize: 16, color: Colors.white),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
          //==
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 100, // Adjust width to make the button smaller
                height: 40,
                child: Material(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.red[900],
                  // shadowColor: Colors.grey[350],
                  // elevation: 5,
                  child: MaterialButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10), // Adjust padding for size
                    onPressed: () async {
                      final noPackingList = packingItem.noPL;
                      final tipePackingList = packingItem.tipePL;

                      if (noPackingList != null && tipePackingList != null) {
                        BlocProvider.of<PackingNiagaCubit>(context)
                            .downloadpacking(noPackingList, tipePackingList);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Packing is missing')),
                        );
                      }
                    },
                    child: Text(
                      'Download',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontFamily: 'Poppins Med'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 80, // Adjust width to make the button smaller
                height: 40,
                child: Material(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.red[900],
                  // shadowColor: Colors.grey[350],
                  // elevation: 5,
                  child: MaterialButton(
                    padding: EdgeInsets.symmetric(
                        vertical: 8, horizontal: 10), // Adjust padding for size
                    onPressed: () async {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return DetailJenisTrackingNiaga(tracking: packingItem);
                      }));
                    },
                    child: Text(
                      'Track',
                      style: TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontFamily: 'Poppins Med'),
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
