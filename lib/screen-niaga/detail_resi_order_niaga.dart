import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/profile/pencarian_barang.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/pencarian_barang_cubit.dart';
import '../model/niaga/cari-barang-profil/detail_cari_barang.dart';
import '../model/niaga/cari-barang-profil/detail_data_barang.dart';
import '../model/niaga/daftar-pesanan/daftar_pesanan.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import '../tracking/tracking_pencarian.dart';
import '../ulasan/detail_pesanan.dart';

class DetailResiOrderNiagaPage extends StatefulWidget {
  final DetailDataBarangAccesses stok;
  final String? asnNo;
  const DetailResiOrderNiagaPage({
    Key? key,
    required this.stok,
    this.asnNo,
  }) : super(key: key);

  @override
  State<DetailResiOrderNiagaPage> createState() =>
      _DetailResiOrderNiagaPageState();
}

class _DetailResiOrderNiagaPageState extends State<DetailResiOrderNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  TextEditingController emailPerusahaanController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  TextEditingController faxController = TextEditingController();
  TextEditingController npwpController = TextEditingController();

  List<DetailJenisBarangAccesses> detailCariBarangModellist = [];

  List<DaftarPesananAccesses> daftarPesanan = [];

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  @override
  void initState() {
    super.initState();
    final String noResi = widget.stok.noResi ?? '';
    BlocProvider.of<PencarianBarangCubit>(context)
        .detailPencarianBarang(noResi: noResi);
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage(initialIndex: 0)),
    );
    return false; // Prevent default back navigation
  }

  Widget build(BuildContext context) {
    var stok = widget.stok;
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
                    "Detail Barang",
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
        body: BlocConsumer<PencarianBarangCubit, PencarianBarangState>(
          listener: (context, state) {
            if (state is DetailPencarianBarangSuccess) {
              print('Tes');
              detailCariBarangModellist.clear();
              detailCariBarangModellist = state.response;
              print('ini detailnya : $detailCariBarangModellist');
            }
            // if (detailCariBarangModellist.isEmpty) {}
          },
          builder: (context, state) {
            if (state is DetailPencarianBarangInProgress) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.amber[600],
                ),
              );
            }
            return Container(
              color: Colors.grey[200],
              height: screenSize.height,
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors
                        .white, // White background color for the container
                    borderRadius:
                        BorderRadius.circular(15), // Circular border radius
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            widget.stok.noResi.toString(),
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins Bold',
                                color: Colors.red[900]),
                          ),
                        ),
                        SizedBox(height: 20),
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
                                    'Penerima',
                                    style: TextStyle(
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
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
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    widget.stok.penerima.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    'Total Volume',
                                    style: TextStyle(
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
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
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    widget.stok.volume.toString(),
                                    style: TextStyle(
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ]),
                            TableRow(children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    'Tanggal Masuk',
                                    style: TextStyle(
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
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
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    widget.stok.sendAsnDate!,
                                    style: TextStyle(
                                        fontFamily: 'Poppins Med',
                                        fontSize: 12),
                                  ),
                                ),
                              ),
                            ]),
                            //COBA
                            // TableRow(children: [
                            //   TableCell(
                            //     child: Padding(
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 8.0, horizontal: 2.0),
                            //       child: Text(
                            //         'No Packing List',
                            //         style: TextStyle(
                            //             fontFamily: 'Poppins Med', fontSize: 12),
                            //       ),
                            //     ),
                            //   ),
                            //   TableCell(
                            //     child: Padding(
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 8.0, horizontal: 2.0),
                            //       child: Text(
                            //         ':',
                            //         style: TextStyle(
                            //             fontFamily: 'Poppins Med', fontSize: 12),
                            //       ),
                            //     ),
                            //   ),
                            //   TableCell(
                            //     child: Padding(
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 8.0, horizontal: 2.0),
                            //       child: InkWell(
                            //         onTap: () {
                            //           Navigator.push(context,
                            //               MaterialPageRoute(builder: (context) {
                            //             return TrackingPencarianNiaga(
                            //                 noPL:
                            //                     'PL%2FSBY%2F51AR-BA%2F2024.02%2F184082');
                            //           }));
                            //         },
                            //         child: Text(
                            //           'PL%2FSBY%2FTJ-SARI%2F2024.02%2F185444',
                            //           style: TextStyle(
                            //               fontFamily: 'Poppins Med',
                            //               fontSize: 12),
                            //         ),
                            //       ),
                            //     ),
                            //   ),
                            // ]),
                          ],
                        ),
                        SizedBox(height: 30),
                        if (detailCariBarangModellist.isNotEmpty)
                          Table(
                            columnWidths: {
                              0: FlexColumnWidth(7),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(6),
                            },
                            children: [
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Nama Barang',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Volume/m3',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'Qty',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      'No PL',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w900),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ]),
                              for (var detail in detailCariBarangModellist)
                                TableRow(children: [
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                        // 'IKEA Round Table Black Steel HSR 09',
                                        detail.deskripsi ?? 'N/A',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13),
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                        // '0',
                                        // detail.actVolume ?? '0',
                                        // detail.actVolume != null &&
                                        //         detail.actVolume!.isNotEmpty
                                        //     ? (double.parse(detail.actVolume!) *
                                        //             100)
                                        //         .toStringAsFixed(5)
                                        //     : '0.00000',
                                        // detail.formatActVolume(detail.actVolume),
                                        detail.actVolume.toString(),
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: Text(
                                        // '1',
                                        detail.qty.toString(),
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                  TableCell(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 2.0),
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return TrackingPencarianNiaga(
                                                noPL: detail.noPl ?? '0');
                                          }));
                                        },
                                        child: Text(
                                          // '1',
                                          detail.noPl ?? '0',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 27, 43, 182),
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ]),
                              // ...List.generate(detailCariBarangModellist.length,
                              //     (index) {
                              //   final detailItem =
                              //       detailCariBarangModellist[index];
                              //   return TableRow(children: [
                              //     TableCell(
                              //       child: Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 8.0, horizontal: 2.0),
                              //         child: Text(
                              //           detailItem.deskripsi?.toString() ?? 'N/A',
                              //           style: TextStyle(color: Colors.grey[600]),
                              //         ),
                              //       ),
                              //     ),
                              //     TableCell(
                              //       child: Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 8.0, horizontal: 2.0),
                              //         child: Text(
                              //           detailItem.actVolume?.toString() ?? '0',
                              //           style: TextStyle(color: Colors.grey[600]),
                              //           textAlign: TextAlign.center,
                              //         ),
                              //       ),
                              //     ),
                              //     TableCell(
                              //       child: Padding(
                              //         padding: EdgeInsets.symmetric(
                              //             vertical: 8.0, horizontal: 2.0),
                              //         child: Text(
                              //           detailItem.qty?.toString() ?? '0',
                              //           style: TextStyle(color: Colors.grey[600]),
                              //           textAlign: TextAlign.center,
                              //         ),
                              //       ),
                              //     ),
                              //   ]);
                              // }),
                            ],
                          ),
                        if (detailCariBarangModellist.isEmpty)
                          Center(
                            child: Text(
                              'Barang sedang dalam proses input oleh admin kami',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppinss',
                              ),
                            ),
                          ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
