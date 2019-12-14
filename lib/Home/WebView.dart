import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebView extends StatefulWidget {
  createState()
  {
    return _WebViewState();
  }

}

class _WebViewState extends State<WebView>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text("Emergency Helplines"),),
      body: WebviewScaffold(
        url: "https://www.indiatoday.in/information/story/list-of-emergency-numbers-in-india-1464566-2019-02-26",
        withLocalStorage: true,
        withZoom: true,
      ),
    );
  }
}