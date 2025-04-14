import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/cubit/tracking_detail_cubit.dart';
import 'package:niaga_apps_mobile/model/tracking_detail.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';
import 'package:niaga_apps_mobile/tracking/menu_tracking_niaga.dart';

import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/tracking_niaga_cubit.dart';
import '../model/niaga/tracking/ptp-cosd/tracking_ptp_cosd.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';

class DetailTrackingNiaga extends StatefulWidget {
  final TrackingPtpCosdAccesses tracking;
  const DetailTrackingNiaga({Key? key, required this.tracking})
      : super(key: key);

  @override
  State<DetailTrackingNiaga> createState() => _DetailTrackingNiagaState();
}

class _DetailTrackingNiagaState extends State<DetailTrackingNiaga> {
  //untuk set navigasi bar dashboard, home, profile
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  int? mePackingListId;

  // List<TrackingPtpCosdAccesses> trackingdetailModellist = [];

  late List<TrackingPtpCosdAccesses> trackingdetailModellist;
  late List<Map<String, String>> items;
  late List<String> jamList;

//untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  // List<Map<String, String>> items = [
  //   {"title": "Masuk Niaga", "subtitle": "Gudang"},
  //   {"title": "Keluar Niaga", "subtitle": "Toko"},
  //   {"title": "Menuju Pelabuhan", "subtitle": "Pabrik"},
  //   {"title": "Muat Pelabuhan", "subtitle": "Pabrik"},
  //   {"title": "Bongkar Pelabuhan", "subtitle": "Pabrik"},
  //   // Add more items as needed
  // ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TrackingNiagaCubit>(context).trackingPTPCOSD;
    final DetailItem =
        widget.tracking.masukNiaga != null ? widget.tracking.masukNiaga : null;
    final DetailItem2 = widget.tracking.keluarNiaga != null
        ? widget.tracking.keluarNiaga
        : null;
    final DetailItem3 = widget.tracking.menujuPelabuhan != null
        ? widget.tracking.menujuPelabuhan
        : null;
    final DetailItem4 = widget.tracking.muatPelabuhan != null
        ? widget.tracking.muatPelabuhan
        : null;
    final DetailItem5 = widget.tracking.bongkarPelabuhan != null
        ? widget.tracking.bongkarPelabuhan
        : null;
    items = [
      {"title": "Masuk Niaga", "subtitle": DetailItem?.namaGudang ?? ''},
      {"title": "Keluar Niaga", "subtitle": DetailItem2?.namaGudang ?? ''},
      {"title": "Menuju Pelabuhan", "subtitle": ''},
      {"title": "Muat Pelabuhan", "subtitle": DetailItem4?.pelabuhanAsal ?? ''},
      {"title": "Bongkar Pelabuhan", "subtitle": DetailItem5?.pelabuhan ?? ''},
    ];
    jamList = [
      // DetailItem?.tglMasuk ?? '',
      DetailItem?.formattedTime ?? '',
      // DetailItem2?.tglKeluar ?? '',
      DetailItem2?.formattedTime ?? '',
      // DetailItem3?.tglMenujuPelabuhan ?? '',
      DetailItem3?.formattedTime ?? '',
      // DetailItem4?.etd ?? '',
      DetailItem4?.formattedTime ?? '',
      // DetailItem5?.eta ?? ''
      DetailItem5?.formattedTime ?? ''
    ];
    // isSelected = false;
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final headerItem =
        widget.tracking.header.isNotEmpty ? widget.tracking.header[0] : null;

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
                  "Lacak Pengiriman",
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
                  onPressed: () {},
                ),
              ),
            ],
          ),
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      body: BlocConsumer<TrackingNiagaCubit, TrackingNiagaState>(
        listener: (context, state) {
          if (state is TrackingPTPCOSDSuccess) {
            trackingdetailModellist.clear();
            // trackingdetailModellist = state.response;
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                          alignment: Alignment.topCenter,
                          margin: EdgeInsets.all(16),
                          height: mediaQuery.size.height * 0.87,
                          width: mediaQuery.size.width * 0.9,
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
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                SizedBox(height: 25),
                                Center(
                                  child: Text(
                                    // widget.tracking.packingListNo!,
                                    headerItem?.nopl ?? '',
                                    style: TextStyle(
                                        color: Colors.red[900],
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20),
                                  ),
                                  // Text(widget.invoice.invoiceNo!),
                                ),
                                SizedBox(height: 30),
                                Table(
                                  columnWidths: {
                                    0: FlexColumnWidth(3),
                                    1: FlexColumnWidth(1),
                                    2: FlexColumnWidth(5),
                                  },
                                  children: [
                                    TableRow(children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 2.0),
                                          child: Text(
                                            'Container',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
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
                                          child: Text(
                                            headerItem?.container ?? '',
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
                                            'Owner Code',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
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
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          headerItem?.ownerCode ?? '',
                                        ),
                                      ))
                                    ]),
                                    //baris ke 3 Rute Pengiriman
                                    TableRow(children: [
                                      TableCell(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0, horizontal: 2.0),
                                          child: Text(
                                            'Owner Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
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
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          headerItem?.ownerName ?? '',
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
                                            'Rute Pengiriman',
                                            style: TextStyle(
                                                fontWeight: FontWeight.normal),
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
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                      TableCell(
                                          child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 8.0, horizontal: 2.0),
                                        child: Text(
                                          headerItem?.keterangan ?? '',
                                        ),
                                      ))
                                    ]),
                                  ],
                                ),
                                SizedBox(height: 60),
                                //tracking line
                                // Stack(
                                //   children: [
                                //     Row(
                                //       mainAxisAlignment:
                                //           MainAxisAlignment.start,
                                //       children: [
                                //         Column(
                                //           children: List.generate(5, (index) {
                                //             return Column(
                                //               children: [
                                //                 Container(
                                //                   width: 10,
                                //                   height: 10,
                                //                   decoration: BoxDecoration(
                                //                     shape: BoxShape.circle,
                                //                     color: Colors.red[900],
                                //                   ),
                                //                 ),
                                //                 // Only add the divider if it's not the last item
                                //                 if (index != 4)
                                //                   Container(
                                //                     height:
                                //                         65, // Adjust the height as needed
                                //                     child: VerticalDivider(
                                //                       color: Colors.grey[600],
                                //                       thickness: 3,
                                //                     ),
                                //                   ),
                                //               ],
                                //             );
                                //           }),
                                //         ),
                                //       ],
                                //     ),
                                //     //Fills the available space of the parent (in this case, the Stack) and positions the text labels in the middle of each circle
                                //     Positioned.fill(
                                //       child: Padding(
                                //         padding:
                                //             const EdgeInsets.only(left: 30),
                                //         child: Column(
                                //           //mengatur jarak antar text atas bwh
                                //           mainAxisAlignment:
                                //               MainAxisAlignment.spaceBetween,
                                //           crossAxisAlignment:
                                //               CrossAxisAlignment.start,
                                //           children: [
                                //             Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Text('Masuk Niaga'),
                                //                 SizedBox(height: 16),
                                //                 SizedBox(
                                //                   height: 28,
                                //                   child: Text('Gudang'),
                                //                 )
                                //               ],
                                //             ),
                                //             Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Text('Keluar Niaga'),
                                //                 SizedBox(height: 16),
                                //                 SizedBox(
                                //                   height: 28,
                                //                   child: Text('Gudang'),
                                //                 )
                                //               ],
                                //             ),
                                //             Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Text('Menuju Pelabuhan'),
                                //                 SizedBox(height: 16),
                                //                 SizedBox(
                                //                   height: 28,
                                //                   child: Text('Gudang'),
                                //                 )
                                //               ],
                                //             ),
                                //             Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Text('Muat Pelabuhan'),
                                //                 SizedBox(height: 16),
                                //                 SizedBox(
                                //                   height: 28,
                                //                   child: Text('Gudang'),
                                //                 )
                                //               ],
                                //             ),
                                //             Column(
                                //               crossAxisAlignment:
                                //                   CrossAxisAlignment.start,
                                //               children: [
                                //                 Text('Bongkar Pelabuhan'),
                                //                 SizedBox(height: 16),
                                //                 Text('Gudang'),
                                //               ],
                                //             ),
                                //           ],
                                //         ),
                                //       ),
                                //     ),
                                //   ],
                                // ),
                                //3
                                Stack(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          children: List.generate(items.length,
                                              (index) {
                                            return Column(
                                              children: [
                                                Container(
                                                  width: 10,
                                                  height: 10,
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red[900],
                                                  ),
                                                ),
                                                if (index !=
                                                    items.length -
                                                        1) // Only add the divider if it's not the last item
                                                  Container(
                                                    height:
                                                        65, // Adjust the height as needed
                                                    child: VerticalDivider(
                                                      color: Colors.grey[600],
                                                      thickness: 3,
                                                    ),
                                                  ),
                                              ],
                                            );
                                          }),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: List.generate(items.length,
                                            (index) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 34.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(items[index]['title']!),
                                                SizedBox(height: 8),
                                                Text(
                                                  items[index]['subtitle']!,
                                                  maxLines: 2,
                                                ),
                                              ], 
                                            ),
                                          );
                                        }),
                                      ),
                                    ),
                                    // Row(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   children: [
                                    //     Text('data'),
                                    //   ],
                                    // )
                                    // Column(
                                    //   mainAxisAlignment: MainAxisAlignment.end,
                                    //   children:
                                    //       List.generate(items.length, (index) {
                                    //     return Padding(
                                    //       padding:
                                    //           const EdgeInsets.only(left: 10.0),
                                    //       child: Text('Jam'),
                                    //     );
                                    //   }),
                                    // ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: List.generate(
                                                jamList.length, (index) {
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 16.0, bottom: 60.0),
                                                child: Text(jamList[index]),
                                              );
                                            }),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                // SizedBox(height: 60),
                                // Material(
                                //   borderRadius: BorderRadius.circular(10.0),
                                //   color: Colors.green[600],
                                //   //membuat bayangan pada button Detail
                                //   shadowColor: Colors.grey[350],
                                //   elevation: 5,
                                //   child: MaterialButton(
                                //     onPressed: () {
                                //       // Add your button action here
                                //     },
                                //     child: Text(
                                //       'Bayar',
                                //       style: TextStyle(
                                //           fontSize: 18, color: Colors.white),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15.0,
                ),
                // Additional containers (container 2, container 3, container 4)
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.dashboard), label: 'Order'),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 20,
                child: ImageIcon(
                  AssetImage('assets/tracking icon.png'),
                ),
              ),
              label: 'Tracking',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: SizedBox(
                width: 12,
                child: ImageIcon(
                  AssetImage('assets/invoice icon.png'),
                ),
              ),
              label: 'Invoice',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
          currentIndex: _selectedIndex,
          // selectedItemColor: Colors.red[900],
          selectedItemColor: Colors.grey[600],
          // unselectedItemColor: Colors.grey[600],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
