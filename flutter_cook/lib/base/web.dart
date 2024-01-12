import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late WebViewController _webController;

  @override
  void initState() {
    final String url = Get.arguments['url'];
    print("url===${url}");

    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(url));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(Get.arguments['title']),
          backgroundColor: CustomColors.themeColor,
        ),
        body: Column(
          children: [
            Expanded(child: WebViewWidget(controller: _webController))
          ],
        ));
  }
}
