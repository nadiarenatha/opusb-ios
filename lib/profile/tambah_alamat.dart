import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/address_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../cubit/niaga/uoc_list_search_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/tipe_alamat.dart';
import '../model/niaga/uoc_list_search.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'daftar_alamat.dart';

class TambahAlamatNiagaPage extends StatefulWidget {
  const TambahAlamatNiagaPage({Key? key}) : super(key: key);

  @override
  State<TambahAlamatNiagaPage> createState() => _TambahAlamatNiagaPageState();
}

class _TambahAlamatNiagaPageState extends State<TambahAlamatNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  TextEditingController _namaAlamatController = TextEditingController();
  TextEditingController _namaPICController = TextEditingController();
  TextEditingController _telpPICController = TextEditingController();
  TextEditingController _kotaController = TextEditingController();
  TextEditingController _alamatController = TextEditingController();

  DataLoginAccesses? dataLogin;

  //TIPE ALAMAT
  List<TipeAlamatAccesses> tipeAlamatsList = [];
  String? selectedTipeAlamat;
  String? selectedTipeAlamatValue;

  //KOTA
  TextEditingController _searchController = TextEditingController();
  String? selectedDistrik;
  Future<List<String>>? _fetchedItemsFuture;
  String? selectedKota;
  List<UOCListSearchAccesses> uoclist = [];

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

  // String? selectedTipeAlamat;
  // final List<String> tipeAlamatList = [
  //   'Muat',
  //   'Bongkar',
  // ];

  @override
  void initState() {
    super.initState();
    _fetchAndLoginUser();
    BlocProvider.of<AddressCubit>(context).tipeAlamat();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<List<String>> fetchItems(String? filter) async {
    if (filter == null || filter.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Masukkan minimal 4 karakter untuk memulai')),
      );
      return [];
    }

    try {
      var response =
          await context.read<UOCListSearchCubit>().uOCCreateAccount(filter);

      if (response == null || response.isEmpty) {
        return [];
      }

      return response.map((e) => e.kota ?? '').toList();
    } catch (error) {
      print("Error fetching data: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memuat data kota')),
      );
      return [];
    }
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

  Future suksesTambahAlamat() => showDialog(
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
                  content: successAdd()),
            ),
          ));

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => DaftarAlamatNiagaPage()),
    );
    return false; // Prevent default back navigation
  }

  Widget build(BuildContext context) {
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
                // Navigator.of(context).pop();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DaftarAlamatNiagaPage()),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Tambah Alamat Baru",
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
        body: BlocConsumer<AddressCubit, AddressState>(
            listener: (context, state) async {
          if (state is AddAddressSuccess) {
            print("Sukes Tambah Alamat");
            await suksesTambahAlamat();
          } else if (state is TipeAlamatSuccess) {
            tipeAlamatsList.clear();
            tipeAlamatsList = state.response;
            print('tipe alamatnya : $tipeAlamatsList');
          }
        }, builder: (context, state) {
          if (state is AddAddressInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
          return BlocConsumer<DataLoginCubit, DataLoginState>(
              listener: (context, state) async {
            if (state is DataLoginSuccess) {
              setState(() {
                dataLogin = state.response;
              });
              print('Ini Data nya yang akan di ambil : $dataLogin');
            }
          }, builder: (context, state) {
            return BlocConsumer<UOCListSearchCubit, UOCListSearchState>(
                listener: (context, state) {
              if (state is UOCCreateAccountSuccess) {
                uoclist.clear();
                setState(() {
                  uoclist = state.response;
                });
                print('Ini respon UOC List di body nya: $uoclist');
              } else if (state is UOCCreateAccountFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            }, builder: (context, state) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Nama Alamat',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _namaAlamatController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Masukkan nama alamat",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 14.0),
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
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Tipe Alamat',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6), // Reduced padding
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButtonFormField<String>(
                          value: selectedTipeAlamat,
                          hint: Text(
                            'Pilih Tipe Alamat',
                            style: TextStyle(fontSize: 14), // Reduced font size
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedTipeAlamat = newValue;
                              selectedTipeAlamatValue = tipeAlamatsList
                                  .firstWhere((item) => item.name == newValue)
                                  .value;
                            });
                            print('Selected Name: $selectedTipeAlamat');
                            print('Selected Value: $selectedTipeAlamatValue');
                          },
                          items: tipeAlamatsList.map<DropdownMenuItem<String>>(
                              (TipeAlamatAccesses item) {
                            return DropdownMenuItem<String>(
                              value: item.name,
                              child: Text(
                                item.name.toString(),
                                style: TextStyle(fontSize: 14),
                              ),
                            );
                          }).toList(),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 6),
                            border:
                                InputBorder.none, // Remove the default border
                          ),
                          iconSize: 20, // Reduce the size of the dropdown arrow
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Nama PIC',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _namaPICController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Masukkan nama PIC",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 14.0),
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
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Nomor Telepon PIC',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
                        child: Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _telpPICController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(13),
                                ],
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Masukkan no telp PIC",
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 14.0),
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
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Kota',
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Cari Kota",
                          hintStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Poppins Regular',
                            color: Colors.grey,
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Circular border
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(color: Colors.black, width: 1.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 16.0,
                              horizontal:
                                  12.0), // Adjust the vertical padding here
                        ),
                        onChanged: (value) {
                          selectedDistrik = null;
                          // Reset dropdown items when text changes
                          if (value.isEmpty || value.length < 4) {
                            setState(() {
                              // Reset dropdown items
                              _fetchedItemsFuture = Future.value([]);
                            });
                          } else {
                            setState(() {
                              // Fetch new items based on the input
                              _fetchedItemsFuture = fetchItems(value);
                            });
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          children: [
                            FutureBuilder<List<String>>(
                              future: _fetchedItemsFuture,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else if (!snapshot.hasData ||
                                    snapshot.data!.isEmpty) {
                                  return Text('Masukkan Nama Kota');
                                }

                                return DropdownSearch<String>(
                                  items: snapshot.data!,
                                  dropdownDecoratorProps:
                                      DropDownDecoratorProps(
                                    dropdownSearchDecoration: InputDecoration(
                                      hintText: "Pilih Kota",
                                      hintStyle: TextStyle(
                                        fontSize: 13,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 12.0,
                                      ),
                                    ),
                                  ),
                                  popupProps: PopupProps.menu(
                                    // showSearchBox: true,
                                    showSearchBox: false,
                                    searchFieldProps: TextFieldProps(
                                      controller: _searchController,
                                      decoration: InputDecoration(
                                        hintText: "Cari Kota",
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                    // Adjust the height of the dropdown
                                    constraints: BoxConstraints(maxHeight: 100),
                                  ),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      selectedDistrik = newValue;

                                      var matchingItem = uoclist.firstWhere(
                                        (item) =>
                                            item.kota == newValue, // yg muncul
                                        orElse: () => UOCListSearchAccesses(),
                                      );
                                      selectedKota = matchingItem.kota;
                                    });
                                    print("Selected Distrik: $newValue");
                                    print(
                                        "Selected Kota: $selectedKota"); // yg dipilih
                                  },
                                  selectedItem: selectedDistrik,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(
                            'Alamat',
                            style: TextStyle(
                                fontSize: 13, fontFamily: 'Poppins Med'),
                          ),
                          Text(
                            '*',
                            style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 13,
                                fontFamily: 'Poppins Med'),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
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
                                controller: _alamatController,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Masukkan alamat",
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
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Material(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.white,
                                shadowColor: Colors.grey[350],
                                elevation: 5,
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
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
                                    'Batal',
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Colors.red[900],
                                        fontFamily: 'Poppins Med'),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 40,
                              child: Material(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.red[900],
                                //membuat bayangan pada button Detail
                                shadowColor: Colors.grey[350],
                                elevation: 5,
                                child: MaterialButton(
                                  minWidth: 200, // Adjust the width as needed
                                  height: 50, // Adjust the height as needed
                                  onPressed: () {
                                    List<String> errorMessages = [];

                                    // Gather trimmed values from text controllers
                                    String namaAlamat =
                                        _namaAlamatController.text.trim();
                                    String namaPIC =
                                        _namaPICController.text.trim();
                                    String telpPIC =
                                        _telpPICController.text.trim();
                                    String kota = _kotaController.text.trim();
                                    String alamat =
                                        _alamatController.text.trim();

                                    // Validation checks
                                    if (namaAlamat.isEmpty) {
                                      errorMessages.add(
                                          "Nama Alamat tidak boleh kosong!");
                                    }
                                    if (namaPIC.isEmpty) {
                                      errorMessages
                                          .add("Nama PIC tidak boleh kosong!");
                                    }
                                    if (telpPIC.isEmpty) {
                                      errorMessages
                                          .add("Telp PIC tidak boleh kosong!");
                                    }
                                    if (selectedKota == null) {
                                      errorMessages
                                          .add("Kota tidak boleh kosong!");
                                    }
                                    if (alamat.isEmpty) {
                                      errorMessages
                                          .add("Alamat tidak boleh kosong!");
                                    }
                                    if (selectedTipeAlamat == null ||
                                        selectedTipeAlamat!.isEmpty) {
                                      errorMessages.add(
                                          "Tipe Alamat tidak boleh kosong!");
                                    }

                                    if (errorMessages.isNotEmpty) {
                                      // Show validation errors
                                      alertKontrak(context, errorMessages);
                                    } else {
                                      String formatDate(DateTime date) {
                                        return DateFormat(
                                                "yyyy-MM-dd'T'HH:mm:ss'Z'")
                                            .format(date.toUtc());
                                      }

                                      if (selectedTipeAlamat == null) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Pilih tipe alamat terlebih dahulu')),
                                        );
                                        return;
                                      }

                                      print(
                                          "addressType: $selectedTipeAlamatValue");
                                      print("email: ${dataLogin?.email ?? ''}");
                                      print(
                                          "addressName: ${_alamatController.text}");
                                      print(
                                          "picName: ${_namaPICController.text}");
                                      print(
                                          "picPhone: ${_telpPICController.text}");
                                      print("city: $selectedKota");
                                      print(
                                          "createdDate: ${formatDate(DateTime.now())}");
                                      print(
                                          "createdBy: ${dataLogin?.email ?? ''}");
                                      print(
                                          "address1: ${_alamatController.text}");

                                      context.read<AddressCubit>().addAddress(
                                          //addressType
                                          selectedTipeAlamatValue ?? '',
                                          //email
                                          dataLogin?.email ?? '',
                                          //addressName
                                          _namaAlamatController.text.isNotEmpty
                                              ? _namaAlamatController.text
                                              : '',
                                          //picName
                                          _namaPICController.text.isNotEmpty
                                              ? _namaPICController.text
                                              : '',
                                          //picPhone
                                          _telpPICController.text.isNotEmpty
                                              ? _telpPICController.text
                                              : '',
                                          //city
                                          selectedKota.toString(),
                                          formatDate(
                                              DateTime.now()), //createdDate
                                          //createdBy
                                          dataLogin?.email ?? '',
                                          _alamatController
                                                  .text.isNotEmpty //address1
                                              ? _alamatController.text
                                              : '',
                                          '' //locationId
                                          );
                                    }
                                  },
                                  child: Text(
                                    'Simpan',
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
                    ],
                  ),
                ),
              );
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
        //     items: const <BottomNavigationBarItem>[
        //       BottomNavigationBarItem(
        //           icon: Icon(Icons.dashboard), label: 'Order'),
        //       BottomNavigationBarItem(
        //         icon: SizedBox(
        //           width: 20,
        //           child: ImageIcon(
        //             AssetImage('assets/tracking icon.png'),
        //           ),
        //         ),
        //         label: 'Tracking',
        //       ),
        //       BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //       BottomNavigationBarItem(
        //         icon: SizedBox(
        //           width: 12,
        //           child: ImageIcon(
        //             AssetImage('assets/invoice icon.png'),
        //           ),
        //         ),
        //         label: 'Invoice',
        //       ),
        //       BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        //     ],
        //     currentIndex: _selectedIndex,
        //     selectedItemColor: Colors.grey[600],
        //     // unselectedItemColor: Colors.grey[600],
        //     onTap: _onItemTapped,
        //   ),
        // ),
      ),
    );
  }

  successAdd() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/notif register.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Sukses Tambah Alamat !",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppinss',
                  fontWeight: FontWeight.w900),
              textAlign: TextAlign.center,
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
                    // Navigator.of(context).pop();
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return DaftarAlamatNiagaPage();
                    }));
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
          SizedBox(height: 5),
        ],
      ),
    );
  }
}
