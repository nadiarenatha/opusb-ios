import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatelessWidget {
  final String url;

  WebViewPage({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pembayaran'),
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          // Use webViewController to interact with the WebView
          // For example, you can store it in a variable to use it later
          // _controller = webViewController;
        },
        // onPageStarted: (String url) {
        //   // Handle page start event
        // },
        // onPageFinished: (String url) {
        //   // Handle page finish event
        // },
        // onWebResourceError: (WebResourceError error) {
        //   // Handle web resource error
        // },
        // onProgress: (int progress) {
        //   // Handle web view progress
        // },
      ),
    );
  }
}
