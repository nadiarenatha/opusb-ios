import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/alamat_cubit.dart';
import '../cubit/niaga/contract_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../cubit/niaga/order_online_fcl_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/alamat_bongkar.dart';
import '../model/niaga/alamat_muat_lcl.dart';
import '../model/niaga/master_lokasi_bongkar.dart';
import '../model/niaga/port_asal_fcl.dart';
import '../model/niaga/port_tujuan_fcl.dart';
import '../order/menu_order_niaga.dart';
import '../profile/profil_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'detail_lcl.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'dart:math';
import 'package:flutter/services.dart';

class RuteLCL extends StatefulWidget {
  const RuteLCL({super.key});

  @override
  State<RuteLCL> createState() => _RuteLCLState();
}

class _RuteLCLState extends State<RuteLCL> {
  int _selectedIndex = 0;
  bool isSelected = false;
  String? selectedKotaAsal;
  String? selectedKotaTujuan;
  String? selectedPortAsal;
  List<String> kotaAsalList = [];
  List<String> kotaTujuanList = [];
  Map<String, List<String>> kotaTujuanMap = {}; // Map kotaAsal to kotaTujuan
  List<PortAsalFCLAccesses> portAsalModellist = [];
  List<PortTujuanFCLAccesses> portTujuanModellist = [];
  Map<String, String> portAsalToKotaAsalMap = {}; // Maps portAsal to kotaAsal

  TextEditingController _dateController = TextEditingController();
  TextEditingController _gudangNiagaController = TextEditingController();
  TextEditingController _alamatMuatController = TextEditingController();
  TextEditingController _detailAlamatMuatController = TextEditingController();
  TextEditingController _picMuatController = TextEditingController();
  TextEditingController _telpPicMuatController = TextEditingController();
  TextEditingController _alamatBongkarController = TextEditingController();
  TextEditingController _detailAlamatBongkarController =
      TextEditingController();
  TextEditingController _picBongkarController = TextEditingController();
  TextEditingController _telpPicBongkarController = TextEditingController();
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
  Map<String, String> kotaTujuanToPortTujuanMap = {};
  String? selectedPortTujuan;

  bool isFetchingKotaTujuan = false;

  DataLoginAccesses? dataLogin;

  //Muat
  // String? _selectedAlamat;
  // List<String> _alamatOptions = [];
  AlamatMuatLCLAccesses? _selectedAlamat;
  List<AlamatMuatLCLAccesses> _alamatOptions = [];
  late TextEditingController detailAlamatMuatController;

  //Bongkar
  String? _selectedAlamatBongkar;
  List<String> _alamatBongkarOptions = [];
  late TextEditingController detailAlamatBongkarController;
  List<AlamatBongkarAccesses> _alamatBongkarResponse = [];
  String? _selectedKota;
  Map<String, String?> nameUOCAsalToKotaMap = {};
  Map<String, String?> nameUOCTujuanToDetailAlamatBongkarMap = {};
  String? selectedValueCityAsal;
  String? selectedValueDetailAlamatBongkar;

  String? selectedOption;

  //Bongkar Master Lokasi Owner Code Khusus
  List<MasterLokasiBongkarAccesses> _alamatBongkarMasterLokasiOptions = [];
  List<MasterLokasiBongkarAccesses> _alamatBongkarMasterLokasiResponse = [];
  Map<String, String?> nameUOCTujuanToKotaMapMasterLokasi = {};
  Map<String, String?> nameUOCTujuanToDetailAlamatBongkarMapMasterLokasi = {};
  String? _selectedAlamatBongkarMasterLokasi;
  String? selectedValueCityBongkarMasterLokasi;
  String? selectedValueDetailAlamatBongkarMasterLokasi;

  //get loc id kota Asal
  Map<String, String> portAsalToLocIdMap = {};
  String? selectedLocIdAsal;

  //get loc id kota tujuan
  Map<String, String?> kotaTujuanToLocIdMap = {};
  String? selectedLocIdTujuan;

  //get loc id uoc tujuan
  String? _selectedLocIdBongkar;

  //get loc id uoc tujuan Owner Code Khusus
  String? _selectedLocIdBongkarMasterLokasi;

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

  void fetchAlamat(String portCode) {
    context.read<AlamatNiagaCubit>().alamatMuatLCL(portCode);
    context.read<AlamatNiagaCubit>().logAlamatMuatLCL(portCode);
  }

  void dispose() {
    // _namaPengirimController.dispose();
    _dateController.dispose();
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
    detailAlamatMuatController = TextEditingController();
    detailAlamatBongkarController = TextEditingController();
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortAsalLCL();
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
    BlocProvider.of<OrderOnlineFCLCubit>(context).fetchPortTujuanLCL(portAsal);
  }

  void _onItemTapped(int index) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => _widgetOptions[index]),
    );
  }

  String? selectedTipePengiriman;
  final List<String> tipePengirimanList = [
    'Surabaya',
    'Makassar',
    'Sorong',
    'Timika'
  ];

  //untuk fungsi calendar pada pop up dialog search dengan nama _dateController
  Future<void> _selectDate(
      BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Current date
      firstDate: DateTime(2000), // The earliest date the user can pick
      lastDate: DateTime(2101), // The latest date the user can pick
    );
    if (picked != null) {
      setState(() {
        // controller.text = "${picked.day}/${picked.month}/${picked.year}";
        controller.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year.toString().padLeft(4, '0')}";
      });
    }
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
          constraints: BoxConstraints(maxHeight: 360, maxWidth: 300),
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
    String gudang = _gudangNiagaController.text.trim();
    String alamatMuat = _alamatMuatController.text.trim();
    String detailAlamatMuat = _detailAlamatMuatController.text.trim();
    String picMuat = _picMuatController.text.trim();
    String telpMuat = _telpPicMuatController.text.trim();
    String alamatBongkar = _alamatBongkarController.text.trim();
    String detailAlamatBongkar = _detailAlamatBongkarController.text.trim();
    String picBongkar = _picBongkarController.text.trim();
    String telpBongkar = _telpPicBongkarController.text.trim();
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
    if (_selectedAlamat == null) {
      errorMessages.add("Alamat Muat tidak boleh kosong !");
    }
    if (detailAlamatMuat.isEmpty) {
      errorMessages.add("Detail Alamat Muat tidak boleh kosong !");
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
    if (dataLogin!.ownerCode == 'ONLINE' && detailAlamatBongkar.isEmpty) {
      errorMessages.add("Detail Alamat Bongkar tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        detailAlamatBongkarMasterLokasi.isEmpty) {
      errorMessages.add("Detail Alamat Bongkar tidak boleh kosong !");
    }
    if (dataLogin!.ownerCode == 'ONLINE' && picBongkar.isEmpty) {
      errorMessages.add("PIC Bongkar tidak boleh kosong !");
    } else if (dataLogin!.ownerCode != 'ONLINE' &&
        picBongkarMasterLokasi.isEmpty) {
      errorMessages.add("PIC Bongkar tidak boleh kosong !");
    }
    if (dataLogin!.ownerCode == 'ONLINE' && telpBongkar.isEmpty) {
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

      // String? selectedLocIdTujuan = kotaTujuanToLocIdMap[selectedLocIdTujuan];

      print('Port Asal: ${selectedPortAsal ?? ''}');
      // print('Port Tujuan: ${selectedPortTujuan ?? ''}');
      print('Port Tujuan: ${portTujuan ?? ''}');
      print('Kota Asal: ${selectedKotaAsal ?? ''}');
      print('Kota Tujuan: ${selectedKotaTujuan ?? ''}');
      print('Nama Alamat Bongkar: ${selectedValueCityAsal ?? ''}');
      print('Selected Loc ID Tujuan di Rute LCL: ${selectedLocIdTujuan ?? ''}');

      // Proceed with your logic here if all fields are not empty
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return DetailLCL(
            portAsal: selectedPortAsal ?? '',
            portTujuan: portTujuan ?? '',
            kotaAsal: selectedKotaAsal ?? '',
            kotaTujuan: selectedKotaTujuan ?? '',
            tanggalCargo: _dateController.text,
            namaAlamatMuat: _selectedAlamat?.namaGudang ?? '',
            detailAlamatMuat: _detailAlamatMuatController.text,
            picMuat: _picMuatController.text,
            telpPicMuat: _telpPicMuatController.text,
            // namaAlamatBongkar: _selectedAlamatBongkar.toString(),
            // namaAlamatBongkar: selectedValueCityAsal.toString(),
            namaAlamatBongkar: dataLogin!.ownerCode == 'ONLINE'
                ? selectedValueCityAsal.toString()
                : selectedValueCityBongkarMasterLokasi.toString(),
            // detailAlamatBongkar: _detailAlamatBongkarController.text,
            detailAlamatBongkar: dataLogin!.ownerCode == 'ONLINE'
                ? _detailAlamatBongkarController.text
                : _detailAlamatBongkarMasterLokasiController.text,
            // picBongkar: _picBongkarController.text,
            picBongkar: dataLogin!.ownerCode == 'ONLINE'
                ? _picBongkarController.text
                : _picBongkarMasterLokasiController.text,
            // telpPicBongkar: _telpPicBongkarController.text,
            telpPicBongkar: dataLogin!.ownerCode == 'ONLINE'
                ? _telpPicBongkarController.text
                : _telpPICBongkarMasterLokasiController.text,
            locIDPortAsal: selectedLocIdAsal.toString(),
            locIDPortTujuan: selectedLocIdTujuan.toString(),
            // locIDPortTujuan: idPortTujuan.toString(),
            locIDUOCAsal: _selectedAlamat?.loctId ?? '',
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
      body: BlocConsumer<OrderOnlineFCLCubit, OrderOnlineFCLState>(
        listener: (context, state) {
          if (state is PortAsalLCLSuccess) {
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

              portAsalToLocIdMap = {
                for (var port in state.response)
                  port.portAsal ?? '': port.locIdAsal ?? ''
              };

              // Reset the selected Kota Tujuan when Kota Asal changes
              selectedKotaTujuan = null;
              kotaTujuanList = [];
            });
          }
          if (state is PortTujuanLCLSuccess) {
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
          }
          if (state is PortTujuanLCLInProgress) {
            setState(() {
              isFetchingKotaTujuan = true;
            });
          }
          if (state is PortTujuanLCLFailure) {
            setState(() {
              isFetchingKotaTujuan = false;
            });
          }
        },
        builder: (context, state) {
          if (state is PortAsalLCLInProgress) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return BlocConsumer<AlamatNiagaCubit, AlamatNiagaState>(
              listener: (context, state) {
            if (state is AlamatBongkarNiagaSuccess) {
              print("Fetched Alamat Bongkar successfully: ${state.response}");
              _alamatBongkarOptions = state.response
                  .map((item) => item.name ?? '') // Extract NAME
                  .where((name) => name.isNotEmpty) // Ensure non-empty names
                  .toList();
              _alamatBongkarResponse = state.response;

              nameUOCAsalToKotaMap = {
                for (var item in state.response) item.name ?? '': item.kota
              };
              nameUOCTujuanToDetailAlamatBongkarMap = {
                for (var item in state.response)
                  item.name ?? '': item.detailAlamatBongkar
              };
              // } else if (state is AlamatMuatNiagaSuccess) {
            } else if (state is AlamatMuatLCLNiagaSuccess) {
              print("Fetched Alamat Muat successfully: ${state.response}");
              _alamatOptions = state.response
                  .where((item) => item.namaGudang?.isNotEmpty ?? false)
                  .toList();
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
                  "Mapped Detail Alamat Bongkar Master Lokasi: $nameUOCTujuanToKotaMapMasterLokasi");

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
                if (state is ContractLCLNiagaFailure) {
                  print("ContractLCLNiagaFailure jalan");
                  failGetContract();
                }
              }, builder: (context, state) {
                bool isFail = state is ContractLCLNiagaFailure;
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
                          //UOC List Search
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
                                  selectedLocIdAsal =
                                      portAsalToLocIdMap[selectedPortAsal] ??
                                          '';
                                  print(
                                      "Selected locId Port Asal: $selectedLocIdAsal");

                                  // Reset the selected Kota Tujuan when Kota Asal changes
                                  selectedKotaTujuan = null;
                                  kotaTujuanList = [];
                                  if (selectedPortAsal != null) {
                                    fetchKotaTujuan(selectedPortAsal!);
                                    // fetchAlamat(selectedPortAsal!, '');
                                    fetchAlamat(selectedPortAsal!);
                                  }
                                });
                              },
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                constraints: BoxConstraints(maxHeight: 200),
                              ),
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
                          //UOC LIST SEARCH
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
                          //             horizontal: 10.0, vertical: 13.0),
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
                                          //untuk pilih alamat di alamat muat
                                          // fetchAlamat(selectedPortAsal!, '');
                                          fetchAlamat(selectedPortAsal!);
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

                                          if (kotaTujuanToLocIdMap
                                              .containsKey(newValue)) {
                                            selectedLocIdTujuan =
                                                kotaTujuanToLocIdMap[newValue];
                                            print(
                                                "Selected locId Port Tujuan: $selectedLocIdTujuan");

                                            // Save or use locIdTujuan as needed
                                          }
                                        }
                                      });
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
                                      'LCL (Less Container Load)',
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
                          // Row(
                          //   children: [
                          //     Expanded(
                          //       child: Container(
                          //         height: 40,
                          //         decoration: BoxDecoration(
                          //           color: Colors.grey[300],
                          //           borderRadius:
                          //               BorderRadius.all(Radius.circular(10.0)),
                          //           border: Border.all(
                          //             color: Colors.black, // Set border color here
                          //             width: 1.0, // Set border width here
                          //           ),
                          //         ),
                          //         child: Padding(
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal: 10.0, vertical: 10.0),
                          //           child: Text(
                          //             'PTD (Port to Door)',
                          //             style: TextStyle(
                          //               fontSize: 12,
                          //               fontFamily: 'Poppins Regular',
                          //               color: Colors.black,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
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
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10.0),
                                    child: DropdownButton<String>(
                                      value:
                                          selectedOption, // The currently selected option
                                      hint: Text(
                                        'Pilih Tipe Pengiriman',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontFamily: 'Poppins Regular',
                                          color: Colors.black,
                                        ),
                                      ),
                                      items: ['PTD (Port to Door)']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(
                                            value,
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Poppins Regular',
                                              color: Colors.black,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          selectedOption = newValue;
                                        });
                                      },
                                      // Makes the dropdown fit the container's width
                                      isExpanded: true,
                                      // Removes the default underline
                                      underline: SizedBox(),
                                      // Matches the dropdown color
                                      dropdownColor: Colors.white,
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
                                    readOnly: true,
                                    onTap: () =>
                                        _selectDate(context, _dateController),
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
                                'Pilih Gudang Niaga',
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
                            height: 45,
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child:
                                // DropdownSearch<String>(
                                //   items: _alamatOptions, // List of distrik names
                                //   dropdownDecoratorProps: DropDownDecoratorProps(
                                //     dropdownSearchDecoration: InputDecoration(
                                //       hintText: "Pilih Alamat",
                                //       hintStyle: TextStyle(
                                //         fontSize: 12,
                                //         fontFamily: 'Poppins Regular',
                                //         color: Colors.grey,
                                //       ),
                                //       border: InputBorder.none,
                                //       contentPadding: EdgeInsets.symmetric(
                                //           horizontal: 10.0, vertical: 12.0),
                                //     ),
                                //   ),
                                //   onChanged: (String? newValue) {
                                //     setState(() {
                                //       _selectedAlamat = newValue;

                                //       // Reset detail address field if no selection
                                //       // Reset saat selesai pilih dropdown kota tujuan
                                //       // if (newValue == null || newValue.isEmpty) {
                                //       //   _detailAlamatMuatController.clear();
                                //       // }
                                //       // Find selected item and get `detailAlamatMuat`
                                //       if (state is AlamatMuatLCLNiagaSuccess) {
                                //         print("Alamat Muat Response: ${state.response}");
                                //         final selectedItem = state.response.firstWhere(
                                //             (item) => item.namaGudang == newValue);

                                //         // Directly set the detailAlamatMuat without null check
                                //         _detailAlamatMuatController.text =
                                //             selectedItem.alamat ?? '';
                                //         print(
                                //             "Detail Alamat Muat: ${selectedItem.alamat}");
                                //       }
                                //     });
                                //     print("Selected Alamat Muat: $_selectedAlamat");
                                //   },
                                //   selectedItem: _selectedAlamat,
                                //   popupProps: PopupProps.menu(
                                //     showSearchBox: true,
                                //     constraints: BoxConstraints(
                                //       maxHeight: 150,
                                //     ),
                                //   ),
                                // ),
                                DropdownSearch<AlamatMuatLCLAccesses>(
                              // List of AlamatMuatLCLAccesses objects
                              items: _alamatOptions,
                              itemAsString: (AlamatMuatLCLAccesses? item) =>
                                  item?.namaGudang ?? '',
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
                                      horizontal: 10.0, vertical: 12.0),
                                ),
                              ),
                              onChanged: (AlamatMuatLCLAccesses? newValue) {
                                setState(() {
                                  _selectedAlamat = newValue;

                                  // Display the selected alamat in the TextFormField
                                  if (newValue == null ||
                                      (newValue.namaGudang?.isEmpty ?? true)) {
                                    _detailAlamatMuatController.clear();
                                  } else {
                                    _detailAlamatMuatController.text =
                                        newValue.alamat ?? '';
                                  }
                                });
                                print(
                                    "Selected Alamat Muat: ${_selectedAlamat?.namaGudang}");
                                print(
                                    "Selected loctId: ${_selectedAlamat?.loctId}");
                              },
                              selectedItem: _selectedAlamat,
                              popupProps: PopupProps.menu(
                                showSearchBox: true,
                                constraints: BoxConstraints(maxHeight: 150),
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Text(
                                'Alamat Gudang Niaga',
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
                              color: Colors.grey[300],
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
                                      hintText: "Masukkan detail alamat muat",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey[300],
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
                                    // Allows the TextFormField to grow vertically
                                    maxLines: null,
                                    // Disable if not null
                                    enabled: _detailAlamatMuatController
                                        .text.isEmpty,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 15),
                          // Row(
                          //   children: [
                          //     Text(
                          //       'PIC Muat',
                          //       style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 12,
                          //           fontFamily: 'Poppins Med'),
                          //     ),
                          //     Text(
                          //       '*',
                          //       style: TextStyle(
                          //           color: Colors.red[900],
                          //           fontSize: 12,
                          //           fontFamily: 'Poppins Med'),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 5),
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
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: TextFormField(
                          //           controller: _picMuatController,
                          //           textInputAction: TextInputAction.next,
                          //           decoration: InputDecoration(
                          //               border: InputBorder.none,
                          //               hintText: "Masukkan PIC Muat",
                          //               hintStyle: TextStyle(
                          //                 fontSize: 12,
                          //                 fontFamily: 'Poppins Regular',
                          //                 color: Colors.grey,
                          //               ),
                          //               contentPadding: EdgeInsets.symmetric(
                          //                   horizontal: 10.0, vertical: 13.0),
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
                          // SizedBox(height: 15),
                          // Row(
                          //   children: [
                          //     Text(
                          //       'No Telepon PIC Muat',
                          //       style: TextStyle(
                          //           color: Colors.black,
                          //           fontSize: 12,
                          //           fontFamily: 'Poppins Med'),
                          //     ),
                          //     Text(
                          //       '*',
                          //       style: TextStyle(
                          //           color: Colors.red[900],
                          //           fontSize: 12,
                          //           fontFamily: 'Poppins Med'),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 5),
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
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: TextFormField(
                          //           controller: _telpPicMuatController,
                          //           textInputAction: TextInputAction.next,
                          //           keyboardType: TextInputType.number,
                          //           inputFormatters: [
                          //             FilteringTextInputFormatter.digitsOnly,
                          //             LengthLimitingTextInputFormatter(13),
                          //           ],
                          //           decoration: InputDecoration(
                          //               border: InputBorder.none,
                          //               hintText: "Masukkan no telp PIC Muat",
                          //               hintStyle: TextStyle(
                          //                 fontSize: 12,
                          //                 fontFamily: 'Poppins Regular',
                          //                 color: Colors.grey,
                          //               ),
                          //               contentPadding: EdgeInsets.symmetric(
                          //                   horizontal: 10.0, vertical: 13.0),
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
                          SizedBox(height: 5),
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

                                    selectedValueCityAsal =
                                        nameUOCAsalToKotaMap[newValue ?? ''];

                                    selectedValueDetailAlamatBongkar =
                                        nameUOCTujuanToDetailAlamatBongkarMap[
                                            newValue ?? ''];

                                    _selectedLocIdBongkar = selectedItem.locID;

                                    print(
                                        "Selected Value Kota Asal: $selectedValueCityAsal");

                                    print(
                                        "Selected locID UOC Bongkar: $_selectedLocIdBongkar");

                                    print(
                                        "Selected KOTA: $selectedValueCityAsal");

                                    print(
                                        "Selected Detail Alamat Bongkar: $selectedValueDetailAlamatBongkar");

                                    //detail alamat Bongkar
                                    _detailAlamatBongkarController.text =
                                        selectedItem.detailAlamatBongkar ?? '';
                                    //pic bongkar
                                    _picBongkarController.text =
                                        selectedItem.picBongkarBarang ?? '';
                                    //no telp pic bongkar
                                    _telpPicBongkarController.text =
                                        selectedItem.noTelpPicBongkar ?? '';
                                    print(
                                        "Detail Alamat Bongkar: ${selectedItem.detailAlamatBongkar}");
                                    String? portTujuan =
                                        selectedKotaTujuan != null
                                            ? kotaTujuanToPortTujuanMap[
                                                selectedKotaTujuan]
                                            : null;
                                    BlocProvider.of<ContractNiagaCubit>(context)
                                        .contractLCL(
                                            selectedPortAsal.toString(),
                                            portTujuan.toString(),
                                            selectedValueCityAsal.toString());
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
                                        labelStyle:
                                            TextStyle(fontFamily: 'Montserrat'),
                                      ),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 14.0,
                                        fontFamily: 'Montserrat',
                                      ),
                                      // Allows the TextFormField to grow vertically
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
                                          hintText: "Masukkan PIC penerima",
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
                                  'No. Telp PIC Bongkar',
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
                                      controller: _telpPicBongkarController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(13),
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan no telp bongkar",
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
                                        .contractLCL(
                                            selectedPortAsal.toString(),
                                            portTujuan.toString(),
                                            selectedValueCityBongkarMasterLokasi
                                                .toString());
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
                                  minWidth: 200, // Adjust the width as needed
                                  height: 50, // Adjust the height as needed
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
                                      fontFamily: 'Poppins Med',
                                    ),
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
          // });
        },
      ),
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
