import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/order_online_fcl_cubit.dart';
import '../cubit/niaga/packing_niaga_cubit.dart';
import '../model/niaga/packing_detail_niaga.dart';
import '../model/niaga/packing_niaga.dart';
import '../model/niaga/port_asal_fcl.dart';
import '../model/niaga/port_tujuan_fcl.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../screen-niaga/order_niaga.dart';
import '../tracking/detail_tracking.dart';
import 'package:dropdown_search/dropdown_search.dart';

class MenuTrackingNiagaPage extends StatefulWidget {
  final String resiNumber;
  const MenuTrackingNiagaPage({Key? key, required this.resiNumber})
      : super(key: key);
  // final String niagaToken;
  // const MenuTrackingNiagaPage({Key? key, required this.niagaToken}) : super(key: key);

  @override
  State<MenuTrackingNiagaPage> createState() => _MenuTrackingNiagaPageState();
}

// class _MenuTrackingNiagaPageState extends State<MenuTrackingNiagaPage> {
class _MenuTrackingNiagaPageState extends State<MenuTrackingNiagaPage>
    with SingleTickerProviderStateMixin {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 1;
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

  List<PackingNiagaAccesses> invoiceModellist = [];
  List<PackingItemAccesses> onProgressPacking = [];
  List<PackingItemAccesses> completePacking = [];

  TextEditingController _NoPackingListController = TextEditingController();
  TextEditingController _NoContainerController = TextEditingController();
  TextEditingController _NamaKapalController = TextEditingController();

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    OrderHomeNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: ''),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

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

    // Initialize filtered lists with full invoice data
    // filteredListUnpaid = List.from(unpaidInvoices);
    // filteredListPaid = List.from(paidInvoices);
  }

  void _fetchDataForPage(int pageIndex) {
    if (_tabController.index == 0) {
      BlocProvider.of<PackingNiagaCubit>(context)
          .packingNiagaUnComplete(pageIndex: pageIndex);
    } else if (_tabController.index == 1) {
      BlocProvider.of<PackingNiagaCubit>(context)
          .packingNiagaComplete(pageIndex: pageIndex);
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

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
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

  @override
  Widget build(BuildContext context) {
    // print('isSelected nya: ' + isSelected.toString());
    final mediaQuery = MediaQuery.of(context);

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
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Color(0xFFB0BEC5), // A color close to grey[350]
                    //     offset: Offset(0, 2),
                    //     blurRadius: 5,
                    //     spreadRadius: 1,
                    //   )
                    // ],
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
              });
            }
          },
          builder: (context, state) {
            if (state is PackingNiagaCompleteInProgress ||
                state is PackingNiagaUnCompleteInProgress) {
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
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // On Progress Tab
                        Column(
                          children: [
                            if (onProgressPacking.isEmpty) SizedBox(height: 10),
                            if (onProgressPacking.isEmpty)
                              SizedBox(
                                child: Image.asset(
                                  'assets/pencarian daftar harga.png',
                                ),
                              ),
                            if (onProgressPacking.isEmpty) SizedBox(height: 15),
                            if (onProgressPacking.isEmpty)
                              Text(
                                'TIdak ada data yang dapat ditampilkan',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            if (onProgressPacking.isEmpty) SizedBox(height: 10),
                            if (onProgressPacking.isEmpty)
                              Text(
                                'Hubungi admin untuk detail selengkapnya',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey),
                              ),
                            Expanded(
                                child: _buildPackingList(onProgressPacking)),
                          ],
                        ),
                        // Completed Tab
                        Column(
                          children: [
                            if (completePacking.isEmpty) SizedBox(height: 10),
                            if (completePacking.isEmpty)
                              SizedBox(
                                child: Image.asset(
                                  'assets/pencarian daftar harga.png',
                                ),
                              ),
                            if (completePacking.isEmpty) SizedBox(height: 15),
                            if (completePacking.isEmpty)
                              Text(
                                'TIdak ada data yang dapat ditampilkan',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900, fontSize: 16),
                              ),
                            if (completePacking.isEmpty) SizedBox(height: 10),
                            if (completePacking.isEmpty)
                              Text(
                                'Hubungi admin untuk detail selengkapnya',
                                style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.grey),
                              ),
                            Expanded(child: _buildPackingList(completePacking)),
                            // _buildPagination(), // Pagination widget
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
                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
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
                                      padding: const EdgeInsets.only(left: 6),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        width:
                                            50, // Width of each page indicator
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
                                              fontSize: 18,
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
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
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
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withOpacity(0.5), // Shadow color
            //     spreadRadius: 5, // How much the shadow spreads
            //     blurRadius: 7, // How soft the shadow looks
            //     offset: Offset(0, 3), // Changes position of the shadow
            //   ),
            // ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard,
                  size: 27,
                ),
                label: 'Order',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  width: 23,
                  child: ImageIcon(
                    AssetImage('assets/tracking icon.png'),
                  ),
                ),
                label: 'Tracking',
              ),
              // BottomNavigationBarItem(
              //   icon: Stack(
              //     alignment:
              //         Alignment.center, // Centers the icon inside the circle
              //     children: <Widget>[
              //       Container(
              //         height: 40, // Adjust size of the circle
              //         width: 40,
              //         decoration: BoxDecoration(
              //           color: Colors.red[900], // Red circle color
              //           shape: BoxShape.circle,
              //         ),
              //       ),
              //       Icon(
              //         Icons.home,
              //         color:
              //             Colors.white, // Icon color (optional for visibility)
              //       ),
              //     ],
              //   ),
              //   label: 'Home',
              // ),
              BottomNavigationBarItem(
                icon: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      height: 50, // Adjusted size of the circle
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.red[900], // Red circle color
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      Icons.home,
                      size: 28,
                      color: Colors.white,
                    ),
                  ],
                ),
                label: '',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  width: 23,
                  child: ImageIcon(
                    AssetImage('assets/invoice icon.png'),
                  ),
                ),
                label: 'Invoice',
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.person,
                  size: 27,
                ),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            // selectedItemColor: Colors.grey[600],
            selectedItemColor: _selectedIndex == 1
                ? Colors.red[900] // Highlight the tracking icon in red
                : Colors.grey[600],
            onTap: _onItemTapped,
          ),
        ));
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
                      // Navigator.of(context).pop();
                      // performSearch();
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
      padding: EdgeInsets.all(12.0),
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
                //         child: Text(
                //             // 'ETA ${data.etaDate ?? 'N/A'}',
                //             'ETA ${packingItem.formattedTimeETA}', // Use formattedTime here
                //             style: TextStyle(
                //                 fontWeight: FontWeight.normal, fontSize: 10)),
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
              //kota tujuan row
              // TableRow(children: [
              //   TableCell(
              //     child: Padding(
              //       padding:
              //           EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
              //       child: Text('Kota Tujuan',
              //           style: TextStyle(fontWeight: FontWeight.normal)),
              //     ),
              //   ),
              //   TableCell(
              //     child: Padding(
              //       padding:
              //           EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
              //       child: Text(':',
              //           style: TextStyle(fontWeight: FontWeight.normal)),
              //     ),
              //   ),
              //   TableCell(
              //     child: Padding(
              //       padding:
              //           EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
              //       child: Text(packingItem.tujuan!,
              //           style: TextStyle(fontWeight: FontWeight.normal)),
              //     ),
              //   ),
              //   // TableCell(child: SizedBox()), // Empty cell to balance the table
              // ]),
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
                // TableCell(child: SizedBox()), // Empty cell to balance the table
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
                // TableCell(child: SizedBox()), // Empty cell to balance the table
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
          //==
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                width: 120,
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
                      style: TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Poppins Med'),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15),
              SizedBox(
                width: 90,
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
                      style: TextStyle(fontSize: 13, color: Colors.white, fontFamily: 'Poppins Med'),
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
