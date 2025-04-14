import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/model/packing_list.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';
import '../cubit/packing_cubit.dart';

class PackingListPage extends StatefulWidget {
  const PackingListPage({Key? key}) : super(key: key);

  @override
  State<PackingListPage> createState() => _PackingListPageState();
}

class _PackingListPageState extends State<PackingListPage> {
  @override
  // Default selected index
  int _selectedIndex = 0;
  // Flag for selected state, not necessary
  bool isSelected = false;
  int currentPageIndex = 0;
  int itemsPerPage = 5;
  ScrollController _scrollController = ScrollController(); //untuk pagination

  List<PackingListAccesses> packingModellist = [];
  List<PackingListAccesses> filteredList = [];

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
    MyInvoicePage(),
    DashboardPage(),
    HomePage(),
    TrackingPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PackingCubit>(context).packinglist();
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
          //untuk setting letak dan warna tulisan My Invoice
          // flexibleSpace: Container(
          //   alignment: Alignment.bottomLeft,
          //   padding: EdgeInsets.only(left: 45, bottom: 6),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         "Dokumen Pengiriman",
          //         style: TextStyle(
          //             fontSize: 20,
          //             color: Colors.red[900],
          //             fontFamily: 'Poppin',
          //             fontWeight: FontWeight.w900),
          //       ),
          //       //untuk lingkaran & icons search
          //       Positioned(
          //         bottom: 16,
          //         left: 16,
          //         child: Container(
          //           width: 40,
          //           height: 40,
          //           decoration: BoxDecoration(
          //               color: Colors.white,
          //               // borderRadius: BorderRadius.circular(50),
          //               shape: BoxShape.circle,
          //               boxShadow: [
          //                 BoxShadow(
          //                   color:
          //                       Color(0xFFB0BEC5), // A color close to grey[350]
          //                   offset: Offset(0, 2),
          //                   blurRadius: 5,
          //                   spreadRadius: 1,
          //                 )
          //               ]),
          //           child: IconButton(
          //               icon: Icon(
          //                 Icons.search,
          //                 color: Colors.black,
          //               ),
          //               onPressed: () {
          //                 //untuk hapus isi dari modal dialog
          //                 _NoPackingListController.text = '';
          //                 _dateController1.text = '';
          //                 _dateController2.text = '';
          //                 _KotaAsalController.text = '';
          //                 _kotaTujuanController.text = '';
          //                 _NamaKapalController.text = '';
          //                 searchMyInvoice();
          //               }),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Dokumen Pengiriman",
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
      body: BlocConsumer<PackingCubit, PackingState>(
        listener: (context, state) {
          if (state is PackingListSuccess) {
            packingModellist.clear();
            packingModellist = state.response;
            //order by ascending
            packingModellist.sort((a, b) => a.id!.compareTo(b.id!));
            filteredList.clear();
            filteredList = state.response;
          }
        },
        builder: (context, state) {
          if (state is PackingInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          // Extract search text
          // String searchText =
          //     _NoPackingListController.text.trim().toLowerCase();
          // String searchTextKapal =
          //     _NamaKapalController.text.trim().toLowerCase();

          // Filter packingModellist based on search criteria
          // List<PackingListAccesses> filteredList =
          //     packingModellist.where((item) {
          //   // Check if packingListNo or other fields contain the search text
          //   bool matchesSearchText =
          //       item.packingListNo!.toLowerCase().contains(searchText) ||
          //           item.type!.toLowerCase().contains(searchText) ||
          //           item.rute!.toLowerCase().contains(searchText) ||
          //           item.ata!.toLowerCase().contains(searchText) ||
          //           item.atd!.toLowerCase().contains(searchText);
          // item.shipName!.toLowerCase().contains(searchTextKapal);
          // return matchesSearchText;
          // }).toList();
          // Widget contentWidget;
          // if (filteredList.isEmpty) {
          //   contentWidget = Center(
          //     child: Text(
          //       'Data tidak ada !!',
          //       style: TextStyle(
          //           color: Colors.red[900],
          //           fontWeight: FontWeight.w900,
          //           fontSize: 24),
          //     ),
          //   );
          // } else {
          return SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  // itemCount: filteredList.length,
                  itemCount: (filteredList.length / itemsPerPage).ceil() > 0
                      ? itemsPerPage
                      : 0,
                  controller: ScrollController(),
                  itemBuilder: (context, index) {
                    // var data = packingModellist[index];
                    final int itemIndex =
                        currentPageIndex * itemsPerPage + index;
                    // var data = filteredList[index];
                    // print(data.packingListNo);
                    if (itemIndex < filteredList.length) {
                      var data = filteredList[itemIndex];
                      return Container(
                        margin: EdgeInsets.all(16),
                        //setting tinggi & lebar container grey
                        // height: mediaQuery.size.height * 0.45,
                        height: mediaQuery.size.height * 0.42,
                        width: mediaQuery.size.height * 0.5,
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
                                    data.packingListNo!,
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
                                              'Type Pengiriman',
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
                                              data.type!,
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
                                            data.volume.toString(),
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
                                              'Rute Pengirimann',
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
                                            data.rute!,
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
                                          child: Text('SPIL Oriental Gold'),
                                        ))
                                      ])
                                    ],
                                  ),
                                  //ETA
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.calendar_today,
                                          size: 20,
                                        ),
                                        onPressed: () {},
                                      ),
                                      // Text('ETA 30 Jan 2024'),
                                      Text(
                                        data.ata!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
                                  //ETD
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.calendar_today,
                                          size: 20,
                                        ),
                                        onPressed: () {},
                                      ),
                                      // Text('ETD 30 Feb 2024'),
                                      Text(
                                        data.atd!,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ],
                                  ),
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
                    }
                  },
                ),
                SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: currentPageIndex > 0
                              ? () {
                                  setState(() {
                                    currentPageIndex--;
                                    _scrollController.animateTo(
                                      0.0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                }
                              : null,
                        ),
                        Expanded(
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                (filteredList.length / itemsPerPage).ceil(),
                            itemBuilder: (context, pageIndex) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    currentPageIndex = pageIndex;
                                    _scrollController.animateTo(
                                      0.0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  margin: EdgeInsets.symmetric(horizontal: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    color: pageIndex == currentPageIndex
                                        ? Colors.blue[300] // Active page color
                                        : Colors
                                            .grey[300], // Inactive page color
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
                                      '${pageIndex + 1}',
                                      style: TextStyle(
                                        color: pageIndex == currentPageIndex
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
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: currentPageIndex <
                                  (filteredList.length / itemsPerPage).ceil() -
                                      1
                              ? () {
                                  setState(() {
                                    currentPageIndex++;
                                    _scrollController.animateTo(
                                      0.0,
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    );
                                  });
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
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.note), label: 'My Invoice'),
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.track_changes_rounded), label: 'Tracking'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          //warna merah jika icon di pilih
          selectedItemColor:
              isSelected == true ? Colors.red[900] : Colors.grey[600],
          // onTap: _onItemTapped,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
            _onItemTapped(index);
          }),
    );
  }

  void performSearch() {
    // Extract search text
    String searchText = _NoPackingListController.text.trim();
    String searchTextKapal = _NamaKapalController.text.trim();

    // Filter packingModellist based on search criteria
    filteredList = packingModellist.where((item) {
      // Check if packingListNo contains the search text
      if (searchText.isNotEmpty &&
          !item.packingListNo!
              .toLowerCase()
              .contains(searchText.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    Navigator.of(context).pop(); // Close the dialog after search
  }

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
    );
  }
}
