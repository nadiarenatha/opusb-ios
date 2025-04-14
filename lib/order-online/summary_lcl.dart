import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/contract_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/cek-harga/cek_harga_lcl.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'konfirmasi_lcl.dart';
import 'package:intl/intl.dart';

class SummaryLCL extends StatefulWidget {
  final String kontrak;
  final String komoditi;
  final String uom;
  final int jumlahProduk;
  final double beratTotal;
  final String deskripsiProduk;
  final double panjang;
  final double lebar;
  final double tinggi;
  final double volume;
  final String portAsal;
  final String portTujuan;
  final String kotaAsal;
  final String kotaTujuan;
  final String tanggalCargo;
  final String namaAlamatMuat;
  final String detailAlamatMuat;
  final String namaAlamatBongkar;
  final String detailAlamatBongkar;
  final String picBongkar;
  final String telpPicBongkar;
  final int harga;
  final double cbm;
  final String namaKontrak;
  final String locIDPortAsal;
  final String locIDPortTujuan;
  final String locIDUOCAsal;
  final String locIDUOCTujuan;
  final int estimasiNilaiProduk;
  // const SummaryLCL({super.key});
  const SummaryLCL({
    Key? key,
    required this.kontrak,
    required this.komoditi,
    required this.uom,
    required this.jumlahProduk,
    required this.beratTotal,
    required this.deskripsiProduk,
    required this.panjang,
    required this.lebar,
    required this.tinggi,
    required this.volume,
    required this.portAsal,
    required this.portTujuan,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalCargo,
    required this.namaAlamatMuat,
    required this.detailAlamatMuat,
    required this.namaAlamatBongkar,
    required this.detailAlamatBongkar,
    required this.picBongkar,
    required this.telpPicBongkar,
    required this.harga,
    required this.cbm,
    required this.namaKontrak,
    required this.locIDPortAsal,
    required this.locIDPortTujuan,
    required this.locIDUOCAsal,
    required this.locIDUOCTujuan,
    required this.estimasiNilaiProduk,
  }) : super(key: key);

  String get formattedHarga {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormat.format(harga) + ',-';
  }

  String get formattedEstimasiNilaiKargo {
    final NumberFormat currencyFormat = NumberFormat.currency(
      locale: 'ID',
      symbol: 'Rp ',
      decimalDigits: 0,
    );
    return currencyFormat.format(estimasiNilaiProduk) + ',-';
  }

  @override
  State<SummaryLCL> createState() => _SummaryLCLState();
}

class _SummaryLCLState extends State<SummaryLCL> {
  int _selectedIndex = 0;
  bool isSelected = false;
  bool _isSwitched = false;
  DataLoginAccesses? dataLogin;
  CekHargaLCLAccesses? cekHarga;

  void dispose() {
    // _namaPengirimController.dispose();
    super.dispose();
  }

  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: 'your_resi_number_here'),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  // Save switch state
  Future<void> _saveSwitchState(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isSwitched', value);
  }

  // Load switch state
  Future<void> _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isSwitched = prefs.getBool('isSwitched') ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
    BlocProvider.of<ContractNiagaCubit>(context)
        .cekHargaLCL(widget.kontrak, widget.harga, widget.cbm);
    print('Kontrak : ${widget.kontrak}');
    print('Harga : ${widget.harga}');
    print('CBM : ${widget.cbm}');
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

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  Future infoWarning() => showDialog(
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
                  content: warningHarga()),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(
          0.12 * MediaQuery.of(context).size.height,
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
          titleSpacing: 0,
          title: Text(
            "Pemesanan LCL",
            style: TextStyle(
                fontSize: 16,
                color: Colors.red[900],
                fontFamily: 'Poppins Extra Bold'),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Padding(
              // padding: EdgeInsets.all(20.0),
              padding:
                  EdgeInsets.only(left: 20.0, right: 20, bottom: 20, top: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildStepItem('1.', 'Rute', 1),
                    _buildSeparator(),
                    _buildStepItem('2.', 'Detail', 2),
                    _buildSeparator(),
                    _buildStepItem('3.', 'Summary', 3),
                    _buildSeparator(),
                    _buildStepItem('4.', 'Konfirmasi', 4),
                  ],
                ),
              ),
            ),
          ),
          toolbarHeight: 0.08 * MediaQuery.of(context).size.height,
        ),
      ),
      body: BlocConsumer<DataLoginCubit, DataLoginState>(
          listener: (context, state) async {
        if (state is DataLoginSuccess) {
          setState(() {
            dataLogin = state.response;
          });
          print('Ini Data nya yang akan di ambil : $dataLogin');
        }
      }, builder: (context, state) {
        return BlocConsumer<ContractNiagaCubit, ContractNiagaState>(
            listener: (context, state) async {
          if (state is CekHargaLCLNiagaSuccess) {
            setState(() {
              cekHarga = state.response;
            });
            print('Ini Respon Harga nya LCL : $cekHarga');
            print('Ini UOM nya : ${widget.uom}');
            print('Panjang nya: ${widget.panjang}');
            print('Lebar nya: ${widget.lebar}');
            print('Tinggi nya : ${widget.tinggi}');
            print(
                'Ini Estimasi Nilai Produknya : ${widget.estimasiNilaiProduk}');
          }
        }, builder: (context, state) {
          // return BlocConsumer<CreateOrderCubit, CreateOrderState>(
          //     listener: (context, state) {
          //   if (state is CreateOrderLCLSuccess) {
          //     // final orderNumber = state.responses['orderNumber'];
          //     final orderNumber = state.response.orderNumber;
          //     Navigator.push(context, MaterialPageRoute(builder: (context) {
          //       return KonfirmasiLCL(orderNumber: orderNumber);
          //     }));
          //   }
          // }, builder: (context, state) {
          //   if (state is CreateOrderLCLInProgress) {
          //     return Center(
          //       child: CircularProgressIndicator(
          //         color: Colors.amber[600],
          //       ),
          //     );
          //   }
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //data pemesan
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color (optional)
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // Rounded corners (optional)
                          // boxShadow: [
                          //   BoxShadow(
                          //     // Grey shadow color with opacity
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 2, // How much the shadow spreads
                          //     blurRadius: 5, // How blurry the shadow is
                          //     // Position of the shadow (x, y)
                          //     offset: Offset(0, 3),
                          //   ),
                          // ],
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
                              'LCL (Less Container Load)',
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
                            SizedBox(height: 10),
                            Text(
                              'PTD (Port to Door)',
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
                              widget.kotaAsal,
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
                              widget.kotaTujuan,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Komoditi',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 10),
                            Text(
                              widget.komoditi,
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
                            Text(
                              widget.namaKontrak,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Harga per M3',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.formattedHarga,
                              style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Bold'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      //data container
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color (optional)
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // Rounded corners (optional)
                          // boxShadow: [
                          //   BoxShadow(
                          //     // Grey shadow color with opacity
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 2, // How much the shadow spreads
                          //     blurRadius: 5, // How blurry the shadow is
                          //     // Position of the shadow (x, y)
                          //     offset: Offset(0, 3),
                          //   ),
                          // ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tanggal Kargo Siap',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.tanggalCargo,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Estimasi Nilai Kargo',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.formattedEstimasiNilaiKargo,
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
                            Text(
                              widget.uom,
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
                            Text(
                              widget.jumlahProduk.toString(),
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
                            Text(
                              widget.beratTotal.toString(),
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Dimensi P x L x T (cm)',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              // '34.5 x 28 x 18.5',
                              '${widget.panjang} x ${widget.lebar} x ${widget.tinggi}',
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                            SizedBox(height: 12),
                            Text(
                              'Total Volume (M3)',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontFamily: 'Poppinss'),
                            ),
                            SizedBox(height: 5),
                            Text(
                              widget.volume.toString(),
                              style: TextStyle(
                                  color: Colors.red[900],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Bold'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      //muat barang
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color (optional)
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // Rounded corners (optional)
                          // boxShadow: [
                          //   BoxShadow(
                          //     // Grey shadow color with opacity
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 2, // How much the shadow spreads
                          //     blurRadius: 5, // How blurry the shadow is
                          //     // Position of the shadow (x, y)
                          //     offset: Offset(0, 3),
                          //   ),
                          // ],
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
                            Text(
                              widget.namaAlamatMuat,
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
                            Text(
                              widget.detailAlamatMuat,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      //bongkar barang
                      Container(
                        padding: EdgeInsets.all(12.0),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.white, // Background color (optional)
                          border: Border.all(
                            color: Colors.grey, // Grey border color
                            width: 2.0, // Border width
                          ),
                          borderRadius: BorderRadius.circular(
                              10), // Rounded corners (optional)
                          // boxShadow: [
                          //   BoxShadow(
                          //     // Grey shadow color with opacity
                          //     color: Colors.grey.withOpacity(0.5),
                          //     spreadRadius: 2, // How much the shadow spreads
                          //     blurRadius: 5, // How blurry the shadow is
                          //     // Position of the shadow (x, y)
                          //     offset: Offset(0, 3),
                          //   ),
                          // ],
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
                            Text(
                              'Alamat Bongkar ${widget.namaAlamatBongkar}',
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
                            Text(
                              widget.picBongkar,
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
                            Text(
                              widget.telpPicBongkar,
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
                            Text(
                              widget.kotaTujuan,
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
                            Text(
                              widget.detailAlamatBongkar,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                  fontFamily: 'Poppins Med'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Gunakan Poin",
                                style: TextStyle(
                                    fontSize: 12, fontFamily: 'Poppins Med'),
                              ),
                              Text(
                                '*',
                                style: TextStyle(
                                    color: Colors.red[900],
                                    fontSize: 12,
                                    fontFamily: 'Poppins Med'),
                              ),
                            ],
                          ),
                          Text(
                            "Sisa Poin Anda:",
                            style: TextStyle(
                                fontSize: 12, fontFamily: 'Poppins Med'),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Transform.scale(
                            scale: 1.5,
                            child: Switch(
                              value: _isSwitched,
                              // onChanged: (value) {
                              //   setState(() {
                              //     _isSwitched = value;
                              //   });
                              //   print('Gunakan Poin: $_isSwitched');
                              //   _saveSwitchState(value);
                              // },
                              onChanged: (cekHarga?.point == 'yes')
                                  ? (value) {
                                      setState(() {
                                        _isSwitched = value;
                                      });
                                      print('Gunakan Poin: $_isSwitched');
                                      _saveSwitchState(value);
                                    }
                                  : null, //disable if point = No
                              activeColor: Colors
                                  .red[900], // Color of the toggle when active
                              inactiveThumbColor: Colors
                                  .grey, // Color of the thumb when inactive
                              inactiveTrackColor: Colors.grey[
                                  300], // Color of the track when inactive
                            ),
                          ),
                          Container(
                              width: 90,
                              height: 35,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.red[900]!, // Red border color
                                  width: 2.0, // Border width
                                ),
                                borderRadius: BorderRadius.circular(
                                    8), // Optional border radius
                              ),
                              child: Center(
                                child: Text(
                                  // '48 Points',
                                  (cekHarga?.pointDigunakan?.toString() ??
                                          '0') +
                                      ' Points',
                                  style: TextStyle(
                                      fontSize: 11, fontFamily: 'Poppinss'),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
                //estimasi harga
                Container(
                  // padding: EdgeInsets.all(24.0),
                  padding:
                      EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey, // Grey border color
                      width: 2.0, // Border width
                    ),
                    // boxShadow: [
                    //   BoxShadow(
                    //     // Grey shadow color with opacity
                    //     color: Colors.grey.withOpacity(0.5),
                    //     spreadRadius: 2, // How much the shadow spreads
                    //     blurRadius: 5, // How blurry the shadow is
                    //     offset: Offset(0, 3), // Position of the shadow (x, y)
                    //   ),
                    // ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Estimasi Harga',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                                fontFamily: 'Poppins Bold'),
                          ),
                          GestureDetector(
                              onTap: () {
                                infoWarning();
                              },
                              // child: Image.asset('assets/Warning.png')),
                              child: Image.asset('assets/info.png')),
                        ],
                      ),
                      // SizedBox(height: 10),
                      Text(
                        // 'Rp 7,700,000',
                        cekHarga?.formattedEstimasiHarga != null
                            ? cekHarga!.formattedEstimasiHarga.toString()
                            : 'N/A',
                        style: TextStyle(
                            color: Colors.orange[600],
                            fontSize: 20,
                            fontFamily: 'Poppinss'),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Harga berikut merupakan harga Free on Trucks (FOT). Tidak termasuk biaya jasa bongkar/muat',
                        style: TextStyle(
                            color: Colors.red[900],
                            fontSize: 11,
                            fontFamily: 'Poppinss'),
                        textAlign: TextAlign.justify,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),
                Center(
                  child: SizedBox(
                    height: 40,
                    width: 300,
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.red[900],
                      child: MaterialButton(
                        minWidth: 200,
                        height: 50,
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return KonfirmasiLCL(
                                kontrak: widget.kontrak,
                                komoditi: widget.komoditi,
                                uom: widget.uom,
                                jumlahProduk: widget.jumlahProduk,
                                beratTotal: widget.beratTotal,
                                deskripsiProduk: widget.deskripsiProduk,
                                panjang: widget.panjang,
                                lebar: widget.lebar,
                                tinggi: widget.tinggi,
                                volume: widget.volume,
                                portAsal: widget.portAsal,
                                portTujuan: widget.portTujuan,
                                kotaAsal: widget.kotaAsal,
                                kotaTujuan: widget.kotaTujuan,
                                tanggalCargo: widget.tanggalCargo,
                                namaAlamatMuat: widget.namaAlamatMuat,
                                detailAlamatMuat: widget.detailAlamatMuat,
                                namaAlamatBongkar: widget.namaAlamatBongkar,
                                detailAlamatBongkar: widget.detailAlamatBongkar,
                                picBongkar: widget.picBongkar,
                                telpPicBongkar: widget.telpPicBongkar,
                                harga: (cekHarga?.estimasiHarga ?? 0).toInt(),
                                cbm: widget.cbm,
                                namaKontrak: widget.namaKontrak,
                                email: dataLogin?.email ?? '',
                                userId: dataLogin?.userId ?? 0,
                                locIDPortAsal: widget.locIDPortAsal,
                                locIDPortTujuan: widget.locIDPortTujuan,
                                locIDUOCAsal: widget.locIDUOCAsal,
                                locIDUOCTujuan: widget.locIDUOCTujuan,
                                // poin: _isSwitched,
                                poin: (cekHarga?.point == 'yes')
                                    ? _isSwitched
                                    : false,
                                price: widget.harga,
                                estimasiNilaiProduk:
                                    widget.estimasiNilaiProduk);
                          }));
                          // String formatDate(DateTime date) {
                          //   return DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
                          //       .format(date.toUtc());
                          // }

                          // DateTime? cargoDate = widget.tanggalCargo != null
                          //     ? DateFormat("dd/MM/yyyy")
                          //         .parse(widget.tanggalCargo)
                          //     : null;
                          // String? formattedCargoDate = cargoDate != null
                          //     ? formatDate(cargoDate)
                          //     : null;

                          // print("email: ${dataLogin?.email ?? ''}");
                          // print("createdBy: ${dataLogin?.email ?? ''}");
                          // print("userId: ${dataLogin?.userId ?? 0}");
                          // print("createdDate: ${formatDate(DateTime.now())}");
                          // print("businessUnit: ${widget.portAsal}");
                          // print("portAsal: ${widget.portAsal}");
                          // print("portTujuan: ${widget.portTujuan}");
                          // print("originalCity: ${widget.namaAlamatMuat}");
                          // print(
                          //     "originalAddress: ${widget.detailAlamatMuat}");
                          // print("cargoReadyDate: $formattedCargoDate");
                          // print(
                          //     "destinationCity: ${widget.namaAlamatBongkar}");
                          // print(
                          //     "destinationAddress: ${widget.detailAlamatBongkar}");
                          // print("destinationPicName: ${widget.picBongkar}");
                          // print(
                          //     "destinationPicNumber: ${int.parse(widget.telpPicBongkar)}");
                          // print("contractNo: ${widget.kontrak}");
                          // print("komoditi: ${widget.komoditi}");
                          // print(
                          //     "productDescription: ${widget.deskripsiProduk}");
                          // print("quantity: ${widget.jumlahProduk}");

                          // final double amount = cekHarga?.estimasiHarga ?? 0;
                          // print("amount: $amount");

                          // print("userPanjang: ${widget.panjang}");
                          // print("userLebar: ${widget.lebar}");
                          // print("userTinggi: ${widget.tinggi}");
                          // print("userTotalVolume: ${widget.volume}");
                          // print("userTotalWeight: ${widget.beratTotal}");
                          // print("uom: ${widget.uom}");

                          // context.read<CreateOrderCubit>().createOrderLCL(
                          //     dataLogin?.email ?? '', // email
                          //     dataLogin?.email ?? '', // createdBy
                          //     dataLogin?.userId ??
                          //         0, // userId (replace with actual user ID)
                          //     formatDate(DateTime.now()), // createdDate
                          //     widget
                          //         .portAsal, // businessUnit (replace with actual value)
                          //     widget.portAsal, // portAsal
                          //     widget.portTujuan, // portTujuan
                          //     widget.namaAlamatMuat, // originalCity
                          //     widget.detailAlamatMuat, // originalAddress
                          //     formattedCargoDate ?? '',
                          //     widget.namaAlamatBongkar, // destinationCity
                          //     widget
                          //         .detailAlamatBongkar, // destinationAddress
                          //     widget.picBongkar, // destinationPicName
                          //     widget.telpPicBongkar, // destinationPicNumber
                          //     widget.kontrak, // contractNo
                          //     widget.komoditi, // komoditi
                          //     widget.deskripsiProduk, // productDescription
                          //     widget.jumlahProduk, // quantity
                          //     amount.toInt(), // amount
                          //     widget.panjang, //userPanjang
                          //     widget.lebar, //userLebar
                          //     widget.tinggi, //userTinggi
                          //     widget.volume.toInt(), //userTotalVolume
                          //     widget.beratTotal, //userTotalWeight
                          //     widget.uom //uom
                          //     );
                        },
                        child: Text(
                          'Selanjutnya',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontFamily: 'Poppins Med'),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: SizedBox(
                    height: 40,
                    width: 300,
                    child: Material(
                      borderRadius: BorderRadius.circular(7.0),
                      color: Colors.white,
                      // shadowColor: Colors.grey[350],
                      // elevation: 5,
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
                ),
                SizedBox(height: 20),
              ],
            ),
          );
          // });
        });
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
    );
  }

  warningHarga() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "Harga final menunggu konfirmasi admin atas kesesuaian data order.",
            style: TextStyle(
                color: Colors.black, fontFamily: 'Poppin', fontSize: 13),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 110,
              height: 35,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 5.0),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Ok",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 1.5,
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

//============
int _currentStep = 1;
Widget _buildStepItem(String number, String title, int stepNumber) {
  // bool isSelected = _currentStep == stepNumber;
  Color itemColor =
      // isSelected
      stepNumber == 3
          ? (Colors.red[900] ?? Colors.red)
          : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      // isSelected
      stepNumber == 3 ? Color.fromARGB(255, 184, 33, 22) : Colors.black;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  number,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ],
        ),
        Text(
          title,
          style: TextStyle(
            // color: Colors.black,
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Widget _buildSeparator() {
  return Container(
    child: Icon(
      Icons.navigate_next,
      size: 15,
      color: Color.fromARGB(255, 175, 163, 163),
    ),
  );
}
