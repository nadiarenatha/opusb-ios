import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/packing_niaga_cubit.dart';
import '../model/niaga/packing_detail_niaga.dart';
import '../model/niaga/packing_niaga.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../screen-niaga/order_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';

class PackingListNiagaPage extends StatefulWidget {
  const PackingListNiagaPage({Key? key}) : super(key: key);

  @override
  State<PackingListNiagaPage> createState() => _PackingListNiagaPageState();
}

class _PackingListNiagaPageState extends State<PackingListNiagaPage> {
  @override
  // Default selected index
  int _selectedIndex = 0;
  // Flag for selected state, not necessary
  bool isSelected = false;
  int currentPageIndex = 0;
  int totalPages = 0; // Declare totalPages as a class-level variable
  int pageIndex = 0;
  int itemsPerPage = 5;
  int visiblePages = 5; // Number of visible page numbers
  ScrollController _scrollController = ScrollController(); //untuk pagination

  List<PackingNiagaAccesses> packingModellist = [];
  // List<PackingNiagaAccesses> filteredList = [];
  List<PackingItemAccesses> packingItems = [];
  // To hold the current page's data
  List<PackingItemAccesses> visibleItems = [];

  //untuk calendar pada pop up dialog search dengan nama _dateController
  //2 nama berbeda karena tgl di calendar berbeda
  TextEditingController _dateController1 = TextEditingController();
  TextEditingController _dateController2 = TextEditingController();

  //untuk no SJM pada pop up dialog search
  TextEditingController _NoPackingListController = TextEditingController();
  //untuk kota asal pada pop up dialog search
  TextEditingController _KotaAsalController = TextEditingController();
  //untuk kota tujuan pada pop up dialog search
  TextEditingController _kotaTujuanController = TextEditingController();
  //untuk nama kapal pada pop up dialog search
  TextEditingController _NamaKapalController = TextEditingController();

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   // BlocProvider.of<PackingNiagaCubit>(context).packingNiaga();
  //   BlocProvider.of<PackingNiagaCubit>(context)
  //       .packingNiaga(pageIndex: currentPageIndex + 1);
  // }

  @override
  void initState() {
    super.initState();
    _fetchDataForPage(currentPageIndex + 1);
  }

  void _fetchDataForPage(int pageIndex) {
    BlocProvider.of<PackingNiagaCubit>(context)
        .packingNiagaComplete(pageIndex: pageIndex);
  }

  int getStartPageIndex() {
    return (currentPageIndex ~/ visiblePages) *
        visiblePages; // Division that results in an int
  }

  int getEndPageIndex() {
    int endPage =
        ((currentPageIndex ~/ visiblePages) * visiblePages + visiblePages)
            .toInt();
    return endPage > totalPages ? totalPages : endPage;
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                    "Dokumen Pengiriman",
                    style: TextStyle(
                      fontSize: 17,
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
                      // Clear the form fields and perform search
                      _NoPackingListController.text = '';
                      _dateController1.text = '';
                      _dateController2.text = '';
                      _KotaAsalController.text = '';
                      _kotaTujuanController.text = '';
                      _NamaKapalController.text = '';
                      searchMyInvoice();
                    },
                  ),
                ),
              ],
            ),
            //agar tulisan di appbar berada di tengah
            toolbarHeight: 0.07 *
                MediaQuery.of(context)
                    .size
                    .height, // Ensure the AppBar height is consistent
          ),
        ),
        //untuk setting form
        body: BlocConsumer<PackingNiagaCubit, PackingNiagaState>(
          listener: (context, state) {
            // if (state is PackingNiagaSuccess) {
            //   packingModellist.clear();
            //   packingModellist = state.response;
            //   // Assuming you want to show data from the first PackingNiagaAccesses' data list
            //   // if (packingModellist.isNotEmpty) {
            //   //   packingItems = packingModellist.first.data;
            //   // }
            //   //====

            //   setState(() {
            //     totalPages = state.totalPages; // Get totalPages from the state
            //     print('Total Pages: $totalPages'); // Debug print
            //     // Accumulate the data for all pages
            //     // packingItems.addAll(state.response.first.data);
            //     packingItems =
            //         state.response.first.data; // Update current page data
            //   });
            // }
          },
          builder: (context, state) {
            // if (state is PackingNiagaInProgress) {
            //   return Center(
            //     child: CircularProgressIndicator(
            //       color: Colors.amber[600],
            //     ),
            //   );
            // }
            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    // itemCount: (packingItems.length / itemsPerPage).ceil() > 0
                    //     ? itemsPerPage
                    //     : 0,
                    itemCount: packingItems.length,
                    controller: ScrollController(),
                    itemBuilder: (context, index) {
                      // final int itemIndex =
                      //     currentPageIndex * itemsPerPage + index;
                      // if (itemIndex < packingItems.length) {
                      // var data = packingItems[itemIndex];
                      var data = packingItems[index];
                      return Container(
                        margin: EdgeInsets.all(16),
                        //setting tinggi & lebar container grey
                        // height: mediaQuery.size.height * 0.45,
                        height: mediaQuery.size.height * 0.3,
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
                              )
                            ]),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    // "PL/DTD/-COSL/20240001",
                                    data.noPL!,
                                    style: TextStyle(
                                        color: Colors.blue[700],
                                        fontSize: 20,
                                        fontFamily: 'Poppin',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  //untuk membuat tabel
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Table(
                                    //mengatur panjang atau ukuran tabel
                                    columnWidths: {
                                      0: FlexColumnWidth(
                                          3), // Adjust the width of the first column
                                      1: FlexColumnWidth(
                                          1), // Adjust the width of the second column
                                      2: FlexColumnWidth(
                                          5), // Adjust the width of the third column
                                    },
                                    children: [
                                      TableRow(children: [
                                        //baris 1 type pengiriman kolom tabel
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                              'Order No',
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
                                            child:
                                                // Text('Door to Door Stuffing Luar'),
                                                Text(
                                              data.orderNo!,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                              'Job Type',
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
                                          child:
                                              // Text('FCL 2 x 20ft'),
                                              Text(
                                            data.jobType.toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ))
                                      ]),
                                      //baris ke 3 rute pengiriman
                                      TableRow(children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                              'Order Date',
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
                                          child:
                                              // Text('Surabaya - Makassar'),
                                              Text(
                                            data.orderDate!,
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ))
                                      ]),
                                      //baris ke 4 nama kapal
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
                                            data.tipePengiriman!,
                                          ),
                                        ))
                                      ])
                                    ],
                                  ),
                                  //ETA
                                  // Row(
                                  //   children: [
                                  //     IconButton(
                                  //       icon: Icon(
                                  //         Icons.calendar_today,
                                  //         size: 20,
                                  //       ),
                                  //       onPressed: () {},
                                  //     ),
                                  //     // Text('ETA 30 Jan 2024'),
                                  //     Text(
                                  //       data.ata!,
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.normal),
                                  //     ),
                                  //   ],
                                  // ),
                                  // //ETD
                                  // Row(
                                  //   children: [
                                  //     IconButton(
                                  //       icon: Icon(
                                  //         Icons.calendar_today,
                                  //         size: 20,
                                  //       ),
                                  //       onPressed: () {},
                                  //     ),
                                  //     // Text('ETD 30 Feb 2024'),
                                  //     Text(
                                  //       data.atd!,
                                  //       style: TextStyle(
                                  //           fontWeight: FontWeight.normal),
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            // Button
                            Positioned(
                              right: 16,
                              bottom: 16,
                              child: Material(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.red[900],
                                //membuat bayangan pada button Detail
                                shadowColor: Colors.grey[350],
                                elevation: 5,
                                child: MaterialButton(
                                  onPressed: () async {
                                    // await downloadFile(fileUrl, fileName);
                                  },
                                  child: Text(
                                    'Download',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                      // }
                    },
                  ),
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      height: 40,
                      child: Row(
                        // Make the row take only as much space as needed
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: currentPageIndex > 0
                                ? () {
                                    setState(() {
                                      currentPageIndex--;
                                      _fetchDataForPage(currentPageIndex + 1);
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    });
                                    // // Fetch new data for the previous page
                                    // BlocProvider.of<PackingNiagaCubit>(context)
                                    //     .packingNiaga(
                                    //         pageIndex: currentPageIndex + 1);
                                  }
                                : null,
                          ),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // itemCount:
                              //     totalPages, // Create as many containers as totalPages
                              itemCount:
                                  getEndPageIndex() - getStartPageIndex(),
                              itemBuilder: (context, pageIndex) {
                                // int actualPageIndex = getStartPageIndex() + index;
                                int actualPageIndex =
                                    (getStartPageIndex() + pageIndex)
                                        .toInt(); // Use int
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      // currentPageIndex = pageIndex;
                                      currentPageIndex = actualPageIndex;
                                      _fetchDataForPage(currentPageIndex + 1);
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    });
                                    // BlocProvider.of<PackingNiagaCubit>(context)
                                    //     .packingNiaga(
                                    //         pageIndex: currentPageIndex + 1);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 35),
                                    child: Container(
                                      // height: 30,
                                      height: 50,
                                      // width: 30,
                                      width: 50,
                                      // margin: EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        // color: pageIndex == currentPageIndex
                                        color: actualPageIndex ==
                                                currentPageIndex
                                            ? Colors
                                                .blue[300] // Active page color
                                            : Colors.grey[
                                                300], // Inactive page color
                                        boxShadow: [
                                          BoxShadow(
                                            color: Color(0xFFB0BEC5),
                                            offset: Offset(0, 2),
                                            blurRadius: 5,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: Text(
                                          // '${pageIndex + 1}',
                                          '${actualPageIndex + 1}',
                                          style: TextStyle(
                                            // color: pageIndex == currentPageIndex
                                            color: actualPageIndex ==
                                                    currentPageIndex
                                                ? Colors
                                                    .white // Active page text color
                                                : Colors
                                                    .black, // Inactive page text color
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
                            // onPressed: currentPageIndex <
                            //         (packingItems.length / itemsPerPage).ceil() -
                            //             1
                            onPressed: currentPageIndex < totalPages - 1
                                ? () {
                                    setState(() {
                                      currentPageIndex++;
                                      _fetchDataForPage(currentPageIndex + 1);
                                      _scrollController.animateTo(
                                        0.0,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeInOut,
                                      );
                                    });
                                    // Fetch new data for the next page
                                    // BlocProvider.of<PackingNiagaCubit>(context)
                                    //     .packingNiaga(
                                    //         pageIndex: currentPageIndex + 1);
                                  }
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
          },
        ),
        //====
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
        //     items: const <BottomNavigationBarItem>[
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.dashboard), label: 'Order'),
        //       BottomNavigationBarItem(
        //         icon: SizedBox(
        //           width: 20,
        //           child: ImageIcon(
        //             AssetImage('assets/tracking icon.png'),
        //           ),
        //         ),
        //         label: 'Tracking',
        //       ),
        //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //       BottomNavigationBarItem(
        //         icon: SizedBox(
        //           width: 12,
        //           child: ImageIcon(
        //             AssetImage('assets/invoice icon.png'),
        //           ),
        //         ),
        //         label: 'Invoice',
        //       ),
        //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        //     ],
        //     currentIndex: _selectedIndex,
        //     // selectedItemColor: Colors.red[900],
        //     selectedItemColor: Colors.grey[600],
        //     // unselectedItemColor: Colors.grey[600],
        //     onTap: _onItemTapped,
        //   ),
        // ),
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
            selectedItemColor: Colors.grey[600],
            onTap: _onItemTapped,
          ),
        ));
  }

  // void performSearch() {
  //   // Extract search text
  //   String searchText = _NoPackingListController.text.trim();
  //   String searchTextKapal = _NamaKapalController.text.trim();

  //   // Filter packingModellist based on search criteria
  //   filteredList = packingModellist.where((item) {
  //     // Check if packingListNo contains the search text
  //     if (searchText.isNotEmpty &&
  //         !item.packingListNo!
  //             .toLowerCase()
  //             .contains(searchText.toLowerCase())) {
  //       return false;
  //     }
  //     return true;
  //   }).toList();

  //   Navigator.of(context).pop(); // Close the dialog after search
  // }

  Widget search() {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 990, maxWidth: 300),
      child: Form(
        //untuk hapus isi search
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //no packing list
            Text(
              "No Packing List",
              style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                controller: _NoPackingListController,
                decoration: InputDecoration(
                  hintText: 'masukkan nomor packing list',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            //estimasi waktu
            Text(
              "Estimasi Waktu",
              style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                //controller 1 digunakan untuk input tgl di calendar
                controller: _dateController1,
                decoration: InputDecoration(
                    hintText: 'ETA',
                    //untuk mengatur letak hint text
                    //horizontal ke kanan kiri
                    //vertical ke atas  bawah
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    border: InputBorder.none,
                    //untuk tambah icon calendar
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, _dateController1),
                    )),
              ),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                //controller 2 digunakan untuk input tgl di calendar
                controller: _dateController2,
                decoration: InputDecoration(
                    hintText: 'ETD',
                    //untuk mengatur letak hint text
                    //horizontal ke kanan kiri
                    //vertical ke atas  bawah
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                    border: InputBorder.none,
                    //untuk tambah icon calendar
                    suffixIcon: IconButton(
                      icon: Icon(Icons.calendar_today),
                      onPressed: () => _selectDate(context, _dateController2),
                    )),
              ),
            ),
            SizedBox(height: 20),
            //kota asal
            Text(
              "Kota Asal",
              style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'masukkan kota asal',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            //kota tujuan
            Text(
              "Kota Tujuan",
              style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'masukkan kota tujuan',
                  contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            //nama kapal
            Text(
              "Nama Kapal",
              style: TextStyle(color: Colors.black, fontFamily: 'Poppin'),
            ),
            SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: 'masukkan nama kapal',
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
          ],
        ),
      ),
    );
  }
}
