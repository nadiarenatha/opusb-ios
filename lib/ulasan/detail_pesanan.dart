import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/daftar_pesanan_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/daftar-pesanan/daftar_pesanan.dart';
import '../model/niaga/daftar-pesanan/detail_header.dart';
import '../model/niaga/daftar-pesanan/detail_line.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/detail_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:intl/intl.dart';

class DetailPesananNiagaPage extends StatefulWidget {
  final DaftarPesananAccesses detail;
  const DetailPesananNiagaPage({Key? key, required this.detail})
      : super(key: key);

  @override
  State<DetailPesananNiagaPage> createState() => _DetailPesananNiagaPageState();
}

// class _DetailPesananNiagaPageState extends State<DetailPesananNiagaPage> {
class _DetailPesananNiagaPageState extends State<DetailPesananNiagaPage>
    with SingleTickerProviderStateMixin {
  @override
  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  //untuk BottomNavigationBarItem
  bool isSelected = false;
  DataLoginAccesses? dataLogin;

  int? id;
  // DetailLineAccesses? detailLineModel;
  List<DetailLineAccesses> detailLineModel = [];
  List<DetailHeaderAccesses> detailHeaderModel = [];

  //untuk no SJM/nama barang pada pop up dialog search
  TextEditingController _NoOrderController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DaftarPesananCubit>(context)
        .detailLinePesanan(id: widget.detail.id ?? 0);
    BlocProvider.of<DaftarPesananCubit>(context)
        .detailHeaderPesanan(id: widget.detail.id ?? 0);
    print('Id nya: ${widget.detail.id}');
    _fetchAndLoginUser();
  }

  Future<void> _fetchAndLoginUser() async {
    // Assuming you retrieve the userId from secure storage
    final userId = await storage.read(
      key: AuthKey.id.toString(),
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    ); // Adjust this as needed
    print('User ID retrieved from storage: $userId');
    if (userId != null) {
      // Trigger the dataLogin API call with the userId
      BlocProvider.of<DataLoginCubit>(context).dataLogin(id: int.parse(userId));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

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
                  "Daftar Pesanan",
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[900],
                      fontFamily: 'Poppins Extra Bold'),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          //agar tulisan di appbar berada di tengah tinggi bar
          toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
        ),
      ),
      //untuk setting form
      body: BlocConsumer<DataLoginCubit, DataLoginState>(
          listener: (context, state) async {
        if (state is DataLoginSuccess) {
          setState(() {
            dataLogin = state.response;
          });
          print('Ini Data nya yang akan di ambil : $dataLogin');
        }
      }, builder: (context, state) {
        return BlocConsumer<DaftarPesananCubit, DaftarPesananState>(
            listener: (context, state) {
          if (state is DetailLinePesananSuccess) {
            detailLineModel.clear();
            detailLineModel = state.response;
            if (detailLineModel.isNotEmpty) {
              print('Price nya: ${detailLineModel[0].price}');
            } else {
              print('No data available in detailLineModel');
            }
          } else if (state is DetaiHeaderPesananSuccess) {
            detailHeaderModel.clear();
            detailHeaderModel = state.response;
          }
        }, builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 15),
                Container(
                  padding:
                      EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey, // Grey border color
                      width: 2.0, // Border width
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nomor Order',
                        style: TextStyle(fontFamily: 'Poppinss', fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        // 'COSL/SBY/2024.08/001332',
                        widget.detail.orderNumber.toString(),
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Nomor Invoice',
                        style: TextStyle(fontFamily: 'Poppinss', fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      // for (var a in detailLineModel)
                      //   Text(
                      //     (a.invoiceNum == null || a.invoiceNum!.isEmpty)
                      //         ? '-'
                      //         : a.invoiceNum!,
                      //     style: TextStyle(
                      //         fontWeight: FontWeight.w900,
                      //         color: Colors.black,
                      //         fontSize: 13,
                      //         fontFamily: 'Poppins Med'),
                      //   ),
                      ...detailLineModel.map((a) {
                        print('invoiceNum: ${a.invoiceNum}');
                        return Text(
                          (a.invoiceNum == null || a.invoiceNum!.isEmpty)
                              ? '-'
                              : a.invoiceNum!,
                          style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: Colors.black,
                              fontSize: 13,
                              fontFamily: 'Poppins Med'),
                        );
                      }).toList(),
                      // SizedBox(height: 10),
                      if (widget.detail.orderService == 'LCL')
                        Text(
                          'Nomor Resi',
                          style:
                              TextStyle(fontFamily: 'Poppinss', fontSize: 14),
                        ),
                      if (widget.detail.orderService == 'LCL')
                        SizedBox(height: 5),
                      if (widget.detail.orderService == 'LCL')
                        for (var b in detailHeaderModel)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return DetailOrderNiagaPage(detail: [b]);
                              }));
                            },
                            child: Text(
                              (b.resiNumber == null || b.resiNumber!.isEmpty)
                                  ? '-'
                                  : b.resiNumber!,
                              style: TextStyle(
                                  fontWeight: FontWeight.w900,
                                  color: Color.fromARGB(255, 14, 17, 223),
                                  fontSize: 13,
                                  fontFamily: 'Poppins Med',
                                  decoration: TextDecoration.underline),
                            ),
                          ),
                      if (widget.detail.orderService == 'LCL')
                        SizedBox(height: 10),
                      Text(
                        'Status Order',
                        style: TextStyle(fontFamily: 'Poppinss', fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        // widget.detail.statusId == 'SO06'
                        //     ? 'Pembayaran Berhasil'
                        //     : widget.detail.statusId == 'SO08'
                        //         ? 'Cancel'
                        //         : 'Menunggu Konfirmasi Admin',
                        widget.detail.status.toString(),
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 10),
                      for (var a in detailLineModel)
                        Text(
                          a.invoiceNum == null || a.invoiceNum!.isEmpty
                              ? 'Estimasi Harga'
                              : 'Harga Final',
                          style:
                              TextStyle(fontFamily: 'Poppinss', fontSize: 14),
                        ),
                      SizedBox(height: 5),
                      Text(
                        // 'Rp 10.250.000,00',
                        widget.detail.formattedAmount,
                        style: TextStyle(
                            fontWeight: FontWeight.w900,
                            color: Colors.red[900],
                            fontSize: 13,
                            fontFamily: 'Poppins Med'),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Penggunaan Poin',
                        style: TextStyle(fontFamily: 'Poppinss', fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      Text(
                        widget.detail.point == true ? 'Ya' : 'Tidak',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 13,
                            fontFamily: 'Poppins Med'),
                      ),
                      if (widget.detail.orderService == 'FCL')
                        SizedBox(height: 10),
                      if (widget.detail.orderService == 'FCL')
                        Text(
                          'Estimasi Closing',
                          style:
                              TextStyle(fontFamily: 'Poppinss', fontSize: 14),
                        ),
                      if (widget.detail.orderService == 'FCL')
                        SizedBox(height: 5),
                      if (widget.detail.orderService == 'FCL')
                        for (var b in detailHeaderModel)
                          Text(
                            // (b.etd == null || b.etd!.isEmpty)
                            //     ? '-'
                            //     : b.etd.toString(),
                            _formatDate(b.etd),
                            style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                      SizedBox(height: 10),
                      Text(
                        'Catatan Admin',
                        style: TextStyle(fontFamily: 'Poppinss', fontSize: 14),
                      ),
                      SizedBox(height: 5),
                      for (var b in detailHeaderModel)
                        Text(
                          (b.reviseDescription == null ||
                                  b.reviseDescription!.isEmpty)
                              ? '-'
                              : b.reviseDescription!,
                          style: TextStyle(
                              color: Colors.grey,
                              fontSize: 13,
                              fontFamily: 'Poppins Med'),
                        ),
                    ],
                  ),
                ),
                //Data Pemesan
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color (optional)
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Pemesan',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // 'Andika Budiarto',
                              dataLogin?.lastName ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Email',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // 'andikabudi@gmail.com',
                              dataLogin?.email ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Nomor Telepon',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // '0813445678902',
                              dataLogin?.phone ?? '',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Jasa',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // 'FCL (Full Container Load)',
                              widget.detail.orderService.toString(),
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Tipe Pengiriman',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // 'DTD (Door to Door)',
                              widget.detail.shipmentType.toString(),
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Kota Asal',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // 'Jakarta',
                              widget.detail.originalCity.toString(),
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Kota Tujuan',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // 'Surabaya',
                              widget.detail.destinationCity.toString(),
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Kontrak',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                b.contractNo.toString(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                            SizedBox(height: 12),
                            if (widget.detail.orderService == 'FCL')
                              for (var a in detailLineModel)
                                if (a.invoiceNum == null ||
                                    a.invoiceNum!.isEmpty)
                                  Text(
                                    'Harga per Container',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Poppinss'),
                                  ),
                            if (widget.detail.orderService == 'FCL')
                              for (var a in detailLineModel)
                                if (a.invoiceNum == null ||
                                    a.invoiceNum!.isEmpty)
                                  SizedBox(height: 5),
                            if (widget.detail.orderService == 'FCL')
                              for (var a in detailLineModel)
                                if (a.invoiceNum!.isEmpty)
                                  Text(
                                    a.formattedPrice,
                                    style: TextStyle(
                                        color: Colors.red[900],
                                        fontSize: 14,
                                        fontFamily: 'Poppins Bold'),
                                  ),
                            if (widget.detail.orderService == 'FCL')
                              for (var a in detailLineModel)
                                if (a.invoiceNum == null ||
                                    a.invoiceNum!.isEmpty)
                                  SizedBox(height: 12),
                            //LCL
                            if (widget.detail.orderService == 'LCL')
                              for (var a in detailLineModel)
                                if (a.invoiceNum == null ||
                                    a.invoiceNum!.isEmpty)
                                  Text(
                                    'Harga per M3',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontFamily: 'Poppinss'),
                                  ),
                            if (widget.detail.orderService == 'LCL')
                              for (var a in detailLineModel)
                                if (a.invoiceNum == null ||
                                    a.invoiceNum!.isEmpty)
                                  SizedBox(height: 5),
                            if (widget.detail.orderService == 'LCL')
                              for (var a in detailLineModel)
                                if (a.invoiceNum!.isEmpty)
                                  Text(
                                    a.formattedPrice,
                                    style: TextStyle(
                                        color: Colors.red[900],
                                        fontSize: 14,
                                        fontFamily: 'Poppins Bold'),
                                  ),
                            if (widget.detail.orderService == 'LCL')
                              for (var a in detailLineModel)
                                if (a.invoiceNum!.isEmpty) SizedBox(height: 12),
                            Text(
                              'Komoditi',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            // for (var item in detailLineModel)
                            for (var a in detailLineModel)
                              Text(
                                a.komoditi.toString(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                          ],
                        ),
                      ),
                      if (widget.detail.orderService == 'FCL')
                        SizedBox(height: 25),
                      // if (widget.detail.orderService == 'LCL')
                      //   SizedBox(height: 25),
                      //Container
                      if (widget.detail.orderService == 'FCL')
                        Container(
                          padding: EdgeInsets.all(12.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color (optional)
                            border: Border.all(
                              color: Colors.grey, // Grey border color
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ukuran Container',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              for (var a in detailLineModel)
                                Text(
                                  // '20 Feet',
                                  a.containerSize.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                              SizedBox(height: 12),
                              Text(
                                'Jumlah Container',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              for (var a in detailLineModel)
                                Text(
                                  // '1',
                                  a.quantity.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                              SizedBox(height: 12),
                              Text(
                                'Total Berat (Kg)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              for (var a in detailLineModel)
                                Text(
                                  // '1250',
                                  a.userTotalWeight.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                              SizedBox(height: 12),
                              Text(
                                'Deskripsi Produk',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              for (var a in detailLineModel)
                                Text(
                                  // 'Pengiriman cairan 2500L @ 1 container',
                                  a.productDescription.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                              SizedBox(height: 12),
                              Text(
                                'Tanggal Cargo Siap',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              for (var b in detailHeaderModel)
                                Text(
                                  _formatDate(b.cargoReadyDate),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                            ],
                          ),
                        ),
                      if (widget.detail.orderService == 'LCL')
                        SizedBox(height: 25),
                      if (widget.detail.orderService == 'LCL')
                        Container(
                          padding: EdgeInsets.all(12.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white, // Background color (optional)
                            border: Border.all(
                              color: Colors.grey, // Grey border color
                              width: 2.0, // Border width
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tanggal Cargo Siap',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              for (var b in detailHeaderModel)
                                Text(
                                  // b.cargoReadyDate.toString(),
                                  // b.cargoReadyDate != null
                                  //   ? DateFormat('dd-MM-yyyy').format(DateTime.parse(b.cargoReadyDate!))
                                  //   : '-',
                                  _formatDate(b.cargoReadyDate),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                              SizedBox(height: 12),
                              Text(
                                'UOM Packaging',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 10),
                              for (var a in detailLineModel)
                                Text(
                                  a.uom.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                              SizedBox(height: 12),
                              Text(
                                'Jumlah Produk',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              for (var a in detailLineModel)
                                Text(
                                  a.quantity.toString(),
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Bold'),
                                ),
                              SizedBox(height: 12),
                              Text(
                                'Berat Total (Kg)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              ...detailLineModel.map((a) {
                                print(
                                    'niagaTotalWeight: ${a.niagaTotalWeight}');
                                print('userTotalWeight: ${a.userTotalWeight}');
                                if (a.niagaTotalWeight != 0.0) {
                                  return Text(
                                    a.niagaTotalWeight.toString(),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med',
                                    ),
                                  );
                                } else if (a.userTotalWeight != 0.0) {
                                  return Text(
                                    a.userTotalWeight.toString(),
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med',
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }).toList(),
                              SizedBox(height: 12),
                              Text(
                                'Dimensi P x L x T (cm)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              ...detailLineModel.map((a) {
                                print('userPanjang: ${a.userPanjang}');
                                print('userLebar: ${a.userLebar}');
                                print('userTinggi: ${a.userTinggi}');
                                print('niagaPanjang: ${a.niagaPanjang}');
                                print('niagaLebar: ${a.niagaLebar}');
                                print('niagaTinggi: ${a.niagaTinggi}');
                                if (a.niagaPanjang != 0.0) {
                                  return Text(
                                    '${a.niagaPanjang} x ${a.niagaLebar} x ${a.niagaTinggi}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med',
                                    ),
                                  );
                                } else if (a.userPanjang != 0.0) {
                                  return Text(
                                    '${a.userPanjang} x ${a.userLebar} x ${a.userTinggi}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med',
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }).toList(),
                              SizedBox(height: 12),
                              Text(
                                'Total Volume (M3)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                              SizedBox(height: 5),
                              ...detailLineModel.map((a) {
                                print(
                                    'niagaTotalVolume: ${a.niagaTotalVolume}');
                                print('userTotalVolume: ${a.userTotalVolume}');
                                if (a.niagaTotalVolume != 0.0) {
                                  return Text(
                                    a.niagaTotalVolume.toString(),
                                    style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Bold',
                                    ),
                                  );
                                } else if (a.userTotalVolume != 0.0) {
                                  return Text(
                                    a.userTotalVolume.toString(),
                                    style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Bold',
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }).toList(),
                            ],
                          ),
                        ),
                      if (widget.detail.orderService == 'FCL')
                        SizedBox(height: 25),
                      if (widget.detail.orderService == 'LCL')
                        SizedBox(height: 25),
                      //Muat
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color (optional)
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Alamat',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                'Alamat Muat ${b.originalCity}',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                            SizedBox(height: 12),
                            Text(
                              'Tipe Alamat',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Muat',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            if (widget.detail.orderService == 'FCL')
                              Text(
                                'PIC Muat Barang',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                            if (widget.detail.orderService == 'FCL')
                              SizedBox(height: 5),
                            if (widget.detail.orderService == 'FCL')
                              for (var b in detailHeaderModel)
                                Text(
                                  b.originalPicName.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                            if (widget.detail.orderService == 'FCL')
                              SizedBox(height: 12),
                            if (widget.detail.orderService == 'FCL')
                              Text(
                                'No Telp PIC Muat Barang',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: 'Poppinss'),
                              ),
                            if (widget.detail.orderService == 'FCL')
                              SizedBox(height: 5),
                            if (widget.detail.orderService == 'FCL')
                              for (var b in detailHeaderModel)
                                Text(
                                  b.originalPicNumber.toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                      fontFamily: 'Poppins Med'),
                                ),
                            if (widget.detail.orderService == 'FCL')
                              SizedBox(height: 12),
                            Text(
                              'Kota',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                b.portAsal.toString(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                            SizedBox(height: 12),
                            Text(
                              'Alamat Muat Barang',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                b.originalAddress.toString(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      //Bongkar
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color (optional)
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Nama Alamat',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                'Alamat Bongkar ${b.destinationCity}',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                            SizedBox(height: 12),
                            Text(
                              'Tipe Alamat',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Bongkar',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'PIC Bongkar Barang',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                b.destinationPicName.toString(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                            SizedBox(height: 12),
                            Text(
                              'No Telp PIC Bongkar Barang',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                b.destinationPicNumber.toString(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                            SizedBox(height: 12),
                            Text(
                              'Kota',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                b.portTujuan.toString(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                            SizedBox(height: 12),
                            Text(
                              'Alamat Bongkar Barang',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            for (var b in detailHeaderModel)
                              Text(
                                b.destinationAddress.toString(),
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                    fontFamily: 'Poppins Med'),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 300,
                  height: 40,
                  child: Material(
                    borderRadius: BorderRadius.circular(7.0),
                    color: Colors.white,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size(200, 50),
                        side: BorderSide(color: Colors.red[900]!, width: 2),
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
                            fontFamily: 'Poppins Med'),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15)
              ],
            ),
          );
        });
      }),
    );
  }

  String _formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) {
      return '-';
    }
    try {
      return DateFormat('dd MMMM yyyy').format(DateTime.parse(dateStr));
    } catch (e) {
      print('Error parsing date: $e');
      return '-';
    }
  }
}
