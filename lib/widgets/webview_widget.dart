import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyWebViewWidget extends StatefulWidget {
  final WebViewController controller;

  const MyWebViewWidget({super.key, required this.controller});

  @override
  _MyWebViewWidgetState createState() => _MyWebViewWidgetState();
}

class _MyWebViewWidgetState extends State<MyWebViewWidget> {
  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: widget.controller,
    );
  }
}
