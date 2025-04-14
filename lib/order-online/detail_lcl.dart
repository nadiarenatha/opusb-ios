import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/order-online/summary_lcl.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/contract_cubit.dart';
import '../model/niaga/contract_lcl.dart';
import '../model/niaga/uom.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class DetailLCL extends StatefulWidget {
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
  // const DetailLCL({super.key});
  const DetailLCL({
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
  State<DetailLCL> createState() => _DetailLCLState();
}

class _DetailLCLState extends State<DetailLCL> {
  int _selectedIndex = 0;
  bool isSelected = false;
  TextEditingController _kontrakController = TextEditingController();
  TextEditingController _komoditiController = TextEditingController();
  TextEditingController _UOMController = TextEditingController();
  TextEditingController _jumlahProdukController = TextEditingController();
  TextEditingController _beratController = TextEditingController();
  TextEditingController _deskripsiProdukController = TextEditingController();
  TextEditingController _panjangController = TextEditingController();
  TextEditingController _lebarController = TextEditingController();
  TextEditingController _tinggiController = TextEditingController();
  TextEditingController _volumeController = TextEditingController();
  TextEditingController _estimasiNilaiProdukController =
      TextEditingController();

  //Rumus volume balok
  double _result = 0;

  //Rumus cbm
  double _resultCbm = 0;

  //dropdown uom
  List<UOMAccesses> uomList = [];
  UOMAccesses? _selectedUOM;

  // bool isLoading = false;
  bool isContractLCLNiagaInProgress = false;

  void dispose() {
    _panjangController.dispose();
    _lebarController.dispose();
    _tinggiController.dispose();
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
    _panjangController.addListener(_calculateVolume);
    _lebarController.addListener(_calculateVolume);
    _tinggiController.addListener(_calculateVolume);
    print('portAsal contractLCL: ${widget.portAsal}');
    print('portTujuan contractLCL: ${widget.portTujuan}');
    print('namaAlamatBongkar contractLCL: ${widget.namaAlamatBongkar}');
    BlocProvider.of<ContractNiagaCubit>(context).contractLCL(
        widget.portAsal, widget.portTujuan, widget.namaAlamatBongkar);
    BlocProvider.of<ContractNiagaCubit>(context).uomNiaga();
  }

  void _calculateVolume() {
    final double panjang = double.tryParse(_panjangController.text) ?? 0;
    final double lebar = double.tryParse(_lebarController.text) ?? 0;
    final double tinggi = double.tryParse(_tinggiController.text) ?? 0;
    final int jumlahProduk = int.tryParse(_jumlahProdukController.text) ?? 0;

    setState(() {
      _result = ((panjang * lebar * tinggi) / 1000000) * jumlahProduk;
      // _result = (panjang * lebar * tinggi) / 1000000;
    });
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  List<ContractLCLAccesses> contractsList = [];
  ContractLCLAccesses? selectedContract;

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

  // Future infoKontrak() => showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         // Getting the size of the screen to help position the dialog
  //         var screenSize = MediaQuery.of(context).size;
  //         return Stack(
  //           children: [
  //             Positioned(
  //               // Adjust top and right to control the position of the dialog
  //               // Adjust the position based on your layout
  //               top: screenSize.height * 0.1,
  //               right: screenSize.width * 0.15, // Adjust based on your layout
  //               child: SingleChildScrollView(
  //                 child: SizedBox(
  //                   width: screenSize.width * 0.65, // Adjust width as needed
  //                   child: AlertDialog(
  //                     shape: RoundedRectangleBorder(
  //                       borderRadius: BorderRadius.circular(20.0),
  //                     ),
  //                     titlePadding: EdgeInsets.zero,
  //                     contentPadding:
  //                         EdgeInsets.symmetric(horizontal: 25, vertical: 3),
  //                     title: Row(
  //                       mainAxisAlignment: MainAxisAlignment.end,
  //                       children: [],
  //                     ),
  //                     content: kontrak(),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         );
  //       },
  //     );

  Future infoKontrak() => showDialog(
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
                    children: [
                      // IconButton(
                      //     icon: Icon(Icons.close),
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //     })
                    ],
                  ),
                  content: kontrak()),
            ),
          ));

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
                                  fontFamily: 'Poppins Regular',
                                ),
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
    String komoditi = _komoditiController.text.trim();
    String uom = _UOMController.text.trim();
    String jumlahProduk = _jumlahProdukController.text.trim();
    String berat = _beratController.text.trim();
    String deskripsiProduk = _deskripsiProdukController.text.trim();
    String panjang = _panjangController.text.trim();
    String lebar = _lebarController.text.trim();
    String tinggi = _tinggiController.text.trim();
    String volume = _volumeController.text.trim();
    String estimasiNilai = _estimasiNilaiProdukController.text.trim();

    int? jumlahProduks = int.tryParse(jumlahProduk);
    int? estimasiNilaiProduk = int.tryParse(estimasiNilai);
    int? volumes = int.tryParse(volume);

    double? beratTotal;
    double? panjangs;
    double? lebars;
    double? tinggis;

    if (berat.isNotEmpty) {
      beratTotal = double.tryParse(berat);
      if (beratTotal == null) {
        errorMessages.add("Berat harus berupa angka yang valid !");
      }
    } else {
      errorMessages.add("Berat tidak boleh kosong !");
    }
    //Panjang
    if (panjang.isNotEmpty) {
      panjangs = double.tryParse(panjang);
      if (panjang == null) {
        errorMessages.add("Panjang harus berupa angka yang valid !");
      }
    } else {
      errorMessages.add("Panjang tidak boleh kosong !");
    }
    //Lebar
    if (lebar.isNotEmpty) {
      lebars = double.tryParse(lebar);
      if (lebar == null) {
        errorMessages.add("Lebar harus berupa angka yang valid !");
      }
    } else {
      errorMessages.add("Lebar tidak boleh kosong !");
    }
    //Tinggi
    if (tinggi.isNotEmpty) {
      tinggis = double.tryParse(tinggi);
      if (tinggi == null) {
        errorMessages.add("Tinggi harus berupa angka yang valid !");
      }
    } else {
      errorMessages.add("Tinggi tidak boleh kosong !");
    }
    if (kontrak.isEmpty) {
      errorMessages.add("Kontrak tidak boleh kosong !");
    }
    if (komoditi.isEmpty) {
      errorMessages.add("Komoditi tidak boleh kosong !");
    }
    if (_selectedUOM == null) {
      errorMessages.add("UOM tidak boleh kosong !");
    }
    // if (selectedUkuranContainer == null || selectedUkuranContainer!.isEmpty) {
    //   errorMessages.add("Ukuran Container tidak boleh kosong !");
    // }
    if (jumlahProduk.isEmpty) {
      errorMessages.add("Jumlah Produk tidak boleh kosong !");
    }
    if (berat.isEmpty) {
      errorMessages.add("Berat Total tidak boleh kosong !");
    }
    if (deskripsiProduk.isEmpty) {
      errorMessages.add("Deskripsi Produk tidak boleh kosong !");
    }
    // if (panjang.isEmpty) {
    //   errorMessages.add("Panjang tidak boleh kosong !");
    // }
    // if (lebar.isEmpty) {
    //   errorMessages.add("Lebar tidak boleh kosong !");
    // }
    // if (tinggi.isEmpty) {
    //   errorMessages.add("Tinggi tidak boleh kosong !");
    // }
    // if (volume.isEmpty) {
    //   errorMessages.add("Volume tidak boleh kosong !");
    // }
    if (_result.toStringAsFixed(6).isEmpty) {
      errorMessages.add("Volume tidak boleh kosong !");
    }
    if (errorMessages.isNotEmpty) {
      alertKontrak(context, errorMessages);
    } else {
      //RUMUS HITUNG CBM UNTUK CEK HARGA LCL
      // int volumeCm = (panjangs ?? 0) * (lebars ?? 0) * (tinggis ?? 0);
      double volumeCm = (panjangs ?? 0) * (lebars ?? 0) * (tinggis ?? 0);

      print('Volume in cm³: $volumeCm');

      // Convert cubic centimeters to cubic meters (1 m³ = 1,000,000 cm³)
      double volumeM3 = volumeCm / 1000000.0;
      print('Volume in m³: $volumeM3');
      // if (jumlahProduks != null) {
      //   double CBMs = volumeM3 * jumlahProduks;
      //   print('CBM nya: $CBMs');
      // }
      double CBMs =
          volumeM3 * (jumlahProduks ?? 0); // Use 0 if jumlahProduks is null
      print('CBM nya: $CBMs');

      // Proceed with your logic here if all fields are not empty
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return SummaryLCL(
            // kontrak: _kontrakController.text,
            kontrak: selectedContract?.contractNo ?? '',
            komoditi: _komoditiController.text,
            // uom: _UOMController.text,
            uom: _selectedUOM?.uomCode ?? 'N/A',
            jumlahProduk: jumlahProduks!,
            beratTotal: beratTotal!,
            deskripsiProduk: _deskripsiProdukController.text,
            panjang: panjangs!,
            lebar: lebars!,
            tinggi: tinggis!,
            // volume: volumes!,
            volume: double.tryParse(_result.toStringAsFixed(6)) ?? 0.0,
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
            harga: (selectedContract?.harga ?? 0).toInt(),
            // cbm: double.parse(_resultCbm.toStringAsFixed(6)),
            cbm: CBMs,
            namaKontrak: _kontrakController.text,
            locIDPortAsal: widget.locIDPortAsal,
            locIDPortTujuan: widget.locIDPortTujuan,
            locIDUOCAsal: widget.locIDUOCAsal,
            locIDUOCTujuan: widget.locIDUOCTujuan,
            estimasiNilaiProduk: estimasiNilaiProduk!);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [ Scaffold(
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
        body: BlocConsumer<ContractNiagaCubit, ContractNiagaState>(
          listener: (context, state) {
            print('Current State: $state');
            if (state is UOMNiagaSuccess) {
              print('UOMNiagaSuccess jalan');
              setState(() {
                uomList = state.response;
              });
            }
            if (state is ContractLCLNiagaSuccess) {
              print('ContractLCLNiagaSuccess jalan');
              setState(() {
                isContractLCLNiagaInProgress = false;
                contractsList = state.response;
              });
              print('LOC ID Port Asal: ${widget.locIDPortAsal}');
              print('LOC ID Port Tujuan: ${widget.locIDPortTujuan}');
              print('LOC ID UOC Asal: ${widget.locIDUOCAsal}');
              print('LOC ID UOC Tujuan: ${widget.locIDUOCTujuan}');
            }
            if (state is ContractLCLNiagaInProgress) {
              print('ContractLCLNiagaInProgress jalan');
              setState(() {
                isContractLCLNiagaInProgress = true;
              });
            }
            if (state is ContractLCLNiagaFailure) {
              print('ContractLCLNiagaFailure jalan');
              setState(() {
                isContractLCLNiagaInProgress = false;
              });
            }
          },
          builder: (context, state) {
            // bool isLoading = state is ContractLCLNiagaInProgress;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                            GestureDetector(
                                onTap: () {
                                  infoKontrak();
                                },
                                child: Image.asset('assets/info.png'))
                          ],
                        ),
                        SizedBox(height: 5),
                        // Container(
                        //   height: 40,
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
                        //           controller: _kontrakController,
                        //           textInputAction: TextInputAction.next,
                        //           decoration: InputDecoration(
                        //               border: InputBorder.none,
                        //               hintText: "Pilih Kontrak",
                        //               hintStyle: TextStyle(
                        //                 fontSize: 12,
                        //                 fontFamily: 'Poppins Regular',
                        //                 color: Colors.grey,
                        //               ),
                        //               contentPadding: EdgeInsets.symmetric(
                        //                   horizontal: 10.0, vertical: 13.0),
                        //               fillColor: Colors.grey[600],
                        //               labelStyle: TextStyle(fontFamily: 'Montserrat')),
                        //           style: TextStyle(
                        //               color: Colors.black,
                        //               fontSize: 14.0,
                        //               fontFamily: 'Montserrat'),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //LAMA
                        // GestureDetector(
                        //   onTap: () {
                        //     isLoading
                        //         ? null
                        //         : showDialog(
                        //             context: context,
                        //             builder: (BuildContext context) {
                        //               return Dialog(
                        //                 shape: RoundedRectangleBorder(
                        //                   borderRadius:
                        //                       BorderRadius.circular(20.0),
                        //                 ),
                        //                 child: Padding(
                        //                   padding: const EdgeInsets.all(8.0),
                        //                   child: SingleChildScrollView(
                        //                     child: Column(
                        //                       mainAxisSize: MainAxisSize.min,
                        //                       children: [
                        //                         Text(
                        //                           'Pilih Kontrak',
                        //                           style: TextStyle(
                        //                               fontSize: 14,
                        //                               fontFamily: 'Poppins Med'),
                        //                         ),
                        //                         ListView.builder(
                        //                           shrinkWrap: true,
                        //                           physics:
                        //                               NeverScrollableScrollPhysics(),
                        //                           itemCount: contractsList.length,
                        //                           itemBuilder: (context, index) {
                        //                             final contract =
                        //                                 contractsList[index];
                        //                             return Card(
                        //                               margin:
                        //                                   EdgeInsets.symmetric(
                        //                                       vertical: 6.0),
                        //                               child: ListTile(
                        //                                 title: Text(
                        //                                   // contract.contractNo ?? '',
                        //                                   '${contract.portAsal} - ${contract.portTujuan}',
                        //                                   style: TextStyle(
                        //                                       fontSize: 12,
                        //                                       fontFamily:
                        //                                           'Poppins Bold'),
                        //                                 ),
                        //                                 subtitle: Column(
                        //                                   crossAxisAlignment:
                        //                                       CrossAxisAlignment
                        //                                           .start,
                        //                                   children: [
                        //                                     Text(
                        //                                       // 'Origin Port: ${contract['originPort']}',
                        //                                       'Origin Port: ${contract.portAsal}',
                        //                                       style: TextStyle(
                        //                                           fontFamily:
                        //                                               'Poppins Med',
                        //                                           fontSize: 12),
                        //                                     ),
                        //                                     Text(
                        //                                       // 'Destination to Port: ${contract['destinationPort']}',
                        //                                       'Destination Port: ${contract.portTujuan}',
                        //                                       style: TextStyle(
                        //                                           fontFamily:
                        //                                               'Poppins Med',
                        //                                           fontSize: 12),
                        //                                     ),
                        //                                     Text(
                        //                                       // 'Shipping Line: ${contract['shippingLine']}',
                        //                                       'Shipping Line: ${contract.pelayaran}',
                        //                                       style: TextStyle(
                        //                                           fontFamily:
                        //                                               'Poppins Med',
                        //                                           fontSize: 12),
                        //                                     ),
                        //                                     Text(
                        //                                       // 'Jenis Pengiriman: ${contract['jenisPengiriman']}',
                        //                                       'Jenis Pengiriman: ${contract.pengiriman}',
                        //                                       style: TextStyle(
                        //                                           fontFamily:
                        //                                               'Poppins Med',
                        //                                           fontSize: 12),
                        //                                     ),
                        //                                     Text(
                        //                                       // 'Rate: Rp ${contract['rate']}',
                        //                                       'Rate: Rp ${contract.harga}',
                        //                                       style: TextStyle(
                        //                                           fontFamily:
                        //                                               'Poppins Med',
                        //                                           fontSize: 12),
                        //                                     ),
                        //                                   ],
                        //                                 ),
                        //                                 onTap: () {
                        //                                   setState(() {
                        //                                     // Store selected contract
                        //                                     selectedContract =
                        //                                         contract;
                        //                                   });
                        //                                   _kontrakController
                        //                                           .text =
                        //                                       // contract['title'] ?? '';
                        //                                       // contract.contractNo ?? '';
                        //                                       '${contract.portAsal} - ${contract.portTujuan}';
                        //                                   Navigator.pop(context);
                        //                                   print(
                        //                                       'Selected contract: ${contract.contractNo}');
                        //                                 },
                        //                               ),
                        //                             );
                        //                           },
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //           );
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
                        //         Icon(
                        //           Icons.arrow_drop_down,
                        //           color: Colors.grey,
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        //==
                        GestureDetector(
                          onTap: isContractLCLNiagaInProgress
                              ? null
                              : () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  'Pilih Harga',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'Poppins Med',
                                                  ),
                                                ),
                                                ListView.builder(
                                                  shrinkWrap: true,
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  itemCount: contractsList.length,
                                                  itemBuilder: (context, index) {
                                                    final contract =
                                                        contractsList[index];
                                                    return Card(
                                                      margin:
                                                          EdgeInsets.symmetric(
                                                              vertical: 6.0),
                                                      child: ListTile(
                                                        title: Text(
                                                          '${contract.portAsal} - ${contract.portTujuan}',
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontFamily:
                                                                'Poppins Bold',
                                                          ),
                                                        ),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              'Origin Port: ${contract.portAsal}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins Med',
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              'Destination Port: ${contract.portTujuan}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins Med',
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              'Shipping Line: ${contract.pelayaran}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins Med',
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              'Jenis Pengiriman: ${contract.pengiriman}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins Med',
                                                                  fontSize: 12),
                                                            ),
                                                            Text(
                                                              'Rate: Rp ${contract.formattedHarga}',
                                                              style: TextStyle(
                                                                  fontFamily:
                                                                      'Poppins Med',
                                                                  fontSize: 12),
                                                            ),
                                                          ],
                                                        ),
                                                        onTap: () {
                                                          setState(() {
                                                            selectedContract =
                                                                contract;
                                                          });
                                                          _kontrakController
                                                                  .text =
                                                              '${contract.portAsal} - ${contract.portTujuan}';
                                                          Navigator.pop(context);
                                                          print(
                                                              'Selected contract: ${contract.contractNo}');
                                                        },
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
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
                                          horizontal: 10.0, vertical: 11.0),
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
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                      labelStyle:
                                          TextStyle(fontFamily: 'Montserrat')),
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
                              'UOM',
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
                        // Container(
                        //   height: 40,
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
                        //           controller: _UOMController,
                        //           textInputAction: TextInputAction.next,
                        //           decoration: InputDecoration(
                        //               border: InputBorder.none,
                        //               hintText: "Pilih Satuan Produk",
                        //               hintStyle: TextStyle(
                        //                 fontSize: 12,
                        //                 fontFamily: 'Poppins Regular',
                        //                 color: Colors.grey,
                        //               ),
                        //               contentPadding: EdgeInsets.symmetric(
                        //                   horizontal: 10.0, vertical: 13.0),
                        //               fillColor: Colors.grey[600],
                        //               labelStyle: TextStyle(fontFamily: 'Montserrat')),
                        //           style: TextStyle(
                        //               color: Colors.black,
                        //               fontSize: 14.0,
                        //               fontFamily: 'Montserrat'),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        //DROPDOWN SEARCH
                        Container(
                          height: 40,
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          child: DropdownSearch<UOMAccesses>(
                            items: uomList, // Pass the list of UOMAccesses
                            // itemAsString: (UOMAccesses? item) =>
                            //     item?.description ??
                            //     '', // Display the description in the dropdown
                            itemAsString: (UOMAccesses? item) =>
                                item?.uomCode ??
                                '', // Display the description in the dropdown
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                hintText: "Pilih Satuan Produk",
                                hintStyle: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Poppins Regular',
                                  color: Colors.grey,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 11.0),
                              ),
                            ),
                            onChanged: (UOMAccesses? selectedItem) {
                              // Handle selection: print or save the uomCode
                              if (selectedItem != null) {
                                print(
                                    "Selected UOM Code: ${selectedItem.uomCode}");
                                setState(() {
                                  _selectedUOM =
                                      selectedItem; // Save the selected item
                                });
                                print(
                                    // "Selected UOM Description: ${selectedItem.description}");
                                    "Selected UOM Description: ${selectedItem.uomCode}");
                              }
                            },
                            popupProps: PopupProps.menu(
                              showSearchBox: true,
                            ),
                            // selectedItem: null, // No default selection
                            selectedItem: _selectedUOM,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Jumlah Produk',
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
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                  controller: _jumlahProdukController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Masukkan Jumlah Produk",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 11.0),
                                      fillColor: Colors.grey[600],
                                      labelStyle:
                                          TextStyle(fontFamily: 'Montserrat')),
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
                              'Berat Total (KG)',
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
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Masukkan Berat Total",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 11.0),
                                      fillColor: Colors.grey[600],
                                      labelStyle:
                                          TextStyle(fontFamily: 'Montserrat')),
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
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                    hintText: "Masukkan Deskripsi Produk",
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
                          children: [
                            Text(
                              'Dimensi (package)',
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
                        Row(
                          children: [
                            // Container for Panjang
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: TextFormField(
                                    controller: _panjangController,
                                    onChanged: (value) {
                                      print(
                                          "Panjang Input: '${_panjangController.text.trim()}'");
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Panjang (cm)",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 10.0),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Container for Lebar
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: TextFormField(
                                    controller: _lebarController,
                                    onChanged: (value) {
                                      print(
                                          "Lebar Input: '${_lebarController.text.trim()}'");
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Lebar (cm)",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10.0),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            // Container for Tinggi
                            Expanded(
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10.0)),
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: TextFormField(
                                    controller: _tinggiController,
                                    onChanged: (value) {
                                      print(
                                          "Tinggi Input: '${_tinggiController.text.trim()}'");
                                    },
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Tinggi (cm)",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10.0, vertical: 10.0),
                                    ),
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Text(
                              'Volume Total (M3)',
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
                        // Container(
                        //   height: 40,
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
                        //           controller: _volumeController,
                        //           textInputAction: TextInputAction.next,
                        //           decoration: InputDecoration(
                        //               border: InputBorder.none,
                        //               hintText: "0",
                        //               hintStyle: TextStyle(
                        //                 fontSize: 12,
                        //                 fontFamily: 'Poppins Regular',
                        //                 color: Colors.grey,
                        //               ),
                        //               contentPadding: EdgeInsets.symmetric(
                        //                   horizontal: 10.0, vertical: 12.0),
                        //               fillColor: Colors.grey[600],
                        //               labelStyle: TextStyle(fontFamily: 'Montserrat')),
                        //           style: TextStyle(
                        //               color: Colors.black,
                        //               fontSize: 14.0,
                        //               fontFamily: 'Montserrat'),
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
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
                                      horizontal: 10.0, vertical: 10.0),
                                  child: Text(
                                    // '0',
                                    _result.toStringAsFixed(4),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontFamily: 'Poppins Regular',
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
                                      labelStyle:
                                          TextStyle(fontFamily: 'Montserrat')),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'Montserrat'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40),
                        Center(
                          child: SizedBox(
                            width: 300,
                            height: 40,
                            child: Material(
                              borderRadius: BorderRadius.circular(7.0),
                              color: Colors.red[900],
                              //membuat bayangan pada button Detail
                              // shadowColor: Colors.grey[350],
                              // elevation: 5,
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
                if (isContractLCLNiagaInProgress)
                // if (state is ContractLCLNiagaInProgress)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
              ],
            );
          },
        ),
      ),]
    );
  }

  komoditi() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Untuk produk DG (Dangerous Good) harap menghubungi ",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppin',
                    fontSize: 14,
                  ),
                ),
                TextSpan(
                  text: "Customer Service",
                  style: TextStyle(
                    color: Colors.blue,
                    fontFamily: 'Poppin',
                    fontSize: 14,
                    decoration: TextDecoration
                        .underline, // Optionally underline the text
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      const url = 'https://wa.me/6282245465151';
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        // Handle error
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not launch WhatsApp')),
                        );
                      }
                    },
                ),
              ],
            ),
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

  kontrak() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            "Harga ditentukan berdasarkan acuan nilai berat atau ukuran (dipilih nominal yang terbesar).",
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
