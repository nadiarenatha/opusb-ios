import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/niaga/invoice_niaga_cubit.dart';
import '../model/niaga/detail-invoice/detail_invoice_fcl.dart';
import '../model/niaga/detail-invoice/detail_invoice_lcl.dart';
import '../model/niaga/open_invoice_detail_niaga.dart';
import '../screen/dahboard.dart';
import '../screen/home.dart';
import '../screen/profile.dart';
import '../tracking/tracking.dart';
import 'invoice_home_niaga.dart';

class DetailInvoiceHomeNiagaPage extends StatefulWidget {
  final InvoiceItemAccesses invoice;
  const DetailInvoiceHomeNiagaPage({Key? key, required this.invoice})
      : super(key: key);

  @override
  State<DetailInvoiceHomeNiagaPage> createState() =>
      _DetailInvoiceHomeNiagaPageState();
}

class _DetailInvoiceHomeNiagaPageState
    extends State<DetailInvoiceHomeNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  DetailInvoiceLCLAccesses? detailLCL;
  DetailInvoiceFCLAccesses? detailFCL;

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MyInvoiceHomeNiagaPage(),
    DashboardPage(),
    HomePage(),
    TrackingPage(),
    ProfilePage(),
  ];

  //untuk BottomNavigationBarItem
  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  @override
  void initState() {
    super.initState();
    // BlocProvider.of<InvoiceNiagaCubit>(context)
    //     .detailInvoiceLCL(widget.invoice.invoiceNumber ?? '');
    // BlocProvider.of<InvoiceNiagaCubit>(context)
    //     .detailInvoiceFCL(widget.invoice.invoiceNumber ?? '');
    if (widget.invoice.volume == 'LCL') {
      BlocProvider.of<InvoiceNiagaCubit>(context)
          .detailInvoiceLCL(widget.invoice.invoiceNumber ?? '');
    } else if (widget.invoice.volume == 'FCL') {
      BlocProvider.of<InvoiceNiagaCubit>(context)
          .detailInvoiceFCL(widget.invoice.invoiceNumber ?? '');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    // Use the invoice object to display the details
    var invoice = widget.invoice;
    final Size screenSize = MediaQuery.of(context).size;

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
                  "Detail Tagihan",
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
      body: BlocConsumer<InvoiceNiagaCubit, InvoiceNiagaState>(
          listener: (context, state) async {
        if (state is DetailInvoiceLCLSuccess) {
          detailLCL = state.response;
          print('Penggunaan Point: ${widget.invoice.penggunaanPoint} ');
        }
        if (state is DetailInvoiceFCLSuccess) {
          detailFCL = state.response;
          print('Penggunaan Point: ${widget.invoice.penggunaanPoint} ');
        }
      }, builder: (context, state) {
        if (widget.invoice.volume == 'LCL' &&
            (state is DetailInvoiceLCLInProgress || detailLCL == null)) {
          return Center(child: CircularProgressIndicator());
        } else if (widget.invoice.volume == 'FCL' &&
            (state is DetailInvoiceFCLInProgress || detailFCL == null)) {
          return Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.grey, width: 2.0), // Grey border
                    // boxShadow: [
                    //   BoxShadow(
                    //     color: Colors.grey.withOpacity(0.5), // Grey shadow
                    //     spreadRadius: 2,
                    //     blurRadius: 5,
                    //     offset: Offset(0, 3), // Shadow position
                    //   ),
                    // ],
                    borderRadius:
                        BorderRadius.circular(7.0), // Rounded corners if needed
                  ),
                  padding:
                      EdgeInsets.all(15.0), // Add padding to the text inside
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          // 'INV/01.NL-SBY.2023.JUL/010995',
                          widget.invoice.invoiceNumber!,
                          style:
                              TextStyle(fontSize: 16, fontFamily: 'Poppinss'),
                        ),
                        SizedBox(height: 15),
                        Table(
                          columnWidths: {
                            0: FlexColumnWidth(5),
                            1: FlexColumnWidth(8),
                          },
                          children: [
                            TableRow(children: [
                              //tipe pengiriman
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    'Tipe Pengiriman',
                                    style: TextStyle(
                                        fontFamily: 'Poppins Regular',
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  // child: Text('LCL DTD'),
                                  child: Text(
                                    widget.invoice.typePengiriman!,
                                    style: TextStyle(
                                        fontFamily: 'Poppins Regular',
                                        fontSize: 13),
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
                                    'Volume',
                                    style: TextStyle(
                                        fontFamily: 'Poppins Regular',
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    // 'LCL 2X20FT',
                                    widget.invoice.volume!,
                                    style: TextStyle(
                                        fontFamily: 'Poppins Regular',
                                        fontSize: 13),
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
                                    'Rute Pengiriman',
                                    style: TextStyle(
                                        fontFamily: 'Poppins Regular',
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    // 'Jakarta - Makassar',
                                    widget.invoice.rute!,
                                    style: TextStyle(
                                        fontFamily: 'Poppins Regular',
                                        fontSize: 13),
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
                                    'No Packing List',
                                    style: TextStyle(
                                        fontFamily: 'Poppins Regular',
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.0, horizontal: 2.0),
                                  child: Text(
                                    // '01/32/AP/20394',
                                    widget.invoice.noPL!,
                                    style: TextStyle(
                                        fontFamily: 'Poppins Regular',
                                        fontSize: 13),
                                  ),
                                ),
                              ),
                            ]),
                            // TableRow(children: [
                            //   TableCell(
                            //     child: Padding(
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 8.0, horizontal: 2.0),
                            //       child: Text(
                            //         'Tgl. Pelunasan',
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.normal),
                            //       ),
                            //     ),
                            //   ),
                            //   TableCell(
                            //     child: Padding(
                            //       padding: EdgeInsets.symmetric(
                            //           vertical: 8.0, horizontal: 2.0),
                            //       child: Text(
                            //         // '5 September 2024',
                            //         widget.invoice.typePengiriman!,
                            //         style: TextStyle(
                            //             fontWeight: FontWeight.normal),
                            //       ),
                            //     ),
                            //   ),
                            // ]),
                          ],
                        ),
                        SizedBox(height: 20),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Harga Kontrak'),
                        //     // Text('Rp.5.000.000')
                        //     Text('Rp ' + detailLCL.hargaKontrak.toString())
                        //   ],
                        // ),
                        // SizedBox(height: 15),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Biaya Karantina'),
                        //     // Text('Rp.5.000.000')
                        //     Text('Rp ' + detailLCL.biayaKarantina.toString())
                        //   ],
                        // ),
                        // SizedBox(height: 15),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Biaya Dokumen'),
                        //     // Text('Rp.5.000.000')
                        //     Text('Rp ' + detailLCL.biayaDokumen.toString())
                        //   ],
                        // ),
                        // SizedBox(height: 15),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     Text('Biaya Asuransi'),
                        //     // Text('Rp.5.000.000')
                        //     Text('Rp ' + detailLCL.biayaAsuransi.toString())
                        //   ],
                        // ),
                        //NEW
                        // if (detailLCL.hargaKontrak != 0) ...[
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('Harga Kontrak'),
                        //       Text('Rp ' + detailLCL.hargaKontrak.toString())
                        //     ],
                        //   ),
                        //   // Only add space if there are other fees to show
                        //   if (detailLCL.biayaKarantina != 0 ||
                        //       detailLCL.biayaDokumen != 0 ||
                        //       detailLCL.biayaAsuransi != 0)
                        //     SizedBox(height: 15),
                        // ],

                        // // Biaya Karantina (Only display if biayaKarantina is not 0)
                        // if (detailLCL.biayaKarantina != 0) ...[
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('Biaya Karantina'),
                        //       Text(
                        //           'Rp ' + detailLCL.biayaKarantina.toString())
                        //     ],
                        //   ),
                        //   if (detailLCL.hargaKontrak != 0 ||
                        //       detailLCL.biayaDokumen != 0 ||
                        //       detailLCL.biayaAsuransi != 0)
                        //     SizedBox(height: 15),
                        // ],

                        // // Biaya Dokumen (Only display if biayaDokumen is not 0)
                        // if (detailLCL.biayaDokumen != 0) ...[
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('Biaya Dokumen'),
                        //       Text('Rp ' + detailLCL.biayaDokumen.toString())
                        //     ],
                        //   ),
                        //   if (detailLCL.hargaKontrak != 0 ||
                        //       detailLCL.biayaKarantina != 0 ||
                        //       detailLCL.biayaAsuransi != 0)
                        //     SizedBox(height: 15),
                        // ],

                        // // Biaya Asuransi (Only display if biayaAsuransi is not 0)
                        // if (detailLCL.biayaAsuransi != 0) ...[
                        //   Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Text('Biaya Asuransi'),
                        //       Text('Rp ' + detailLCL.biayaAsuransi.toString())
                        //     ],
                        //   ),
                        //   if (detailLCL.hargaKontrak != 0 ||
                        //       detailLCL.biayaDokumen != 0 ||
                        //       detailLCL.biayaKarantina != 0)
                        //     SizedBox(height: 15),
                        // ],
                        //===
                        if (widget.invoice.volume == 'LCL') ...[
                          // if (detailLCL!.hargaKontrak != null &&
                          //     detailLCL!.hargaKontrak != 0)
                          //   // buildRow('Harga Kontrak',
                          //   //     detailLCL!.hargaKontrak ?? 0),
                          //   buildRow('Harga Kontrak',
                          //       detailLCL!.formattedHargaKontrak),
                          if (detailLCL!.biayaKarantina != null &&
                              detailLCL!.biayaKarantina != 0)
                            // buildRow('Biaya Karantina',
                            //     detailLCL!.biayaKarantina ?? 0),
                            buildRow('Biaya Karantina',
                                detailLCL!.formattedBiayaKarantina),
                          if (detailLCL!.biayaDokumen != null &&
                              detailLCL!.biayaDokumen != 0)
                            // buildRow('Biaya Dokumen',
                            //     detailLCL!.biayaDokumen ?? 0),
                            buildRow('Biaya Dokumen',
                                detailLCL!.formattedBiayaDokumen),
                          if (detailLCL!.biayaAsuransi != null &&
                              detailLCL!.biayaAsuransi != 0)
                            // buildRow('Biaya Asuransi',
                            //     (detailLCL!.biayaAsuransi ?? 0).toInt()),
                            buildRow('Biaya Asuransi',
                                detailLCL!.formattedBiayaAsuransi),
                        ] else if (widget.invoice.volume == 'FCL') ...[
                          // if (detailFCL!.hargaKontrak != null &&
                          //     detailFCL!.hargaKontrak != 0)
                          //   // buildRow('Harga Kontrak',
                          //   //     detailFCL!.hargaKontrak ?? 0),
                          //   buildRow('Harga Kontrak',
                          //       detailFCL!.formattedHargaKontrak),
                          if (detailFCL!.biayaKarantina != null &&
                              detailFCL!.biayaKarantina != 0)
                            // buildRow('Biaya Karantina',
                            //     detailFCL!.biayaKarantina ?? 0),
                            buildRow('Biaya Karantina',
                                detailFCL!.formattedBiayaKarantina),
                          if (detailFCL!.biayaDokumen != null &&
                              detailFCL!.biayaDokumen != 0)
                            // buildRow('Biaya Dokumen',
                            //     detailFCL!.biayaDokumen ?? 0),
                            buildRow('Biaya Dokumen',
                                detailFCL!.formattedBiayaDokumen),
                          if (detailFCL!.biayaAsuransi != null &&
                              detailFCL!.biayaAsuransi != 0)
                            // buildRow('Biaya Asuransi',
                            //     (detailFCL!.biayaAsuransi ?? 0).toInt()),
                            buildRow('Biaya Asuransi',
                                detailFCL!.formattedBiayaAsuransi),
                        ],
                        // SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Harga Pengiriman',
                              style: TextStyle(
                                  fontFamily: 'Poppins Regular', fontSize: 13),
                            ),
                            if (widget.invoice.volume == 'LCL') ...[
                              Text(
                                '${detailLCL!.formattedHargaPengiriman}',
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    fontSize: 13),
                              )
                            ] else if (widget.invoice.volume == 'FCL') ...[
                              Text(
                                '${detailFCL!.formattedHargaPengiriman}',
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    fontSize: 13),
                              )
                            ]
                          ],
                        ),
                        SizedBox(height: 15),
                        if (widget.invoice.penggunaanPoint != 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Penggunaan Poin',
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    fontSize: 13),
                              ),
                              Text(
                                '${widget.invoice.penggunaanPoint}',
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    fontSize: 13),
                              )
                            ],
                          ),
                        if (widget.invoice.penggunaanPoint != 0)
                          SizedBox(height: 40),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              // '+ PPN 1.1%',
                              '+PPN ${widget.invoice.taxCode}',
                              style: TextStyle(
                                  fontFamily: 'Poppins Regular', fontSize: 13),
                            ),
                            // Text('Rp.55.000')
                            Text(
                              // 'Rp ' + widget.invoice.ppn.toString()
                              '${widget.invoice.formattedPPN}',
                              style: TextStyle(
                                  fontFamily: 'Poppins Regular', fontSize: 13),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sub Total',
                              style: TextStyle(
                                  fontFamily: 'Poppins Regular', fontSize: 13),
                            ),
                            Text(
                              '${widget.invoice.formattedSetelahPPN}',
                              style: TextStyle(
                                  fontFamily: 'Poppins Regular', fontSize: 13),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        if (widget.invoice.pph != 0)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '- PPH 2%',
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    fontSize: 13),
                              ),
                              Text(
                                '${widget.invoice.formattedPPH}',
                                style: TextStyle(
                                    fontFamily: 'Poppins Regular',
                                    fontSize: 13),
                              )
                            ],
                          ),
                        if (widget.invoice.pph != 0) SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand Total',
                              style: TextStyle(
                                  color: Colors.red[900],
                                  fontFamily: 'Poppins Bold',
                                  fontSize: 13),
                            ),
                            Text(
                              // 'Rp.5.055.000',
                              // 'Rp ' + widget.invoice.totalInvoice.toString(),
                              '${widget.invoice.formattedTotalInvoice}',
                              style: TextStyle(
                                  color: Colors.red[900],
                                  fontFamily: 'Poppins Bold',
                                  fontSize: 13),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tagihan Terbayar',
                              style: TextStyle(
                                  fontFamily: 'Poppins Bold', fontSize: 13),
                            ),
                            Text(
                              // 'Rp ' +
                              //     widget.invoice.tagihanTerbayar.toString(),
                              '${widget.invoice.formattedTagihanTerbayar}',
                              style: TextStyle(
                                  fontFamily: 'Poppins Bold', fontSize: 13),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Sisa Pembayaran',
                              style: TextStyle(
                                  fontFamily: 'Poppins Bold', fontSize: 13),
                            ),
                            Text(
                              // 'Rp ' +
                              //     widget.invoice.sisaPembayaran.toString(),
                              '${widget.invoice.formattedSisaPembayaran}',
                              style: TextStyle(
                                  fontFamily: 'Poppins Bold', fontSize: 13),
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                      ]),
                ),
                SizedBox(height: 40),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 170,
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Colors.red[900],
                          //membuat bayangan pada button Detail
                          // shadowColor: Colors.grey[350],
                          // elevation: 5,
                          child: MaterialButton(
                            onPressed: () {
                              final invoiceNumber =
                                  widget.invoice.invoiceNumber;
                              final volume = widget.invoice.volume;

                              // if (invoiceNumber != null) {
                              if (invoiceNumber != null && volume != null) {
                                BlocProvider.of<InvoiceNiagaCubit>(context)
                                    .downloadinvoice(invoiceNumber, volume);
                              } else {
                                // Handle the case where invoiceNumber is null (e.g., show an error message)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text('Invoice number is missing')),
                                );
                              }
                            },
                            child: Text(
                              'Download Invoice',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontFamily: 'Poppinss'),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        width: 170,
                        child: Material(
                          borderRadius: BorderRadius.circular(7.0),
                          color: Colors.white,
                          // shadowColor: Colors.grey[350],
                          // elevation: 5,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(200, 50),
                              side:
                                  BorderSide(color: Colors.red[900]!, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              'Kembali',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.red[900],
                                  fontFamily: 'Poppinss'),
                            ),
                          ),
                        ),
                      ),
                    ],
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
      //     items: <BottomNavigationBarItem>[
      //       const BottomNavigationBarItem(
      //         icon: Icon(Icons.dashboard),
      //         label: 'Order',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: SizedBox(
      //           width: 20,
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
      //               color: Colors.white,
      //             ),
      //           ],
      //         ),
      //         label: '',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: SizedBox(
      //           width: 12,
      //           child: ImageIcon(
      //             AssetImage('assets/invoice icon.png'),
      //           ),
      //         ),
      //         label: 'Invoice',
      //       ),
      //       const BottomNavigationBarItem(
      //         icon: Icon(Icons.person),
      //         label: 'Profil',
      //       ),
      //     ],
      //     currentIndex: _selectedIndex,
      //     selectedItemColor: Colors.grey[600],
      //     onTap: _onItemTapped,
      //   ),
      // )
    );
  }

  Widget buildRow(String label, String amount) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            // Text('Rp ' + amount.toString()),
            Text(amount),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
