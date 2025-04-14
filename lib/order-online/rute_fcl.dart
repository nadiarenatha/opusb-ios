import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/alamat_cubit.dart';
import '../cubit/niaga/contract_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../cubit/niaga/order_online_fcl_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/alamat.dart';
import '../model/niaga/alamat_bongkar.dart';
import '../model/niaga/master_lokasi.dart';
import '../model/niaga/master_lokasi_bongkar.dart';
import '../model/niaga/port_asal_fcl.dart';
import '../model/niaga/port_tujuan_fcl.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'detail_fcl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class RuteFCL extends StatefulWidget {
  const RuteFCL({super.key});

  @override
  State<RuteFCL> createState() => _RuteFCLState();
}

class _RuteFCLState extends State<RuteFCL> {
  int _selectedIndex = 0;
  bool isSelected = false;
  TextEditingController _pelabuhanTujuanController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _alamatMuatController = TextEditingController();
  TextEditingController _detailAlamatMuatController = TextEditingController();
  TextEditingController _picMuatController = TextEditingController();
  TextEditingController _telpPICMuatController = TextEditingController();
  TextEditingController _alamatBongkarController = TextEditingController();
  TextEditingController _detailAlamatBongkarController =
      TextEditingController();
  TextEditingController _picBongkarController = TextEditingController();
  TextEditingController _telpPICBongkarController = TextEditingController();
  TextEditingController _detailAlamatMuatMasterLokasiController =
      TextEditingController();
  TextEditingController _picMuatMasterLokasiController =
      TextEditingController();
  TextEditingController _telpPICMuatMasterLokasiController =
      TextEditingController();
  TextEditingController _detailAlamatBongkarMasterLokasiController =
      TextEditingController();
  TextEditingController _picBongkarMasterLokasiController =
      TextEditingController();
  TextEditingController _telpPICBongkarMasterLokasiController =
      TextEditingController();

  DataLoginAccesses? dataLogin;
  bool isFetchingKotaTujuan = false;

  bool isContractFCL = false;

  String? selectedKotaAsal;
  String? selectedKotaTujuan;
  String? selectedPortAsal;
  List<String> kotaAsalList = [];
  List<String> kotaTujuanList = [];
  Map<String, List<String>> kotaTujuanMap = {}; // Map kotaAsal to kotaTujuan
  List<PortAsalFCLAccesses> portAsalModellist = [];
  List<PortTujuanFCLAccesses> portTujuanModellist = [];
  Map<String, String> portAsalToKotaAsalMap = {}; // Maps portAsal to kotaAsal
  Map<String, String> kotaTujuanToPortTujuanMap =
      {}; // Maps kotaTujuan to portTujuan
  // String? selectedPortTujuan;
  String? selectedPortTujuan;

  //get loc id kota asal
  Map<String, String> kotaAsalToLocIdMap = {};
  String? selectedLocIdAsal;
  //get loc id kota tujuan
  Map<String, String> kotaTujuanToLocIdMap = {};
  String? selectedLocIdTujuan;
  //get loc id uoc asal Owner Code Online
  Map<String, String?> nameUOCAsalToLocIdMap = {};
  Map<String, String?> nameUOCAsalToKotaMap = {};
  Map<String, String?> nameUOCAsalToDetailAlamatMap = {};
  String? selectedLocIdUOCAsal;
  String? selectedValueCityAsal;
  String? selectedValueDetailAlamatMuatAsal;
  //get loc id uoc tujuan Owner Code Online
  String? _selectedLocIdBongkar;

  //get loc id uoc asal Owner Code Khusus
  Map<String, String?> nameUOCAsalToLocIdMapMasterLokasi = {};
  Map<String, String?> nameUOCAsalToKotaMapMasterLokasi = {};
  Map<String, String?> nameUOCAsalToDetailAlamatMuatMapMasterLokasi = {};
  String? selectedLocIdUOCAsalMasterLokasi;
  String? selectedValueCityAsalMasterLokasi;
  String? selectedValueDetailAlamatMuatAsalMasterLokasi;

  //get loc id uoc tujuan Owner Code Khusus
  String? _selectedLocIdBongkarMasterLokasi;

  //Muat Owner Code Online
  AlamatAccesses? _selectedAlamat;
  List<AlamatAccesses> _alamatOptions = [];
  late TextEditingController detailAlamatMuatController;

  //Bongkar Owner Code Online
  String? _selectedAlamatBongkar;
  List<String> _alamatBongkarOptions = [];
  late TextEditingController detailAlamatBongkarController;
  List<AlamatBongkarAccesses> _alamatBongkarResponse = [];
  Map<String, String?> nameUOCTujuanToKotaMap = {};
  Map<String, String?> nameUOCTujuanToDetailAlamatBongkarMap = {};
  String? selectedValueCityBongkar;
  String? selectedValueDetailAlamatBongkar;

  //Muat Master Lokasi Owner Code Khusus
  MasterLokasiAccesses? _selectedAlamatMasterLokasi;
  List<MasterLokasiAccesses> _alamatOptionsMasterLokasi = [];
  late TextEditingController detailAlamatMuatMasterLokasiController;

  //Bongkar Master Lokasi Owner Code Khusus
  List<MasterLokasiBongkarAccesses> _alamatBongkarMasterLokasiOptions = [];
  List<MasterLokasiBongkarAccesses> _alamatBongkarMasterLokasiResponse = [];
  Map<String, String?> nameUOCTujuanToKotaMapMasterLokasi = {};
  Map<String, String?> nameUOCTujuanToDetailAlamatBongkarMapMasterLokasi = {};
  String? _selectedAlamatBongkarMasterLokasi;
  String? selectedValueCityBongkarMasterLokasi;
  String? selectedValueDetailAlamatBongkarMasterLokasi;

  String? formattedDate;

  //Muat Owner Code Online
  void fetchAlamat(String port, String kota) {
    // context.read<UOCListSearchCubit>().uOCListSearchMuat(kota, port);
    context.read<AlamatNiagaCubit>().alamatMuat(port, '');
  }

  //Muat Owner Code Khusus
  void fetchAlamatKhusus(String port) {
    context.read<AlamatNiagaCubit>().masterLokasiMuat(port);
  }

  void dispose() {
    // _namaPengirimController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: ''),
    HomeNiagaPage(),
    MenuInvoiceNiagaPage(),
    ProfileNiagaPage(),
  ];

  @override
  void initState() {
    super.initState();
    detailAlamatMuatController = TextEditingController();
    detailAlamatBongkarController = TextEditingController();
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortAsalFCL();

    _dateController.addListener(() {
      String text = _dateController.text;

      // Remove any non-digit characters
      text = text.replaceAll(RegExp(r'[^0-9]'), '');

      // Automatically format the input as dd/mm/yyyy
      if (text.length >= 2 && text.length <= 4) {
        text = text.substring(0, 2) +
            (text.length >= 3 ? '/' + text.substring(2) : '');
      } else if (text.length > 4) {
        text = text.substring(0, 2) +
            '/' +
            text.substring(2, 4) +
            '/' +
            text.substring(4, min(8, text.length)); // Use min here
      }

      // Update the controller text with formatted date
      _dateController.value = _dateController.value.copyWith(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    });
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

  void fetchKotaTujuan(String portAsal) {
    print("Fetching Kota Tujuan for Port Asal: $portAsal");
    setState(() {
      isFetchingKotaTujuan = true;
    });
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortTujuanFCL(portAsal);
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  Future failGetContract() => showDialog(
      context: context,
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: failContract()),
            ),
          ));

  failContract() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Maaf Area yang Anda Tuju Tidak Tercover",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppin',
                  fontWeight: FontWeight.w900),
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
                    "OK",
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
        ],
      ),
    );
  }

  //untuk fungsi calendar pada pop up dialog search dengan nama _dateController
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(2000), // The earliest date the user can pick
      lastDate: DateTime(2101), // The latest date the user can pick
      // lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        // controller.text = "${picked.day}/${picked.month}/${picked.year}";
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().padLeft(4, '0')}";
      });
    }
    // if (picked != null) {
    //   // Reset the time to 00:00:00.000
    //   final DateTime resetTime =
    //       DateTime(picked.year, picked.month, picked.day);
    //   print("Selected Date (Reset to 00:00:00): $resetTime");

    //   // Format the date
    //   // final formattedDate = DateFormat("dd/MM/yyyy").format(resetTime);
    //   final String formattedDate =
    //       DateFormat("dd/MM/yyyy HH:mm:ss.SSS").format(resetTime);

    //   print("Formatted Date: $formattedDate");

    //   // Update the controller
    //   controller.text = formattedDate;
    // }
  }

  //====
  Future<void> alertKontrak(BuildContext context, List<String> messages) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        titlePadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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

    String tanggal = _dateController.text.trim();
    String alamatMuat = _alamatMuatController.text.trim();
    String detailAlamatMuat = _detailAlamatMuatController.text.trim();
    String picMuat = _picMuatController.text.trim();
    String telpPICMuat = _telpPICMuatController.text.trim();
    String alamatBongkar = _alamatBongkarController.text.trim();
    String detailAlamatBongkar = _detailAlamatBongkarController.text.trim();
    String picBongkar = _picBongkarController.text.trim();
    String telpPICBongkar = _telpPICBongkarController.text.trim();
    String detailAlamatMuatMasterLokasi =
        _detailAlamatMuatMasterLokasiController.text.trim();
    String picMuatMasterLokasi = _picMuatMasterLokasiController.text.trim();
    String telpPICMuatMasterLokasi =
        _telpPICMuatMasterLokasiController.text.trim();
    String detailAlamatBongkarMasterLokasi =
        _detailAlamatBongkarMasterLokasiController.text.trim();
    String picBongkarMasterLokasi =
        _picBongkarMasterLokasiController.text.trim();
    String telpPICBongkarMasterLokasi =
        _telpPICBongkarMasterLokasiController.text.trim();

    if (selectedKotaAsal == null || selectedKotaAsal!.isEmpty) {
      errorMessages.add("Kota Asal tidak boleh kosong !");
    }
    if (selectedKotaTujuan == null || selectedKotaTujuan!.isEmpty) {
      errorMessages.add("Kota Tujuan tidak boleh kosong !");
    }
    if (tanggal.isEmpty) {
      errorMessages.add("Tanggal Cargo tidak boleh kosong !");
    }
    // if (_selectedAlamat == null) {
    //   errorMessages.add("Alamat Muat tidak boleh kosong !");
    // }
    if (dataLogin!.ownerCode == 'ONLINE' && _selectedAlamat == null) {
      errorMessages.add("Alamat Muat tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        _selectedAlamatMasterLokasi == null) {
      errorMessages.add("Alamat Muat tidak boleh kosong !");
    }
    if (dataLogin!.ownerCode == 'ONLINE' && detailAlamatMuat.isEmpty) {
      errorMessages.add("Detail Alamat Muat tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        detailAlamatMuatMasterLokasi.isEmpty) {
      errorMessages.add("Detail Alamat Muat tidak boleh kosong !");
    }
    // if (picMuat.isEmpty) {
    //   errorMessages.add("PIC Muat tidak boleh kosong !");
    // }
    if (dataLogin!.ownerCode == 'ONLINE' && picMuat.isEmpty) {
      errorMessages.add("PIC Muat tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        picMuatMasterLokasi.isEmpty) {
      errorMessages.add("PIC Muat tidak boleh kosong !");
    }

    // if (telpPICMuat.isEmpty) {
    //   errorMessages.add("Telp PIC Muat tidak boleh kosong !");
    // }
    if (dataLogin!.ownerCode == 'ONLINE' && telpPICMuat.isEmpty) {
      errorMessages.add("Telp PIC Muat tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        telpPICMuatMasterLokasi.isEmpty) {
      errorMessages.add("Telp PIC Muat tidak boleh kosong !");
    }
    // if (_selectedAlamatBongkar == null || _selectedAlamatBongkar!.isEmpty) {
    //   errorMessages.add("Alamat Bongkar tidak boleh kosong !");
    // }
    if (dataLogin!.ownerCode == 'ONLINE' && _selectedAlamatBongkar == null) {
      errorMessages.add("Alamat Bongkar tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        _selectedAlamatBongkarMasterLokasi == null) {
      errorMessages.add("Alamat Bongkar tidak boleh kosong !");
    }
    // if (detailAlamatBongkar.isEmpty) {
    //   errorMessages.add("Detail Alamat Bongkar tidak boleh kosong !");
    // }
    if (dataLogin!.ownerCode == 'ONLINE' && detailAlamatBongkar.isEmpty) {
      errorMessages.add("Detail Alamat Bongkar tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        detailAlamatBongkarMasterLokasi.isEmpty) {
      errorMessages.add("Detail Alamat Bongkar tidak boleh kosong !");
    }
    // if (picBongkar.isEmpty) {
    //   errorMessages.add("PIC Bongkar tidak boleh kosong !");
    // }
    if (dataLogin!.ownerCode == 'ONLINE' && picBongkar.isEmpty) {
      errorMessages.add("PIC Bongkar tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        picBongkarMasterLokasi.isEmpty) {
      errorMessages.add("PIC Bongkar tidak boleh kosong !");
    }
    // if (telpPICBongkar.isEmpty) {
    //   errorMessages.add("Telp PIC Bongkar tidak boleh kosong !");
    // }
    if (dataLogin!.ownerCode == 'ONLINE' && telpPICBongkar.isEmpty) {
      errorMessages.add("Telp PIC Bongkar tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        telpPICBongkarMasterLokasi.isEmpty) {
      errorMessages.add("Telp PIC Bongkar tidak boleh kosong !");
    }

    if (errorMessages.isNotEmpty) {
      alertKontrak(context, errorMessages);
    } else {
      String? portTujuan = selectedKotaTujuan != null
          ? kotaTujuanToPortTujuanMap[selectedKotaTujuan]
          : null;

      print('Port Asal: ${selectedPortAsal ?? ''}');
      // print('Port Tujuan: ${selectedPortTujuan ?? ''}');
      print('Port Tujuan: ${portTujuan ?? ''}');
      print('Kota Asal: ${selectedKotaAsal ?? ''}');
      print('Kota Tujuan: ${selectedKotaTujuan ?? ''}');
      print('Nama Alamat Muat: ${selectedValueCityAsal ?? ''}');
      print('Nama Alamat Bongkar: ${selectedValueCityBongkar ?? ''}');

      // Proceed with your logic here if all fields are not empty
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DetailFCL(
            portAsal: selectedPortAsal ?? '',
            // portTujuan: selectedPortTujuan ?? '',
            portTujuan: portTujuan ?? '',
            kotaAsal: selectedKotaAsal ?? '',
            kotaTujuan: selectedKotaTujuan ?? '',
            tanggalCargo: _dateController.text,
            // namaAlamatMuat: _selectedAlamat.toString(),
            namaAlamatMuat: dataLogin!.ownerCode == 'ONLINE'
                ? selectedValueCityAsal.toString()
                : selectedValueCityAsalMasterLokasi.toString(),
            // detailAlamatMuat: _detailAlamatMuatController.text,
            detailAlamatMuat: dataLogin!.ownerCode == 'ONLINE'
                ? _detailAlamatMuatController.text
                : _detailAlamatMuatMasterLokasiController.text,
            // picMuat: _picMuatController.text,
            picMuat: dataLogin!.ownerCode == 'ONLINE'
                ? _picMuatController.text
                : _picMuatMasterLokasiController.text,
            // telpPicMuat: _telpPICMuatController.text,
            telpPicMuat: dataLogin!.ownerCode == 'ONLINE'
                ? _telpPICMuatController.text
                : _telpPICMuatMasterLokasiController.text,
            // namaAlamatBongkar: _selectedAlamatBongkar.toString(),
            // namaAlamatBongkar: selectedValueCityBongkar.toString(),
            namaAlamatBongkar: dataLogin!.ownerCode == 'ONLINE'
                ? selectedValueCityBongkar.toString()
                : selectedValueCityBongkarMasterLokasi.toString(),
            // detailAlamatBongkar: _detailAlamatBongkarController.text,
            detailAlamatBongkar: dataLogin!.ownerCode == 'ONLINE'
                ? _detailAlamatBongkarController.text
                : _detailAlamatBongkarMasterLokasiController.text,
            // picBongkar: _picBongkarController.text,
            picBongkar: dataLogin!.ownerCode == 'ONLINE'
                ? _picBongkarController.text
                : _picBongkarMasterLokasiController.text,
            // telpPicBongkar: _telpPICBongkarController.text,
            telpPicBongkar: dataLogin!.ownerCode == 'ONLINE'
                ? _telpPICBongkarController.text
                : _telpPICBongkarMasterLokasiController.text,
            locIDPortAsal: selectedLocIdAsal.toString(),
            locIDPortTujuan: selectedLocIdTujuan.toString(),
            // locIDUOCAsal: selectedLocIdUOCAsal.toString(),
            locIDUOCAsal: dataLogin!.ownerCode == 'ONLINE'
                ? selectedLocIdUOCAsal.toString()
                : selectedLocIdUOCAsalMasterLokasi.toString(),
            // locIDUOCTujuan: _selectedLocIdBongkar.toString()
            locIDUOCTujuan: dataLogin!.ownerCode == 'ONLINE'
                ? _selectedLocIdBongkar.toString()
                : _selectedLocIdBongkarMasterLokasi.toString());
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            // 0.08 * MediaQuery.of(context).size.height,
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
            // title: Row(
            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //   children: [
            //     Text(
            //       "Pemesanan",
            //       style: TextStyle(
            //         fontSize: 20,
            //         color: Colors.red[900],
            //         fontFamily: 'Poppin',
            //         fontWeight: FontWeight.w900,
            //       ),
            //     ),
            //   ],
            // ),
            // bottom: PreferredSize(
            //   preferredSize: Size.fromHeight(50.0),
            //   child: Padding(
            //     // padding: const EdgeInsets.symmetric(horizontal: 8.0),
            //     padding: EdgeInsets.all(20.0),
            //     child: Row(
            //       children: [
            //         Expanded(child: _buildStepItem('1.', 'Rute', 1)),
            //         _buildSeparator(),
            //         Expanded(child: _buildStepItem('2.', 'Detail', 2)),
            //         _buildSeparator(),
            //         Expanded(child: _buildStepItem('3.', 'Summary', 3)),
            //         _buildSeparator(),
            //         Expanded(child: _buildStepItem('4.', 'Konfirmasi', 4)),
            //       ],
            //     ),
            //   ),
            // ),
            // toolbarHeight: 0.08 * MediaQuery.of(context).size.height,
            //new
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
        body: BlocConsumer<OrderOnlineFCLCubit, OrderOnlineFCLState>(
            listener: (context, state) {
          if (state is PortAsalFCLSuccess) {
            print("Kota Asal: ${state.response}");
            setState(() {
              // Populate portAsalToKotaAsalMap for mapping
              portAsalToKotaAsalMap = {
                for (var port in state.response)
                  port.portAsal ?? '': port.kotaAsal ?? ''
              };

              // Populate kotaAsalList with portAsal
              kotaAsalList = portAsalToKotaAsalMap.keys
                  .where((portAsal) => portAsal.isNotEmpty)
                  .toList();

              kotaAsalToLocIdMap = {
                for (var port in state.response)
                  port.kotaAsal ?? '': port.locIdAsal ?? ''
              };

              // Reset the selected Kota Tujuan when Kota Asal changes
              selectedKotaTujuan = null;
              kotaTujuanList = [];
            });
          }
          if (state is PortTujuanFCLSuccess) {
            print("Kota Tujuan fetched successfully: ${state.response}");
            setState(() {
              isFetchingKotaTujuan = false;

              kotaTujuanToPortTujuanMap = {
                for (var port in state.response)
                  port.kotaTujuan ?? '': port.portTujuan ?? ''
              };

              kotaTujuanList = kotaTujuanToPortTujuanMap.keys
                  .where((kotaTujuan) => kotaTujuan.isNotEmpty)
                  .toList();

              kotaTujuanToLocIdMap = {
                for (var port in state.response)
                  port.kotaTujuan ?? '': port.locIdTujuan ?? ''
              };
            });
            print(
                "Map of kotaTujuan to portTujuan: $kotaTujuanToPortTujuanMap");
          }
          if (state is PortTujuanFCLInProgress) {
            setState(() {
              isFetchingKotaTujuan = true;
            });
          }
          if (state is PortTujuanFCLFailure) {
            setState(() {
              isFetchingKotaTujuan = false;
            });
          }
        }, builder: (context, state) {
          if (state is PortAsalFCLInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return BlocConsumer<AlamatNiagaCubit, AlamatNiagaState>(
              listener: (context, state) {
            if (state is AlamatBongkarNiagaSuccess) {
              print("Fetched Alamat Bongkar successfully: ${state.response}");
              // Update _alamatBongkarOptions with filtered NAME values
              _alamatBongkarOptions = state.response
                  .where((item) =>
                      selectedPortTujuan == null) // Filter by portCode
                  .map((item) => item.name ?? '') // Extract NAME
                  .where((name) => name.isNotEmpty) // Ensure non-empty names
                  .toList();
              _alamatBongkarResponse = state.response;
              nameUOCTujuanToKotaMap = {
                for (var item in state.response) item.name ?? '': item.kota
              };
              nameUOCTujuanToDetailAlamatBongkarMap = {
                for (var item in state.response)
                  item.name ?? '': item.detailAlamatBongkar
              };
              print(
                  'Detail Alamat Bongkar: $nameUOCTujuanToDetailAlamatBongkarMap');
            } else if (state is AlamatMuatNiagaSuccess) {
              print("Fetched Alamat Muat successfully: ${state.response}");
              _alamatOptions = state.response
                  .where((item) => item.name?.isNotEmpty ?? false)
                  .toList();
              //LAMA
              // _alamatOptions = state.response
              //     .map((item) => item.name ?? '') // Extract NAME
              //     .where((name) => name.isNotEmpty)
              //     .toList();
              nameUOCAsalToLocIdMap = {
                for (var item in state.response) item.name ?? '': item.locID
              };
              nameUOCAsalToKotaMap = {
                for (var item in state.response) item.name ?? '': item.kota
              };
              nameUOCAsalToDetailAlamatMap = {
                for (var item in state.response)
                  item.name ?? '': item.detailAlamatMuat
              };
              print("Mapped LocID: $nameUOCAsalToLocIdMap");
              print("Mapped City: $nameUOCAsalToKotaMap");
              print("Mapped Detail Alamat Muat: $nameUOCAsalToDetailAlamatMap");
            } else if (state is MasterLokasiMuatSuccess) {
              print(
                  "Fetched Alamat Muat Master Lokasi successfully: ${state.response}");
              _alamatOptionsMasterLokasi = state.response
                  .where((item) => item.pilihAlamatMuat?.isNotEmpty ?? false)
                  .toList();

              nameUOCAsalToLocIdMapMasterLokasi = {
                for (var item in state.response)
                  item.pilihAlamatMuat ?? '': item.locID
              };
              nameUOCAsalToKotaMapMasterLokasi = {
                for (var item in state.response)
                  item.pilihAlamatMuat ?? '': item.kota
              };
              nameUOCAsalToDetailAlamatMuatMapMasterLokasi = {
                for (var item in state.response)
                  item.pilihAlamatMuat ?? '': item.detailAlamatMuat
              };

              print(
                  "Mapped LocID Master Lokasi: $nameUOCAsalToLocIdMapMasterLokasi");
              print(
                  "Mapped City Master Lokasi: $nameUOCAsalToKotaMapMasterLokasi");
              print(
                  "Mapped Detail Alamat Muat Master Lokasi: $nameUOCAsalToDetailAlamatMuatMapMasterLokasi");
            } else if (state is MasterLokasiBongkarSuccess) {
              print(
                  "Fetched Alamat Bongkar Master Lokasi successfully: ${state.response}");

              _alamatBongkarMasterLokasiOptions = state.response
                  .where(
                      (item) => item.detailAlamatBongkar?.isNotEmpty ?? false)
                  .toList();

              _alamatBongkarMasterLokasiResponse = state.response;
              nameUOCTujuanToKotaMapMasterLokasi = {
                for (var item in state.response)
                  item.pilihAlamatBongkar ?? '': item.kota
              };
              nameUOCTujuanToDetailAlamatBongkarMapMasterLokasi = {
                for (var item in state.response)
                  item.pilihAlamatBongkar ?? '': item.detailAlamatBongkar
              };
              print(
                  "Mapped City Bongkar Master Lokasi: $nameUOCTujuanToKotaMapMasterLokasi");
              print(
                  "Mapped Detail Alamat Bongkar Master Lokasi: $nameUOCTujuanToDetailAlamatBongkarMapMasterLokasi");

              //Alert jika informasi bongkar kosong
              // if (_alamatBongkarMasterLokasiOptions.isEmpty) {
              //   Future.delayed(Duration.zero, () {
              //     showDialog(
              //       context: context,
              //       builder: (BuildContext context) {
              //         return AlertDialog(
              //           title: Text('Peringatan'),
              //           content: Text('Data dengan kota ini tidak tersedia!'),
              //           actions: [
              //             TextButton(
              //               child: Text('OK'),
              //               onPressed: () {
              //                 Navigator.of(context).pop();
              //               },
              //             ),
              //           ],
              //         );
              //       },
              //     );
              //   });
              // }
            }
          }, builder: (context, state) {
            return BlocConsumer<DataLoginCubit, DataLoginState>(
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
                if (state is ContractFCLNiagaFailure) {
                  print("ContractFCLNiagaFailure jalan");
                  failGetContract();
                }
              }, builder: (context, state) {
                bool isFail = state is ContractFCLNiagaFailure;
                return Stack(children: [
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
                                'Kota Asal',
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
                          //dropdown biasa
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 6),
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Colors.black),
                          //       borderRadius: BorderRadius.circular(5.0)),
                          //   child: DropdownButtonFormField<String>(
                          //     value: selectedKotaAsal,
                          //     hint: Text('Pilih Pelabuhan Asal',
                          //         style: TextStyle(fontSize: 14)),
                          //     onChanged: (String? newValue) {
                          //       setState(() {
                          //         selectedKotaAsal = newValue;
                          //         selectedKotaTujuan =
                          //             null; // Reset the selected Kota Tujuan
                          //         kotaTujuanList =
                          //             []; // Clear the previous Kota Tujuan list
                          //         if (newValue != null) {
                          //           fetchKotaTujuan(newValue);
                          //         }
                          //       });
                          //     },
                          //     // items: kotaAsalList
                          //     //     .map<DropdownMenuItem<String>>((String value) {
                          //     //   return DropdownMenuItem<String>(
                          //     //     value: value,
                          //     //     child:
                          //     //         Text(value, style: TextStyle(fontSize: 14)),
                          //     //   );
                          //     // }).toList(),
                          //     items: kotaAsalList
                          //         .map<DropdownMenuItem<String>>((String portAsal) {
                          //       return DropdownMenuItem<String>(
                          //         value: portAsal, // Use portAsal as value
                          //         child: Text(portAsalToKotaAsalMap[portAsal] ?? '',
                          //             style: TextStyle(
                          //                 fontSize: 14)), // Display kotaAsal
                          //       );
                          //     }).toList(),
                          //     decoration: InputDecoration(
                          //         contentPadding: EdgeInsets.symmetric(horizontal: 6),
                          //         border: InputBorder.none),
                          //     iconSize: 20,
                          //   ),
                          // ),
                          //dropdown search UOC Search
                          // Container(
                          //   height: 40,
                          //   padding: EdgeInsets.symmetric(horizontal: 6),
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     border: Border.all(color: Colors.black),
                          //     borderRadius: BorderRadius.circular(5.0),
                          //   ),
                          //   child: DropdownSearch<String>(
                          //     items: kotaAsalList.map((portAsal) {
                          //       return portAsalToKotaAsalMap[portAsal] ?? '';
                          //     }).toList(),
                          //     dropdownDecoratorProps: DropDownDecoratorProps(
                          //       dropdownSearchDecoration: InputDecoration(
                          //         hintText: "Pilih Kota Asal",
                          //         hintStyle: TextStyle(
                          //           fontSize: 12,
                          //           fontFamily: 'Poppins Regular',
                          //           color: Colors.grey,
                          //         ),
                          //         border: InputBorder.none,
                          //         contentPadding: EdgeInsets.symmetric(
                          //             horizontal: 10.0, vertical: 12.0),
                          //       ),
                          //     ),
                          //     onChanged: (String? newValue) {
                          //       // Handle selection
                          //       print("Selected Kota Asal: $newValue");
                          //       setState(() {
                          //         // Reverse lookup to get the corresponding portAsal from kotaAsal
                          //         selectedPortAsal =
                          //             portAsalToKotaAsalMap.keys.firstWhere(
                          //           (portAsal) =>
                          //               portAsalToKotaAsalMap[portAsal] == newValue,
                          //           orElse: () => '',
                          //         );
                          //         selectedKotaAsal = newValue;

                          //         // Reset the selected Kota Tujuan when Kota Asal changes
                          //         selectedKotaTujuan = null;
                          //         kotaTujuanList = [];
                          //         if (selectedPortAsal != null) {
                          //           fetchKotaTujuan(selectedPortAsal!);
                          //           // fetchAlamat(
                          //           //     selectedKotaAsal!, selectedPortAsal!);
                          //           fetchAlamat('', selectedPortAsal!);
                          //         }
                          //       });
                          //     },
                          //     popupProps: PopupProps.menu(
                          //       showSearchBox: true,
                          //     ),
                          //     // selectedItem: null, // No default selection
                          //     selectedItem: selectedKotaAsal, // No default selection
                          //   ),
                          // ),
                          //UNION ALAMAT
                          Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: DropdownSearch<String>(
                              items: kotaAsalList.map((portAsal) {
                                return portAsalToKotaAsalMap[portAsal] ?? '';
                              }).toList(),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Pilih Kota Asal",
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
                              onChanged: (String? newValue) {
                                // Handle selection
                                print("Selected Kota Asal: $newValue");
                                setState(() {
                                  // Reverse lookup to get the corresponding portAsal from kotaAsal
                                  selectedPortAsal =
                                      portAsalToKotaAsalMap.keys.firstWhere(
                                    (portAsal) =>
                                        portAsalToKotaAsalMap[portAsal] ==
                                        newValue,
                                    orElse: () => '',
                                  );
                                  selectedKotaAsal = newValue;
                                  // final selectedLocIdAsal =
                                  //     kotaAsalToLocIdMap[newValue ?? ''];
                                  selectedLocIdAsal =
                                      kotaAsalToLocIdMap[newValue ?? ''];
                                  print(
                                      "Selected LocId Kota Asal: $selectedLocIdAsal");

                                  // Reset the selected Kota Tujuan when Kota Asal changes
                                  selectedKotaTujuan = null;
                                  kotaTujuanList = [];
                                  if (selectedPortAsal != null) {
                                    fetchKotaTujuan(selectedPortAsal!);
                                    fetchAlamat(selectedPortAsal!, '');
                                    fetchAlamatKhusus(selectedPortAsal!);
                                  }
                                });
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                              ),
                              // selectedItem: null, // No default selection
                              selectedItem:
                                  selectedKotaAsal, // No default selection
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Kota Tujuan',
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
                          //dropdown biasa
                          // Container(
                          //   padding: EdgeInsets.symmetric(horizontal: 6),
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Colors.black),
                          //       borderRadius: BorderRadius.circular(5.0)),
                          //   child: DropdownButtonFormField<String>(
                          //     value: selectedKotaTujuan,
                          //     hint: Text('Pilih Kota Tujuan',
                          //         style: TextStyle(fontSize: 14)),
                          //     onChanged: (String? newValue) {
                          //       print("Selected Kota Tujuan: $newValue");
                          //       setState(() {
                          //         selectedKotaTujuan = newValue;
                          //       });
                          //     },
                          //     items: kotaTujuanList
                          //         .map<DropdownMenuItem<String>>((String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(value, style: TextStyle(fontSize: 14)),
                          //       );
                          //     }).toList(),
                          //     decoration: InputDecoration(
                          //         contentPadding: EdgeInsets.symmetric(horizontal: 6),
                          //         border: InputBorder.none),
                          //     iconSize: 20,
                          //   ),
                          // ),
                          //dropdown search UOC LIST SEARCH
                          // Container(
                          //   height: 40,
                          //   padding: EdgeInsets.symmetric(horizontal: 6),
                          //   decoration: BoxDecoration(
                          //       color: Colors.white,
                          //       border: Border.all(color: Colors.black),
                          //       borderRadius: BorderRadius.circular(5.0)),
                          //   child: DropdownSearch<String>(
                          //     items: kotaTujuanList,
                          //     dropdownDecoratorProps: DropDownDecoratorProps(
                          //       dropdownSearchDecoration: InputDecoration(
                          //         hintText: "Pilih Kota Tujuan",
                          //         hintStyle: TextStyle(
                          //           fontSize: 12,
                          //           fontFamily: 'Poppins Regular',
                          //           color: Colors.grey,
                          //         ),
                          //         border: InputBorder.none,
                          //         contentPadding: EdgeInsets.symmetric(
                          //             horizontal: 10.0, vertical: 12.0),
                          //       ),
                          //     ),
                          //     onChanged: (String? newValue) {
                          //       // Handle selection
                          //       print("Selected Kota Tujuan: $newValue");
                          //       setState(() {
                          //         selectedKotaTujuan = newValue;

                          //         if (newValue != null &&
                          //             kotaTujuanToPortTujuanMap
                          //                 .containsKey(newValue)) {
                          //           String? selectedPortTujuan =
                          //               kotaTujuanToPortTujuanMap[newValue];
                          //           print(
                          //               "Corresponding Port Tujuan: $selectedPortTujuan");
                          //           //untuk pilih alamat di alamat muat
                          //           fetchAlamat('', selectedPortAsal!);
                          //           // fetchAlamatBongkar(selectedPortTujuan!);
                          //           // context.read<UOCListSearchCubit>().uOCListSearchBongkar(newValue, selectedPortTujuan ?? '');
                          //           context
                          //               .read<UOCListSearchCubit>()
                          //               .uOCListSearchBongkar(
                          //                   '', selectedPortTujuan ?? '');
                          //         }
                          //       });
                          //     },
                          //     popupProps: PopupProps.menu(
                          //       showSearchBox: true,
                          //     ),
                          //     // selectedItem: null, // No default selection
                          //     selectedItem:
                          //         selectedKotaTujuan, // No default selection
                          //   ),
                          // ),
                          //UNION ALAMAT
                          Container(
                            height: 40,
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0)),
                            child: DropdownSearch<String>(
                              items: kotaTujuanList,
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                  hintText: "Pilih Kota Tujuan",
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
                              onChanged: isFetchingKotaTujuan
                                  ? null
                                  : (String? newValue) {
                                      // Handle selection
                                      print("Selected Kota Tujuan: $newValue");
                                      setState(() {
                                        selectedKotaTujuan = newValue;

                                        if (newValue != null &&
                                            kotaTujuanToPortTujuanMap
                                                .containsKey(newValue)) {
                                          String? selectedPortTujuan =
                                              kotaTujuanToPortTujuanMap[
                                                  newValue];
                                          print(
                                              "Corresponding Port Tujuan: $selectedPortTujuan");
                                          // String? selectedLocIdTujuan =
                                          //     kotaTujuanToLocIdMap[newValue ?? ''];
                                          selectedLocIdTujuan =
                                              kotaTujuanToLocIdMap[
                                                  newValue ?? ''];
                                          print(
                                              "Selected LocId Kota Tujuan: $selectedLocIdTujuan");
                                          //untuk pilih alamat di alamat muat
                                          fetchAlamat(selectedPortAsal!, '');
                                          fetchAlamatKhusus(selectedPortAsal!);
                                          context
                                              .read<AlamatNiagaCubit>()
                                              .alamatBongkar(
                                                  selectedPortTujuan ?? '', '');

                                          String? portTujuan =
                                              selectedKotaTujuan != null
                                                  ? kotaTujuanToPortTujuanMap[
                                                      selectedKotaTujuan]
                                                  : null;

                                          context
                                              .read<AlamatNiagaCubit>()
                                              .masterLokasiBongkar(
                                                  portTujuan ?? '');
                                        } else {
                                          print(
                                              "No corresponding portTujuan found for selected kotaTujuan.");
                                          selectedPortTujuan =
                                              selectedPortTujuan; // Reset if not found
                                          selectedKotaTujuan =
                                              selectedKotaTujuan;
                                        }
                                      });

                                      // if (_alamatBongkarMasterLokasiOptions.isEmpty) {
                                      //   Future.delayed(Duration.zero, () {
                                      //     showDialog(
                                      //       context: context,
                                      //       builder: (BuildContext context) {
                                      //         return AlertDialog(
                                      //           title: Text('Peringatan'),
                                      //           content: Text(
                                      //               'Data Informasi dengan kota ini tidak tersedia!'),
                                      //           actions: [
                                      //             TextButton(
                                      //               child: Text('OK'),
                                      //               onPressed: () {
                                      //                 Navigator.of(context).pop();
                                      //               },
                                      //             ),
                                      //           ],
                                      //         );
                                      //       },
                                      //     );
                                      //   });
                                      // }
                                    },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                              ),
                              // selectedItem: null, // No default selection
                              selectedItem:
                                  selectedKotaTujuan, // No default selection
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Jasa/Service',
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
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(
                                      color:
                                          Colors.black, // Set border color here
                                      width: 1.0, // Set border width here
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Text(
                                      'FCL (Full Container Load)',
                                      style: TextStyle(
                                        fontSize: 12,
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
                                'Tipe Pengiriman',
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
                              Expanded(
                                child: Container(
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(
                                      color:
                                          Colors.black, // Set border color here
                                      width: 1.0, // Set border width here
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 10.0),
                                    child: Text(
                                      'DTD (Door to Door)',
                                      style: TextStyle(
                                        fontSize: 12,
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
                                'Tanggal Cargo Siap',
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
                              Expanded(
                                child: Container(
                                  width: 320,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(
                                      color:
                                          Colors.black, // Set border color here
                                      width: 1.0, // Set border width here
                                    ),
                                  ),
                                  //untuk tulisan nama barang
                                  child: TextFormField(
                                    //controller 1 digunakan untuk input tgl di calendar
                                    controller: _dateController,
                                    keyboardType: TextInputType.number,
                                    readOnly: true, // Make the field read-only
                                    onTap: () => _selectDate(context,
                                        _dateController), // Show calendar on tap
                                    decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText:
                                            "Tentukan tanggal pengambilan barang",
                                        hintStyle: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins Regular',
                                          color: Colors.grey,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 11.0),
                                        fillColor: Colors.grey[600],
                                        labelStyle:
                                            TextStyle(fontFamily: 'Montserrat'),
                                        suffixIcon: IconButton(
                                          icon: Icon(Icons.calendar_today),
                                          color: Colors.red[900],
                                          onPressed: () => _selectDate(
                                              context, _dateController),
                                        )),
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Montserrat'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15),
                          Text(
                            'Informasi Muat',
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 15,
                                fontFamily: 'Poppinss'),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Pilih Alamat',
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
                          //dropdown biasa
                          // Container(
                          //   height: 40,
                          //   decoration: BoxDecoration(
                          //     color: Colors.white,
                          //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          //     border: Border.all(
                          //       color: Colors.black,
                          //       width: 1.0,
                          //     ),
                          //   ),
                          //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                          //   child: DropdownButtonFormField<String>(
                          //     decoration: InputDecoration(
                          //       border: InputBorder.none,
                          //       hintText: "Pilih Alamat",
                          //       contentPadding:
                          //           EdgeInsets.symmetric(vertical: 12.0),
                          //     ),
                          //     value: _selectedAlamat,
                          //     icon: Icon(Icons.arrow_drop_down),
                          //     onChanged: (String? newValue) {
                          //       setState(() {
                          //         _selectedAlamat = newValue;
                          //       });
                          //     },
                          //     items: _alamatOptions
                          //         .map<DropdownMenuItem<String>>((String value) {
                          //       return DropdownMenuItem<String>(
                          //         value: value,
                          //         child: Text(
                          //           value,
                          //           style: TextStyle(
                          //             color: Colors.black,
                          //             fontSize: 14.0,
                          //             fontFamily: 'Montserrat',
                          //           ),
                          //         ),
                          //       );
                          //     }).toList(),
                          //   ),
                          // ),
                          //dropdown search
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownSearch<AlamatAccesses>(
                                items: _alamatOptions, // List of distrik names
                                itemAsString: (AlamatAccesses? item) =>
                                    item?.name ?? '',
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Pilih Alamat",
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
                                onChanged: (AlamatAccesses? newValue) {
                                  setState(() {
                                    _selectedAlamat = newValue;

                                    selectedLocIdUOCAsal =
                                        nameUOCAsalToLocIdMap[
                                            newValue?.name ?? ''];

                                    selectedValueCityAsal =
                                        nameUOCAsalToKotaMap[
                                            newValue?.name ?? ''];

                                    selectedValueDetailAlamatMuatAsal =
                                        nameUOCAsalToDetailAlamatMap[
                                            newValue?.name ?? ''];
                                    print(
                                        "Selected LocID UOC Asal: $selectedLocIdUOCAsal");

                                    print(
                                        "Selected Value Kota Asal: $selectedValueCityAsal");

                                    print(
                                        "Selected Value Detail Alamat Muat Asal: $selectedValueDetailAlamatMuatAsal");

                                    if (newValue == null) {
                                      _detailAlamatMuatController.clear();
                                    } else {
                                      _detailAlamatMuatController.text =
                                          newValue.detailAlamatMuat ?? '';
                                      _picMuatController.text =
                                          newValue.picMuatBarang ?? '';
                                      _telpPICMuatController.text =
                                          newValue.noTelpPicMuat ?? '';
                                    }
                                  });
                                  print(
                                      "Selected Alamat Muat: $_selectedAlamat");
                                },
                                selectedItem: _selectedAlamat,
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                ),
                              ),
                            ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'Detail Alamat Muat',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    selectedValueDetailAlamatMuatAsal == null ||
                                            selectedValueDetailAlamatMuatAsal!
                                                .isEmpty
                                        ? Colors.white
                                        : Colors.grey[300],
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
                                      controller: _detailAlamatMuatController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Masukkan detail alamat muat",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins Regular',
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 14.0),
                                          fillColor: Colors.grey[600],
                                          labelStyle: TextStyle(
                                              fontFamily: 'Montserrat')),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat'),
                                      maxLines: null,
                                      enabled:
                                          selectedValueDetailAlamatMuatAsal ==
                                                  null ||
                                              selectedValueDetailAlamatMuatAsal!
                                                  .isEmpty,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'PIC Muat',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _picMuatController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan pic muat",
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'No. Telepon PIC Muat',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _telpPICMuatController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(13),
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan no telp pic muat",
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownSearch<MasterLokasiAccesses>(
                                items:
                                    _alamatOptionsMasterLokasi, // List of distrik names
                                itemAsString: (MasterLokasiAccesses? item) =>
                                    item?.pilihAlamatMuat ?? '',
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Pilih Alamat",
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
                                onChanged: (MasterLokasiAccesses? newValue) {
                                  setState(() {
                                    _selectedAlamatMasterLokasi = newValue;

                                    if (newValue != null) {
                                      selectedLocIdUOCAsalMasterLokasi =
                                          nameUOCAsalToLocIdMapMasterLokasi[
                                              newValue.pilihAlamatMuat ?? ''];
                                      selectedValueCityAsalMasterLokasi =
                                          nameUOCAsalToKotaMapMasterLokasi[
                                              newValue.pilihAlamatMuat ?? ''];

                                      selectedValueDetailAlamatMuatAsalMasterLokasi =
                                          nameUOCAsalToDetailAlamatMuatMapMasterLokasi[
                                              newValue.pilihAlamatMuat ?? ''];

                                      _detailAlamatMuatMasterLokasiController
                                              .text =
                                          newValue.detailAlamatMuat ?? '';
                                      _picMuatMasterLokasiController.text =
                                          newValue.picMuatBarang ?? '';
                                      _telpPICMuatMasterLokasiController.text =
                                          newValue.noTelpPicMuat ?? '';
                                    } else {
                                      selectedLocIdUOCAsalMasterLokasi = null;
                                      selectedValueCityAsalMasterLokasi = null;

                                      _detailAlamatMuatMasterLokasiController
                                          .clear();
                                      _picMuatMasterLokasiController.clear();
                                      _telpPICMuatMasterLokasiController
                                          .clear();
                                    }
                                  });
                                  print(
                                      "Selected LocID UOC Asal Master Lokasi: $selectedLocIdUOCAsalMasterLokasi");
                                  print(
                                      "Selected Value Kota Asal Master Lokasi: $selectedValueCityAsalMasterLokasi");
                                  print(
                                      "Selected Alamat Muat Master Lokasi: $_selectedAlamatMasterLokasi");
                                  print(
                                      "Selected Detail Alamat Muat Master Lokasi: $selectedValueDetailAlamatMuatAsalMasterLokasi");
                                },
                                selectedItem: _selectedAlamatMasterLokasi,
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                ),
                              ),
                            ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'Detail Alamat Muat',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Container(
                              decoration: BoxDecoration(
                                color: selectedValueDetailAlamatMuatAsalMasterLokasi ==
                                            null ||
                                        selectedValueDetailAlamatMuatAsalMasterLokasi!
                                            .isEmpty
                                    ? Colors.white
                                    : Colors.grey[300],
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
                                      controller:
                                          _detailAlamatMuatMasterLokasiController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Masukkan detail alamat muat",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins Regular',
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 14.0),
                                          fillColor: Colors.grey[600],
                                          labelStyle: TextStyle(
                                              fontFamily: 'Montserrat')),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat'),
                                      maxLines: null,
                                      enabled:
                                          selectedValueDetailAlamatMuatAsalMasterLokasi ==
                                                  null ||
                                              selectedValueDetailAlamatMuatAsalMasterLokasi!
                                                  .isEmpty,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'PIC Muat',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _picMuatMasterLokasiController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan pic muat",
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'No. Telepon PIC Muat',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _telpPICMuatMasterLokasiController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(13),
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan no telp pic muat",
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
                          Text(
                            'Informasi Bongkar',
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 15,
                                fontFamily: 'Poppinss'),
                          ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Pilih Alamat',
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
                          SizedBox(height: 15),
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
                          //           controller: _alamatBongkarController,
                          //           textInputAction: TextInputAction.next,
                          //           decoration: InputDecoration(
                          //               border: InputBorder.none,
                          //               hintText: "Pilih Alamat",
                          //               contentPadding: EdgeInsets.symmetric(
                          //                   horizontal: 10.0, vertical: 14.0),
                          //               fillColor: Colors.grey[600],
                          //               labelStyle:
                          //                   TextStyle(fontFamily: 'Montserrat')),
                          //           style: TextStyle(
                          //               color: Colors.black,
                          //               fontSize: 14.0,
                          //               fontFamily: 'Montserrat'),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownSearch<String>(
                                items:
                                    _alamatBongkarOptions, // List of distrik names
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Pilih Alamat",
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
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAlamatBongkar = newValue;

                                    final selectedItem =
                                        _alamatBongkarResponse.firstWhere(
                                            (item) => item.name == newValue);

                                    print(
                                        'selectedItem Bongkar: $selectedItem');

                                    _selectedLocIdBongkar = selectedItem.locID;
                                    selectedValueCityBongkar =
                                        nameUOCTujuanToKotaMap[newValue ?? ''];

                                    selectedValueDetailAlamatBongkar =
                                        nameUOCTujuanToDetailAlamatBongkarMap[
                                            newValue ?? ''];

                                    print(
                                        "Selected KOTA: $selectedValueCityBongkar");
                                    print(
                                        "Selected locID UOC Bongkar: $_selectedLocIdBongkar");
                                    print(
                                        "Selected Detail Alamat Bongkar: $selectedValueDetailAlamatBongkar");

                                    //detail alamat bongkar
                                    _detailAlamatBongkarController.text =
                                        selectedItem.detailAlamatBongkar ?? '';
                                    //pic bongkar
                                    _picBongkarController.text =
                                        selectedItem.picBongkarBarang ?? '';
                                    //no telp pic bongkar
                                    _telpPICBongkarController.text =
                                        selectedItem.noTelpPicBongkar ?? '';
                                    print(
                                        "Detail Alamat Bongkar: ${selectedItem.detailAlamatBongkar}");
                                    String? portTujuan =
                                        selectedKotaTujuan != null
                                            ? kotaTujuanToPortTujuanMap[
                                                selectedKotaTujuan]
                                            : null;
                                    print(
                                        'selectedPortAsal contract: $selectedPortAsal');
                                    print('portTujuan contract: $portTujuan');
                                    print(
                                        'selectedValueCityAsal contract: $selectedValueCityAsal');
                                    print(
                                        'selectedValueCityBongkar contract: $selectedValueCityBongkar');
                                    BlocProvider.of<ContractNiagaCubit>(context)
                                        .cekContractFCL(
                                      selectedPortAsal ?? '',
                                      portTujuan ?? '',
                                      selectedValueCityAsal ?? '',
                                      selectedValueCityBongkar ?? '',
                                    );
                                  });
                                  print(
                                      "Selected Alamat Bongkar: $_selectedAlamatBongkar");
                                },
                                selectedItem: _selectedAlamatBongkar,
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                ),
                              ),
                            ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'Detail Alamat Bongkar',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Container(
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                color:
                                    selectedValueDetailAlamatBongkar == null ||
                                            selectedValueDetailAlamatBongkar!
                                                .isEmpty
                                        ? Colors.white
                                        : Colors.grey[300],
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
                                      controller:
                                          _detailAlamatBongkarController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Masukkan detail alamat bongkar",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins Regular',
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 14.0),
                                          fillColor: Colors.grey[600],
                                          labelStyle: TextStyle(
                                              fontFamily: 'Montserrat')),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat'),
                                      maxLines: null,
                                      enabled:
                                          selectedValueDetailAlamatBongkar ==
                                                  null ||
                                              selectedValueDetailAlamatBongkar!
                                                  .isEmpty,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'PIC Bongkar',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Container(
                              height: 40,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                  color: Colors.black, // Set border color here
                                  width: 1.0, // Set border width here
                                ),
                              ),
                              //untuk tulisan alamat pengirim
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _picBongkarController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan PIC bongkar",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins Regular',
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 11.0),
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'No. Telepon PIC Bongkar',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode == 'ONLINE')
                            Container(
                              height: 40,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                  color: Colors.black, // Set border color here
                                  width: 1.0, // Set border width here
                                ),
                              ),
                              //untuk tulisan alamat pengirim
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _telpPICBongkarController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(13),
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Masukkan no telp pic bongkar",
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Container(
                              height: 40,
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: Colors.black),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: DropdownSearch<String>(
                                items: _alamatBongkarMasterLokasiOptions
                                    .map((e) => e.pilihAlamatBongkar ?? '')
                                    .toList(), // List of distrik names
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    hintText: "Pilih Alamat",
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
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedAlamatBongkarMasterLokasi =
                                        newValue;

                                    final selectedItem =
                                        _alamatBongkarMasterLokasiResponse
                                            .firstWhere((item) =>
                                                item.pilihAlamatBongkar ==
                                                newValue);

                                    print(
                                        'selectedItem Bongkar: $selectedItem');

                                    _selectedLocIdBongkarMasterLokasi =
                                        selectedItem.locID;
                                    selectedValueCityBongkarMasterLokasi =
                                        nameUOCTujuanToKotaMapMasterLokasi[
                                            newValue ?? ''];
                                    selectedValueDetailAlamatBongkarMasterLokasi =
                                        nameUOCTujuanToDetailAlamatBongkarMapMasterLokasi[
                                            newValue ?? ''];

                                    print(
                                        "Selected KOTA: $selectedValueCityBongkarMasterLokasi");
                                    print(
                                        "Selected locID UOC Bongkar: $_selectedLocIdBongkarMasterLokasi");
                                    print(
                                        "Selected Detail Alamat Bongkar: $selectedValueDetailAlamatBongkarMasterLokasi");

                                    //detail alamat bongkar
                                    _detailAlamatBongkarMasterLokasiController
                                            .text =
                                        selectedItem.detailAlamatBongkar ?? '';
                                    //pic bongkar
                                    _picBongkarMasterLokasiController.text =
                                        selectedItem.picBongkarBarang ?? '';
                                    //no telp pic bongkar
                                    _telpPICBongkarMasterLokasiController.text =
                                        selectedItem.noTelpPicBongkar ?? '';
                                    print(
                                        "Detail Alamat Bongkar: ${selectedItem.detailAlamatBongkar}");
                                    String? portTujuan =
                                        selectedKotaTujuan != null
                                            ? kotaTujuanToPortTujuanMap[
                                                selectedKotaTujuan]
                                            : null;
                                    BlocProvider.of<ContractNiagaCubit>(context)
                                        .cekContractFCL(
                                      selectedPortAsal ?? '',
                                      portTujuan ?? '',
                                      selectedValueCityAsalMasterLokasi ?? '',
                                      selectedValueCityBongkarMasterLokasi ??
                                          '',
                                    );
                                  });
                                  print(
                                      "Selected Alamat Bongkar: $_selectedAlamatBongkarMasterLokasi");
                                },
                                selectedItem:
                                    _selectedAlamatBongkarMasterLokasi,
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                ),
                              ),
                            ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'Detail Alamat Bongkar',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Container(
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                color: selectedValueDetailAlamatBongkarMasterLokasi ==
                                            null ||
                                        selectedValueDetailAlamatBongkarMasterLokasi!
                                            .isEmpty
                                    ? Colors.white
                                    : Colors.grey[300],
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
                                      controller:
                                          _detailAlamatBongkarMasterLokasiController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Masukkan detail alamat bongkar",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins Regular',
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 14.0),
                                          fillColor: Colors.grey[600],
                                          labelStyle: TextStyle(
                                              fontFamily: 'Montserrat')),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat'),
                                      maxLines: null,
                                      enabled:
                                          selectedValueDetailAlamatBongkarMasterLokasi ==
                                                  null ||
                                              selectedValueDetailAlamatBongkarMasterLokasi!
                                                  .isEmpty,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'PIC Bongkar',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Container(
                              height: 40,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                  color: Colors.black, // Set border color here
                                  width: 1.0, // Set border width here
                                ),
                              ),
                              //untuk tulisan alamat pengirim
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _picBongkarMasterLokasiController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan PIC bongkar",
                                          hintStyle: TextStyle(
                                            fontSize: 12,
                                            fontFamily: 'Poppins Regular',
                                            color: Colors.grey,
                                          ),
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 11.0),
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 15),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Row(
                              children: [
                                Text(
                                  'No. Telepon PIC Bongkar',
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
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            SizedBox(height: 5),
                          if (dataLogin != null &&
                              dataLogin!.ownerCode != 'ONLINE')
                            Container(
                              height: 40,
                              padding: EdgeInsets.zero,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                  color: Colors.black, // Set border color here
                                  width: 1.0, // Set border width here
                                ),
                              ),
                              //untuk tulisan alamat pengirim
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller:
                                          _telpPICBongkarMasterLokasiController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(13),
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                              "Masukkan no telp pic bongkar",
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
                          SizedBox(height: 40),
                          Center(
                            child: SizedBox(
                              width: 300,
                              height: 40,
                              child: Material(
                                borderRadius: BorderRadius.circular(7.0),
                                color: isFail ? Colors.grey : Colors.red[900],
                                child: MaterialButton(
                                  minWidth: 200,
                                  height: 50,
                                  onPressed: isFail
                                      ? null
                                      : () async {
                                          setState(() {
                                            validateAndShowAlert(context);
                                          });
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
                        ],
                      ),
                    ),
                  ),
                  if (isFetchingKotaTujuan)
                    ModalBarrier(
                      dismissible: false,
                      color: Colors.black.withOpacity(0.2),
                    ),
                  if (isFetchingKotaTujuan)
                    Center(
                      child: CircularProgressIndicator(),
                    ),
                ]);
              });
            });
          });
        }));
  }
}

//============
int _currentStep = 1;
Widget _buildStepItem(String number, String title, int stepNumber) {
  bool isSelected = _currentStep == stepNumber;
  Color itemColor = isSelected
      ? (Colors.red[900] ?? Colors.red)
      : (Colors.grey[400] ?? Colors.grey);
  Color textColor =
      isSelected ? Color.fromARGB(255, 184, 33, 22) : Colors.black;

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0),
    child: Row(
      children: [
        Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Container(
                //   // width: 25,
                //   width: 20,
                //   height: 20,
                //   // height: 25,
                //   decoration: BoxDecoration(
                //     color: itemColor,
                //     borderRadius: BorderRadius.circular(5.0),
                //   ),
                // ),
                Text(
                  number,
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w800,
                    // fontSize: 20,
                    fontSize: 13,
                  ),
                )
              ],
            ),
          ],
        ),
        // SizedBox(width: 5),
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
