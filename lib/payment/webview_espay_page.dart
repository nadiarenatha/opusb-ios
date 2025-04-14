// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewEspayPage extends StatelessWidget {
//   final String url;

//   WebViewEspayPage({required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Pembayaran Espay'),
//       ),
//       body: WebView(
//         initialUrl: url,
//         javascriptMode: JavascriptMode.unrestricted,
//         onWebViewCreated: (WebViewController webViewController) {
//         },
//       ),
//     );
//   }
// }

//tutup modal dialog
// import 'package:flutter/material.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// class WebViewEspayPage extends StatelessWidget {
//   final String url;

//   WebViewEspayPage({required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Close the modal when back is pressed
//         Navigator.pop(context); // Close the WebView page
//         Navigator.pop(context); // Close the modal dialog
//         return true;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Pembayaran'),
//         ),
//         body: WebView(
//           initialUrl: url,
//           javascriptMode: JavascriptMode.unrestricted,
//         ),
//       ),
//     );
//   }
// }

//klik back ke halaman invoice

import 'package:flutter/material.dart';
import 'package:niaga_apps_mobile/screen-niaga/invoice_home_niaga.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../Invoice/invoice_espay.dart';
import '../Invoice/menu_invoice_niaga.dart';
import '../Invoice/my_invoice_niaga.dart';
import '../screen-niaga/home_niaga.dart';

// class WebViewEspayPage extends StatelessWidget {
//   final String url;

//   WebViewEspayPage({required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Navigate back to MenuInvoiceNiagaPage when back is pressed
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             // builder: (context) => MyInvoiceHomeNiagaPage(),
//             // builder: (context) => EspayInvoiceNiagaPage(),
//             builder: (context) => HomeNiagaPage(),
//           ),
//         );
//         return false; // Prevent default back navigation
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text('Pembayaran'),
//         ),
//         body: WebView(
//           initialUrl: url,
//           javascriptMode: JavascriptMode.unrestricted,
//           onWebViewCreated: (WebViewController webViewController) {
//             // Additional web view setup
//           },
//         ),
//       ),
//     );
//   }
// }

class WebViewEspayPage extends StatefulWidget {
  final String url;
  final String selectedMethodName;
  final String selectedMethodValue;
  final String invoiceNumber;
  final String noPL;
  final String rute;
  final String typePengiriman;
  final String volume;

  WebViewEspayPage({
    required this.url,
    required this.selectedMethodName,
    required this.selectedMethodValue,
    required this.invoiceNumber,
    required this.noPL,
    required this.rute,
    required this.typePengiriman,
    required this.volume,
  });

  @override
  _WebViewEspayPageState createState() => _WebViewEspayPageState();
}

class _WebViewEspayPageState extends State<WebViewEspayPage> {
  late String selectedMethodName;
  late String selectedMethodValue;
  late String selectedInvoiceNumber;
  late String selectedNoPL;
  late String selectedRute;
  late String selectedTypePengiriman;
  late String selectedVolume;

  @override
  void initState() {
    super.initState();
    selectedMethodName = widget.selectedMethodName;
    selectedMethodValue = widget.selectedMethodValue;
    selectedInvoiceNumber = widget.invoiceNumber;
    selectedNoPL = widget.noPL;
    selectedRute = widget.rute;
    selectedTypePengiriman = widget.typePengiriman;
    selectedVolume = widget.volume;
    print('get selectedMethodName = $selectedMethodName');
    print('get selectedMethodValue = $selectedMethodValue');
    print('get selectedInvoiceNumber = $selectedInvoiceNumber');
    print('get selectedNoPL = $selectedNoPL');
    print('get selectedRute = $selectedRute');
    print('get selectedTypePengiriman = $selectedTypePengiriman');
    print('get selectedVolume = $selectedVolume');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          selectedMethodName = '';
          selectedMethodValue = '';
          selectedInvoiceNumber = '';
          selectedNoPL = '';
          selectedRute = '';
          selectedTypePengiriman = '';
          selectedVolume = '';
          print('selectedMethodName di Espay: $selectedMethodName');
          print('selectedMethodValue di Espay: $selectedMethodValue');
          print('selectedInvoiceNumber di Espay: $selectedInvoiceNumber');
          print('selectedNoPL di Espay: $selectedNoPL');
          print('selectedRute di Espay: $selectedRute');
          print('selectedTypePengiriman di Espay: $selectedTypePengiriman');
          print('selectedVolume di Espay: $selectedVolume');
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeNiagaPage(initialIndex: 3),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pembayaran'),
        ),
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
