import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:my_flutter_app/widgets/iframe_widget.dart'; // Importiere die Datei mit dem IframeWidget
import 'package:my_flutter_app/widgets/webview_widget.dart'; // Importiere die Datei mit dem WebViewWidget

class CRMWebScreen extends StatefulWidget {
  const CRMWebScreen({super.key});

  @override
  _CRMWebScreenState createState() => _CRMWebScreenState();
}

class _CRMWebScreenState extends State<CRMWebScreen> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
     print('Initializing WebViewController for ${widget.runtimeType}');
    if (!kIsWeb) {
      _webViewController = WebViewController()
        ..loadRequest(Uri.parse('https://ebo-app01.strenge.de:4160/mobilecrm/de/login'));
    }
  }

  @override
  Widget build(BuildContext context) {
    const String url = 'https://ebo-app01.strenge.de:4160/mobilecrm/de/login';

    return WillPopScope(
      onWillPop: () async {
        // Hier kannst du spezifische Logik für das Zurück-Navigieren einfügen
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CRM Website'),
        ),
        body: kIsWeb
            ? IframeWidget(url: url)
            : MyWebViewWidget(controller: _webViewController),
      ),
    );
  }
}
