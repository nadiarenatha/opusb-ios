// import 'dart:ui';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:niaga_apps_mobile/cubit/auth_cubit.dart';
import 'package:niaga_apps_mobile/login/reset_password.dart';
import 'package:niaga_apps_mobile/shared/logistic_theme.dart';

import '../cubit/niaga/auth_niaga_cubit.dart';
import '../cubit/niaga/data_login_cubit.dart';
import '../cubit/niaga/id_account_cubit.dart';
import '../model/data_login.dart';
import '../screen-niaga/home_niaga.dart';
import '../shared/constants.dart';
import '../shared/functions/flutter_secure_storage.dart';
import 'create_account_perseorangan.dart';

class LoginBody extends StatefulWidget {
  const LoginBody({Key? key}) : super(key: key);

  @override
  State<LoginBody> createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordFocus = FocusNode();
  final _emailFocus = FocusNode();

  //untuk fungsi masking password
  bool _passwordVisible = true;
  bool savePassword = false;

  List<String> roleList = [];

  bool isLoggedIn = false;

  DataLoginAccesses? dataLogin;
  bool isLoginButtonDisabled = false;

  //untuk fungsi masking password
  void _togglevisibility() {
    setState(() {
      _passwordVisible = !_passwordVisible;
    });
  }

  Future<void> showLoadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible:
          false, // Prevent dismissing the dialog by tapping outside
      builder: (context) => Center(
        child: CircularProgressIndicator(
          color: Colors.amber[600],
        ),
      ),
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  Future notifFail() => showDialog(
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
                  content: gagalLogin()),
            ),
          ));

  Future<void> showRoleNotSupportedDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Role ini tidak didukung'),
        content:
            Text('Karyawan Niaga hanya dapat login menggunakan Aplikasi Web.'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                isLoginButtonDisabled = false;
              });
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  gagalLogin() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align content to start
        children: [
          SizedBox(height: 5),
          Center(
            child: SizedBox(
              height: 40.0, // Adjust the height as needed
              child: Image.asset('assets/Cancel.png'),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Username / Password Salah",
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

  @override
  Widget build(BuildContext context) {
    //final size agar gambar background sesuai dgn masing2 layar hp
    final Size screenSize = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<AuthNiagaCubit>(
          create: (context) => AuthNiagaCubit(),
        ),
        BlocProvider<IdAccountCubit>(
          create: (context) => IdAccountCubit(),
        ),
        BlocProvider<DataLoginCubit>(
          create: (context) => DataLoginCubit(),
        ),
      ],
      child: Scaffold(
        //agar saat input data keyboard
        resizeToAvoidBottomInset: true,
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, authState) {
            // TODO: implement listener
            if (authState is AuthAuthenticationSuccess) {
              // roleList.clear();
              // roleList = state.response.authorities!;
              // setState(() {
              //   isLoggedIn = !isLoggedIn;
              // });

              BlocProvider.of<AuthNiagaCubit>(context).authenticateNiaga(
                  // _emailController.text,
                  // _passwordController.text,
                  );
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) {
              //   return HomePage();
              // }));
              BlocProvider.of<IdAccountCubit>(context).getIdAccount();
            } else if (authState is AuthFailure) {
              notifFail();
            }
          },
          builder: (context, authState) {
            return BlocConsumer<AuthNiagaCubit, AuthNiagaState>(
              listener: (context, authNiagaState) async {
                if (authNiagaState is AuthNiagaAuthenticationSuccess) {
                  final String? niagaToken =
                      await BlocProvider.of<AuthNiagaCubit>(context)
                          .getValidAccessToken();

                  print("Niaga Token: $niagaToken");

                  final String? authToken =
                      BlocProvider.of<AuthCubit>(context).getToken();

                  // Proceed to HomePage if both tokens are retrieved successfully
                  // if (authToken != null && niagaToken != null) {
                  //   Navigator.pushReplacement(
                  //     context,
                  //     // MaterialPageRoute(builder: (context) => HomePage()),
                  //     MaterialPageRoute(builder: (context) => HomeNiagaPage()),
                  //   );
                  // }
                }
              },
              builder: (context, authNiagaState) {
                return BlocConsumer<IdAccountCubit, IdAccountState>(
                    listener: (context, idAccountState) async {
                  if (idAccountState is IdAccountSuccess) {
                    // Fetching the first account's ID
                    final int? accountId = idAccountState.response.first.id;

                    if (accountId != null) {
                      final flagEmployee = await BlocProvider.of<DataLoginCubit>(context).dataLogin(id: accountId);
                      print('account id: $accountId');

                      if (!flagEmployee) {
                        final String? niagaToken = await BlocProvider.of<AuthNiagaCubit>(context).getValidAccessToken();
                        final String? authToken = BlocProvider.of<AuthCubit>(context).getToken();

                        if (authToken != null && niagaToken != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeNiagaPage()),
                          );
                        }
                      }
                    }
                  } else if (idAccountState is IdAccountFailure) {
                    // Handle failure
                  }
                }, builder: (context, idAccountState) {
                  return BlocConsumer<DataLoginCubit, DataLoginState>(
                      listener: (context, dataLoginState) async {
                    if (dataLoginState is DataLoginRoleNotSupported) {
                      setState(() {
                        isLoginButtonDisabled = true;
                      });
                      showRoleNotSupportedDialog(context);
                    }
                  }, builder: (context, datastate) {
                    return Stack(
                        // child:
                        children: [
                          Container(
                            //height & weight sesuai layar masing2
                            height: screenSize.height,
                            //height & weight sesuai layar masing2
                            width: screenSize.width,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/background-login.jpeg'),
                                    fit: BoxFit.cover)),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    height: 100.0,
                                  ),
                                  SizedBox(
                                    height: 115.0,
                                    child: Image.asset('assets/Logo Niaga.png'),
                                  ),
                                  SizedBox(
                                    height: 100.0,
                                  ),
                                  // Align(
                                  //   alignment: Alignment.topLeft,
                                  //   child: Column(
                                  //     crossAxisAlignment:
                                  //         CrossAxisAlignment.start,
                                  //     children: [
                                  //       Text(
                                  //         'Login',
                                  //         style: TextStyle(
                                  //             fontSize: 20,
                                  //             color: Colors.white,
                                  //             fontFamily: 'Montserrat',
                                  //             fontWeight: FontWeight.w800),
                                  //       ),
                                  //       Text(
                                  //         'to Your Account',
                                  //         style: TextStyle(
                                  //             fontSize: 20,
                                  //             color: Colors.white,
                                  //             fontWeight: FontWeight.w800),
                                  //       ),
                                  //     ],
                                  //   ),
                                  // ),
                                  SizedBox(height: 25.0),
                                  Container(
                                    child: Material(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0)),
                                        // color: Colors.blue,
                                        color: Colors.red[900],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              // padding: EdgeInsets.all(13.0),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0,
                                                  horizontal: 10.0),
                                              child: Icon(Icons.person,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(7.0),
                                                    bottomRight:
                                                        Radius.circular(7.0),
                                                  ),
                                                ),
                                                // width: 400,
                                                // height: 50,
                                                // padding: EdgeInsets.all(2.0),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 10.0),
                                                child: TextFormField(
                                                  // focusNode: _emailFocus,
                                                  focusNode: _emailFocus,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onFieldSubmitted: (v) {
                                                    FocusScope.of(context)
                                                        .requestFocus(
                                                            _passwordFocus);
                                                  },
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none,
                                                      hintText:
                                                          "Masukkan email Anda",
                                                      hintStyle:
                                                          const TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                      // Adjust the top padding
                                                      // contentPadding:
                                                      //     EdgeInsets.only(
                                                      //         bottom: 2.0,
                                                      //         top: -6.0),
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              bottom: 8.0,
                                                              top: 8.0),
                                                      fillColor: Colors.white,
                                                      labelStyle: TextStyle(
                                                          fontFamily:
                                                              'Montserrat')),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      // fontSize: 20.0,
                                                      fontSize: _emailController
                                                                  .text.length >
                                                              20
                                                          ? 14.0
                                                          : 15.0,
                                                      fontFamily: 'Montserrat'),
                                                  // filled: true,
                                                  controller: _emailController,
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    child: Material(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0)),
                                        // color: Color.fromRGBO(33, 150, 243, 1),
                                        // color: Color.fromRGBO(33, 150, 243, 1),
                                        color: Colors.red[900],
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Padding(
                                              // padding: EdgeInsets.all(13.0),
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.0,
                                                  horizontal: 10.0),
                                              child: Icon(Icons.vpn_key,
                                                  color: Colors.white),
                                            ),
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(7.0),
                                                    bottomRight:
                                                        Radius.circular(7.0),
                                                  ),
                                                ),
                                                // width: 320,
                                                // // height: 60,
                                                // height: 50,
                                                // padding: EdgeInsets.all(8.0),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 2.0,
                                                    horizontal: 10.0),
                                                child: TextFormField(
                                                  focusNode: _passwordFocus,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  onFieldSubmitted: (v) {
                                                    // _onLoginButtonPressed(context);
                                                  },
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintText:
                                                        "Masukkan password Anda",
                                                    hintStyle: const TextStyle(
                                                      fontSize: 15,
                                                    ),
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            bottom: 8.0,
                                                            top: 10.0),
                                                    fillColor: Colors.white,
                                                    labelStyle: TextStyle(
                                                        fontFamily:
                                                            'Montserrat'),
                                                    suffixIcon: GestureDetector(
                                                      onTap: () {
                                                        _togglevisibility();
                                                      },
                                                      child: Icon(
                                                        _passwordVisible
                                                            ? Icons.visibility
                                                            : Icons
                                                                .visibility_off,
                                                        // color: Theme.of(context).primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      // fontSize: 20.0,
                                                      fontSize:
                                                          _passwordController
                                                                      .text
                                                                      .length >
                                                                  20
                                                              ? 14.0
                                                              : 15.0,
                                                      fontFamily: 'Montserrat'),
                                                  controller:
                                                      _passwordController,
                                                  //untuk membuat masking password
                                                  obscureText: _passwordVisible,
                                                ),
                                              ),
                                            )
                                          ],
                                        )),
                                  ),
                                  //role
                                  // if (isLoggedIn == true) SizedBox(height: 15.0),
                                  //pilih role
                                  // if (isLoggedIn == true) roleOrg(roleList),
                                  SizedBox(height: 80),
                                  // Row(
                                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  //   children: [
                                  //     TextButton(
                                  //       child: Text(
                                  //         "Create Account",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontFamily: 'Montserrat',
                                  //             fontWeight: FontWeight.w900),
                                  //       ),
                                  //       onPressed: () {},
                                  //     ),
                                  //     TextButton(
                                  //       child: Text(
                                  //         "Forgot Password?",
                                  //         style: TextStyle(
                                  //             color: Colors.white,
                                  //             fontFamily: 'Montserrat',
                                  //             fontWeight: FontWeight.w900),
                                  //       ),
                                  //       onPressed: () {},
                                  //     )
                                  //   ],
                                  // ),
                                  //tombol login
                                  Material(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color: Colors.red[900],
                                    child: MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      onPressed: isLoginButtonDisabled
                                          ? null
                                          : () async {
                                              BlocProvider.of<AuthCubit>(
                                                      context)
                                                  .authenticate(
                                                _emailController.text,
                                                _passwordController.text,
                                              );
                                            },
                                      child: Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 15.0,
                                  ),
                                  Material(
                                    borderRadius: BorderRadius.circular(7.0),
                                    color: Colors.orange[600],
                                    child: MaterialButton(
                                      minWidth:
                                          MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.fromLTRB(
                                          20.0, 15.0, 20.0, 15.0),
                                      onPressed: () {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CreateAccountPerseoranganPage()),
                                        );
                                      },
                                      child:
                                          // Row(
                                          //   mainAxisAlignment: MainAxisAlignment.center,
                                          //   children: [
                                          //     //untuk tambah icon search
                                          //     Icon(Icons.search, color: Colors.white),
                                          //     SizedBox(width: 10),
                                          Text(
                                        "Create New Account",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          letterSpacing: 1.5,
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      //   ],
                                      // ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      TextButton(
                                        child: Text(
                                          "Forgot Password?",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'Montserrat',
                                              fontWeight: FontWeight.w900),
                                        ),
                                        onPressed: () {
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ResetPasswordPage();
                                          }));
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          if (authState is AuthInProgress ||
                              authNiagaState is AuthNiagaInProgress)
                            Center(
                              child: CircularProgressIndicator(
                                color: Colors.amber[600],
                              ),
                            ),
                        ]);
                  });
                });
              },
            );
          },
        ),
      ),
    );
  }

  Widget roleOrg(
    List<String> roleItemsString,
    // List<IdNamePair> roleItems,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Text(
        //   'Select Role',
        //   style: TextStyle(
        //     color: blue,
        //     fontWeight: bold,
        //     fontSize: 16,
        //     fontFamily: ,
        //   ),
        // ),
        // const SizedBox(height: 10),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Role',
              style: TextStyle(
                  fontSize: 14,
                  // fontFamily: poppins,
                  color: white,
                  fontWeight: FontWeight.w800),
            ),
            // Text(
            //   '*',
            //   style: TextStyle(
            //     color: redCalendar,
            //     fontSize: 14,
            //     fontFamily: poppins,
            //   ),
            // ),
          ],
        ),
        Flexible(
          child: DropdownSearch<String>(
            // enabled: false,
            items: roleItemsString,
            popupProps: const PopupProps.menu(
              menuProps: MenuProps(),
              showSearchBox: false,
              scrollbarProps: ScrollbarProps(thumbVisibility: true),
              constraints:
                  BoxConstraints(minWidth: 300, maxWidth: 300, maxHeight: 100),
            ),
            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration.collapsed(
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(6.0),
                ),
                hintText: " Select role",
                hintStyle: const TextStyle(
                  fontSize: 11,
                  // fontFamily: poppins,
                ),
                filled: true,
                fillColor: greyF4,
              ),
              textAlignVertical: TextAlignVertical.center,
            ),
            onChanged: (String? newValue) {
              setState(() {
                // dropdownValue = newValue!;
                // // setState(() {});
                // int? index = 0;
                // index = roleItems.indexWhere((e) => e.name == newValue);
                // roleId = roleItems[index].id;
                // if (newValue.contains(" Admin")) {
                //   admin = true;
                // }
                // if (newValue.contains("Manager ")) {
                //   manager = true;
                // }
              });
            },
          ),
        ),
        const SizedBox(height: 10),
        // const Row(
        //   mainAxisSize: MainAxisSize.min,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Text('Organization'),
        //     Text('*', style: TextStyle(color: Colors.red)),
        //   ],
        // ),
        // Flexible(
        //   child: DropdownSearch<String>(
        //     // enabled: false,
        //     items: orgItems,
        //     popupProps: const PopupProps.menu(
        //       // title: Text(
        //       //   "Organization",
        //       //   textAlign: TextAlign.center,
        //       //   style: TextStyle(fontSize: 16),
        //       // ),
        //       showSearchBox: false,
        //       scrollbarProps: ScrollbarProps(thumbVisibility: true),
        //       constraints: BoxConstraints(
        //         // minWidth: 400,
        //         minWidth: 300,
        //         maxWidth: 300,
        //         maxHeight: 200,
        //         // maxHeight: 600,
        //       ),
        //       // BoxConstraints.
        //     ),
        //     dropdownDecoratorProps: DropDownDecoratorProps(
        //       dropdownSearchDecoration: InputDecoration.collapsed(
        //         hintText: " Select organization",
        //         hintStyle: TextStyle(
        //           color: Colors.grey[600],
        //           fontSize: 12,
        //         ),
        //         filled: true,
        //         fillColor: Colors.grey[200],
        //       ),
        //       textAlignVertical: TextAlignVertical.center,
        //     ),
        //     onChanged: (String? newValue) {
        //       dropdownValue = newValue!;
        //       setState(() {});
        //     },
        //   ),
        // ),
        // * ================================================
        // Row(
        //   mainAxisSize: MainAxisSize.max,
        //   children: [
        //     Expanded(
        //       flex: 1,
        //       child: Container(
        //         // width: MediaQuery.sizeOf(context).width,
        //         padding: const EdgeInsets.symmetric(vertical: 10),
        //         child: Material(
        //           elevation: 5.0,
        //           borderRadius: BorderRadius.circular(7.0),
        //           color: Colors.red,
        //           child: MaterialButton(
        //             // minWidth: MediaQuery.of(context)
        //             //         .size
        //             //         .width /
        //             //     5,
        //             minWidth: 30,
        //             padding: const EdgeInsets.symmetric(
        //               horizontal: 20,
        //               vertical: 15,
        //             ),
        //             onPressed: () => setState(() {
        //               // _pageIndex = 0;
        //             }),
        //             child: Text(
        //               "Cancel",
        //               textAlign: TextAlign.center,
        //               // style:
        //               //     OpusbTheme().whiteTextStyleO.copyWith(fontSize: 20),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //     const SizedBox(width: 10),
        //     Expanded(
        //       flex: 1,
        //       child: Container(
        //         // width: MediaQuery.sizeOf(context).width,
        //         padding: const EdgeInsets.symmetric(vertical: 10),
        //         child: Material(
        //           elevation: 5.0,
        //           borderRadius: BorderRadius.circular(7.0),
        //           color: blueOceanTheme,
        //           child: MaterialButton(
        //             minWidth: 30,
        //             padding: const EdgeInsets.symmetric(
        //                 horizontal: 20, vertical: 15),
        //             onPressed: () => _loginRoleAccess(context),
        //             child: Text(
        //               "OK",
        //               textAlign: TextAlign.center,
        //               style:
        //                   OpusbTheme().whiteTextStyleO.copyWith(fontSize: 20),
        //             ),
        //           ),
        //         ),
        //       ),
        //     ),
        //   ],
        // ),
      ],
    );
  }

  // _onLoginButtonPressed(BuildContext context) {
  //   if (savePassword) {}
  //   BlocProvider.of<AuthCubit>(context)
  //       .authenticate(_emailController.text, _passwordController.text);
  // }
}
