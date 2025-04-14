import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/order-online/summary_fcl.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/contract_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../cubit/niaga/jadwal_kapal_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/contract.dart';
import '../model/niaga/jadwal-kapal/jadwal_kapal.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class DetailFCL extends StatefulWidget {
  final String portAsal;
  final String portTujuan;
  final String kotaAsal;
  final String kotaTujuan;
  final String tanggalCargo;
  final String namaAlamatMuat;
  final String detailAlamatMuat;
  final String picMuat;
  final String telpPicMuat;
  final String namaAlamatBongkar;
  final String detailAlamatBongkar;
  final String picBongkar;
  final String telpPicBongkar;
  final String locIDPortAsal;
  final String locIDPortTujuan;
  final String locIDUOCAsal;
  final String locIDUOCTujuan;
  // const DetailFCL({super.key});
  const DetailFCL({
    Key? key,
    required this.portAsal,
    required this.portTujuan,
    required this.kotaAsal,
    required this.kotaTujuan,
    required this.tanggalCargo,
    required this.namaAlamatMuat,
    required this.detailAlamatMuat,
    required this.picMuat,
    required this.telpPicMuat,
    required this.namaAlamatBongkar,
    required this.detailAlamatBongkar,
    required this.picBongkar,
    required this.telpPicBongkar,
    required this.locIDPortAsal,
    required this.locIDPortTujuan,
    required this.locIDUOCAsal,
    required this.locIDUOCTujuan,
  }) : super(key: key);

  @override
  State<DetailFCL> createState() => _DetailFCLState();
}

class _DetailFCLState extends State<DetailFCL> {
  int _selectedIndex = 0;
  bool isSelected = false;
  TextEditingController _kontrakController = TextEditingController();
  TextEditingController _jumlahContainerController = TextEditingController();
  TextEditingController _deskripsiProdukController = TextEditingController();
  TextEditingController _komoditiController = TextEditingController();
  TextEditingController _beratController = TextEditingController();
  TextEditingController _estimasiNilaiProdukController =
      TextEditingController();
  String? formattedDate;

  List<JadwalKapalNiagaAccesses> kapalModellist = [];
  List<JadwalKapalNiagaAccesses> filteredKapalModellist = [];
  DataLoginAccesses? dataLogin;

  String? selectedContractNo;

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

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ContractNiagaCubit>(context).containerSize();
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

  String? selectedUkuranContainer;
  // final List<String> ukuranContainerList = [
  //   '20 Feet',
  //   '21 Feet',
  //   '40 Feet',
  // ];
  List<String> ukuranContainerList = [];
  List<ContractAccesses> contractsList = [];
  ContractAccesses? selectedContract;

  // List<Map<String, String>> contractsList = [
  //   {
  //     'title': 'C20201190-S/FCL/JKT-SBY/DTD4-SKTN-2021-018426',
  //     'originPort': 'Jakarta',
  //     'destinationPort': 'Surabaya',
  //     'shippingLine': 'SPIL',
  //     'jenisPengiriman': 'DTD-COSL',
  //     'rate': 'Rp 2.570.000,00',
  //   },
  //   {
  //     'title': 'C20201190-S/FCL/JKT-SBY/DTD4-SKTN-2021-017701',
  //     'originPort': 'Jakarta',
  //     'destinationPort': 'Surabaya',
  //     'shippingLine': 'TANTO',
  //     'jenisPengiriman': 'DTD-COSL',
  //     'rate': 'Rp 2.720.000,00',
  //   },
  //   {
  //     'title': 'JKSTS-COSLSPILSBY (Umum)',
  //     'originPort': 'Jakarta',
  //     'destinationPort': 'Surabaya',
  //     'shippingLine': 'TANTO',
  //     'jenisPengiriman': 'DTD-COSL',
  //     'rate': 'Rp 3.300.000,00',
  //   },
  // ];

  Future infoKomoditi() => showDialog(
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
                  content: komoditi()),
            ),
          ));

  String _formatDate(String date) {
    try {
      final parts = date.split('/');
      if (parts.length == 3) {
        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        final parsedDate = DateTime(year, month, day).add(Duration(days: 3));
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      }
    } catch (e) {
      // Handle parsing error if needed
    }
    return date; // Return the original string if parsing fails
  }

  // String _formatDate(String date) {
  //   try {
  //     final DateTime parsedDate = DateTime.parse(date).add(Duration(days: 3));
  //     return DateFormat('dd-MM-yyyy').format(parsedDate);
  //   } catch (e) {
  //     return date; // Return the original string if parsing fails
  //   }
  // }

  Future infoNilaiProduk() => showDialog(
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
                  content: nilaiProduk()),
            ),
          ));

  nilaiProduk() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Table(
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FlexColumnWidth(10),
            },
            children: [
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '1',
                      style: TextStyle(
                        fontFamily: 'Poppins Med',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Masukan nilai dalam Rupiah',
                      style: TextStyle(
                        fontFamily: 'Poppins Med',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ]),
              TableRow(children: [
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      '2',
                      style: TextStyle(
                        fontFamily: 'Poppins Med',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                TableCell(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(
                      'Angka ini digunakan sebagai dasar penentuan biaya Asuransi Produk',
                      style: TextStyle(
                        fontFamily: 'Poppins Med',
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ]),
            ],
          ),
          SizedBox(height: 15),
          Center(
            child: SizedBox(
              width: 150,
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
                      fontSize: 14,
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

  Future<void> alertKontrak(BuildContext context, List<String> messages) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        content: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 350, maxWidth: 300),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Periksa kembali isian Anda:',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w800),
                ),
                SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: messages.asMap().entries.map((entry) {
                    int index = entry.key + 1;
                    String message = entry.value;
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '$index. ',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                              child: Text(
                                message,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontFamily: 'Poppins Regular'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'OK',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void validateAndShowAlert(BuildContext context) {
    List<String> errorMessages = [];

    String kontrak = _kontrakController.text.trim();
    String jumlahContainer = _jumlahContainerController.text.trim();
    String deskripsiProduk = _deskripsiProdukController.text.trim();
    String komoditi = _komoditiController.text.trim();
    String berat = _beratController.text.trim();
    String estimasiNilai = _estimasiNilaiProdukController.text.trim();

    int? jumlahContainers = int.tryParse(jumlahContainer);
    int? estimasiNilaiProduk = int.tryParse(estimasiNilai);
    // int? beratTotal = int.tryParse(berat);

    double? beratTotal;

    if (berat.isNotEmpty) {
      beratTotal = double.tryParse(berat);
      if (beratTotal == null) {
        errorMessages.add("Berat harus berupa angka yang valid !");
      }
    } else {
      errorMessages.add("Berat tidak boleh kosong !");
    }

    // if (kontrak.isEmpty) {
    //   errorMessages.add("Kontrak tidak boleh kosong !");
    // }
    if (selectedUkuranContainer == null || selectedUkuranContainer!.isEmpty) {
      errorMessages.add("Ukuran Container tidak boleh kosong !");
    }
    if (jumlahContainer.isEmpty) {
      errorMessages.add("Jumlah Container tidak boleh kosong !");
    }
    if (deskripsiProduk.isEmpty) {
      errorMessages.add("Deskripsi Produk tidak boleh kosong !");
    }
    if (komoditi.isEmpty) {
      errorMessages.add("Komoditi tidak boleh kosong !");
    }
    if (berat.isEmpty) {
      errorMessages.add("Berat tidak boleh kosong !");
    }
    if (errorMessages.isNotEmpty) {
      alertKontrak(context, errorMessages);
    } else {
      print("Total Berat: $beratTotal");
      // Proceed with your logic here if all fields are not empty
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SummaryFCL(
            ukuranContainer: selectedUkuranContainer ?? '',
            // kontrak: _kontrakController.text,
            kontrak: selectedContract?.contractNo ?? '',
            jumlahContainer: jumlahContainers!,
            deskripsiProduk: _deskripsiProdukController.text,
            komoditi: _komoditiController.text,
            // totalBerat: beratTotal!.toDouble(),
            totalBerat: beratTotal!,
            kotaAsal: widget.kotaAsal,
            kotaTujuan: widget.kotaTujuan,
            tanggalCargo: widget.tanggalCargo,
            namaAlamatMuat: widget.namaAlamatMuat,
            detailAlamatMuat: widget.detailAlamatMuat,
            picMuat: widget.picMuat,
            telpPicMuat: widget.telpPicMuat,
            namaAlamatBongkar: widget.namaAlamatBongkar,
            detailAlamatBongkar: widget.detailAlamatBongkar,
            picBongkar: widget.picBongkar,
            telpPicBongkar: widget.telpPicBongkar,
            harga: selectedContract?.harga ?? 0,
            portAsal: widget.portAsal,
            portTujuan: widget.portTujuan,
            namaKontrak: _kontrakController.text,
            locIDPortAsal: widget.locIDPortAsal,
            locIDPortTujuan: widget.locIDPortTujuan,
            locIDUOCAsal: widget.locIDUOCAsal,
            locIDUOCTujuan: widget.locIDUOCTujuan,
            estimasiNilaiProduk: estimasiNilaiProduk!,
            estimasiClosing: _formatDate(widget.tanggalCargo));
      }));
    }
  }

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
            "Pemesanan FCL",
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
        return BlocConsumer<JadwalKapalNiagaCubit, JadwalKapalNiagaState>(
            listener: (context, state) {
          if (state is JadwalKapalNiagaSuccess) {
            kapalModellist.clear();
            kapalModellist = state.response;
          }
        }, builder: (context, state) {
          return BlocConsumer<ContractNiagaCubit, ContractNiagaState>(
              listener: (context, state) async {
            print('Current State: $state');
            if (state is ContainerSizeNiagaSuccess) {
              ukuranContainerList = state.response
                  .map((item) =>
                      item.containerSize ?? '') // Extract containerSize
                  .where((size) => size.isNotEmpty) // Filter out empty values
                  .toList();

              print('LOC ID Port Asal: ${widget.locIDPortAsal}');
              print('LOC ID Port Tujuan: ${widget.locIDPortTujuan}');
              print('LOC ID UOC Asal: ${widget.locIDUOCAsal}');
              print('LOC ID UOC Tujuan: ${widget.locIDUOCTujuan}');
              print('Alamat Muat: ${widget.namaAlamatMuat}');
              print('Detail Alamat Muat: ${widget.detailAlamatMuat}');
              print('Alamat Bongkar: ${widget.namaAlamatBongkar}');
              print('Detail Alamat Bongkar: ${widget.detailAlamatBongkar}');
              print('Tanggal Cargo Siap: ${widget.tanggalCargo}');
            }
            if (state is ContractNiagaSuccess) {
              contractsList = state.response;
            }
          }, builder: (context, state) {
            bool isLoading = state is ContractNiagaInProgress;
            return Stack(
                // child:
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Ukuran Container',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins Med'),
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
                          SizedBox(height: 5),
                          Container(
                            // height: 40,
                            padding: EdgeInsets.symmetric(
                                horizontal: 6), // Reduced padding
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: selectedUkuranContainer,
                              hint: Text(
                                'Pilih Ukuran Container',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins Regular',
                                  color: Colors.grey,
                                ), // Reduced font size
                              ),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  selectedUkuranContainer = newValue;
                                  _kontrakController
                                      .clear(); // Clear the kontrak controller text
                                  selectedContract =
                                      null; // Clear the selected contract in radio button
                                  selectedContractNo = null;
                                  filteredKapalModellist
                                      .clear(); // Clear list data the filtered kapal list
                                  print(
                                      "Ukuran Container nya: $selectedUkuranContainer");

                                  if (selectedUkuranContainer != null) {
                                    BlocProvider.of<ContractNiagaCubit>(context)
                                        .contract(
                                      widget.portAsal,
                                      widget.portTujuan,
                                      widget.namaAlamatMuat,
                                      widget.namaAlamatBongkar,
                                      // Use selected container size or fallback to 40
                                      int.tryParse(selectedUkuranContainer!) ??
                                          0,
                                    );
                                    //get jadwal Kapal
                                    BlocProvider.of<JadwalKapalNiagaCubit>(
                                            context)
                                        .jadwalKapalNiaga(
                                      widget.portAsal,
                                      widget.portTujuan,
                                      _formatDate(widget.tanggalCargo),
                                    );
                                  }
                                });
                              },
                              items: ukuranContainerList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value,
                                      style: TextStyle(
                                          fontSize: 14)), // Reduced font size
                                );
                              }).toList(),
                              dropdownColor: Colors.white,
                              decoration: InputDecoration(
                                // Reduced content padding
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 6),
                                border: InputBorder
                                    .none, // Remove the default border
                              ),
                              iconSize:
                                  20, // Reduce the size of the dropdown arrow
                              // menuMaxHeight: 200,
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Pilih Harga',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins Med'),
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
                          SizedBox(height: 5),
                          //NEW
                          // GestureDetector(
                          //   onTap: () {
                          //     showModalBottomSheet(
                          //       context: context,
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius:
                          //             BorderRadius.vertical(top: Radius.circular(20.0)),
                          //       ),
                          //       builder: (BuildContext context) {
                          //         return Padding(
                          //           padding: const EdgeInsets.all(8.0),
                          //           child: Column(
                          //             mainAxisSize: MainAxisSize.min,
                          //             children: [
                          //               Text(
                          //                 'Pilih Kontrak',
                          //                 style: TextStyle(
                          //                     fontSize: 14, fontFamily: 'Poppins Med'),
                          //               ),
                          //               ListView.builder(
                          //                 shrinkWrap: true,
                          //                 // itemCount: contractsList.length,
                          //                 itemCount: contractsList.length,
                          //                 itemBuilder: (context, index) {
                          //                   final contract = contractsList[index];
                          //                   return Card(
                          //                     margin: EdgeInsets.symmetric(vertical: 6.0),
                          //                     child: ListTile(
                          //                       title: Text(
                          //                         contract['title'] ??
                          //                             '', // Replace with your data field
                          //                         style: TextStyle(
                          //                             fontSize: 12,
                          //                             fontFamily: 'Poppins Bold'),
                          //                       ),
                          //                       subtitle: Column(
                          //                         crossAxisAlignment:
                          //                             CrossAxisAlignment.start,
                          //                         children: [
                          //                           Text(
                          //                             'Origin Port: ${contract['originPort']}',
                          //                             style: TextStyle(
                          //                                 fontFamily: 'Poppins Med',
                          //                                 fontSize: 12),
                          //                           ),
                          //                           Text(
                          //                               'Destination to Port: ${contract['destinationPort']}',
                          //                               style: TextStyle(
                          //                                   fontFamily: 'Poppins Med',
                          //                                   fontSize: 12)),
                          //                           Text(
                          //                               'Shipping Line: ${contract['shippingLine']}',
                          //                               style: TextStyle(
                          //                                   fontFamily: 'Poppins Med',
                          //                                   fontSize: 12)),
                          //                           Text(
                          //                               'Jenis Pengiriman: ${contract['jenisPengiriman']}',
                          //                               style: TextStyle(
                          //                                   fontFamily: 'Poppins Med',
                          //                                   fontSize: 12)),
                          //                           Text('Rate: Rp ${contract['rate']}',
                          //                               style: TextStyle(
                          //                                   fontFamily: 'Poppins Med',
                          //                                   fontSize: 12)),
                          //                         ],
                          //                       ),
                          //                       onTap: () {
                          //                         // Set the selected contract in your controller
                          //                         _kontrakController.text =
                          //                             contract['title'] ?? '';
                          //                         Navigator.pop(context);
                          //                         print(
                          //                             'Selected contract: ${contract['title']}');
                          //                       },
                          //                     ),
                          //                   );
                          //                 },
                          //               ),
                          //               // ElevatedButton(
                          //               //   onPressed: () {
                          //               //     Navigator.pop(context);
                          //               //   },
                          //               //   child: Text('Terapkan'),
                          //               //   style: ElevatedButton.styleFrom(
                          //               //       primary: Colors.red),
                          //               // ),
                          //             ],
                          //           ),
                          //         );
                          //       },
                          //     );
                          //   },
                          //   child: Container(
                          //     height: 40,
                          //     decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       borderRadius: BorderRadius.circular(10.0),
                          //       border: Border.all(
                          //         color: Colors.black,
                          //         width: 1.0,
                          //       ),
                          //     ),
                          //     child: Row(
                          //       children: [
                          //         Expanded(
                          //           child: TextFormField(
                          //             controller: _kontrakController,
                          //             enabled: false, // Disable direct editing
                          //             decoration: InputDecoration(
                          //               border: InputBorder.none,
                          //               hintText: "Pilih kontrak",
                          //               hintStyle: TextStyle(
                          //                 fontSize: 12,
                          //                 fontFamily: 'Poppins Regular',
                          //                 color: Colors.grey,
                          //               ),
                          //               contentPadding: EdgeInsets.symmetric(
                          //                   horizontal: 10.0, vertical: 11.0),
                          //             ),
                          //             style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 14.0,
                          //               fontFamily: 'Montserrat',
                          //             ),
                          //           ),
                          //         ),
                          //         Icon(Icons.arrow_drop_down),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          //===2
                          GestureDetector(
                            onTap: () {
                              isLoading
                                  ? null
                                  : showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(
                                            //agar filter kapal bisa refresh saat klik radio button
                                            builder: (context, setState) {
                                          return Dialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Pilih Harga',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontFamily:
                                                              'Poppins Med'),
                                                    ),
                                                    if (state
                                                        is ContractNiagaFailure)
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 10.0),
                                                        child: Text(
                                                          'Harga tidak tersedia !',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[900],
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Poppins Bold'),
                                                        ),
                                                      ),
                                                    ListView.builder(
                                                      shrinkWrap: true,
                                                      physics:
                                                          NeverScrollableScrollPhysics(),
                                                      itemCount:
                                                          contractsList.length,
                                                      itemBuilder:
                                                          (context, index) {
                                                        final contract =
                                                            contractsList[
                                                                index];
                                                        return Card(
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      6.0),
                                                          child: ListTile(
                                                            // leading: Radio<
                                                            //     ContractAccesses>(
                                                            leading:
                                                                Radio<String>(
                                                              // value: contract,
                                                              value: contract
                                                                  .contractNo
                                                                  .toString(),
                                                              // groupValue:
                                                              //     selectedContract,
                                                              groupValue:
                                                                  selectedContractNo,
                                                              // onChanged:
                                                              //     (ContractAccesses?
                                                              //         value) {
                                                              //   setState(() {
                                                              //     selectedContract =
                                                              //         value;
                                                              //     _kontrakController
                                                              //             .text =
                                                              //         '${contract.portAsal} - ${contract.portTujuan}';
                                                              //     filteredKapalModellist = kapalModellist
                                                              //         .where((kapal) =>
                                                              //             kapal
                                                              //                 .shippingLine ==
                                                              //             contract
                                                              //                 .pelayaran)
                                                              //         .toList();
                                                              //   });
                                                              // },
                                                              //NEW
                                                              onChanged:
                                                                  (String?
                                                                      value) {
                                                                setState(() {
                                                                  selectedContractNo =
                                                                      value; // Update the selected contract number
                                                                  selectedContract =
                                                                      contract;
                                                                  _kontrakController
                                                                          .text =
                                                                      '${selectedContract!.portAsal} - ${selectedContract!.portTujuan}';
                                                                  filteredKapalModellist = kapalModellist
                                                                      .where((kapal) =>
                                                                          kapal
                                                                              .shippingLine ==
                                                                          contract
                                                                              .pelayaran)
                                                                      .toList();
                                                                  // Additional logic for filtering or updating other states
                                                                });
                                                              },
                                                            ),
                                                            title: Text(
                                                              // contract.contractNo ?? '',
                                                              // '${contract.portAsal} - ${contract.portTujuan} (${contract.pelayaran})',
                                                              '${contract.portAsal} - ${contract.portTujuan}',
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  fontFamily:
                                                                      'Poppins Bold'),
                                                            ),
                                                            subtitle: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  // 'Origin Port: ${contract['originPort']}',
                                                                  'Origin Port: ${contract.portAsal}',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins Med',
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  // 'Destination to Port: ${contract['destinationPort']}',
                                                                  'Destination Port: ${contract.portTujuan}',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins Med',
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                if (dataLogin !=
                                                                        null &&
                                                                    dataLogin!
                                                                            .ownerCode !=
                                                                        'ONLINE')
                                                                  Text(
                                                                    // 'Shipping Line: ${contract['shippingLine']}',
                                                                    'Shipping Line: ${contract.pelayaran}',
                                                                    style: TextStyle(
                                                                        fontFamily:
                                                                            'Poppins Med',
                                                                        fontSize:
                                                                            12),
                                                                  ),
                                                                Text(
                                                                  // 'Jenis Pengiriman: ${contract['jenisPengiriman']}',
                                                                  'Jenis Pengiriman: ${contract.pengiriman}',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins Med',
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                                Text(
                                                                  // 'Rate: Rp ${contract['rate']}',
                                                                  'Rate: Rp ${contract.formattedHarga}',
                                                                  style: TextStyle(
                                                                      fontFamily:
                                                                          'Poppins Med',
                                                                      fontSize:
                                                                          12),
                                                                ),
                                                              ],
                                                            ),
                                                            onTap: () {
                                                              setState(() {
                                                                // Store selected contract
                                                                selectedContract =
                                                                    contract;
                                                              });
                                                              // _kontrakController
                                                              //         .text =
                                                              //     // '${contract.portAsal} - ${contract.portTujuan} (${contract.pelayaran})';
                                                              //     '${contract.portAsal} - ${contract.portTujuan}';
                                                              _kontrakController
                                                                      .text =
                                                                  '${selectedContract!.portAsal} - ${selectedContract!.portTujuan}';
                                                              filteredKapalModellist =
                                                                  kapalModellist
                                                                      .where((kapal) =>
                                                                          kapal
                                                                              .shippingLine ==
                                                                          contract
                                                                              .pelayaran)
                                                                      .toList();
                                                              print(
                                                                  'Selected contract: ${contract.contractNo}');
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Table(
                                                      columnWidths: {
                                                        0: FlexColumnWidth(5),
                                                        1: FlexColumnWidth(4),
                                                        2: FlexColumnWidth(7),
                                                        3: FlexColumnWidth(4),
                                                      },
                                                      children: [
                                                        TableRow(children: [
                                                          TableCell(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          2.0),
                                                              child: Text(
                                                                'Kapal',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins Med',
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          2.0),
                                                              child: Text(
                                                                'Rute',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins Med',
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          2.0),
                                                              child: Text(
                                                                'Tanggal Closing',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins Med',
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          ),
                                                          TableCell(
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          8.0,
                                                                      horizontal:
                                                                          2.0),
                                                              child: Text(
                                                                'Pelayaran',
                                                                style: TextStyle(
                                                                    fontFamily:
                                                                        'Poppins Med',
                                                                    fontSize:
                                                                        12),
                                                              ),
                                                            ),
                                                          )
                                                        ]),
                                                      ],
                                                    ),
                                                    if (state
                                                        is JadwalKapalNiagaInProgress)
                                                      Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color:
                                                              Colors.amber[600],
                                                        ),
                                                      ),
                                                    if (dataLogin != null &&
                                                        dataLogin!.ownerCode !=
                                                            'ONLINE')
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            filteredKapalModellist
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final kapal =
                                                              filteredKapalModellist[
                                                                  index];
                                                          return Table(
                                                            columnWidths: {
                                                              0: FlexColumnWidth(
                                                                  5),
                                                              1: FlexColumnWidth(
                                                                  4),
                                                              2: FlexColumnWidth(
                                                                  7),
                                                              3: FlexColumnWidth(
                                                                  4),
                                                            },
                                                            children: [
                                                              TableRow(
                                                                  children: [
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          kapal.vesselName ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins Med',
                                                                              fontSize: 10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          '${kapal.portAsal ?? ''} - ${kapal.portTujuan ?? ''}',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins Med',
                                                                              fontSize: 10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          kapal.tglClosing ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins Med',
                                                                              fontSize: 10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          kapal.shippingLine ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins Med',
                                                                              fontSize: 10),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ]),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    if (dataLogin != null &&
                                                        dataLogin!.ownerCode ==
                                                            'ONLINE')
                                                      ListView.builder(
                                                        shrinkWrap: true,
                                                        physics:
                                                            NeverScrollableScrollPhysics(),
                                                        itemCount:
                                                            kapalModellist
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final kapal =
                                                              kapalModellist[
                                                                  index];
                                                          return Table(
                                                            columnWidths: {
                                                              0: FlexColumnWidth(
                                                                  5),
                                                              1: FlexColumnWidth(
                                                                  4),
                                                              2: FlexColumnWidth(
                                                                  7),
                                                              3: FlexColumnWidth(
                                                                  4),
                                                            },
                                                            children: [
                                                              TableRow(
                                                                  children: [
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          kapal.vesselName ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins Med',
                                                                              fontSize: 10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          '${kapal.portAsal ?? ''} - ${kapal.portTujuan ?? ''}',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins Med',
                                                                              fontSize: 10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          kapal.tglClosing ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins Med',
                                                                              fontSize: 10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    TableCell(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                8.0,
                                                                            horizontal:
                                                                                2.0),
                                                                        child:
                                                                            Text(
                                                                          kapal.shippingLine ??
                                                                              '',
                                                                          style: TextStyle(
                                                                              fontFamily: 'Poppins Med',
                                                                              fontSize: 10),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ]),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    SizedBox(
                                                      width: 300,
                                                      height: 40,
                                                      child: Material(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.0),
                                                        color: Colors.red[900],
                                                        child: MaterialButton(
                                                          minWidth:
                                                              200, // Adjust the width as needed
                                                          height:
                                                              50, // Adjust the height as needed
                                                          onPressed: () {
                                                            setState(() {
                                                              // Set the selected contract and update the text field
                                                              // _kontrakController
                                                              //         .text =
                                                              //     '${selectedContract?.portAsal ?? ''} - ${selectedContract?.portTujuan ?? ''}';
                                                              _kontrakController
                                                                      .text =
                                                                  '${selectedContract!.portAsal} - ${selectedContract!.portTujuan}';
                                                              // Update formattedDate
                                                              formattedDate =
                                                                  _formatDate(widget
                                                                      .tanggalCargo);
                                                            });
                                                            Navigator.of(
                                                                    context)
                                                                .pop(); // Close the dialog
                                                          },
                                                          child: Text(
                                                            'Terapkan',
                                                            style: TextStyle(
                                                                fontSize: 13,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'Poppins Med'),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    );
                            },
                            child: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.0,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _kontrakController,
                                      enabled: false, // Disable direct editing
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Pilih harga",
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins Regular',
                                          color: Colors.grey,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 12.0),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Estimasi Closing',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins Med'),
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
                          SizedBox(height: 5),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                color: Colors.black, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  formattedDate ?? '',
                                  style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 12,
                                      fontFamily: 'Poppins Regular'),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Jumlah Container',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins Med'),
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
                          SizedBox(height: 5),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                color: Colors.black, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                            ),
                            //untuk tulisan nama pengirim
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _jumlahContainerController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Masukkan Jumlah Container",
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins Regular',
                                          color: Colors.grey,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 12.0),
                                        fillColor: Colors.grey[600],
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Deskripsi Produk',
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
                          SizedBox(height: 5),
                          // Container(
                          //   height: 90,
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          //     border: Border.all(
                          //       color: Colors.black, // Set border color here
                          //       width: 1.0, // Set border width here
                          //     ),
                          //   ),
                          //   //untuk tulisan nama pengirim
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: TextFormField(
                          //           controller: _deskripsiProdukController,
                          //           textInputAction: TextInputAction.next,
                          //           decoration: InputDecoration(
                          //               border: InputBorder.none,
                          //               hintText: "Isi Deskripsi Produk",
                          //               contentPadding:
                          //                   EdgeInsets.symmetric(horizontal: 10.0),
                          //               fillColor: Colors.grey[600],
                          //               labelStyle: TextStyle(fontFamily: 'Montserrat')),
                          //           style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 14.0,
                          //               fontFamily: 'Montserrat'),
                          //           maxLines: 4,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                color: Colors.black, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _deskripsiProdukController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Isi Deskripsi Produk",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 14.0),
                                      fillColor: Colors.grey[600],
                                      labelStyle:
                                          TextStyle(fontFamily: 'Montserrat'),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'Montserrat',
                                    ),
                                    maxLines:
                                        null, // Allows the TextFormField to grow vertically
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Komoditi',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Poppins Med'),
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
                              GestureDetector(
                                  onTap: () {
                                    infoKomoditi();
                                  },
                                  child: Image.asset('assets/info.png')),
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                color: Colors.black, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                            ),
                            //untuk tulisan nama pengirim
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _komoditiController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Isi Jenis Komiditi",
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins Regular',
                                          color: Colors.grey,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 12.0),
                                        fillColor: Colors.grey[600],
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Total Berat (KG)',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontFamily: 'Poppins Med'),
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
                          SizedBox(height: 5),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                color: Colors.black, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                            ),
                            //untuk tulisan nama pengirim
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _beratController,
                                    onChanged: (value) {
                                      print(
                                          "Berat Input: '${_beratController.text.trim()}'");
                                    },
                                    textInputAction: TextInputAction.next,
                                    // keyboardType: TextInputType.number,
                                    // inputFormatters: [
                                    //   FilteringTextInputFormatter.digitsOnly,
                                    // ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Masukkan Total Berat",
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins Regular',
                                          color: Colors.grey,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 12.0),
                                        fillColor: Colors.grey[600],
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Estimasi Nilai Kargo',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontFamily: 'Poppins Med'),
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
                              GestureDetector(
                                  onTap: () {
                                    infoNilaiProduk();
                                  },
                                  child: Image.asset('assets/info.png')),
                            ],
                          ),
                          SizedBox(height: 5),
                          Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0)),
                              border: Border.all(
                                color: Colors.black, // Set border color here
                                width: 1.0, // Set border width here
                              ),
                            ),
                            //untuk tulisan nama pengirim
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _estimasiNilaiProdukController,
                                    textInputAction: TextInputAction.next,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                    ],
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Masukkan Nilai Produk",
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins Regular',
                                          color: Colors.grey,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 12.0),
                                        fillColor: Colors.grey[600],
                                        labelStyle: TextStyle(
                                            fontFamily: 'Montserrat')),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 70),
                          Center(
                            child: SizedBox(
                              width: 300,
                              height: 40,
                              child: Material(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.red[900],
                                child: MaterialButton(
                                  minWidth: 200, // Adjust the width as needed
                                  height: 50, // Adjust the height as needed
                                  onPressed: () {
                                    validateAndShowAlert(context);
                                    setState(() {});
                                  },
                                  child: Text(
                                    'Lanjut',
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
                              width: 300,
                              height: 40,
                              child: Material(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.white,
                                // shadowColor: Colors.grey[350],
                                // elevation: 5,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    minimumSize: Size(200, 50),
                                    side: BorderSide(
                                        color: Colors.red[900]!, width: 2),
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
                        ],
                      ),
                    ),
                  ),
                  if (state is ContractNiagaInProgress)
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.amber[600],
                      ),
                    ),
                ]);
          });
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
      //           // width: 20,
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
      //           // width: 12,
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

  komoditi() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   "1. Komoditi digunakan untuk menentukan kualitas container yang dipilih",
          //   style: TextStyle(
          //       color: Colors.black, fontFamily: 'Poppin', fontSize: 13),
          //   textAlign: TextAlign.justify,
          // ),
          // SizedBox(height: 8),
          // RichText(
          //   textAlign: TextAlign.justify,
          //   text: TextSpan(
          //     children: [
          //       TextSpan(
          //         text:
          //             "2. Untuk produk DG (Dangerous Good) harap menghubungi ",
          //         style: TextStyle(
          //           color: Colors.black,
          //           fontFamily: 'Poppin',
          //           fontSize: 13,
          //         ),
          //       ),
          //       TextSpan(
          //         text: "Customer Service",
          //         style: TextStyle(
          //           color: Colors.blue,
          //           fontFamily: 'Poppin',
          //           fontSize: 13,
          //           decoration: TextDecoration
          //               .underline, // Optionally underline the text
          //         ),
          //         recognizer: TapGestureRecognizer()
          //           ..onTap = () async {
          //             const url = 'https://wa.me/6282245465151';
          //             if (await canLaunch(url)) {
          //               await launch(url);
          //             } else {
          //               // Handle error
          //               ScaffoldMessenger.of(context).showSnackBar(
          //                 SnackBar(content: Text('Could not launch WhatsApp')),
          //               );
          //             }
          //           },
          //       ),
          //     ],
          //   ),
          // ),
          RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppin',
                fontSize: 13,
              ),
              children: [
                TextSpan(
                  text:
                      "1. Komoditi digunakan untuk menentukan kualitas container yang dipilih\n\n",
                ),
                TextSpan(
                  text:
                      "2. Untuk produk DG (Dangerous Good) harap menghubungi ",
                ),
                TextSpan(
                  text: "Customer Service",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url = 'https://wa.me/6282245465151';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch WhatsApp')),
                        );
                      }
                    },
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: SizedBox(
              width: 150,
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
                      fontSize: 14,
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
      stepNumber == 2
          ? (Colors.red[900] ?? Colors.red)
          : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      // isSelected
      stepNumber == 2 ? Color.fromARGB(255, 184, 33, 22) : Colors.black;

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
