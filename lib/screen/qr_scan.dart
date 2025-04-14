import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import '../screen-niaga/home_niaga.dart';

class QRViewExample extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String result = '';
  bool isFlashOn = false;

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      if (Platform.isAndroid) {
        controller?.pauseCamera();
      }
      Future.delayed(Duration(milliseconds: 300), () {
        controller?.resumeCamera();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

  Future<void> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeNiagaPage()),
    );
    return false; // Prevent default back navigation
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomeNiagaPage()),
              );
            },
          ),
          title: Text(
            "Tracking Barang",
            style: TextStyle(
              fontSize: 20,
              color: Colors.red[900],
              fontFamily: 'Poppin',
              fontWeight: FontWeight.w900,
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  isFlashOn = !isFlashOn;
                });
                controller?.toggleFlash();
              },
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red[900]!,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 200,
              ),
            ),
            // Display the scan result below the QRView
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  result.isEmpty ? 'Scan a code' : 'Result: $result',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = ''; // Clear the result before scanning
      });

      if (scanData.code != null) {
        setState(() {
          result = scanData.code!;
        });

        print('Scanned QR Code Hasil: $result');

        if (Navigator.canPop(context)) {
          Navigator.of(context).pop(result);
        } else {
          print("No route to pop!");
        }
      }
    });

    // Ensure the camera is focused
    controller.resumeCamera();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
