import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/screen/home.dart';
// import 'package:niaga_apps_mobile/screen/home_screen.dart';

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
