import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';
import '../cubit/jadwal_kapal_cubit.dart';
import '../cubit/wa_cubit.dart';
import '../model/jadwal_kapal.dart';

class JadwalKapalPage extends StatefulWidget {
  const JadwalKapalPage({Key? key}) : super(key: key);

  @override
  State<JadwalKapalPage> createState() => _JadwalKapalPageState();
}

class _JadwalKapalPageState extends State<JadwalKapalPage> {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  int currentPageIndex = 0;
  int itemsPerPage = 2;
  ScrollController _scrollController = ScrollController(); //untuk pagination

  List<JadwalKapalAccesses> kapalModellist = [];

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
    BlocProvider.of<JadwalKapalCubit>(context).jadwalKapal();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Colors.amber[600],
        ),
      ),
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  //untuk fungsi pop up dialog search
  Future searchMyInvoice() => showDialog(
      context: context,
      //alert diberi SingleChildScrollView agar bisa di scroll
      builder: (BuildContext context) => SingleChildScrollView(
            child: AlertDialog(
              //untuk memberi border melengkung
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              content: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 40, maxWidth: 300),
                child: Form(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // BlocProvider.of<WACubit>(context).sendwhatsapp();
                        },
                        child: Expanded(
                          child: Image.asset(
                            'assets/WA.png', // Replace 'your_image.png' with your image asset path
                            height: 80, // Adjust height as needed
                            width: 80, // Adjust width as needed
                          ),
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/telegram.png', // Replace 'your_image.png' with your image asset path
                          height: 80, // Adjust height as needed
                          width: 80, // Adjust width as needed
                        ),
                      ),
                      Expanded(
                        child: Image.asset(
                          'assets/Image.png', // Replace 'your_image.png' with your image asset path
                          height: 80, // Adjust height as needed
                          width: 80, // Adjust width as needed
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
          //         "Jadwal Kapal",
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
          //                 Icons.share,
          //                 color: Colors.black,
          //               ),
          //               onPressed: () {
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
                  "Jadwal Kapal",
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
                    Icons.share,
                    color: Colors.black,
                  ),
                  iconSize: 24,
                  onPressed: () {
                    searchMyInvoice();
                  },
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: BlocConsumer<WACubit, WAState>(
        listener: (context, state) {
          if (state is SendWhatsappSuccess) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                // content: Text('PDF sent via WhatsApp'),
                // duration: Duration(seconds: 2),
                content: Text('PDF sent via WhatsApp (queued for delivery)'),
                duration: Duration(seconds: 2),
              ),
            );
          }
          if (state is SendWhatsappFailure) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              // content: Text('Failed to send PDF via WhatsApp'),
              // duration: Duration(seconds: 2),
              content: Text('Failed to send PDF via WhatsApp'),
              duration: Duration(seconds: 2),
            ));
          }
        },
        builder: (context, state) {
          return BlocConsumer<JadwalKapalCubit, JadwalKapalState>(
            listener: (context, state) async {
              // if (state is JadwalKapalInProgress) {
              //   await showLoadingDialog(context);
              // } else
              if (state is JadwalKapalSuccess) {
                // await Future.delayed(Duration(seconds: 3));
                kapalModellist.clear();
                kapalModellist = state.response;
                //order by ascending
                kapalModellist.sort((a, b) => a.id!.compareTo(b.id!));
                // hideLoadingDialog(context);
              }
            },
            builder: (context, state) {
              if (state is JadwalKapalInProgress) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber[600],
                  ),
                );
              }
              return SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        // physics: NeverScrollableScrollPhysics(),
                        // itemCount: kapalModellist.length,
                        itemCount:
                            (kapalModellist.length / itemsPerPage).ceil() > 0
                                ? itemsPerPage
                                : 0,
                        controller: ScrollController(),
                        itemBuilder: (context, index) {
                          final int itemIndex =
                              currentPageIndex * itemsPerPage + index;
                          // var data = kapalModellist[index];
                          if (itemIndex < kapalModellist.length) {
                            var data = kapalModellist[itemIndex];
                            return Container(
                              margin: EdgeInsets.all(18),
                              //setting tinggi & lebar container grey
                              height: mediaQuery.size.height * 0.4,
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
                              //untuk form
                              child: Stack(
                                children: [
                                  // Main content
                                  Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          data.shipName!,
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
                                              //baris 1 No Voyage kolom tabel
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
                                                  child: Text(
                                                    'No Voyage',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
                                                  child: Text(':'),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
                                                  child:
                                                      // (item.containsKey('voyage'))
                                                      Text(
                                                    data.voyageNo!,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              )
                                            ]),
                                            //baris ke 2 Tanggal Closing
                                            TableRow(children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
                                                  child: Text(
                                                    'Tanggal Closing',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
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
                                                    vertical: 8.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  data.closingDate!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ))
                                            ]),
                                            //baris ke 3 rute tujuan
                                            TableRow(children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
                                                  child: Text(
                                                    'Rute dan Tujuan',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
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
                                                    vertical: 8.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  data.rute!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ))
                                            ]),
                                            //baris ke 4 rute panjang
                                            TableRow(children: [
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
                                                  child: Text(
                                                    'Rute Panjang',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              TableCell(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 2.0),
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
                                                    vertical: 8.0,
                                                    horizontal: 2.0),
                                                child: Text(
                                                  data.rutePanjang!,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
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
                                            Text(
                                              data.eta!,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
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
                                            Text(
                                              data.etd!,
                                              style: TextStyle(
                                                  fontWeight:
                                                      FontWeight.normal),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          // else {
                          //   return SizedBox.shrink();
                          // }
                        }),
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
                                    (kapalModellist.length / itemsPerPage)
                                        .ceil(),
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
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: pageIndex == currentPageIndex
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
                                      (kapalModellist.length / itemsPerPage)
                                              .ceil() -
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
          );
        },
      ),
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
}
