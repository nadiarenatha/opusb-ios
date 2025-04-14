import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import 'package:niaga_apps_mobile/profile/tambah_alamat.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/address_cubit.dart';
import '../model/niaga/address.dart';
import '../model/niaga/tipe_alamat.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:flutter/services.dart';

class DaftarAlamatNiagaPage extends StatefulWidget {
  const DaftarAlamatNiagaPage({Key? key}) : super(key: key);

  @override
  State<DaftarAlamatNiagaPage> createState() => _DaftarAlamatNiagaPageState();
}

class _DaftarAlamatNiagaPageState extends State<DaftarAlamatNiagaPage> {
  @override
  int _selectedIndex = 0;
  List<AddressAccesses> alamatList = [];
  //GET TIPE ALAMAT
  List<TipeAlamatAccesses> tipeAlamatsList = [];

  //Pagination
  int currentPageIndex = 0;
  int itemsPerPage = 5;
  ScrollController _scrollController = ScrollController();

  TextEditingController _pageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AddressCubit>(context).address();
    BlocProvider.of<AddressCubit>(context).tipeAlamat();
    _clearAssigner();
  }

  Future<void> _clearAssigner() async {
    final storage = FlutterSecureStorage();
    await storage.write(
      key: AuthKey.assigner.toString(),
      value: 'false',
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  //Get Tipe Alamat berdasarkan value
  String getAddressTypeName(String value) {
    for (var tipeAlamat in tipeAlamatsList) {
      if (tipeAlamat.value == value) {
        return tipeAlamat.name.toString();
      }
    }
    return 'Unknown Type';
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
                    child: Text(
                        ((alamatList.length / itemsPerPage).ceil()).toString(),
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
                        int pageNumber = int.tryParse(_pageController.text) ?? 1;
                        int maxPage = (alamatList.length / itemsPerPage).ceil();
                        if (pageNumber > 0 && pageNumber <= maxPage) {
                          setState(() {
                            currentPageIndex = pageNumber - 1;
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

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage(initialIndex: 4)),
    );
    return false; // Prevent default back navigation
  }

  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
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
                // Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HomeNiagaPage(initialIndex: 4)),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Daftar Alamat",
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
        body: BlocConsumer<AddressCubit, AddressState>(
            listener: (context, state) {
          if (state is AddressSuccess) {
            alamatList.clear();
            alamatList = state.response;
            alamatList.sort((a, b) => b.createdDate!.compareTo(a.createdDate!));
          } else if (state is TipeAlamatSuccess) {
            tipeAlamatsList.clear();
            tipeAlamatsList = state.response;
            print('tipe alamatnya : $tipeAlamatsList');
          }
        }, builder: (context, state) {
          if (state is AddressInProgress || state is AddAddressInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          return SingleChildScrollView(
            //untuk go up pagination
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.red[900],
                          //membuat bayangan pada button Detail
                          shadowColor: Colors.grey[350],
                          elevation: 5,
                          child: MaterialButton(
                            minWidth: 200, // Adjust the width as needed
                            height: 50, // Adjust the height as needed
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return TambahAlamatNiagaPage();
                              }));
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Tambah Alamat',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white,
                                      fontFamily: 'Poppins Med'),
                                ),
                                SizedBox(width: 8),
                                Image.asset(
                                  'assets/tambah alamat.png', // Image to place inside the frame
                                  // width: 26, // Adjust size as needed
                                  // height: 26,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Container(
                  //   margin: EdgeInsets.all(6),
                  //   // padding: EdgeInsets.all(16),
                  //   padding: EdgeInsets.only(
                  //       top: 10, left: 16, right: 10, bottom: 10),
                  //   decoration: BoxDecoration(
                  //     color: Colors.white,
                  //     borderRadius: BorderRadius.circular(20),
                  //     border: Border.all(
                  //       color: Colors.red[900]!, // Red border color
                  //       width: 2, // Border width
                  //     ),
                  //   ),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Center(
                  //         child: Text(
                  //           'Alamat Muat Surabaya',
                  //           style: TextStyle(
                  //               fontSize: 15, fontFamily: 'Poppins Bold'),
                  //         ),
                  //       ),
                  //       SizedBox(height: 6),
                  //       Container(
                  //         height: 2,
                  //         color: Colors.red[900],
                  //       ),
                  //       SizedBox(height: 5),
                  //       Text(
                  //         'Budi Sulistiyono',
                  //         style:
                  //             TextStyle(fontSize: 14, fontFamily: 'Poppinss'),
                  //       ),
                  //       SizedBox(height: 5),
                  //       Text(
                  //         'Muat',
                  //         style: TextStyle(
                  //             fontSize: 14, fontFamily: 'Poppins Regular'),
                  //       ),
                  //       SizedBox(height: 5),
                  //       Text(
                  //         'Surabaya, Surabaya, Jatim, SBY',
                  //         style: TextStyle(
                  //             fontSize: 14, fontFamily: 'Poppins Regular'),
                  //       ),
                  //       SizedBox(height: 5),
                  //       Text(
                  //         'Jl. Rungkut Madya 59, RT 09 RW 16, Rungkut, Surabaya, Jawa Timur',
                  //         style: TextStyle(
                  //             fontSize: 14, fontFamily: 'Poppins Regular'),
                  //         textAlign: TextAlign.justify,
                  //       ),
                  //     ],
                  //   ),
                  // )
                  alamatList.isEmpty
                      ? Center(
                          child: Text(
                            'No addresses found.',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins Regular',
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap:
                              true, // Allows the ListView to fit inside a Column
                          physics:
                              NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                          // itemCount: alamatList.length,
                          itemCount:
                              (alamatList.length / itemsPerPage).ceil() > 0
                                  ? itemsPerPage
                                  : 0,
                          itemBuilder: (context, index) {
                            // final address = alamatList[index];
                            final int itemIndex =
                                currentPageIndex * itemsPerPage + index;
                            if (itemIndex < alamatList.length) {
                              var address = alamatList[itemIndex];
                              return Container(
                                margin: EdgeInsets.all(6),
                                padding: EdgeInsets.only(
                                  top: 10,
                                  left: 16,
                                  right: 10,
                                  bottom: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.red[900]!, // Red border color
                                    width: 2, // Border width
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Text(
                                        address.addressName ??
                                            'Unknown Address',
                                        // 'Alamat ${address.addressType ?? 'Unknown Type'} ${address.city ?? 'Unknown City'}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontFamily: 'Poppins Bold',
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 6),
                                    Container(
                                      height: 2,
                                      color: Colors.red[900],
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      getAddressTypeName(
                                          address.addressType.toString()),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      address.picName ?? 'Unknown PIC',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppinss',
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      address.picPhone ?? 'Unknown Type',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      address.city ?? 'Unknown City',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      address.address1 ??
                                          'Address details not available',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ],
                                ),
                              );
                            }
                          },
                        ),
                  SizedBox(height: 15),
                  if (alamatList.isNotEmpty &&
                      ((alamatList.length / itemsPerPage).ceil() > 1))
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 40,
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
                                onPressed: currentPageIndex > 0
                                    ? () {
                                        setState(() {
                                          currentPageIndex--;
                                          _scrollController.animateTo(
                                            0.0,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      }
                                    : null,
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    (alamatList.length / itemsPerPage).ceil(),
                                itemBuilder: (context, pageIndex) {
                                  // Only show 5 pages at a time
                                  int startPage = (currentPageIndex ~/ 5) * 5;
                                  int endPage = startPage + 5;
                                  if (pageIndex < startPage ||
                                      pageIndex >= endPage) {
                                    return SizedBox.shrink();
                                  }
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
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 3),
                                      child: Container(
                                        width: 30,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: pageIndex == currentPageIndex
                                              ? Colors.blue[
                                                  300] // Active page color
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
                                            '${pageIndex + 1}',
                                            style: TextStyle(
                                              color: pageIndex ==
                                                      currentPageIndex
                                                  ? Colors
                                                      .white // Active page text color
                                                  : Colors
                                                      .black, // Inactive page text color
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
                                onPressed: currentPageIndex <
                                        (alamatList.length / itemsPerPage)
                                                .ceil() -
                                            1
                                    ? () {
                                        setState(() {
                                          currentPageIndex++;
                                          _scrollController.animateTo(
                                            0.0,
                                            duration:
                                                Duration(milliseconds: 500),
                                            curve: Curves.easeInOut,
                                          );
                                        });
                                      }
                                    : null,
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
                                    int lastPageIndex =
                                        (alamatList.length / itemsPerPage)
                                                .ceil() -
                                            1;
                                    if (currentPageIndex != lastPageIndex) {
                                      currentPageIndex = lastPageIndex;
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
        //     selectedItemColor: Colors.grey[600],
        //     // unselectedItemColor: Colors.grey[600],
        //     onTap: _onItemTapped,
        //   ),
        // ),
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
      ),
    );
  }
}
