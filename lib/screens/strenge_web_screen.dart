import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:my_flutter_app/widgets/iframe_widget.dart'; // Importiere die Datei mit dem IframeWidget
import 'package:my_flutter_app/widgets/webview_widget.dart'; // Importiere die Datei mit dem WebViewWidget

class StrengeWebScreen extends StatefulWidget {
  const StrengeWebScreen({super.key});

  @override
  _StrengeWebScreenState createState() => _StrengeWebScreenState();
}

class _StrengeWebScreenState extends State<StrengeWebScreen> {
  late WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
     print('Initializing WebViewController for ${widget.runtimeType}');
    if (!kIsWeb) {
      _webViewController = WebViewController()
        ..loadRequest(Uri.parse('https://www.strenge.de'));
    }
  }

  @override
  Widget build(BuildContext context) {
    const String url = 'https://www.strenge.de';

    return WillPopScope(
      onWillPop: () async {
        // Hier kannst du spezifische Logik für das Zurück-Navigieren einfügen
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Strenge Website'),
        ),
        body: kIsWeb
            ? IframeWidget(url: url)
            : MyWebViewWidget(controller: _webViewController),
      ),
    );
  }
}

