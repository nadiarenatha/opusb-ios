import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/Invoice/my_invoice.dart';
import 'package:niaga_apps_mobile/daftar-harga/daftar_harga.dart';
import 'package:niaga_apps_mobile/jadwal-kapal/jadwal_kapal.dart';
import 'package:niaga_apps_mobile/packing/packing_list.dart';
import 'package:niaga_apps_mobile/screen/qr_scan.dart';
import 'package:niaga_apps_mobile/simulasi-pengiriman/simulasi_pengiriman.dart';
import 'package:niaga_apps_mobile/stok-barang-gudang/stok_barang.dart';
import 'package:niaga_apps_mobile/tracking/tracking.dart';

import '../Invoice/invoice_niaga.dart';
import '../pemesanan/kontak_perjanjian.dart';
import '../tracking/tracking_niaga.dart';
import '../tracking/tracking_pencarian.dart';
// import 'package:barcode_scan/barcode_scan.dart;

//home screen isi dari homenya

class HomePageScreen extends StatefulWidget {
  final String? qrResult;
  //untuk navigate ke hlmn tracking
  final String resiNumber;
  const HomePageScreen({
    Key? key,
    this.qrResult,
    //untuk navigate ke hlmn tracking
    required this.resiNumber,
  }) : super(key: key);

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  late TextEditingController _resiController;

  @override
  void initState() {
    super.initState();
    // Initialize the controller and set the initial value to the QR result
    //jika hanya ambil hasil qr dan tempel di masukkan no resi nya
    // _resiController = TextEditingController(text: widget.qrResult ?? '');
    //jika langsung ke halaman tracking
    _resiController =
        TextEditingController(text: widget.qrResult ?? widget.resiNumber);

    // Print the qrResult to the console
    print('QR Result in HomePage: ${widget.qrResult}');
  }

  @override
  void dispose() {
    _resiController.dispose();
    super.dispose();
  }

  Future<void> _scanQRCode() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => QRViewExample()),
    );

    if (result != null) {
      setState(() {
        _resiController.clear(); // Clear the previous result
        _resiController.text = result;

        // Print the new scanned result to the console
        print('New Scanned QR Code: $result');
      });

      // After setting the result, navigate to the TrackingPage automatically
      // _navigateToTrackingPage();
    }
  }

  //untuk fungsi tombol track
  void _navigateToTrackingPage() {
    if (_resiController.text.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              TrackingPencarianNiaga(noPL: _resiController.text),
        ),
      );
      // Clear the previous result
      _resiController.clear();
    } else {
      // Optionally, show an error if the resi number is empty
      print('Resi number is empty!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Image.asset(
            'assets/niaga-home.png',
            width: MediaQuery.of(context).size.width,
          ),
          Container(
            height: mediaQuery.size.height * 0.59,
            decoration: BoxDecoration(
              color: Colors.grey[300],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lacak Pengirimanmu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.red[900],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.5,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: TextFormField(
                              // Link controller here
                              controller: _resiController,
                              decoration: InputDecoration(
                                hintText: "masukkan nomor resi",
                                fillColor: Colors.grey[400],
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 15,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Material(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.red[900],
                          //membuat bayangan pada button Detail
                          shadowColor: Colors.grey[350],
                          elevation: 5,
                          child: MaterialButton(
                            minWidth: 10,
                            padding:
                                EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                            // onPressed: () {},
                            onPressed:
                                _navigateToTrackingPage, // Navigate on button press
                            child: Text(
                              "Lacak",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                letterSpacing: 1.5,
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: _scanQRCode,
                          child: SizedBox(
                            height: 20.0,
                            child: Image.asset('assets/scan-QR.png'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Text(
                    "Menu",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.red[900],
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 250,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        shrinkWrap: true,
                        // scrollDirection: Axis.horizontal,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                //kolom 1
                                Column(
                                  children: [
                                    //row 1 untuk kotak dan icon My Menus
                                    Row(
                                      //row kotak Packing list
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return PackingListPage();
                                                }));
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                      // width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.blue[200]!,
                                                            Colors.white
                                                          ],
                                                        ),
                                                      ),
                                                      //logo packing list
                                                      child:
                                                          // Stack(
                                                          //   children: [
                                                          SizedBox(
                                                        height: 115.0,
                                                        child: Image.asset(
                                                            'assets/Packing-List.png'),
                                                      )
                                                      //   ],
                                                      // ),
                                                      ),
                                                  //tulisan packing
                                                  Text(
                                                    "Dokumen",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Pengiriman",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return StokBarangPage();
                                                }));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      // width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              Colors.red[100]!,
                                                              Colors.white
                                                            ]),
                                                      ),
                                                      //logo stok  barang
                                                      child:
                                                          // Stack(
                                                          //   children: [
                                                          SizedBox(
                                                        height: 115.0,
                                                        child: Image.asset(
                                                            'assets/Stok-Barang.png'),
                                                      )
                                                      //   ],
                                                      // ),
                                                      ),
                                                  //tulisan stok barang
                                                  Text(
                                                    "Stok",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Barang",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Gudang",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  // Text(
                                                  //   "Gudang",
                                                  //   style: TextStyle(
                                                  //     fontSize: 12,
                                                  //     fontWeight: FontWeight.bold,
                                                  //     color: Colors.black,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      // return TrackingNiagaPage(
                                                      //     resiNumber:
                                                      //         _resiController
                                                      //             .text);
                                                      return TrackingPencarianNiaga(
                                                          noPL:
                                                              _resiController
                                                                  .text);
                                                    }));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          // width: 60,
                                                          height: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              colors: [
                                                                Colors
                                                                    .blue[100]!,
                                                                Colors.white
                                                              ],
                                                            ),
                                                          ),
                                                          //logo tracking barang
                                                          child:
                                                              // Stack(
                                                              // children: [
                                                              SizedBox(
                                                            height: 115.0,
                                                            child: Image.asset(
                                                                'assets/Tracking-Barang.png'),
                                                          )
                                                          //   ],
                                                          // ),
                                                          ),
                                                    ],
                                                  ),
                                                ),
                                                //tulisna tracking barang
                                                Text(
                                                  "Lacak",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "Pengiriman",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        //row kotak jadwal kapal
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return JadwalKapalPage();
                                                }));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      // width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.pink[100]!,
                                                            Colors.white
                                                          ],
                                                        ),
                                                      ),
                                                      //logo tracking barang
                                                      child:
                                                          // Stack(
                                                          //   children: [
                                                          SizedBox(
                                                        height: 115.0,
                                                        child: Image.asset(
                                                            'assets/Jadwal-Kapal.png'),
                                                      )
                                                      //   ],
                                                      // ),
                                                      ),
                                                  //tulisan jadwal kapal
                                                  Text(
                                                    "Jadwal",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Kapal",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //kolom 2
                                Column(
                                  children: [
                                    //row 1 untuk kotak dan icon My Menus
                                    Row(
                                      //row kotak My Invoice
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      // mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  // return MyInvoicePage();
                                                  return InvoicePage();
                                                }));
                                              },
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                      // width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.orange[300]!,
                                                            Colors.white
                                                          ],
                                                        ),
                                                      ),
                                                      //logo packing list
                                                      child:
                                                          // Stack(
                                                          //   children: [
                                                          SizedBox(
                                                        height: 115.0,
                                                        child: Image.asset(
                                                            'assets/My-Invoice.png'),
                                                      )
                                                      //   ],
                                                      // ),
                                                      ),
                                                  //tulisan tagihan
                                                  Text(
                                                    "Tagihan",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              // ),
                                              // ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return DaftarHargaPage();
                                                }));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      // width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient: LinearGradient(
                                                            begin: Alignment
                                                                .topCenter,
                                                            end: Alignment
                                                                .bottomCenter,
                                                            colors: [
                                                              Colors.pink[100]!,
                                                              Colors.white
                                                            ]),
                                                      ),
                                                      //logo stok  barang
                                                      child:
                                                          // Stack(
                                                          //   children: [
                                                          SizedBox(
                                                        height: 115.0,
                                                        child: Image.asset(
                                                            'assets/List-Harga.png'),
                                                      )
                                                      //   ],
                                                      // ),
                                                      ),
                                                  //tulisan stok barang
                                                  Text(
                                                    "Daftar",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Harga",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: Column(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    Navigator.push(context,
                                                        MaterialPageRoute(
                                                            builder: (context) {
                                                      return SimulasiPengirimanPage();
                                                    }));
                                                  },
                                                  child: Column(
                                                    children: [
                                                      Container(
                                                          // width: 60,
                                                          height: 60,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                            gradient:
                                                                LinearGradient(
                                                              begin: Alignment
                                                                  .topCenter,
                                                              end: Alignment
                                                                  .bottomCenter,
                                                              colors: [
                                                                Colors.yellow[
                                                                    300]!,
                                                                Colors.white
                                                              ],
                                                            ),
                                                          ),
                                                          //logo tracking barang
                                                          child:
                                                              // Stack(
                                                              //   children: [
                                                              SizedBox(
                                                            height: 115.0,
                                                            child: Image.asset(
                                                                'assets/Simulasi-Pengiriman.png'),
                                                          )
                                                          //   ],
                                                          // ),
                                                          ),
                                                    ],
                                                  ),
                                                ),
                                                //tulisam simulasi
                                                Text(
                                                  "Simulasi",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                                Text(
                                                  "Pengiriman",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          fit: FlexFit.loose,
                                          child: Padding(
                                            padding: const EdgeInsets.all(11.0),
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.push(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                  return Pemesanan();
                                                }));
                                              },
                                              child: Column(
                                                children: [
                                                  Container(
                                                      // width: 60,
                                                      height: 60,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        gradient:
                                                            LinearGradient(
                                                          begin: Alignment
                                                              .topCenter,
                                                          end: Alignment
                                                              .bottomCenter,
                                                          colors: [
                                                            Colors.blue[300]!,
                                                            Colors.white
                                                          ],
                                                        ),
                                                      ),
                                                      //logo tracking barang
                                                      child:
                                                          // Stack(
                                                          //   children: [
                                                          SizedBox(
                                                        height: 115.0,
                                                        child: Image.asset(
                                                            'assets/Pemesanan.png'),
                                                      )
                                                      //   ],
                                                      // ),
                                                      ),
                                                  //tulisan jadwal kapal
                                                  Text(
                                                    "Pemesanan",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Text(
                                                    "",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
