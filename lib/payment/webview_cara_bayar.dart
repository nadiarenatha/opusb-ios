import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../screen-niaga/home_niaga.dart';

class WebViewCaraBayarPage extends StatefulWidget {
  final String url;

  const WebViewCaraBayarPage({required this.url, super.key});

  @override
  State<WebViewCaraBayarPage> createState() => _WebViewCaraBayarPageState();
}

class _WebViewCaraBayarPageState extends State<WebViewCaraBayarPage> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
        body: WebViewWidget(controller: _controller),
      ),
    );
  }
}
