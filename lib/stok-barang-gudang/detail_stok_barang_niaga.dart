import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import 'package:niaga_apps_mobile/stok-barang-gudang/stok_barang_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/warehouse_niaga_cubit.dart';
import '../model/niaga/detail-warehouse/data_barang_gudang.dart';
import '../model/niaga/warehouse_detail_niaga.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';

class DetailStokBarangNiagaPage extends StatefulWidget {
  final WarehouseItemAccesses stok;
  const DetailStokBarangNiagaPage({Key? key, required this.stok})
      : super(key: key);

  @override
  State<DetailStokBarangNiagaPage> createState() =>
      _DetailStokBarangNiagaPageState();
}

class _DetailStokBarangNiagaPageState extends State<DetailStokBarangNiagaPage> {
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
  int currentPageIndex = 0;
  int itemsPerPage = 5; // Number of items per page
  int _totalPages = 0; // Store total pages from API
  int _currentPage = 1; // Track the current page
  int totalPages = 0; // Declare totalPages as a class-level variable
  int pageIndex = 0;
  int visiblePages = 5;
  String? asnNO;

  // List<BarangGudangAccesses> detailwarehouseModel = [];
  List<BarangGudangDataAccesses> detailwarehouseModel = [];
  // BarangGudangDataAccesses? detailwarehouseModel;

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
    BlocProvider.of<WarehouseNiagaCubit>(context)
        .detailwarehouseNiaga(asnNo: widget.stok.asnNo);
    print('ASN NO nya: ${widget.stok.asnNo}');
  }

  @override
  void dispose() {
    super.dispose();
  }

  // int getStartPageIndex() {
  //   return ((currentPageIndex ~/ visiblePages) * visiblePages).toInt();
  // }

  // int getEndPageIndex() {
  //   int endPage = (getStartPageIndex() + visiblePages).toInt();
  //   return endPage > _totalPages ? _totalPages : endPage;
  // }

  // void _fetchDataForPage(int pageNumber) {
  //   // Assuming you are using a Bloc to fetch warehouse data
  //   BlocProvider.of<WarehouseNiagaCubit>(context)
  //       .detailwarehouseNiaga();
  //   // BlocProvider.of<WarehouseNiagaCubit>(context)
  //   //     .detailwarehouseNiaga(pageIndex: pageNumber);
  // }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StokBarangNiagaPage()),
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
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) {
                  return StokBarangNiagaPage();
                }));
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
        body: BlocConsumer<WarehouseNiagaCubit, WarehouseNiagaState>(
            listener: (context, state) {
          if (state is WarehouseDetailNiagaSuccess) {
            detailwarehouseModel.clear();
            detailwarehouseModel = state.response;
            // detailwarehouseModel = state.response.data.isNotEmpty ? state.response.data.first : null;

            print("Detail Warehouse Model List: $detailwarehouseModel");
            print(detailwarehouseModel.length);
          }
        }, builder: (context, state) {
          if (state is WarehouseDetailNiagaInProgress) {
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
                  color:
                      Colors.white, // White background color for the container
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
                      // SizedBox(height: 10),
                      Center(
                        child: Text(
                          widget.stok.customerDistribusi!,
                          style: TextStyle(
                              fontSize: 18,
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
                                  'Total Volume',
                                  style: TextStyle(
                                      fontFamily: 'Poppins Med', fontSize: 12),
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
                                      fontFamily: 'Poppins Med', fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child: Text(
                                  widget.stok.totalVolume.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Poppins Med', fontSize: 12),
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
                                      fontFamily: 'Poppins Med', fontSize: 12),
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
                                      fontFamily: 'Poppins Med', fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child: Text(
                                  widget.stok.tanggalMasuk!,
                                  style: TextStyle(
                                      fontFamily: 'Poppins Med', fontSize: 12),
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
                                  'Kota Tujuan',
                                  style: TextStyle(
                                      fontFamily: 'Poppins Med', fontSize: 12),
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
                                      fontFamily: 'Poppins Med', fontSize: 12),
                                ),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 2.0),
                                child: Text(
                                  widget.stok.tujuan!,
                                  style: TextStyle(
                                      fontFamily: 'Poppins Med', fontSize: 12),
                                ),
                              ),
                            ),
                          ]),
                        ],
                      ),
                      SizedBox(height: 20),
                      if (detailwarehouseModel.isNotEmpty)
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(7),
                            1: FlexColumnWidth(3),
                            2: FlexColumnWidth(2),
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
                                        fontFamily: 'Poppins Bold',
                                        fontSize: 12),
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
                                        fontFamily: 'Poppins Bold',
                                        fontSize: 12),
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
                                        fontFamily: 'Poppins Bold',
                                        fontSize: 12),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ]),
                            for (var warehouseAccess in detailwarehouseModel)
                              // for (var data in warehouseAccess.data)
                              TableRow(children: [
                                TableCell(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 2.0),
                                    child: Text(
                                      // 'IKEA Round Table Black Steel HSR 09',
                                      warehouseAccess.deskripsi ?? 'N/A',
                                      style: TextStyle(
                                          color: Colors.grey[600],
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
                                      // '0.028',
                                      // warehouseAccess.volume?.toString() ?? 'N/A',
                                      warehouseAccess.volume.toString(),
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
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
                                      // warehouseAccess.qtyOnHand?.toString() ??
                                      //     'N/A',
                                      warehouseAccess.qtyOnHand.toString(),
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontFamily: 'Poppins Med',
                                          fontSize: 12),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ]),
                            //NEW
                            // for (var accesses in detailwarehouseModel)
                            //   for (var item in accesses.data)
                            //     TableRow(children: [
                            //       TableCell(
                            //         child: Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               vertical: 8.0, horizontal: 2.0),
                            //           child: Text(
                            //             item.deskripsi ?? '-',
                            //             style: TextStyle(color: Colors.grey[600]),
                            //           ),
                            //         ),
                            //       ),
                            //       TableCell(
                            //         child: Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               vertical: 8.0, horizontal: 2.0),
                            //           child: Text(
                            //             item.volume?.toString() ?? '-',
                            //             style: TextStyle(color: Colors.grey[600]),
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ),
                            //       ),
                            //       TableCell(
                            //         child: Padding(
                            //           padding: EdgeInsets.symmetric(
                            //               vertical: 8.0, horizontal: 2.0),
                            //           child: Text(
                            //             item.qtyOnHand?.toString() ?? '-',
                            //             style: TextStyle(color: Colors.grey[600]),
                            //             textAlign: TextAlign.center,
                            //           ),
                            //         ),
                            //       ),
                            //     ]),
                          ],
                        ),
                      // _buildDataRows(),
                      if (detailwarehouseModel.isEmpty)
                        Center(
                          child: Text(
                            'Barang sedang dalam proses input oleh admin kami',
                            style: TextStyle(fontWeight: FontWeight.w900),
                          ),
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
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
