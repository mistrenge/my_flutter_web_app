import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui_web' as ui;

class IframeWidget extends StatelessWidget {
  final String url;

  const IframeWidget({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      print(url);
      // Generiere einen einzigartigen viewType
      final viewType = 'iframeElement_${DateTime.now().millisecondsSinceEpoch}';

      // Erstelle ein IFrame-Element und setze dessen Attribute
      final iframe = html.IFrameElement()
        ..width = '100%'
        ..height = '100%'
        ..src = url
        ..style.border = 'none';

      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(
        viewType,
        (int viewId) => iframe,
      );

      // Verwende HtmlElementView, um das IFrame-Element anzuzeigen
      return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: HtmlElementView(
          viewType: viewType,
        ),
      );
    } else {
      return const Center(
        child: Text('Iframe ist nur auf dem Web verfügbar.'),
      );
    }
  }
}

