import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import 'package:niaga_apps_mobile/profile/setting_akun_niaga.dart';

import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../cubit/niaga/uoc_list_search_cubit.dart';
import '../model/data_login.dart';
import '../model/niaga/uoc_list_search.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import '../tracking/menu_tracking_niaga.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';

class EditAkunNiagaPage extends StatefulWidget {
  const EditAkunNiagaPage({Key? key}) : super(key: key);

  @override
  State<EditAkunNiagaPage> createState() => _EditAkunNiagaPageState();
}

class _EditAkunNiagaPageState extends State<EditAkunNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;
  TextEditingController namaPerusahaanController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController provinsiController = TextEditingController();
  TextEditingController kotaController = TextEditingController();
  TextEditingController telpController = TextEditingController();
  TextEditingController nikController = TextEditingController();
  TextEditingController npwpController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController namaPICController = TextEditingController();

  String? selectedDistrik;
  Future<List<String>>? _fetchedItemsFuture;
  String? selectedKota;
  List<UOCListSearchAccesses> uoclist = [];

  DataLoginAccesses? dataLogin;

  bool isEditingNik = true;

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

  @override
  void initState() {
    super.initState();
    _fetchAndLoginUser();
    if (dataLogin != null) {
      namaPICController.text = dataLogin!.picName ?? "";
      alamatController.text = dataLogin!.address ?? "";
      kotaController.text = dataLogin!.city ?? "";
      telpController.text = dataLogin!.phone ?? "";
      npwpController.text = dataLogin!.npwp ?? "";
      nikController.text = dataLogin!.nik ?? "";
      selectedKota = dataLogin!.city; // Initialize selectedKota
    }
  }

  @override
  void dispose() {
    namaPICController.dispose();
    telpController.dispose();
    super.dispose();
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
    final flagContract = await storage.read(
      key: AuthKey.contractFlag.toString(),
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    print('Flag Contract nya: $flagContract');
    final verifiedWa = await storage.read(
      key: AuthKey.waVerified.toString(),
      aOptions: const AndroidOptions(
        encryptedSharedPreferences: true,
      ),
    );
    print('Verified WA nya: $verifiedWa');
    if (userId != null) {
      // Trigger the dataLogin API call with the userId
      BlocProvider.of<DataLoginCubit>(context).dataLogin(id: int.parse(userId));
    }
  }

  Future notifUpdate() => showDialog(
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
                  content: updateProfile()),
            ),
          ));

  Future failUpdate() => showDialog(
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
                      IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () {
                            Navigator.of(context).pop();
                          })
                    ],
                  ),
                  content: failUpdateProfil()),
            ),
          ));

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SettingAkunNiagaPage()),
    );
    return false; // Prevent default back navigation
  }

  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    // Set the initial value for the TextEditingController only when data changes
    // if (dataLogin != null) {
    //   if (namaPICController.text != dataLogin!.picName) {
    //     namaPICController.text = dataLogin!.picName ?? "";
    //   }
    //   if (alamatController.text != dataLogin!.address) {
    //     alamatController.text = dataLogin!.address ?? "";
    //   }
    //   if (kotaController.text != dataLogin!.city) {
    //     kotaController.text = dataLogin!.city ?? "";
    //   }
    //   if (telpController.text != dataLogin!.phone) {
    //     telpController.text = dataLogin!.phone ?? "";
    //   }
    //   if (npwpController.text != dataLogin!.nik) {
    //     npwpController.text = dataLogin!.nik ?? "";
    //   }
    // }

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
                      builder: (context) => SettingAkunNiagaPage()),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Ubah Data Personal",
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
        body: BlocConsumer<DataLoginCubit, DataLoginState>(
            listener: (context, state) async {
          if (state is DataLoginSuccess) {
            setState(() {
              dataLogin = state.response;
              // Update controllers when dataLogin is updated
              namaPICController.text = dataLogin?.picName ?? "";
              alamatController.text = dataLogin?.address ?? "";
              kotaController.text = dataLogin?.city ?? "";
              telpController.text = dataLogin?.phone ?? "";
              npwpController.text = dataLogin?.npwp ?? "";
              nikController.text = dataLogin?.nik ?? "";
              selectedKota = dataLogin?.city; // Update selectedKota
            });
            print(
                'Ini Data nya yang akan di ambil di halaman profil : $dataLogin');
          }
        }, builder: (context, state) {
          if (state is DataLoginInProgress) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.amber[600],
              ),
            );
          }
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
                    Text(
                      'Nama Perusahaan/Perorangan',
                      style: TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: mediaQuery.size.width,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            // 'PT Adikrasa Mitrajaya',
                            dataLogin?.lastName ?? '',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontFamily: 'Poppins Regular'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Email',
                      style: TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                    ),
                    SizedBox(height: 8),
                    Container(
                      width: mediaQuery.size.width,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            dataLogin?.email ?? '',
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontFamily: 'Poppins Regular'),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Nama PIC',
                      style: TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 45,
                      width: mediaQuery.size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: Colors.grey, // Set the border color to grey
                          width: 2.0, // Set the border width
                        ),
                      ),
                      // The container will now have a flexible height
                      child: Padding(
                        // Optional padding for text field
                        padding: EdgeInsets.symmetric(horizontal: 14.0),
                        child: TextFormField(
                          controller: namaPICController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: "PIC",
                              fillColor: Colors.grey[600],
                              labelStyle: TextStyle(fontFamily: 'Montserrat')),
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: 'Poppins Regular'),
                          // Allows the TextFormField to expand vertically
                          maxLines: null,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Alamat',
                      style: TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 90,
                      width: mediaQuery.size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: Colors.grey, // Set the border color to grey
                          width: 2.0, // Set the border width
                        ),
                      ),
                      // The container will now have a flexible height
                      child: Padding(
                        // Optional padding for text field
                        padding: EdgeInsets.symmetric(horizontal: 14.0),
                        child: TextFormField(
                          controller: alamatController,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText:
                              //     "Jln.Kenangan Selatan No.77, RT.02, RW.03 Kecamatan Penjaringan , Jakarta Utara",
                              fillColor: Colors.grey[600],
                              labelStyle: TextStyle(fontFamily: 'Montserrat')),
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: 'Poppins Regular'),
                          // Allows the TextFormField to expand vertically
                          maxLines: null,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Kota',
                      style: TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                    ),
                    SizedBox(height: 8),
                    // Container(
                    //   height: 45,
                    //   width: mediaQuery.size.width,
                    //   decoration: BoxDecoration(
                    //     color: Colors.white,
                    //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    //     border: Border.all(
                    //       color: Colors.grey, // Set the border color to grey
                    //       width: 2.0, // Set the border width
                    //     ),
                    //   ),
                    //   // The container will now have a flexible height
                    //   child: Padding(
                    //     // Optional padding for text field
                    //     padding: EdgeInsets.symmetric(horizontal: 14.0),
                    //     child: TextFormField(
                    //       controller: kotaController,
                    //       textInputAction: TextInputAction.next,
                    //       decoration: InputDecoration(
                    //           border: InputBorder.none,
                    //           // hintText: "Surabaya",
                    //           fillColor: Colors.grey[600],
                    //           labelStyle: TextStyle(fontFamily: 'Montserrat')),
                    //       style: TextStyle(
                    //           color: Colors.grey[600],
                    //           fontSize: 12,
                    //           fontFamily: 'Poppins Regular'),
                    //       // Allows the TextFormField to expand vertically
                    //       maxLines: null,
                    //     ),
                    //   ),
                    // ),
                    //2
                    TextField(
                      controller: kotaController,
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
                              BorderSide(color: Colors.grey, width: 1.0),
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
                                dropdownDecoratorProps: DropDownDecoratorProps(
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
                                  showSearchBox: false,
                                  searchFieldProps: TextFieldProps(
                                    controller: kotaController,
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
                                      (item) => item.kota == newValue,
                                      orElse: () => UOCListSearchAccesses(),
                                    );
                                    selectedKota = matchingItem.kota;
                                  });
                                  print("Selected Distrik: $newValue");
                                  print("Selected Kota: $selectedKota");
                                },
                                selectedItem: selectedDistrik,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'No Telp',
                      style: TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                    ),
                    SizedBox(height: 8),
                    Container(
                      height: 45,
                      width: mediaQuery.size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(
                          color: Colors.grey, // Set the border color to grey
                          width: 2.0, // Set the border width
                        ),
                      ),
                      // The container will now have a flexible height
                      child: Padding(
                        // Optional padding for text field
                        padding: EdgeInsets.symmetric(horizontal: 14.0),
                        child: TextFormField(
                          controller: telpController,
                          textInputAction: TextInputAction.next,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(
                                13), // Limit input to 16 characters
                          ],
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              // hintText: "+62813445678902",
                              fillColor: Colors.grey[600],
                              labelStyle: TextStyle(fontFamily: 'Montserrat')),
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                              fontFamily: 'Poppins Regular'),
                          // Allows the TextFormField to expand vertically
                          maxLines: null,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'NIK/NPWP',
                      style: TextStyle(fontSize: 13, fontFamily: 'Poppins Med'),
                    ),
                    SizedBox(height: 8),
                    //NPWP
                    if (dataLogin?.npwp?.isNotEmpty == true)
                      Container(
                        height: 45,
                        width: mediaQuery.size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                            color: Colors.grey, // Set the border color to grey
                            width: 2.0, // Set the border width
                          ),
                        ),
                        // The container will now have a flexible height
                        child: Padding(
                          // Optional padding for text field
                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                          child: TextFormField(
                            controller: npwpController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  16), // Limit input to 16 characters
                            ],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                // hintText: "7789653477009812",
                                fillColor: Colors.grey[600],
                                labelStyle:
                                    TextStyle(fontFamily: 'Montserrat')),
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontFamily: 'Poppins Regular'),
                            // Allows the TextFormField to expand vertically
                            maxLines: null,
                          ),
                        ),
                      ),
                    //NIK
                    if (dataLogin?.nik?.isNotEmpty == true)
                      Container(
                        height: 45,
                        width: mediaQuery.size.width,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(
                            color: Colors.grey, // Set the border color to grey
                            width: 2.0, // Set the border width
                          ),
                        ),
                        // The container will now have a flexible height
                        child: Padding(
                          // Optional padding for text field
                          padding: EdgeInsets.symmetric(horizontal: 14.0),
                          child: TextFormField(
                            controller: nikController,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                  16), // Limit input to 16 characters
                            ],
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                // hintText: "7789653477009812",
                                fillColor: Colors.grey[600],
                                labelStyle:
                                    TextStyle(fontFamily: 'Montserrat')),
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                                fontFamily: 'Poppins Regular'),
                            // Allows the TextFormField to expand vertically
                            maxLines: null,
                          ),
                        ),
                      ),
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width:
                                120, // Adjust width to make the button smaller
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.red[900]!,
                                    width: 2), // Red border
                                borderRadius: BorderRadius.circular(7.0),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.white,
                                // shadowColor: Colors.grey[350],
                                // elevation: 5,
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal:
                                          10), // Adjust padding for size
                                  onPressed: () async {
                                    // Navigator.of(context).pop();
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SettingAkunNiagaPage()),
                                    );
                                  },
                                  child: Text(
                                    'Batal',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.red[900]),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10), // Add space between buttons
                        Expanded(
                          child: SizedBox(
                            width:
                                120, // Adjust width to make the button smaller
                            height: 40,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.red[900]!,
                                    width: 2), // Red border
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Material(
                                borderRadius: BorderRadius.circular(7.0),
                                color: Colors.red[900],
                                child: MaterialButton(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal:
                                          10), // Adjust padding for size
                                  onPressed: () async {
                                    final userIdString = await storage.read(
                                      key: AuthKey.id.toString(),
                                      aOptions: const AndroidOptions(
                                        encryptedSharedPreferences: true,
                                      ),
                                    );
                                    print('Ini user id nya : $userIdString');

                                    final userIdParsed =
                                        int.tryParse(userIdString ?? '') ?? 0;

                                    print(
                                        'Ini user parsed id nya : $userIdParsed');

                                    bool waVerifieds = await storage.read(
                                          key: AuthKey.waVerified.toString(),
                                          aOptions: const AndroidOptions(
                                            encryptedSharedPreferences: true,
                                          ),
                                        ) ==
                                        'true';
                                    print('WA Verified nya: $waVerifieds');

                                    if (telpController.text !=
                                        dataLogin!.phone) {
                                      waVerifieds = false;
                                    }

                                    bool contractFlag = await storage.read(
                                          key: AuthKey.contractFlag.toString(),
                                          aOptions: const AndroidOptions(
                                            encryptedSharedPreferences: true,
                                          ),
                                        ) ==
                                        'true';

                                    print('Contract Flag nya: $contractFlag');

                                    final updatedData = {
                                      "id": userIdParsed,
                                      "active": dataLogin?.active ?? "",
                                      "phone": telpController.text,
                                      "city": selectedKota ?? kotaController.text,
                                      "nik": nikController.text,
                                      "address": alamatController.text,
                                      "position": dataLogin?.position ?? "",
                                      "employee": dataLogin?.employee ?? "",
                                      "waVerified": waVerifieds,
                                      "failedLoginCount":
                                          dataLogin?.failedLoginCount ?? "",
                                      "concurrentUserAccess":
                                          dataLogin?.concurrentUserAccess ?? "",
                                      "lastLoginDate":
                                          dataLogin?.lastLoginDate ?? "",
                                      "userId": userIdParsed,
                                      "userLogin": alamatController.text,
                                      "firstName": dataLogin?.firstName ?? "",
                                      "lastName": dataLogin?.lastName ?? "",
                                      "email": dataLogin?.email ?? "",
                                      "adOrganizationId":
                                          dataLogin?.adOrganizationId ?? "",
                                      "adOrganizationName":
                                          dataLogin?.adOrganizationName ?? "",
                                      "name": dataLogin?.name ?? "",
                                      "businessUnit":
                                          dataLogin?.businessUnit ?? "",
                                      "entitas": dataLogin?.entitas ?? "",
                                      "ownerCode": dataLogin?.ownerCode ?? "",
                                      "picName": namaPICController.text,
                                      "contractFlag":
                                          contractFlag, // Include contractFlag here
                                      "npwp": npwpController.text,
                                      "assigner": dataLogin?.assigner ?? "",
                                    };

                                    context
                                        .read<DataLoginCubit>()
                                        .updateDataLogin(
                                          updatedData["id"] as int,
                                          updatedData["active"] as bool,
                                          updatedData["phone"] as String,
                                          updatedData["city"] as String,
                                          // updatedData["nik"] as String,
                                          updatedData["nik"] as String? ?? "",
                                          updatedData["address"] as String,
                                          updatedData["position"] as String,
                                          updatedData["employee"] as bool,
                                          updatedData["failedLoginCount"]
                                              as int,
                                          updatedData["concurrentUserAccess"]
                                              as int,
                                          updatedData["lastLoginDate"]
                                              as String,
                                          updatedData["userId"] as int,
                                          updatedData["userLogin"] as String,
                                          updatedData["firstName"] as String,
                                          updatedData["lastName"] as String,
                                          updatedData["email"] as String,
                                          updatedData["adOrganizationId"]
                                              as int,
                                          updatedData["adOrganizationName"]
                                              as String,
                                          updatedData["name"] as String,
                                          updatedData["businessUnit"] as String,
                                          updatedData["entitas"] as String,
                                          updatedData["ownerCode"] as String,
                                          updatedData["picName"] as String,
                                          updatedData["waVerified"] as bool,
                                          updatedData["contractFlag"]
                                              as bool, // Ensure contractFlag is treated as String
                                          updatedData["npwp"] as String? ?? "",
                                          updatedData["assigner"] as bool,
                                        );

                                    context
                                        .read<DataLoginCubit>()
                                        .stream
                                        .listen((state) {
                                      if (state is DataLoginUpdatedSuccess) {
                                        notifUpdate();
                                      } else if (state is DataLoginFailure) {
                                        failUpdate();
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Simpan',
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                  ),
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
        //       BottomNavigationBarItem(
        //         icon: Stack(
        //           alignment:
        //               Alignment.center, // Centers the icon inside the circle
        //           children: <Widget>[
        //             Container(
        //               height: 50, // Adjust size of the circle
        //               width: 50,
        //               decoration: BoxDecoration(
        //                 color: Colors.red[900], // Red circle color
        //                 shape: BoxShape.circle,
        //               ),
        //             ),
        //             Icon(
        //               Icons.home,
        //               size: 28,
        //               color:
        //                   Colors.white, // Icon color (optional for visibility)
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

  updateProfile() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 5),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/notif register.png'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Profil Berhasil di update",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppin',
                  fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(height: 25),
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
                    // Navigator.pushReplacement(context,
                    //     MaterialPageRoute(builder: (context) {
                    //   return SettingAkunNiagaPage();
                    // }));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SettingAkunNiagaPage()),
                      (route) => false, // Removes all previous routes
                    );
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
        ],
      ),
    );
  }

  failUpdateProfil() {
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
              "Gagal Update Profil",
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: 'Poppin',
                  fontWeight: FontWeight.w900),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
