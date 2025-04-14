import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/login/syarat_ketentuan_register.dart';
import '../cubit/check_email_cubit.dart';
import '../cubit/niaga/uoc_list_search_cubit.dart';
import '../cubit/register_cubit.dart';
import '../model/niaga/uoc_list_search.dart';
import 'create_account_perseorangan.dart';
import 'login_body.dart';
import 'dart:convert'; // for base64 encoding and decoding
import 'package:flutter/services.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _namaPerusahaanController = TextEditingController();
  final _kotaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _namapicController = TextEditingController();
  final _nohpController = TextEditingController();
  final _npwpController = TextEditingController();
  final _emailController = TextEditingController();
  final TextEditingController _captchaController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _passwordConfirmFocus = FocusNode();
  final _emailFocus = FocusNode();
  String randomString = "";
  String verificationText = "";
  bool isVerified = false;
  bool showVerifiedIcon = false;
  TextEditingController controller = TextEditingController();
  // Default selection for radio buttons
  String _selectedCategory = "Perusahaan";
  String _selectedProvince = 'Jakarta'; // Default selection for the dropdown

  //untuk fungsi masking password
  bool _passwordVisible = true;
  bool _passwordConfirmVisible = true;
  bool _passwordsMatch = true;
  bool savePassword = false;
  bool _passwordValid = true;

  //captcha
  bool isCaptcha = false;
  String? sessionId;
  String? captchaEncode;
  ImageProvider? captchaImage; // Use ImageProvider for the image

  //UOC LIST
  List<UOCListSearchAccesses> uoclist = [];
  String? selectedDistrik;
  Future<List<String>>? _fetchedItemsFuture;
  TextEditingController _searchController = TextEditingController();
  String? selectedKota;

  final List<String> _provinces = [
    "Jawa Barat", "Jawa Tengah", "Jawa Timur",
    "DKI Jakarta", "Banten", "Bali", // Add more provinces here
  ];
  final List<String> _cities = [
    "Bandung",
    "Batam",
    "Makassar",
    "Medan",
    "Semarang",
    "Solo",
  ];

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
  }

  @override
  void dispose() {
    super.dispose();
  }

  void buildCaptcha() {
    const letters =
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890";
    const length = 6;
    final random = Random();
    randomString = String.fromCharCodes(List.generate(
        length, (index) => letters.codeUnitAt(random.nextInt(letters.length))));
    setState(() {});
  }

  //untuk fungsi masking password
  void _togglevisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  //untuk visibility confirm password
  void _togglevisibilityConfirm() {
    setState(() {
      _passwordConfirmVisible = !_passwordConfirmVisible;
    });
  }

  void _validatePasswords() {
    setState(() {
      _passwordsMatch =
          _passwordController.text == _passwordConfirmController.text;
      // _passwordValid = _validatePassword(_passwordController.text);

      // bool isValid = isValidPassword(_passwordController.text);
      _passwordValid = isValidPassword(_passwordController.text);

      // Show a message or highlight the field if passwords don't match or don't meet criteria
      // if (!isValid) {
      if (!_passwordValid) {
        // Show some validation message or error UI
        print('Password is not strong enough');
      }
      if (!_passwordsMatch) {
        print('Passwords do not match');
      }
    });
  }

  bool isValidPassword(String password) {
    // Regular expression for at least 5 characters, a number, a symbol, and both uppercase and lowercase letters
    final RegExp passwordRegExp = RegExp(
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{5,}$');
    return passwordRegExp.hasMatch(password);
  }

  String passwordPattern = r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,}$';

  bool _isPasswordValid(String password) {
    final RegExp regExp = RegExp(passwordPattern);
    return regExp.hasMatch(password);
  }

  //Cek Field
  Future cekField() => showDialog(
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
                  content: fieldKosong()),
            ),
          ));

  //cek jika password baru tdk sm dgn confirm password
  Future cekPassword() => showDialog(
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
                  content: passwordCek()),
            ),
          ));

  //Alert Check Email
  Future alertCheckEmail() => showDialog(
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
                    //supaya berada di kanan
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [],
                  ),
                  content: checkEmail()),
            ),
          ));

  //jika password kosong
  Future alertPassword() => showDialog(
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
                  content: notifAlert()),
            ),
          ));

  //cek karakter password
  Future alertKarakterPasswordLama() => showDialog(
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
                  content: alertLama()),
            ),
          ));

  Future notifCreateAccount() => showDialog(
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
                  content: notifikasi()),
            ),
          ));

  @override
  Widget build(BuildContext context) {
    //final size agar gambar background sesuai dgn masing2 layar hp
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        //agar saat input data keyboard
        resizeToAvoidBottomInset: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            0.07 * MediaQuery.of(context).size.height,
          ),
          child: AppBar(
            backgroundColor: Colors.red[900],
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: 32,
              ),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginBody()),
                );
              },
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Poppins Extra Bold'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  height: 40.0, // Adjust the height as needed
                  child: Image.asset('assets/logo-niaga.png'),
                ),
              ],
            ),
            toolbarHeight: 0.07 * MediaQuery.of(context).size.height,
          ),
        ),
        body: BlocConsumer<RegisterCubit, RegisterState>(
          listener: (context, state) {
            //Generate
            if (state is GenerateCaptchaSuccess) {
              sessionId = state.response.sessionId ?? '';
              captchaEncode = state.response.captchaEncode ?? '';

              setState(() {
                isCaptcha = true;

                // Decode Base64 to Image
                if (captchaEncode != null && captchaEncode!.isNotEmpty) {
                  try {
                    final decodedBytes = base64Decode(captchaEncode!);
                    captchaImage = MemoryImage(decodedBytes); // Set the image
                  } catch (e) {
                    // Handle decoding error
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Invalid CAPTCHA image data')),
                    );
                  }
                }
              });
            }
            //Validate
            if (state is ValidateCaptchaSuccess) {
              if (state.response.status == "SUCCESS") {
                // ScaffoldMessenger.of(context).showSnackBar(
                //   SnackBar(content: Text('CAPTCHA validated successfully!')),
                // );
                // Show the notifCreateAccount modal dialog
                notifCreateAccount();

                String phoneNumber = _nohpController.text;
                if (phoneNumber.isNotEmpty && !phoneNumber.startsWith('62')) {
                  phoneNumber = '62' + phoneNumber;
                }

                context.read<RegisterCubit>().registeringAccount(
                      //active
                      false,
                      //phone
                      // _nohpController.text.isNotEmpty
                      //     ? _nohpController.text
                      //     : '',
                      phoneNumber,
                      //userLogin
                      _emailController.text.isNotEmpty
                          ? _emailController.text
                          : '',
                      //firstName
                      // '',
                      //lastName
                      _namaPerusahaanController.text.isNotEmpty
                          ? _namaPerusahaanController.text
                          : '',
                      //email
                      _emailController.text.isNotEmpty
                          ? _emailController.text
                          : '',
                      //adOrganizationId
                      1,
                      //name
                      // _namaPerusahaanController.text.isNotEmpty
                      //     ? _namaPerusahaanController.text
                      //     : '',
                      //city
                      selectedKota,
                      //nik
                      '',
                      //npwp
                      _npwpController.text.isNotEmpty
                          ? _npwpController.text
                          : '',
                      //password
                      _passwordController.text.isNotEmpty
                          ? _passwordController.text
                          : '',
                      //businessUnit
                      'SBY',
                      //address
                      _alamatController.text.isNotEmpty
                          ? _alamatController.text
                          : '',
                      //entitas
                      '',
                      //employee
                      false,
                      //adOrganizationName
                      _namaPerusahaanController.text.isNotEmpty
                          ? _namaPerusahaanController.text
                          : '',
                      //ownerCode
                      'ONLINE',
                      //contractFlag
                      true,
                      //waVerified
                      false,
                      //picName
                      _namapicController.text.isNotEmpty
                          ? _namapicController.text
                          : '',
                      //assigner
                      true,
                    );
                print("Selected Kota nya: $selectedKota");
                // Proceed with next steps (e.g., move to the next screen)
              } else if (state.response.status == "FAILED") {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content:
                          Text('CAPTCHA validation failed. Refreshing...')),
                );
                // Trigger a new CAPTCHA generation
                context
                    .read<RegisterCubit>()
                    .generateCaptcha(_emailController.text);
                _captchaController.clear();
              }
            }
          },
          builder: (context, state) {
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
              return BlocConsumer<CheckEmailCubit, CheckEmailState>(
                  listener: (context, state) {
                if (state is CheckEmailSuccess) {
                  context
                      .read<RegisterCubit>()
                      .generateCaptcha(_emailController.text);
                } else if (state is CheckEmailFailure) {
                  alertCheckEmail();
                }
              }, builder: (context, state) {
                return Container(
                  height: screenSize.height,
                  width: screenSize.width,
                  color: Colors.white,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 5),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Expanded(
                                //   child: RadioListTile<String>(
                                //     title: Text(
                                //       'Perseorangan',
                                //       style: TextStyle(
                                //           color: _selectedCategory == 'Perseorangan'
                                //               ? Colors.black
                                //               : Colors.white,
                                //           fontSize: 20,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //     value: 'Perseorangan',
                                //     groupValue: _selectedCategory,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         _selectedCategory = value!;
                                //       });
                                //     },
                                //     activeColor: Colors.black,
                                //   ),
                                // ),
                                // Expanded(
                                //   child: RadioListTile<String>(
                                //     title: Text(
                                //       'Perusahaan',
                                //       style: TextStyle(
                                //           color: _selectedCategory == 'Perusahaan'
                                //               ? Colors.black
                                //               : Colors.white,
                                //           fontSize: 20,
                                //           fontWeight: FontWeight.w500),
                                //     ),
                                //     value: 'Perusahaan',
                                //     groupValue: _selectedCategory,
                                //     onChanged: (value) {
                                //       setState(() {
                                //         _selectedCategory = value!;
                                //       });
                                //     },
                                //     activeColor: Colors.black,
                                //   ),
                                // ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = 'Perseorangan';
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateAccountPerseoranganPage()),
                                      );
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: 'Perseorangan',
                                            groupValue: _selectedCategory,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedCategory = value!;
                                              });
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateAccountPerseoranganPage()),
                                              );
                                            },
                                            activeColor: Colors.black,
                                          ),
                                          Flexible(
                                            child: Text(
                                              'Perseorangan',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins Med'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedCategory = 'Perusahaan';
                                      });
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CreateAccountPage()),
                                      );
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Radio<String>(
                                            value: 'Perusahaan',
                                            groupValue: _selectedCategory,
                                            onChanged: (value) {
                                              setState(() {
                                                _selectedCategory = value!;
                                              });
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CreateAccountPage()),
                                              );
                                            },
                                            activeColor: Colors.black,
                                          ),
                                          Flexible(
                                            child: Text(
                                              'Perusahaan',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                  fontFamily: 'Poppins Med'),
                                            ),
                                          ),
                                        ],
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
                                  'Nama Perusahaan',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _namaPerusahaanController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan nama perusahaan",
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
                            // SizedBox(height: 20.0),
                            // Text(
                            //   'Provinsi',
                            //   style: TextStyle(color: Colors.black, fontSize: 18),
                            // ),
                            // SizedBox(height: 10.0),
                            // //dropdown search
                            // Container(
                            //   padding: EdgeInsets.symmetric(horizontal: 10.0),
                            //   decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius:
                            //         BorderRadius.all(Radius.circular(10.0)),
                            //     border: Border.all(
                            //       color: Colors.black,
                            //       width: 1.0,
                            //     ),
                            //   ),
                            //   child: DropdownSearch<String>(
                            //     items: _provinces,
                            //     dropdownDecoratorProps: DropDownDecoratorProps(
                            //       dropdownSearchDecoration: InputDecoration(
                            //         hintText: "Pilih Provinsi",
                            //         border: InputBorder.none,
                            //         contentPadding: EdgeInsets.symmetric(
                            //             horizontal: 10.0, vertical: 14.0),
                            //       ),
                            //     ),
                            //     onChanged: (String? newValue) {
                            //       // Handle selection
                            //       // Update the controller with the selected value
                            //       _provinsiController.text = newValue ?? '';
                            //       print("Selected province: $newValue");
                            //     },
                            //     popupProps: PopupProps.menu(
                            //       showSearchBox: true,
                            //     ),
                            //     // selectedItem: null, // No default selection
                            //     selectedItem: _provinsiController.text.isNotEmpty
                            //         ? _provinsiController.text
                            //         : null, // No default selection unless controller has value
                            //   ),
                            // ),
                            SizedBox(height: 15),
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
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
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
                                  borderRadius: BorderRadius.circular(
                                      10.0), // Circular border
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors.black, width: 1.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide: BorderSide(
                                      color: Colors.blue, width: 2.0),
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
                                          dropdownSearchDecoration:
                                              InputDecoration(
                                            hintText: "Pilih Kota",
                                            hintStyle: TextStyle(
                                              fontSize: 13,
                                              fontFamily: 'Poppins Regular',
                                              color: Colors.grey,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding:
                                                EdgeInsets.symmetric(
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
                                          constraints:
                                              BoxConstraints(maxHeight: 100),
                                        ),
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            selectedDistrik = newValue;

                                            var matchingItem =
                                                uoclist.firstWhere(
                                              (item) => item.kota == newValue,
                                              orElse: () =>
                                                  UOCListSearchAccesses(),
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
                            Row(
                              children: [
                                Text(
                                  'Alamat',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Container(
                              // width: mediaQuery.size.width,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                                border: Border.all(
                                  color: Colors
                                      .black, // Set the border color to grey
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 14.0, vertical: 2.0),
                                child: TextFormField(
                                  controller: _alamatController,
                                  textInputAction: TextInputAction.next,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Masukkan Alamat",
                                      hintStyle: TextStyle(
                                        fontSize: 12,
                                        fontFamily: 'Poppins Regular',
                                        color: Colors.grey,
                                      ),
                                      fillColor: Colors.grey[600],
                                      labelStyle:
                                          TextStyle(fontFamily: 'Montserrat')),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.0,
                                      fontFamily: 'Montserrat'),
                                  // Allows the TextFormField to expand vertically
                                  maxLines: null,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  'Nama Penanggung Jawab / PIC',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _namapicController,
                                      // controller: _nikController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan nama PIC",
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
                                  'Nomor HP (WhatsApp)',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
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
                                  // width: 1.0, // Set border width here
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text(
                                      "+62",
                                      style: TextStyle(
                                        fontSize: 14.0,
                                        fontFamily: 'Poppins Bold',
                                        color: Colors
                                            .red[900], // Adjust color as needed
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      controller: _nohpController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(13),
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan nomor HP",
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
                                  'NPWP Perusahaan',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _npwpController,
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                        LengthLimitingTextInputFormatter(16),
                                      ],
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan NPWP perusahaan",
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
                                  'Email Address',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
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
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _emailController,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan alamat email",
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
                                  'Password',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
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
                                  // color: Colors.black, // Set border color here
                                  color: _passwordValid
                                      ? Colors.black
                                      : Colors.red, // Red border if invalid
                                  width: 1.0, // Set border width here
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      focusNode: _passwordFocus,
                                      textInputAction: TextInputAction.done,
                                      //untuk membuat masking password
                                      obscureText: _passwordVisible,
                                      controller: _passwordController,
                                      //cek match password & confirm password
                                      // onChanged: (value) => _validatePasswords(),
                                      onChanged: (value) =>
                                          _validatePasswords(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "********",
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 12.0),
                                        fillColor: Colors.grey[600],
                                        labelStyle:
                                            TextStyle(fontFamily: 'Montserrat'),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            _togglevisibility();
                                          },
                                          child: Icon(
                                            _passwordVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            // color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            if (!_passwordValid)
                              // if (!isValidPassword(_passwordController.text))
                              Text(
                                // 'Password must be at least 5 characters, include letters and numbers',
                                'Password harus memiliki minimal 5 karakter, kombinasi huruf besar, angka, dan simbol.',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 12.0),
                              ),
                            SizedBox(height: 15),
                            Row(
                              children: [
                                Text(
                                  'Confirm Password',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontFamily: 'Poppins Med'),
                                ),
                                Text(
                                  ' *',
                                  style: TextStyle(
                                      color: Colors.red[900],
                                      fontSize: 13,
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
                                  // color: Colors.black, // Set border color here
                                  color: _passwordsMatch
                                      ? Colors.black
                                      : Colors
                                          .red, // Red border if passwords don't match
                                  width: 1.0, // Set border width here
                                ),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      focusNode: _passwordConfirmFocus,
                                      textInputAction: TextInputAction.done,
                                      //untuk membuat masking password
                                      obscureText: _passwordConfirmVisible,
                                      controller: _passwordConfirmController,
                                      //cek match password & confirm password
                                      onChanged: (value) =>
                                          _validatePasswords(),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "********",
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10.0, vertical: 12.0),
                                        fillColor: Colors.grey[600],
                                        labelStyle:
                                            TextStyle(fontFamily: 'Montserrat'),
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            _togglevisibilityConfirm();
                                          },
                                          child: Icon(
                                            _passwordConfirmVisible
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            // color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10.0),
                            if (!_passwordsMatch)
                              Text(
                                'Password tidak sesuai!',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900),
                              ),
                            SizedBox(height: 10.0),
                            if (isCaptcha)
                              // Display the CAPTCHA image
                              if (captchaImage != null)
                                Image(image: captchaImage!),
                            SizedBox(height: 10.0),
                            // CAPTCHA Input Field
                            if (isCaptcha)
                              Container(
                                  height: 40,
                                  margin: EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Row(children: [
                                    Expanded(
                                        child: TextFormField(
                                      controller: _captchaController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: "Masukkan kode CAPTCHA",
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 10.0, vertical: 14.0),
                                          fillColor: Colors.grey[600],
                                          labelStyle: TextStyle(
                                              fontFamily: 'Montserrat')),
                                      style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14.0,
                                          fontFamily: 'Montserrat'),
                                      onChanged: (value) {
                                        // Optionally, you can log or print the entered value
                                        print("Entered OTP Code: $value");
                                      },
                                    ))
                                  ])),
                            SizedBox(height: 15.0),
                            // Button to Validate CAPTCHA
                            if (isCaptcha)
                              Material(
                                  borderRadius: BorderRadius.circular(7.0),
                                  // color: Colors.blue[600],
                                  color: Colors.orange[600],
                                  child: MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      onPressed: () {
                                        //Validate Captcha
                                        context
                                            .read<RegisterCubit>()
                                            .validateCaptcha(
                                              // or another appropriate email source
                                              email: _emailController.text,
                                              // otpCode entered by the user
                                              otpCode: _captchaController.text,
                                              // Session ID as a string
                                              sessionId: sessionId.toString(),
                                            );
                                      },
                                      child: Text("Verifikasi Captcha",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              letterSpacing: 1.5,
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontFamily: 'Poppinss')))),
                            SizedBox(height: 10.0),
                            // Button to Generate CAPTCHA
                            if (!isCaptcha)
                              SizedBox(
                                height: 50,
                                child: Material(
                                  borderRadius: BorderRadius.circular(7.0),
                                  color: Colors.orange[600],
                                  child: MaterialButton(
                                    minWidth: MediaQuery.of(context).size.width,
                                    // padding:
                                    //     EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                                    onPressed: () {
                                      // context
                                      //     .read<RegisterCubit>()
                                      //     .generateCaptcha(_emailController.text);
                                      final password = _passwordController.text;
                                      final confirmPassword =
                                          _passwordConfirmController.text;

                                      bool isCurrentPasswordValid =
                                          _isPasswordValid(password);
                                      bool isConfirmPasswordValid =
                                          _isPasswordValid(confirmPassword);

                                      if (password != confirmPassword) {
                                        cekPassword();
                                      } else if (password.isEmpty ||
                                          confirmPassword.isEmpty) {
                                        alertPassword();
                                      } else if (_nohpController.text.isEmpty ||
                                          _emailController.text.isEmpty ||
                                          _namaPerusahaanController
                                              .text.isEmpty ||
                                          _alamatController.text.isEmpty ||
                                          _namapicController.text.isEmpty ||
                                          _npwpController.text.isEmpty ||
                                          selectedKota == null) {
                                        cekField();
                                      } else if ((!isCurrentPasswordValid ||
                                          !isConfirmPasswordValid)) {
                                        alertKarakterPasswordLama();
                                      } else {
                                        // context
                                        //     .read<RegisterCubit>()
                                        //     .generateCaptcha(
                                        //         _emailController.text);
                                        context
                                            .read<CheckEmailCubit>()
                                            .checkEmail(_emailController.text);
                                      }
                                      _captchaController.clear();
                                      controller.text = "";
                                      verificationText = "";
                                      showVerifiedIcon = false;
                                      // captcha();
                                    },
                                    child: Text(
                                      "Selanjutnya",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontFamily: 'Poppinss'),
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
          },
        ));
  }

  Widget notifikasi() {
    return Padding(
      // padding: const EdgeInsets.only(bottom: 5),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 40.0,
              child: Image.asset('assets/notif register.png'),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Text(
              'Captcha Benar',
              style: TextStyle(fontSize: 14, fontFamily: 'Poppinss'),
            ),
          ),
          SizedBox(height: 25),
          Center(
            child: Text(
              'Silahkan Klik button selanjutnya untuk melanjutkan proses sign up.',
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontFamily: 'Poppins Reg'),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: SizedBox(
              height: 40,
              width: 140,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                child: MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  // padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return SyaratKetentuanPage();
                    }));
                  },
                  child: Text(
                    "Selanjutnya",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        // letterSpacing: 1.5,
                        fontSize: 13,
                        color: Colors.white,
                        fontFamily: 'Poppins Bold'),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  fieldKosong() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to start
        children: [
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Harap Periksa Kembali Field Isian Anda!",
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
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

  passwordCek() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to start
        children: [
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Password dan konfirmasi Password harus sama",
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 150,
              height: 35,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                // shadowColor: Colors.grey[350],
                // elevation: 5,
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
        ],
      ),
    );
  }

  notifAlert() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Harap isi Password dan Konfirmasi Password !",
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              width: 150,
              height: 35,
              child: Material(
                borderRadius: BorderRadius.circular(7.0),
                color: Colors.red[900],
                // shadowColor: Colors.grey[350],
                // elevation: 5,
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

  alertLama() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to start
        children: [
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Password harus memiliki minimal 5 karakter, kombinasi huruf besar, angka, dan simbol",
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
              textAlign: TextAlign.justify,
            ),
          ),
          SizedBox(height: 10),
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

  checkEmail() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to start
        children: [
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Email sudah pernah digunakan! Silakan gunakan alamat email yang lain",
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 10),
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
}
