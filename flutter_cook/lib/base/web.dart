import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  WebViewPageState createState() => WebViewPageState();
}

class WebViewPageState extends State<WebViewPage> {
  late WebViewController _webController;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    final url = args?['url'] as String? ?? '';
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..loadRequest(Uri.parse(url.isNotEmpty ? url : 'about:blank'));
  }

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments as Map<String, dynamic>?;
    return Scaffold(
      appBar: AppNavBar(title: args?['title'] as String? ?? ''),
      body: WebViewWidget(controller: _webController),
    );
  }
}
