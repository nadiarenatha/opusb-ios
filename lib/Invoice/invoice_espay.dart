import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';
import '../cubit/niaga/invoice_niaga_cubit.dart';
import '../model/niaga/open_invoice_detail_niaga.dart';
import '../model/niaga/open_invoice_niaga.dart';
import 'package:niaga_apps_mobile/screen/home.dart';

import '../order/menu_order_niaga.dart';
import '../payment/pembayaran_page.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/detail_invoice_home_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'menu_invoice_niaga.dart';

class EspayInvoiceNiagaPage extends StatefulWidget {
  const EspayInvoiceNiagaPage({Key? key}) : super(key: key);
  // final String niagaToken;
  // const EspayInvoiceNiagaPage({Key? key, required this.niagaToken}) : super(key: key);

  @override
  State<EspayInvoiceNiagaPage> createState() => _EspayInvoiceNiagaPageState();
}

// class _EspayInvoiceNiagaPageState extends State<EspayInvoiceNiagaPage> {
class _EspayInvoiceNiagaPageState extends State<EspayInvoiceNiagaPage>
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
  List<InvoiceItemAccesses> filteredListUnpaid = [];
  List<InvoiceItemAccesses> filteredListPaid = [];

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _noInvoice = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    // InvoicePage(),
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   _tabController = TabController(length: 3, vsync: this)
  //     ..addListener(() {
  //       if (_tabController.indexIsChanging) {
  //         _handleTabChange(_tabController.index);
  //       }
  //     });
  //   _scrollController = ScrollController();
  //   // Load initial data
  //   _fetchDataForPage(currentPageIndex + 1);
  // }

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

    // Initialize filtered lists with full invoice data
    // filteredListUnpaid = List.from(unpaidInvoices);
    // filteredListPaid = List.from(paidInvoices);
  }

  void _fetchDataForPage(int pageIndex) {
    if (_tabController.index == 0) {
      // BlocProvider.of<InvoiceNiagaCubit>(context)
      //     .closeinvoice(pageIndex: pageIndex);
      BlocProvider.of<InvoiceNiagaCubit>(context)
          .openinvoice(pageIndex: pageIndex);
    } else if (_tabController.index == 2) {
      // BlocProvider.of<InvoiceNiagaCubit>(context)
      //     .openinvoice(pageIndex: pageIndex);
      BlocProvider.of<InvoiceNiagaCubit>(context)
          .closeinvoice(pageIndex: pageIndex);
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

  // void _handleTabChange(int index) {
  //   if (index == 0) {
  //     // _unpaidPage = 0; // Reset to first page
  //     unpaidInvoices.clear(); // Clear previous data
  //     BlocProvider.of<InvoiceNiagaCubit>(context).closeinvoice();
  //   } else if (index == 2) {
  //     // _paidPage = 0; // Reset to first page
  //     paidInvoices.clear(); // Clear previous data
  //     BlocProvider.of<InvoiceNiagaCubit>(context).openinvoice();
  //   }
  // }

  void _handleTabChange(int index) {
    if (index == 0) {
      unpaidInvoices.clear(); // Clear previous data
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
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: TextFormField(
                      controller: _noInvoice,
                      decoration: InputDecoration(
                        hintText: 'masukkan nomor invoice',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Kota Asal",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(height: 8),
                  SizedBox(height: 8),
                  Text(
                    "Kota Tujuan",
                    style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.red[900],
                      child: MaterialButton(
                        onPressed: () {
                          performSearch();
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
                ],
              ),
            ),
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
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Tagihan Saya",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.red[900],
                    fontFamily: 'Poppin',
                    fontWeight: FontWeight.w900,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                // width: 30,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xFFB0BEC5), // A color close to grey[350]
                      offset: Offset(0, 2),
                      blurRadius: 5,
                      spreadRadius: 1,
                    )
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  iconSize: 24,
                  onPressed: () {
                    _noInvoice.text = '';
                    searchMyInvoice();
                  },
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
              // _totalPages =
              //     state.response.first.totalPage ?? 0; // Store totalPage
              _totalPages = state.totalPages;
              print("Total Pages Paid (OpenInvoice): $_totalPages");
              // Convert List<OpenInvoiceAccesses> to List<InvoiceItemAccesses>
              // paidInvoices = state.response
              //     .expand((invoiceAccess) => invoiceAccess.data)
              //     .toList();
              unpaidInvoices = state.response
                  .expand((invoiceAccess) => invoiceAccess.data)
                  .toList();
            });
          } else if (state is CloseInvoiceSuccess) {
            setState(() {
              // _totalPages = state.response.first.totalPage ?? 0;
              _totalPages = state.totalPages;
              print("Total Pages Unpaid(CloseInvoice): $_totalPages");
              // Convert List<CloseInvoiceAccesses> to List<InvoiceItemAccesses>
              // unpaidInvoices = state.response
              //     .expand((invoiceAccess) => invoiceAccess.data)
              //     .toList();
              paidInvoices = state.response
                  .expand((invoiceAccess) => invoiceAccess.data)
                  .toList();
            });
          }
        },
        builder: (context, state) {
          if (state is OpenInvoiceInProgress ||
              state is CloseInvoiceInProgress) {
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
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'On Process',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                    Tab(
                      child: Text(
                        'Paid',
                        style: TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  ],
                ),
                // Your TabBarView
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildInvoiceList(unpaidInvoices),
                      _buildInvoiceList([]), // Placeholder for 'On Process'
                      _buildInvoiceList(paidInvoices),
                      // _buildInvoiceList(
                      //     filteredListUnpaid), // Unpaid tab uses filtered list
                      // _buildInvoiceList([]), // Placeholder for 'On Process'
                      // _buildInvoiceList(
                      //     filteredListPaid), // Paid tab uses filtered list
                    ],
                  ),
                ),
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
                            itemCount: getEndPageIndex() - getStartPageIndex(),
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
                                    margin:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    width: 50, // Width of each page indicator
                                    decoration: BoxDecoration(
                                      color: actualPageIndex == currentPageIndex
                                          ? Colors.blue[800]
                                          : Colors.blue[600],
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Text(
                                        '${actualPageIndex + 1}', // Display page number
                                        style: TextStyle(
                                          color: Colors.white,
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
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // Shadow color
                spreadRadius: 5, // How much the shadow spreads
                blurRadius: 7, // How soft the shadow looks
                offset: Offset(0, 3), // Changes position of the shadow
              ),
            ],
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            items: <BottomNavigationBarItem>[
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Order',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  width: 20,
                  child: ImageIcon(
                    AssetImage('assets/tracking icon.png'),
                  ),
                ),
                label: 'Tracking',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  alignment:
                      Alignment.center, // Centers the icon inside the circle
                  children: <Widget>[
                    Container(
                      height: 40, // Adjust size of the circle
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.red[900], // Red circle color
                        shape: BoxShape.circle,
                      ),
                    ),
                    Icon(
                      Icons.home,
                      color:
                          Colors.white, // Icon color (optional for visibility)
                    ),
                  ],
                ),
                label: 'Home',
              ),
              const BottomNavigationBarItem(
                icon: SizedBox(
                  width: 12,
                  child: ImageIcon(
                    AssetImage('assets/invoice icon.png'),
                  ),
                ),
                label: 'Invoice',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Profil',
              ),
            ],
            currentIndex: _selectedIndex,
            // selectedItemColor: Colors.grey[600],
            selectedItemColor: _selectedIndex == 3
                ? Colors.red[900] // Highlight the tracking icon in red
                : Colors.grey[600],
            onTap: _onItemTapped,
          ),
        )
    );
  }

  void performSearch() {
    String searchNoInvoice = _noInvoice.text.trim().toLowerCase();

    // Clear previous search results
    filteredListUnpaid.clear();
    filteredListPaid.clear();

    if (searchNoInvoice.isNotEmpty) {
      // Filter unpaid invoices
      filteredListUnpaid = unpaidInvoices.where((invoice) {
        return invoice.invoiceNumber?.toLowerCase().contains(searchNoInvoice) ??
            false;
      }).toList();

      // Filter paid invoices
      filteredListPaid = paidInvoices.where((invoice) {
        return invoice.invoiceNumber?.toLowerCase().contains(searchNoInvoice) ??
            false;
      }).toList();
    } else {
      // If search field is empty, show all invoices
      filteredListUnpaid = List.from(unpaidInvoices);
      filteredListPaid = List.from(paidInvoices);
    }

    // Close the search dialog and update the UI
    Navigator.of(context).pop();
    setState(() {}); // Update the UI to reflect the search results
  }
}

Widget _buildInvoiceList(List<InvoiceItemAccesses> invoices) {
  return ListView.builder(
    itemCount: invoices.length,
    itemBuilder: (context, index) {
      var invoiceItem = invoices[index];
      // return _buildInvoiceCard(invoiceItem);
      return _buildInvoiceCard(context, invoiceItem);
    },
  );
}

// Widget _buildInvoiceCard(InvoiceItemAccesses invoiceItem) {
Widget _buildInvoiceCard(
    BuildContext context, InvoiceItemAccesses invoiceItem) {
  return Container(
    margin: EdgeInsets.all(12),
    // height: 200, // Adjust according to your UI
    decoration: BoxDecoration(
      color: Colors.grey[200],
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Color(0xFFB0BEC5),
          offset: Offset(0, 6),
          blurRadius: 10,
          spreadRadius: 1,
        ),
      ],
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
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
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
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      'Type Pengiriman',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(':'),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      // data.type!,
                      invoiceItem.typePengiriman.toString(),
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                )
              ]),
              //volume
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      'Volume',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      ':',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  child: Text(
                    invoiceItem.volume.toString(),
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ))
              ]),
              //Rute Pengiriman
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      'Rute Pengiriman',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      ':',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  child: Text(
                    invoiceItem.rute.toString(),
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ))
              ]),
              //No. Packing List
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      'No. Packing List',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      ':',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  child: Text(
                    invoiceItem.noPL.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                ))
              ]),
              //Total
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                    child: Text(
                      ':',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ),
                ),
                TableCell(
                    child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
                  child: Text(
                    // "Rp " + invoiceItem.totalInvoice.toString(),
                    '${invoiceItem.formattedTotalInvoice}',
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ))
              ]),
            ],
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (invoiceItem.statusPayment == "not_paid")
                Material(
                  borderRadius: BorderRadius.circular(7.0),
                  color: Colors.red[900],
                  //membuat bayangan pada button Detail
                  shadowColor: Colors.grey[350],
                  elevation: 5,
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return MetodePembayaranNiagaPage(invoice: invoiceItem);
                      }));
                    },
                    child: Text(
                      'Bayar',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              SizedBox(width: 10),
              Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.white,
                shadowColor: Colors.grey[350],
                elevation: 5,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // Smaller size
                    minimumSize: Size(100, 50),
                    side: BorderSide(color: Colors.red[900]!, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    final invoiceNumber = invoiceItem.invoiceNumber;
                    final volume =
                        invoiceItem.volume; // Ensure you have a 'volume' value

                    // if (invoiceNumber != null) {
                    if (invoiceNumber != null && volume != null) {
                      BlocProvider.of<InvoiceNiagaCubit>(context)
                          .downloadinvoice(invoiceNumber, volume);
                    } else {
                      // Handle the case where invoiceNumber is null (e.g., show an error message)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Invoice number is missing')),
                      );
                    }
                  },
                  child: Text(
                    'Download',
                    style: TextStyle(
                        fontSize: 18, color: Colors.red[900]), // Smaller font
                  ),
                ),
              ),
              SizedBox(width: 10),
              Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.white,
                shadowColor: Colors.grey[350],
                elevation: 5,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    // Smaller size
                    minimumSize: Size(100, 50),
                    side: BorderSide(color: Colors.red[900]!, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7.0),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      // return DetailInvoiceHomeNiagaPage();
                      return DetailInvoiceHomeNiagaPage(invoice: invoiceItem);
                    }));
                  },
                  child: Text(
                    'Detail',
                    style: TextStyle(
                        fontSize: 18, color: Colors.red[900]), // Smaller font
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
