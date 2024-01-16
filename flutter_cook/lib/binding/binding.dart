import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/binding/controller/bindController.dart';
import '../module/search/search_page.dart';

// 实现Bindings的接口
class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    // 懒初始化
    Get.lazyPut<GetxDataController>(() => GetxDataController());
  }
}
