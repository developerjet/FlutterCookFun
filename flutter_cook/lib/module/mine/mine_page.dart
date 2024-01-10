import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/utils/toast.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  _MinePageState createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
            child: Column(
      children: [
        ElevatedButton(
            onPressed: () {
              Get.toNamed('/search');
            },
            child: Text("去搜索界面")),
        ElevatedButton(
            onPressed: () {
              ToastUtils.showShortToast("Hello world");
            },
            child: Text("展示Toast")),
      ],
    )));
  }
}
