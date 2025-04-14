import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/niaga/invoice_group_cubit.dart';
import '../cubit/niaga/invoice_niaga_cubit.dart';
import '../model/niaga/daftar-pesanan/daftar_pesanan.dart';
import '../model/niaga/detail_invoice_group.dart';
import '../model/niaga/open_invoice_detail_niaga.dart';
import '../model/niaga/open_invoice_niaga.dart';
import '../payment/invoice_gabungan.dart';
import '../payment/pembayaran_page.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/detail_invoice_home_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../screen-niaga/invoice_home_niaga.dart';
import '../screen-niaga/order_niaga.dart';
import '../screen-niaga/tracking_home_niaga.dart';
import 'package:intl/intl.dart';

class DetaiInvoiceResiOrderPage extends StatefulWidget {
  final DaftarPesananAccesses detailResi;
  const DetaiInvoiceResiOrderPage({Key? key, required this.detailResi})
      : super(key: key);

  @override
  State<DetaiInvoiceResiOrderPage> createState() =>
      _DetaiInvoiceResiOrderPageState();
}

class _DetaiInvoiceResiOrderPageState extends State<DetaiInvoiceResiOrderPage>
    with SingleTickerProviderStateMixin {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 3;
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

  List<OpenInvoiceAccesses> invoiceModellist = [];
  List<InvoiceItemAccesses> unpaidInvoices = [];
  List<InvoiceItemAccesses> paidInvoices = [];
  List<InvoiceItemAccesses> onProcessInvoices = [];
  List<InvoiceItemAccesses> filteredListUnpaid = [];
  List<InvoiceItemAccesses> filteredListPaid = [];

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _noInvoice = TextEditingController();
  TextEditingController _noOrder = TextEditingController();
  TextEditingController _noPackingList = TextEditingController();

  //checkbox
  bool _isCombinedPayment = false;
  //checkbox tiap container
  Map<String, Map<String, dynamic>> _selectedInvoices = {};
  DetailInvoiceGroupAccess? invoiceGroup;

  bool noResultsUnpaid = false;
  bool noResultsPaid = false;
  bool noResultsOnProcess = false;

  bool _isSearchButtonClickedUnpaid = false;
  bool _isSearchButtonClickedPaid = false;
  bool _isSearchButtonClickedOnProcess = false;

  String _noInvoices = '';
  String _noOrders = '';

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    OrderHomeNiagaPage(),
    TrackingHomeNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MyInvoiceHomeNiagaPage(),
    ProfileNiagaPage(),
  ];

  void resetCombinedPayment() {
    setState(() {
      _isCombinedPayment = false;
      _selectedInvoices.updateAll((key, value) => {
            ...value,
            'isSelected': false,
          });
    });
  }

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

    // Load initial data
    _fetchDataForPage(currentPageIndex + 1);
  }

  void _fetchDataForPage(int pageIndex) {
    if (_tabController.index == 0) {
      print('No Invoice nya Unpaid: ${widget.detailResi.invoiceNum}');
      print('No Order nya Unpaid: $_noOrders');
      BlocProvider.of<InvoiceNiagaCubit>(context).openinvoice(
          pageIndex: pageIndex,
          invoiceNumber: widget.detailResi.invoiceNum,
          noJob: '');
    } else if (_tabController.index == 1) {
      print('No Invoice nya On Progress: ${widget.detailResi.invoiceNum}');
      print('No Order nya On Progress: $_noOrders');
      BlocProvider.of<InvoiceNiagaCubit>(context).invoiceOnProcess(
          pageIndex: pageIndex,
          invoiceNumber: widget.detailResi.invoiceNum,
          noJob: '');
    } else if (_tabController.index == 2) {
      print('No Invoice nya Paid: ${widget.detailResi.invoiceNum}');
      print('No Order nya Paid: $_noOrders');
      BlocProvider.of<InvoiceNiagaCubit>(context).closeinvoice(
          pageIndex: pageIndex,
          invoiceNumber: widget.detailResi.invoiceNum,
          noJob: '');
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

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleTabChange(int index) {
    if (index == 0) {
      unpaidInvoices.clear(); // Clear previous data
      _fetchDataForPage(currentPageIndex + 1);
    } else if (index == 1) {
      onProcessInvoices.clear(); // Clear previous data
      _fetchDataForPage(currentPageIndex + 1);
    } else if (index == 2) {
      paidInvoices.clear(); // Clear previous data
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

  //untuk fungsi pop up dialog search
  Future searchMyInvoice() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            //untuk memberi border melengkung
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            //untuk mengatur letak dari close icon
            titlePadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 3),
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
                    "No Invoice",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
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
                      controller: _noInvoice,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nomor invoice',
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
                    "No. Order",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
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
                      controller: _noOrder,
                      decoration: InputDecoration(
                        hintText: 'Masukkan nomor order',
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
                          _isSearchButtonClickedUnpaid = true;
                          _isSearchButtonClickedPaid = true;
                          _isSearchButtonClickedOnProcess = true;
                          noResultsUnpaid = false;
                          noResultsPaid = false;
                          noResultsOnProcess = false;
                          performSearch();
                          if (_noInvoice.text.isEmpty &&
                              _noOrder.text.isEmpty &&
                              _noPackingList.text.isEmpty) {
                            context.read<InvoiceNiagaCubit>().openinvoice();
                            context.read<InvoiceNiagaCubit>().closeinvoice();
                            context
                                .read<InvoiceNiagaCubit>()
                                .invoiceOnProcess();
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
          ));

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage(initialIndex: 0)),
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
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeNiagaPage(initialIndex: 0)),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Tagihan Saya",
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
        //untuk setting form
        body: BlocConsumer<InvoiceNiagaCubit, InvoiceNiagaState>(
          listener: (context, state) async {
            if (state is OpenInvoiceSuccess) {
              // Extract totalPage and set the data
              setState(() {
                _totalPages = state.totalPages;
                print("Total Pages Paid (OpenInvoice): $_totalPages");
                unpaidInvoices = state.response
                    .expand((invoiceAccess) => invoiceAccess.data)
                    .toList();
              });
            } else if (state is CloseInvoiceSuccess) {
              setState(() {
                _totalPages = state.totalPages;
                print("Total Pages Unpaid(CloseInvoice): $_totalPages");
                paidInvoices = state.response
                    .expand((invoiceAccess) => invoiceAccess.data)
                    .toList();
              });
            } else if (state is InvoiceOnProcessSuccess) {
              setState(() {
                _totalPages = state.totalPages;
                print("Total Pages On Process Invoice: $_totalPages");
                onProcessInvoices = state.response
                    .expand((invoiceAccess) => invoiceAccess.data)
                    .toList();
              });
            } else if (state is SearchInvoiceSuccess) {
              unpaidInvoices.clear();
              paidInvoices.clear();
              _totalPages = state.totalPages;
              print("Total Pages Search Invoice: $_totalPages");
              unpaidInvoices = state.response
                  .expand((invoiceAccess) => invoiceAccess.data)
                  .toList();
              paidInvoices = state.response
                  .expand((invoiceAccess) => invoiceAccess.data)
                  .toList();
            } else if (state is SearchInvoiceFailure) {
              unpaidInvoices.clear();
              paidInvoices.clear();
              noResultsUnpaid = true;
              noResultsPaid = true;
            }
          },
          builder: (context, state) {
            if (state is OpenInvoiceInProgress ||
                state is CloseInvoiceInProgress ||
                state is InvoiceOnProcessInProgress ||
                state is DownloadInvoiceInProgress ||
                state is SearchInvoiceInProgress) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber[600],
                ),
              );
            }
            return BlocConsumer<InvoiceGroupCubit, InvoiceGroupState>(
                listener: (context, state) async {
              if (state is MultipleInvoiceSuccess) {
                // invoiceGroup = state.response;
                final noInvGroup =
                    state.response?.noInvGroup ?? 'DefaultInvoiceGroup';
                final total = state.response?.total ?? 0;

                String merchantId = '';
                String subMerchantId = '';
                String selectedCabang = '';

                if (_selectedInvoices.isNotEmpty) {
                  final firstSelectedInvoice = _selectedInvoices.values.first;
                  merchantId = firstSelectedInvoice['merchantId'] ?? '';
                  subMerchantId = firstSelectedInvoice['subMerchantId'] ?? '';
                  selectedCabang = firstSelectedInvoice['selectedCabang'] ?? '';
                }

                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return InvoiceGabunganPage(
                      noInvGroup: noInvGroup,
                      total: total,
                      merchantId: merchantId,
                      subMerchantId: subMerchantId,
                      cabang: selectedCabang);
                }));
              }
              if (state is DeleteInvoiceSuccess) {
                // Reset _isCombinedPayment when DeleteInvoiceSuccess is triggered
                resetCombinedPayment();
              }
            }, builder: (context, state) {
              if (state is MultipleInvoiceInProgress) {
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
                            'Unpaid',
                            style: TextStyle(
                                fontFamily: _tabController.index == 0
                                    ? 'Poppins Bold'
                                    : 'Poppins Med',
                                fontSize: 13),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'On Process',
                            style: TextStyle(
                                fontFamily: _tabController.index == 1
                                    ? 'Poppins Bold'
                                    : 'Poppins Med',
                                fontSize: 13),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Paid',
                            style: TextStyle(
                                fontFamily: _tabController.index == 2
                                    ? 'Poppins Bold'
                                    : 'Poppins Med',
                                fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                    //NEW
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Unpaid Tab
                          Column(
                            children: [
                              // if (unpaidInvoices.isNotEmpty)
                              //   Padding(
                              //     padding: const EdgeInsets.only(right: 12),
                              //     child: Row(
                              //       mainAxisAlignment: MainAxisAlignment.end,
                              //       children: [
                              //         Row(
                              //           mainAxisAlignment: MainAxisAlignment.end,
                              //           children: [
                              //             Checkbox(
                              //               value: _isCombinedPayment,
                              //               onChanged: (value) {
                              //                 setState(() {
                              //                   _isCombinedPayment = value!;
                              //                   if (!_isCombinedPayment) {
                              //                     // Clear selections if combined payment is unchecked
                              //                     _selectedInvoices.clear();
                              //                   }
                              //                 });
                              //               },
                              //               activeColor: Colors.red[900],
                              //             ),
                              //             Text(
                              //               'Gabungkan Pembayaran',
                              //               style: TextStyle(
                              //                   fontSize: 12,
                              //                   fontFamily: 'Poppins Med'),
                              //             ),
                              //           ],
                              //         ),
                              //         SizedBox(width: 10),
                              //         if (_isCombinedPayment == true)
                              //           SizedBox(
                              //             width: 80,
                              //             height: 30,
                              //             child: Material(
                              //               borderRadius:
                              //                   BorderRadius.circular(7.0),
                              //               color: Colors.grey,
                              //               child: OutlinedButton(
                              //                 style: OutlinedButton.styleFrom(
                              //                   // Smaller size
                              //                   minimumSize: Size(100, 50),
                              //                   side: BorderSide(
                              //                     color: _selectedInvoices.values
                              //                                 .where((e) =>
                              //                                     e['isSelected'] ==
                              //                                     true)
                              //                                 .length >
                              //                             1
                              //                         ? Colors.red[900]!
                              //                         : Colors.grey,
                              //                     width: 2,
                              //                   ),
                              //                   shape: RoundedRectangleBorder(
                              //                     borderRadius:
                              //                         BorderRadius.circular(7.0),
                              //                   ),
                              //                   backgroundColor: _selectedInvoices
                              //                               .values
                              //                               .where((e) =>
                              //                                   e['isSelected'] ==
                              //                                   true)
                              //                               .length >
                              //                           1
                              //                       ? Colors.red[900]
                              //                       : Colors.grey,
                              //                 ),
                              //                 onPressed: _selectedInvoices.values
                              //                             .where((e) =>
                              //                                 e['isSelected'] ==
                              //                                 true)
                              //                             .length >
                              //                         1
                              //                     ? () {
                              //                         List<Map<String, dynamic>>
                              //                             selectedInvoicesList =
                              //                             _selectedInvoices
                              //                                 .entries
                              //                                 .where((entry) =>
                              //                                     entry.value[
                              //                                         'isSelected'] ==
                              //                                     true)
                              //                                 .map((entry) => {
                              //                                       "no_invoice":
                              //                                           entry.key,
                              //                                       "total_invoice":
                              //                                           entry.value[
                              //                                                   'totalInvoiceKey'] ??
                              //                                               0,
                              //                                       "no_job":
                              //                                           entry.value[
                              //                                                   'noJobKey'] ??
                              //                                               '',
                              //                                       "no_order_online":
                              //                                           entry.value[
                              //                                                   'noOrderOnlineKey'] ??
                              //                                               'NULL',
                              //                                     })
                              //                                 .toList();
                              //                         print(
                              //                             'Selected Invoices for Payment: $selectedInvoicesList');
                              //                         selectedInvoicesList
                              //                             .forEach((invoice) {
                              //                           print(
                              //                               'no_invoice: ${invoice['no_invoice']}, '
                              //                               'no_job: ${invoice['no_job']}, '
                              //                               'no_order_online: ${invoice['no_order_online']}');
                              //                         });

                              //                         // Call the multipleInvoice method from the Cubit
                              //                         context
                              //                             .read<
                              //                                 InvoiceGroupCubit>()
                              //                             .multipleInvoice(
                              //                                 selectedInvoicesList);
                              //                       }
                              //                     : null,
                              //                 child: Text(
                              //                   'Bayar',
                              //                   style: TextStyle(
                              //                       fontSize: 12,
                              //                       color: Colors.white,
                              //                       fontFamily:
                              //                           'Poppins Med'), // Smaller font
                              //                 ),
                              //               ),
                              //             ),
                              //           ),
                              //       ],
                              //     ),
                              //   ),
                              if (unpaidInvoices.isEmpty &&
                                  _isSearchButtonClickedUnpaid == false)
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
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                              if (_isSearchButtonClickedUnpaid == true &&
                                  unpaidInvoices.isEmpty)
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
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              else if (_isSearchButtonClickedUnpaid == true ||
                                  unpaidInvoices.isNotEmpty)
                                Expanded(
                                    child: _buildInvoiceList(unpaidInvoices)),
                            ],
                          ),
                          // On Process Tab
                          Column(
                            children: [
                              // Image Asset placed inside Paid Tab
                              if (onProcessInvoices.isEmpty &&
                                  _isSearchButtonClickedOnProcess == false)
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
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                              if (_isSearchButtonClickedOnProcess == true &&
                                  onProcessInvoices.isEmpty)
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
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              else if (_isSearchButtonClickedOnProcess ==
                                      true ||
                                  onProcessInvoices.isNotEmpty)
                                Expanded(
                                    child:
                                        _buildInvoiceList(onProcessInvoices)),
                            ],
                          ),
                          // Paid Tab
                          Column(
                            children: [
                              if (paidInvoices.isEmpty &&
                                  _isSearchButtonClickedPaid == false)
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
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                )),
                              if (_isSearchButtonClickedPaid == true &&
                                  paidInvoices.isEmpty)
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
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                              else if (_isSearchButtonClickedPaid == true ||
                                  paidInvoices.isNotEmpty)
                                Expanded(
                                    child: _buildInvoiceList(paidInvoices)),
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
                                          _fetchDataForPage(
                                              currentPageIndex + 1);
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
            });
          },
        ),
        // bottomNavigationBar: Container(
        //   decoration: BoxDecoration(
        //     // boxShadow: [
        //     //   BoxShadow(
        //     //     color: Colors.grey.withOpacity(0.5), // Shadow color
        //     //     spreadRadius: 5, // How much the shadow spreads
        //     //     blurRadius: 7, // How soft the shadow looks
        //     //     offset: Offset(0, 3), // Changes position of the shadow
        //     //   ),
        //     // ],
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
        //     selectedItemColor: _selectedIndex == 3
        //         ? Colors.red[900] // Highlight the tracking icon in red
        //         : Colors.grey[600],
        //     onTap: _onItemTapped,
        //   ),
        // )
      ),
    );
  }

  void performSearch() {
    String searchTextNoInvoice = _noInvoice.text.trim().toUpperCase();
    String searchTextNoOrder = _noOrder.text.trim().toUpperCase();

    print('No Invoice adalah: $searchTextNoInvoice');
    print('No Order adalah: $searchTextNoOrder');

    if (searchTextNoInvoice.isEmpty && searchTextNoOrder.isEmpty) {
      unpaidInvoices.clear();
      paidInvoices.clear();
      // Close the dialog if no search terms are provided
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _noInvoices = searchTextNoInvoice;
      _noOrders = searchTextNoOrder;
    });

    BlocProvider.of<InvoiceNiagaCubit>(context).openinvoice(
      pageIndex: pageIndex,
      invoiceNumber: searchTextNoInvoice,
      noJob: searchTextNoOrder,
    );

    BlocProvider.of<InvoiceNiagaCubit>(context).closeinvoice(
      pageIndex: pageIndex,
      invoiceNumber: searchTextNoInvoice,
      noJob: searchTextNoOrder,
    );

    BlocProvider.of<InvoiceNiagaCubit>(context).invoiceOnProcess(
      pageIndex: pageIndex,
      invoiceNumber: searchTextNoInvoice,
      noJob: searchTextNoOrder,
    );

    //UnPaid
    unpaidInvoices.where((item) {
      bool matchesSearch = true;

      if (searchTextNoInvoice.isNotEmpty) {
        matchesSearch = item.invoiceNumber != null &&
            item.invoiceNumber!
                .toUpperCase()
                .contains(searchTextNoInvoice.toUpperCase());
      }
      if (searchTextNoOrder.isNotEmpty) {
        matchesSearch = item.noJob != null &&
            item.noJob!.toUpperCase().contains(searchTextNoOrder.toUpperCase());
      }

      return matchesSearch;
    }).toList();

    //Paid
    paidInvoices.where((item) {
      bool matchesSearch = true;

      if (searchTextNoInvoice.isNotEmpty) {
        matchesSearch = item.invoiceNumber != null &&
            item.invoiceNumber!
                .toUpperCase()
                .contains(searchTextNoInvoice.toUpperCase());
      }
      if (searchTextNoOrder.isNotEmpty) {
        matchesSearch = item.noJob != null &&
            item.noJob!.toUpperCase().contains(searchTextNoOrder.toUpperCase());
      }

      return matchesSearch;
    }).toList();

    noResultsUnpaid = unpaidInvoices.isEmpty;
    noResultsPaid = paidInvoices.isEmpty;

    // Close the search dialog and update the UI
    Navigator.of(context).pop();
  }

  Widget _buildInvoiceList(List<InvoiceItemAccesses> invoices) {
    String? selectedCabang;

    return ListView.builder(
      itemCount: invoices.length,
      itemBuilder: (context, index) {
        var invoiceItem = invoices[index];
        String invoiceKey = invoiceItem.invoiceNumber ?? 'unknown_invoice';
        int totalInvoiceKey = invoiceItem.totalInvoice ?? 0;
        String noJobKey = invoiceItem.noJob ?? 'unknown_job';
        String noOrderOnlineKey = invoiceItem.noOrderOnline ?? 'NULL';

        bool isSelected = _selectedInvoices[invoiceKey]?['isSelected'] ?? false;
        bool isCheckboxEnabled =
            selectedCabang == null || selectedCabang == invoiceItem.cabang;

        return Row(
          children: [
            if (_isCombinedPayment)
              Checkbox(
                value: isSelected,
                onChanged: isCheckboxEnabled
                    ? (value) {
                        setState(() {
                          if (selectedCabang == null && value == true) {
                            selectedCabang = invoiceItem.cabang;
                          }
                          String merchantId = '';
                          String subMerchantId = '';

                          if (invoiceItem.cabang == 'SBY') {
                            merchantId = 'SGWNIAGALOGISTIK';
                            subMerchantId = '60e83314016d7595781e1ea3d94a76d4';
                          } else if (invoiceItem.cabang == 'JKT') {
                            merchantId = 'SGWNIAGA2';
                            subMerchantId = '7c339a6d0b151e51a4ea1c66d2cf56cc';
                          } else if (invoiceItem.cabang == 'MKS') {
                            merchantId = 'SGWNIAGA3';
                            subMerchantId = '037e8ec7113fb45c9827bd73040be3c9';
                          }

                          _selectedInvoices[invoiceKey] = {
                            'isSelected': value ?? false,
                            'totalInvoiceKey': totalInvoiceKey,
                            'noJobKey': noJobKey,
                            'noOrderOnlineKey': noOrderOnlineKey,
                            'merchantId': merchantId,
                            'subMerchantId': subMerchantId,
                            'selectedCabang': selectedCabang,
                          };
                          if (value == false &&
                              _selectedInvoices.values
                                  .every((e) => e['isSelected'] == false)) {
                            selectedCabang = null;
                          }
                          print(
                              'Updated _selectedInvoices: $_selectedInvoices');
                        });
                      }
                    : null,
                activeColor: Colors.red[900], // Red checkbox color
              ),
            Expanded(
              child: _buildInvoiceCard(context, invoiceItem),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInvoiceCard(
      BuildContext context, InvoiceItemAccesses invoiceItem) {
    // DateTime jatuhTempoDate = DateFormat('yyyy-MM-dd')
    //     .parse(invoiceItem.tanggalJatuhTempo.toString());
    // DateTime today = DateTime.now();

    DateTime? jatuhTempoDate;
    DateTime today = DateTime.now();

    if (invoiceItem.tanggalJatuhTempo != null &&
        invoiceItem.tanggalJatuhTempo!.isNotEmpty) {
      jatuhTempoDate = DateFormat('yyyy-MM-dd')
          .parse(invoiceItem.tanggalJatuhTempo.toString());
    } else {
      print('Invalid date format');
    }

    return Container(
      margin: EdgeInsets.all(12),
      // height: 200, // Adjust according to your UI
      decoration: BoxDecoration(
        // color: Colors.grey[200],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey, // Red border color
          width: 2.0, // Border width
        ),
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
              invoiceItem.invoiceNumber.toString(),
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
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
                  //tipe pengiriman
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
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        // data.type!,
                        invoiceItem.typePengiriman.toString(),
                        style:
                            TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                      ),
                    ),
                  )
                ]),
                //volume
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'Volume',
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
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(
                      invoiceItem.volume.toString(),
                      style: TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                    ),
                  ))
                ]),
                //Rute Pengiriman
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'Rute Pengiriman',
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
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(
                      invoiceItem.rute.toString(),
                      style: TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                    ),
                  ))
                ]),
                //No. Packing List
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'No. Packing List',
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
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(
                      invoiceItem.noPL.toString(),
                      style: TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                    ),
                  ))
                ]),
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'No. Pembayaran',
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
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(
                      invoiceItem.invoiceGroup.toString(),
                      // '',
                      style: TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                    ),
                  ))
                ]),
                //Total
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                      child: Text(
                        'Total',
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
                    padding:
                        EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                    child: Text(
                      // "Rp " + invoiceItem.totalInvoice.toString(),
                      '${invoiceItem.formattedTotalInvoice}',
                      style: TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                    ),
                  ))
                ]),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding:
                  EdgeInsets.all(6.0), // Add some padding inside the container
              decoration: BoxDecoration(
                color: Colors.white, // You can set a background color if needed
                border: Border.all(
                  color: Colors.red, // Red border color
                  width: 2.0, // Border width
                ),
                borderRadius: BorderRadius.circular(
                    20.0), // Circular border with radius 10
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time, // Clock icon
                    color: Colors.black, // Icon color
                    size: 20.0, // Icon size
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Jatuh Tempo :  ${invoiceItem.tanggalJatuhTempo}',
                    style: TextStyle(fontFamily: 'Poppins Med', fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // if (invoiceItem.statusPayment == "not_paid" &&
                //     jatuhTempoDate.isBefore(today))
                //JATUH TEMPO
                // if (invoiceItem.statusPayment == "not_paid" &&
                //     jatuhTempoDate != null &&
                //     jatuhTempoDate.isBefore(today))
                //TESTING TANPA JATUH TEMPO
                if (invoiceItem.statusPayment == "not_paid" &&
                    // jatuhTempoDate != null &&
                    invoiceItem.urlEspay == '' &&
                    invoiceItem.invoiceGroup == '' &&
                    invoiceItem.flagEspay == false &&
                    invoiceItem.totalInvoice == invoiceItem.sisaPembayaran)
                  Flexible(
                    child: SizedBox(
                      width: 75,
                      height: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(7.0),
                        // color: Colors.red[900],
                        color: _isCombinedPayment == true
                            ? Colors.grey
                            : Colors.red[900]!,
                        child: MaterialButton(
                          onPressed: () {
                            if (_isCombinedPayment == false)
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MetodePembayaranNiagaPage(
                                    invoice: invoiceItem);
                              }));
                          },
                          child: Text(
                            'Bayar',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'Poppins Med'),
                          ),
                        ),
                      ),
                    ),
                  ),
                if (invoiceItem.statusPayment == "paid") SizedBox(width: 10),
                if (invoiceItem.statusPayment == "paid")
                  Flexible(
                    child: SizedBox(
                      width: 80,
                      height: 40,
                      child: Material(
                        borderRadius: BorderRadius.circular(7.0),
                        color: Color.fromARGB(255, 40, 185, 45),
                        // shadowColor: Colors.grey[350],
                        // elevation: 5,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            // Smaller size
                            minimumSize: Size(100, 50),
                            side: BorderSide(
                                color: Color.fromARGB(255, 40, 185, 45),
                                width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(7.0),
                            ),
                            backgroundColor: Color.fromARGB(255, 40, 185, 45),
                          ),
                          onPressed: () {},
                          child: Text(
                            'Lunas',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'Poppins Med'), // Smaller font
                          ),
                        ),
                      ),
                    ),
                  ),
                SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    width: 120,
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      // color: Colors.white,
                      color: _isCombinedPayment == true
                          ? Colors.grey
                          : Colors.white,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          // Smaller size
                          minimumSize: Size(100, 50),
                          // side: BorderSide(color: Colors.red[900]!, width: 2),
                          side: BorderSide(
                              color: _isCombinedPayment == true
                                  ? Colors.grey
                                  : Colors.red[900]!,
                              width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          // backgroundColor: Colors.white,
                          backgroundColor: _isCombinedPayment == true
                              ? Colors.grey
                              : Colors.white,
                        ),
                        onPressed: () {
                          final invoiceNumber = invoiceItem.invoiceNumber;
                          final volume = invoiceItem
                              .volume; // Ensure you have a 'volume' value

                          // if (invoiceNumber != null) {
                          if (invoiceNumber != null &&
                              volume != null &&
                              _isCombinedPayment == false) {
                            BlocProvider.of<InvoiceNiagaCubit>(context)
                                .downloadinvoice(invoiceNumber, volume);
                          }
                        },
                        child: Text(
                          'Download',
                          style: TextStyle(
                              fontSize: 12,
                              // color: Colors.red[900],
                              color: _isCombinedPayment == true
                                  ? Colors.white
                                  : Colors.red[900],
                              fontFamily: 'Poppins Med'), // Smaller font
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Flexible(
                  child: SizedBox(
                    width: 80,
                    height: 40,
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      // color: Colors.white,
                      color: _isCombinedPayment == true
                          ? Colors.grey
                          : Colors.white,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          // Smaller size
                          minimumSize: Size(100, 50),
                          // side: BorderSide(color: Colors.red[900]!, width: 2),
                          side: BorderSide(
                              color: _isCombinedPayment == true
                                  ? Colors.grey
                                  : Colors.red[900]!,
                              width: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          // backgroundColor: Colors.white,
                          backgroundColor: _isCombinedPayment == true
                              ? Colors.grey
                              : Colors.white,
                        ),
                        onPressed: () {
                          if (_isCombinedPayment == false)
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              // return DetailInvoiceHomeNiagaPage();
                              return DetailInvoiceHomeNiagaPage(
                                  invoice: invoiceItem);
                            }));
                        },
                        child: Text(
                          'Detail',
                          style: TextStyle(
                              fontSize: 12,
                              // color: Colors.red[900],
                              color: _isCombinedPayment == true
                                  ? Colors.white
                                  : Colors.red[900],
                              fontFamily: 'Poppins Med'), // Smaller font
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
