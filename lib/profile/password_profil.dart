import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/profile/profil_niaga.dart';
import 'package:niaga_apps_mobile/tracking/menu_tracking_niaga.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../cubit/niaga/password_cubit.dart';
import '../order/menu_order_niaga.dart';
import '../screen-niaga/home_niaga.dart';

class PasswordNiagaPage extends StatefulWidget {
  const PasswordNiagaPage({Key? key}) : super(key: key);

  @override
  State<PasswordNiagaPage> createState() => _PasswordNiagaPageState();
}

class _PasswordNiagaPageState extends State<PasswordNiagaPage> {
  @override

  //untuk BottomNavigationBarItem
  int _selectedIndex = 0;

  final _passwordlamaController = TextEditingController();
  final _passwordbaruController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  final _passwordFocus = FocusNode();
  final _passwordBaruFocus = FocusNode();
  final _passwordConfirmFocus = FocusNode();

  //untuk fungsi masking password
  bool _passwordLamaVisible = true;
  bool _passwordBaruVisible = true;
  bool _passwordConfirmVisible = true;

  bool _passwordsMatch = true;
  bool savePassword = false;
  bool _passwordValid = true;

  String? _passwordErrorLama;
  String? _passwordErrorBaru;

  bool isPasswordChangeSuccess = false;

  // @override
  // void initState() {
  //   super.initState();
  //   BlocProvider.of<PasswordCubit>(context).changePasswordProfil();
  // }

  void _togglePasswordLamaVisibility() {
    setState(() {
      _passwordLamaVisible = !_passwordLamaVisible;
    });
  }

  void _togglePasswordBaruVisibility() {
    setState(() {
      _passwordBaruVisible = !_passwordBaruVisible;
    });
  }

  void _togglePasswordConfirmVisibility() {
    setState(() {
      _passwordConfirmVisible = !_passwordConfirmVisible;
    });
  }

  // void _validatePasswords() {
  //   setState(() {
  //     _passwordsMatch =
  //         _passwordbaruController.text == _passwordConfirmController.text;

  //     // Validate 'Password Lama' and 'Password Baru' based on regex
  //     if (!_isPasswordValid(_passwordlamaController.text)) {
  //       _passwordErrorLama =
  //           'Password lama harus memiliki minimal 5 karakter, kombinasi huruf besar, angka, dan simbol.';
  //     } else {
  //       _passwordErrorLama = null;
  //     }

  //     if (!_isPasswordValid(_passwordbaruController.text)) {
  //       _passwordErrorBaru =
  //           'Password baru harus memiliki minimal 5 karakter, kombinasi huruf besar, angka, dan simbol.';
  //     } else {
  //       _passwordErrorBaru = null;
  //     }
  //   });
  // }

  void _validatePasswords(
      {bool validateLama = false, bool validateBaru = false}) {
    setState(() {
      _passwordsMatch =
          _passwordbaruController.text == _passwordConfirmController.text;

      // Validate 'Password Lama' only when necessary
      if (validateLama && !_isPasswordValid(_passwordlamaController.text)) {
        _passwordErrorLama =
            'Password lama harus memiliki minimal 5 karakter, kombinasi huruf besar, angka, dan simbol.';
      } else {
        _passwordErrorLama = null;
      }

      // Validate 'Password Baru' only when necessary
      if (validateBaru && !_isPasswordValid(_passwordbaruController.text)) {
        _passwordErrorBaru =
            'Password baru harus memiliki minimal 5 karakter, kombinasi huruf besar, angka, dan simbol.';
      } else {
        _passwordErrorBaru = null;
      }
    });
  }

  String passwordPattern = r'^(?=.*?[A-Z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{5,}$';

  bool _isPasswordValid(String password) {
    final RegExp regExp = RegExp(passwordPattern);
    return regExp.hasMatch(password);
  }

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
                    children: [
                      // IconButton(
                      //     icon: Icon(Icons.close),
                      //     onPressed: () {
                      //       Navigator.of(context).pop();
                      //     })
                    ],
                  ),
                  content: passwordCek()),
            ),
          ));

  //password lama tidak sesuai
  Future cekPasswordLama() => showDialog(
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
                  content: cekPwdLama()),
            ),
          ));

  //untuk BottomNavigationBarItem
  static List<Widget> _widgetOptions = <Widget>[
    MenuOrderNiagaPage(),
    MenuTrackingNiagaPage(resiNumber: ''),
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

  //Gagal update password
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

  //sukses ubah password
  Future changePassword() => showDialog(
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
                  content: successChange()),
            ),
          ));

  Widget build(BuildContext context) {
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
                  "Ubah Password",
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
      body: BlocConsumer<PasswordCubit, PasswordState>(
          listener: (context, state) async {
        if (state is ChangePasswordSuccess) {
          _passwordlamaController.clear();
          _passwordbaruController.clear();
          _passwordConfirmController.clear();
          // Optionally, show a success message to the user
          print("Password changed successfully");
          await changePassword();
        } else if (state is ChangePasswordFailure) {
          // Show the failure dialog based on the error message
          await cekPasswordLama();
        }
      }, builder: (context, state) {
        if (state is ChangePasswordInProgress) {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.amber[600],
            ),
          );
        }
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Password Lama',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins Med')),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _passwordFocus,
                          textInputAction: TextInputAction.done,
                          obscureText: _passwordLamaVisible,
                          controller: _passwordlamaController,
                          // onChanged: (value) => _validatePasswords(),
                          onChanged: (value) =>
                              _validatePasswords(validateLama: true),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "********",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12.0),
                            fillColor: Colors.grey[600],
                            labelStyle: TextStyle(fontFamily: 'Montserrat'),
                            suffixIcon: GestureDetector(
                              onTap: _togglePasswordLamaVisibility,
                              child: Icon(
                                _passwordLamaVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                if (_passwordErrorLama != null)
                  Text(
                    _passwordErrorLama!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                SizedBox(height: 10),
                Text('Password Baru',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins Med')),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _passwordBaruFocus,
                          textInputAction: TextInputAction.done,
                          obscureText: _passwordBaruVisible,
                          controller: _passwordbaruController,
                          // onChanged: (value) => _validatePasswords(),
                          onChanged: (value) =>
                              _validatePasswords(validateBaru: true),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "********",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12.0),
                            fillColor: Colors.grey[600],
                            labelStyle: TextStyle(fontFamily: 'Montserrat'),
                            suffixIcon: GestureDetector(
                              onTap: _togglePasswordBaruVisibility,
                              child: Icon(
                                _passwordBaruVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.0,
                              fontFamily: 'Montserrat'),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                if (_passwordErrorBaru != null)
                  Text(
                    _passwordErrorBaru!,
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                SizedBox(height: 10),
                Text('Konfirmasi Password Baru',
                    style: TextStyle(fontSize: 12, fontFamily: 'Poppins Med')),
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
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _passwordConfirmFocus,
                          textInputAction: TextInputAction.done,
                          obscureText: _passwordConfirmVisible,
                          controller: _passwordConfirmController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "********",
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 12.0),
                            fillColor: Colors.grey[600],
                            labelStyle: TextStyle(fontFamily: 'Montserrat'),
                            suffixIcon: GestureDetector(
                              onTap: _togglePasswordConfirmVisibility,
                              child: Icon(
                                _passwordConfirmVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            _validatePasswords(); // Validate on each change
                          },
                          style: TextStyle(
                              color: Colors.grey[600],
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
                SizedBox(height: 80),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: SizedBox(
                          width: 70,
                          height: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.white,
                            // shadowColor: Colors.grey[350],
                            // elevation: 5,
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
                      //==
                      Expanded(
                        child: SizedBox(
                          width: 70,
                          height: 40,
                          child: Material(
                            borderRadius: BorderRadius.circular(7.0),
                            color: Colors.red[900],
                            child: MaterialButton(
                              onPressed: () {
                                final currentPassword =
                                    _passwordlamaController.text;
                                final newPassword =
                                    _passwordbaruController.text;
                                final confirmPassword =
                                    _passwordConfirmController.text;

                                bool isCurrentPasswordValid =
                                    _isPasswordValid(currentPassword);
                                bool isNewPasswordValid =
                                    _isPasswordValid(newPassword);
                                bool passwordsMatch =
                                    newPassword == confirmPassword;

                                if (currentPassword.isEmpty ||
                                    newPassword.isEmpty ||
                                    confirmPassword.isEmpty) {
                                  alertPassword();
                                } else if (newPassword != confirmPassword) {
                                  cekPassword();
                                } else if ((!isCurrentPasswordValid ||
                                    !isNewPasswordValid ||
                                    !passwordsMatch)) {
                                  alertKarakterPasswordLama();
                                } else {
                                  // alertKarakterPasswordLama();
                                  context
                                      .read<PasswordCubit>()
                                      .changePasswordProfil(
                                          currentPassword, newPassword);
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
                      )
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

  notifAlert() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Harap isi Password Lama dan Password Baru !",
              style: TextStyle(
                  color: Colors.black, fontSize: 14, fontFamily: 'Poppinss'),
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
          SizedBox(height: 5),
        ],
      ),
    );
  }

  successChange() {
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
              "Sukses Ubah Password !",
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
          SizedBox(height: 5),
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
          SizedBox(height: 10),
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

  passwordCek() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to start
        children: [
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Password baru dan konfirmasi harus sama",
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

  cekPwdLama() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Align content to start
        children: [
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 15),
          Center(
            child: Text(
              "Password Lama tidak sesuai",
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
