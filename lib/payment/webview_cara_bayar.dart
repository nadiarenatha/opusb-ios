import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../screen-niaga/home_niaga.dart';

class WebViewCaraBayarPage extends StatefulWidget {
  final String url;

  WebViewCaraBayarPage({required this.url});

  @override
  _WebViewCaraBayarPageState createState() => _WebViewCaraBayarPageState();
}

class _WebViewCaraBayarPageState extends State<WebViewCaraBayarPage> {
  @override
  void initState() {
    super.initState();
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
        body: WebView(
          initialUrl: widget.url,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}
