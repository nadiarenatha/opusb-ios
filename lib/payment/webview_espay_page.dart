import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../screen-niaga/home_niaga.dart';

class WebViewEspayPage extends StatefulWidget {
  final String url;
  final String selectedMethodName;
  final String selectedMethodValue;
  final String invoiceNumber;
  final String noPL;
  final String rute;
  final String typePengiriman;
  final String volume;

  const WebViewEspayPage({
    Key? key,
    required this.url,
    required this.selectedMethodName,
    required this.selectedMethodValue,
    required this.invoiceNumber,
    required this.noPL,
    required this.rute,
    required this.typePengiriman,
    required this.volume,
  }) : super(key: key);

  @override
  _WebViewEspayPageState createState() => _WebViewEspayPageState();
}

class _WebViewEspayPageState extends State<WebViewEspayPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));

    debugPrint('get selectedMethodName = ${widget.selectedMethodName}');
    debugPrint('get selectedMethodValue = ${widget.selectedMethodValue}');
    debugPrint('get selectedInvoiceNumber = ${widget.invoiceNumber}');
    debugPrint('get selectedNoPL = ${widget.noPL}');
    debugPrint('get selectedRute = ${widget.rute}');
    debugPrint('get selectedTypePengiriman = ${widget.typePengiriman}');
    debugPrint('get selectedVolume = ${widget.volume}');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Optionally reset values here if needed
        debugPrint('Back pressed. Navigating to HomeNiagaPage.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeNiagaPage(initialIndex: 3),
          ),
        );
        return false; // Prevent default back navigation
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran'),
        ),
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
