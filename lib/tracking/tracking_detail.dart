import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/cubit/tracking_detail_cubit.dart';
import 'package:niaga_apps_mobile/model/packing_list.dart';
import 'package:niaga_apps_mobile/model/tracking_detail.dart';
import 'package:niaga_apps_mobile/screen/dahboard.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
import 'package:niaga_apps_mobile/screen/profile.dart';

class DetailTracking extends StatefulWidget {
  final PackingListAccesses tracking;
  const DetailTracking({Key? key, required this.tracking}) : super(key: key);

  @override
  State<DetailTracking> createState() => _DetailTrackingState();
}

class _DetailTrackingState extends State<DetailTracking> {
  //untuk set navigasi bar dashboard, home, profile
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  int? mePackingListId;

  List<TrackingDetailAccesses> trackingdetailModellist = [];

//untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    DashboardPage(),
    HomePage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TrackingDetailCubit>(context)
        .fetchTrackingDetail(mePackingListId: widget.tracking.id);
    // isSelected = false;
  }

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DashboardPage()),
        );
        break;
      case 1:
        Navigator.pop(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: BlocConsumer<TrackingDetailCubit, TrackingDetailState>(
        listener: (context, state) {
          if (state is TrackingDetailSuccess) {
            trackingdetailModellist.clear();
            trackingdetailModellist = state.response;
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
                        height: mediaQuery.size.height * 0.92,
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
                        child: Stack(
                          children: [
                            //tulisan judul no packing list
                            Positioned(
                              top: 30,
                              left: 16,
                              right: 16,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      widget.tracking.packingListNo!,
                                      style: TextStyle(
                                          color: Colors.red[900],
                                          fontWeight: FontWeight.w900,
                                          fontSize: 20),
                                    ),
                                    // Text(widget.invoice.invoiceNo!),
                                  ),
                                ],
                              ),
                            ),
                            //tabel Invoice no (TABEL ATAS)
                            Positioned(
                              top: 80, // Adjust the top position as needed
                              left: 16, // Adjust the left position as needed
                              right: 16, // Adjust the right position as needed
                              child: Column(
                                children: [
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
                                            child: Text(widget.tracking.type!),
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
                                          child: Text(
                                            widget.tracking.volume.toString()!,
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
                                              'Rute Pengiriman',
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
                                            widget.tracking.rute!,
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
                                      ]),
                                      //baris ke 5 lokasi
                                      TableRow(children: [
                                        TableCell(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0, horizontal: 2.0),
                                            child: Text(
                                              'Lokasi',
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
                                            'In Warehouse Niaga',
                                            style: TextStyle(
                                                color: Colors.indigo[600],
                                                fontWeight: FontWeight.w800),
                                          ),
                                        ))
                                      ]),
                                    ],
                                  ),
                                  // Row(
                                  //   //agar tulisan di atas
                                  //   crossAxisAlignment:
                                  //       CrossAxisAlignment.start,
                                  //   children: [
                                  //     Padding(
                                  //       padding: const EdgeInsets.all(10.0),
                                  //       child: Column(
                                  //         mainAxisAlignment:
                                  //             MainAxisAlignment.spaceBetween,
                                  //         children: [
                                  //           Positioned(
                                  //             top: 300,
                                  //             left: 80,
                                  //             right: 16,
                                  //             child: Column(
                                  //               crossAxisAlignment:
                                  //                   CrossAxisAlignment.start,
                                  //               children: [
                                  //                 //kolom 1 lingakaran + garis
                                  //                 for (var a
                                  //                     in trackingdetailModellist)
                                  //                   Column(
                                  //                     children: [
                                  //                       Container(
                                  //                         width:
                                  //                             10, // Adjust the width of the circle as needed
                                  //                         height:
                                  //                             10, // Adjust the height of the circle as needed
                                  //                         decoration:
                                  //                             BoxDecoration(
                                  //                           shape:
                                  //                               BoxShape.circle,
                                  //                           color: Colors.red[
                                  //                               900], // Adjust the color of the circle as needed
                                  //                         ),
                                  //                       ),
                                  //                       Container(
                                  //                         height:
                                  //                             45, // Adjust the height as needed
                                  //                         child:
                                  //                             VerticalDivider(
                                  //                           color: Colors
                                  //                               .grey[400],
                                  //                           thickness: 3,
                                  //                         ),
                                  //                       ),
                                  //                     ],
                                  //                   ),
                                  //                 //kolom ke 2 ingakaran + garis
                                  //                 // Column(
                                  //                 //   children: [
                                  //                 //     Container(
                                  //                 //       width:
                                  //                 //           10, // Adjust the width of the circle as needed
                                  //                 //       height:
                                  //                 //           10, // Adjust the height of the circle as needed
                                  //                 //       decoration:
                                  //                 //           BoxDecoration(
                                  //                 //         shape:
                                  //                 //             BoxShape.circle,
                                  //                 //         color: Colors.red[
                                  //                 //             900], // Adjust the color of the circle as needed
                                  //                 //       ),
                                  //                 //     ),
                                  //                 //     Container(
                                  //                 //       height:
                                  //                 //           45, // Adjust the height as needed
                                  //                 //       child: VerticalDivider(
                                  //                 //         color:
                                  //                 //             Colors.grey[400],
                                  //                 //         thickness: 3,
                                  //                 //       ),
                                  //                 //     ),
                                  //                 //   ],
                                  //                 // ),
                                  //                 //kolom 3 ingakaran + garis
                                  //                 // Column(
                                  //                 //   children: [
                                  //                 //     Container(
                                  //                 //       width:
                                  //                 //           10, // Adjust the width of the circle as needed
                                  //                 //       height:
                                  //                 //           10, // Adjust the height of the circle as needed
                                  //                 //       decoration:
                                  //                 //           BoxDecoration(
                                  //                 //         shape:
                                  //                 //             BoxShape.circle,
                                  //                 //         color: Colors.red[
                                  //                 //             900], // Adjust the color of the circle as needed
                                  //                 //       ),
                                  //                 //     ),
                                  //                 //     Container(
                                  //                 //       height:
                                  //                 //           45, // Adjust the height as needed
                                  //                 //       child: VerticalDivider(
                                  //                 //         color:
                                  //                 //             Colors.grey[400],
                                  //                 //         thickness: 3,
                                  //                 //       ),
                                  //                 //     ),
                                  //                 //   ],
                                  //                 // ),
                                  //                 //kolom ke 4 ingakaran + garis
                                  //                 // Column(
                                  //                 //   children: [
                                  //                 //     Container(
                                  //                 //       width:
                                  //                 //           10, // Adjust the width of the circle as needed
                                  //                 //       height:
                                  //                 //           10, // Adjust the height of the circle as needed
                                  //                 //       decoration:
                                  //                 //           BoxDecoration(
                                  //                 //         shape:
                                  //                 //             BoxShape.circle,
                                  //                 //         color: Colors.red[
                                  //                 //             900], // Adjust the color of the circle as needed
                                  //                 //       ),
                                  //                 //     ),
                                  //                 //     Container(
                                  //                 //       height:
                                  //                 //           80, // Adjust the height as needed
                                  //                 //       child: VerticalDivider(
                                  //                 //         color:
                                  //                 //             Colors.grey[400],
                                  //                 //         thickness: 3,
                                  //                 //       ),
                                  //                 //     ),
                                  //                 //   ],
                                  //                 // ),
                                  //                 //kolom ke 4 ingakaran + garis
                                  // Column(
                                  //   children: [
                                  //     Container(
                                  //       width:
                                  //           10, // Adjust the width of the circle as needed
                                  //       height:
                                  //           10, // Adjust the height of the circle as needed
                                  //       decoration: BoxDecoration(
                                  //         shape: BoxShape.circle,
                                  //         color: Colors.grey[
                                  //             400], // Adjust the color of the circle as needed
                                  //       ),
                                  //     ),
                                  //     Container(
                                  //       height:
                                  //           0, // Adjust the height as needed
                                  //       child: VerticalDivider(
                                  //         color: Colors.grey[400],
                                  //         thickness: 3,
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  //               ],
                                  //             ),
                                  //           ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //     //baris pertama teks
                                  //     Padding(
                                  //       padding: const EdgeInsets.all(10.0),
                                  //       child: Column(
                                  //         children: [
                                  //           Row(
                                  //             mainAxisAlignment:
                                  //                 MainAxisAlignment
                                  //                     .spaceBetween,
                                  //             children: [
                                  //               Column(
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.start,
                                  //                 children: [
                                  //                   for (var a
                                  //                       in trackingdetailModellist)
                                  //                     // Padding(
                                  //                     //   padding: const EdgeInsets
                                  //                     //           .fromLTRB(
                                  //                     //       5, 10, 10, 10),

                                  //                     //   child:
                                  //                     Text(a.description
                                  //                         .toString()),
                                  //                   // ),
                                  //                 ],
                                  //               ),
                                  //               // Container(width: 30),
                                  //               Column(
                                  //                 crossAxisAlignment:
                                  //                     CrossAxisAlignment.end,
                                  //                 children: [
                                  //                   for (var a
                                  //                       in trackingdetailModellist)
                                  //                     // Padding(
                                  //                     //     padding:
                                  //                     //         const EdgeInsets
                                  //                     //                 .only(
                                  //                     //             bottom: 5),
                                  //                     //     child:
                                  //                     // Text('SBY'),
                                  //                     Text(
                                  //                       a.location.toString(),
                                  //                     )
                                  //                   // ),
                                  //                   // Text('04:12 P.M',
                                  //                   //     style: TextStyle(
                                  //                   //         fontSize: 12)),
                                  //                 ],
                                  //               ),
                                  //             ],
                                  //           ),
                                  //           //ke 2
                                  //           // Row(
                                  //           //   children: [
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.start,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets
                                  //           //                   .fromLTRB(
                                  //           //               5, 10, 10, 10),
                                  //           //           child: Text(
                                  //           //               'Stuffing Processing Warehouse'),
                                  //           //         ),
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets
                                  //           //               .fromLTRB(5, 0, 10, 10),
                                  //           //           child: Text(
                                  //           //               'Event occured 29/11/2024',
                                  //           //               style: TextStyle(
                                  //           //                   fontSize: 12)),
                                  //           //         ),
                                  //           //       ],
                                  //           //     ),
                                  //           //     // Container(width: 30),
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.end,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding:
                                  //           //               const EdgeInsets.only(
                                  //           //                   bottom: 5),
                                  //           //           child: Text('SBY'),
                                  //           //         ),
                                  //           //         Text('09:12 P.M',
                                  //           //             style: TextStyle(
                                  //           //                 fontSize: 12)),
                                  //           //       ],
                                  //           //     ),
                                  //           //   ],
                                  //           // ),
                                  //           // ke -3
                                  //           // Row(
                                  //           //   children: [
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.start,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets
                                  //           //                   .fromLTRB(
                                  //           //               5, 10, 10, 10),
                                  //           //           child: Text(
                                  //           //               'Loading in Port Tanjung Perak'),
                                  //           //         ),
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets
                                  //           //               .fromLTRB(5, 0, 10, 10),
                                  //           //           child: Text(
                                  //           //               'Event occured 30/11/2024',
                                  //           //               style: TextStyle(
                                  //           //                   fontSize: 12)),
                                  //           //         ),
                                  //           //       ],
                                  //           //     ),
                                  //           //     // Container(width: 30),
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.end,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding:
                                  //           //               const EdgeInsets.only(
                                  //           //                   bottom: 5),
                                  //           //           child: Text('SBY'),
                                  //           //         ),
                                  //           //         Text('04:12 P.M',
                                  //           //             style: TextStyle(
                                  //           //                 fontSize: 12)),
                                  //           //       ],
                                  //           //     ),
                                  //           //   ],
                                  //           // ),
                                  //           // ke-4
                                  //           // Row(
                                  //           //   children: [
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.start,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets
                                  //           //                   .fromLTRB(
                                  //           //               5, 10, 10, 10),
                                  //           //           child: Text(
                                  //           //             'Shipping Transit in Makassar',
                                  //           //             maxLines: 2,
                                  //           //             overflow:
                                  //           //                 TextOverflow.ellipsis,
                                  //           //           ),
                                  //           //         ),
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets
                                  //           //               .fromLTRB(5, 0, 10, 10),
                                  //           //           child: Text(
                                  //           //               'Event occured 29/11/2024',
                                  //           //               style: TextStyle(
                                  //           //                   fontSize: 12)),
                                  //           //         ),
                                  //           //       ],
                                  //           //     ),
                                  //           //     // Container(width: 30),
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.end,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding:
                                  //           //               const EdgeInsets.only(
                                  //           //                   bottom: 5),
                                  //           //           child: Text('SBY'),
                                  //           //         ),
                                  //           //         Text('11:17 P.M',
                                  //           //             style: TextStyle(
                                  //           //                 fontSize: 12)),
                                  //           //       ],
                                  //           //     ),
                                  //           //   ],
                                  //           // ),
                                  //           //ke -5
                                  //           // Row(
                                  //           //   crossAxisAlignment:
                                  //           //       CrossAxisAlignment.start,
                                  //           //   children: [
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.start,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding:
                                  //           //               const EdgeInsets.fromLTRB(
                                  //           //                   5, 10, 10, 10),
                                  //           //           child:
                                  //           //               Text('Package Delivered'),
                                  //           //         ),
                                  //           //         Padding(
                                  //           //           padding:
                                  //           //               const EdgeInsets.fromLTRB(
                                  //           //                   5, 0, 10, 10),
                                  //           //           child: Text(
                                  //           //               'Event yet to occured',
                                  //           //               style: TextStyle(
                                  //           //                   fontSize: 12)),
                                  //           //         ),
                                  //           //       ],
                                  //           //     ),
                                  //           //     // Container(width: 30),
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.end,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets.only(
                                  //           //               bottom: 5),
                                  //           //           child: Text('SBY'),
                                  //           //         ),
                                  //           //         Text('11:17 P.M',
                                  //           //             style:
                                  //           //                 TextStyle(fontSize: 12)),
                                  //           //       ],
                                  //           //     ),
                                  //           //   ],
                                  //           // ),
                                  //           //----
                                  //           // Row(
                                  //           //   mainAxisAlignment:
                                  //           //       MainAxisAlignment.spaceBetween,
                                  //           //   children: [
                                  //           //     // Expanded(
                                  //           //     // child:
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.start,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets
                                  //           //                   .fromLTRB(
                                  //           //               5, 10, 10, 10),
                                  //           //           child: Text(
                                  //           //               'Package Delivered'),
                                  //           //         ),
                                  //           //         Padding(
                                  //           //           padding: const EdgeInsets
                                  //           //               .fromLTRB(5, 0, 10, 10),
                                  //           //           child: Text(
                                  //           //               'Event occured 29/11/2024',
                                  //           //               style: TextStyle(
                                  //           //                   fontSize: 12)),
                                  //           //         ),
                                  //           //       ],
                                  //           //     ),
                                  //           //     // ),
                                  //           //     // Container(width: 30),
                                  //           //     // Expanded(
                                  //           //     // child:
                                  //           //     Column(
                                  //           //       crossAxisAlignment:
                                  //           //           CrossAxisAlignment.end,
                                  //           //       children: [
                                  //           //         Padding(
                                  //           //           padding:
                                  //           //               const EdgeInsets.only(
                                  //           //                   bottom: 5),
                                  //           //           child: Text('SBY'),
                                  //           //         ),
                                  //           //         Text('04:12 P.M',
                                  //           //             style: TextStyle(
                                  //           //                 fontSize: 12)),
                                  //           //       ],
                                  //           //     ),
                                  //           //     // ),
                                  //           //   ],
                                  //           // ),
                                  //         ],
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  //==
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Red circles and vertical dividers
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          children: [
                                            for (int index = 0;
                                                index <
                                                    trackingdetailModellist
                                                        .length;
                                                index++)
                                              Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Container(
                                                        width: 10,
                                                        height: 10,
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          color: trackingdetailModellist[
                                                                          index]
                                                                      ?.description
                                                                      ?.contains(
                                                                          'Delivered') ??
                                                                  false
                                                              ? Colors.grey[
                                                                  400] // Grey color if description contains 'Delivered'
                                                              : Colors.red[
                                                                  900], // Red color otherwise
                                                        ),
                                                      ),
                                                      if (index <
                                                          trackingdetailModellist
                                                                  .length -
                                                              1)
                                                        Container(
                                                          height:
                                                              45, // Adjust the height as needed
                                                          child:
                                                              VerticalDivider(
                                                            color: Colors
                                                                .grey[400],
                                                            thickness: 3,
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                      // Text descriptions and locations
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            for (var a
                                                in trackingdetailModellist)
                                              Column(
                                                // mainAxisAlignment:
                                                //     MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        a.description
                                                            .toString(),
                                                        maxLines: 3,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                      Text(
                                                        a.location.toString(),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    a.date.toString(),
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  SizedBox(height: 17),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            //tabel freight (TABEL BAWAH)
                            //tracking baru
                            //membuat tombol Bayar
                            Positioned(
                              right: 126,
                              bottom: 30,
                              child: Material(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.green[600],
                                //membuat bayangan pada button Detail
                                shadowColor: Colors.grey[350],
                                elevation: 5,
                                child: MaterialButton(
                                  onPressed: () {
                                    // Add your button action here
                                  },
                                  child: Text(
                                    'Bayar',
                                    style: TextStyle(
                                        fontSize: 18, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            isSelected == true ? Colors.red[900] : Colors.grey[600],
        onTap: _onItemTapped,
      ),
    );
  }
}
