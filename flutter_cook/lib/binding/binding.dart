import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/module/home/controller/foodClassController.dart';
import '../module/search/search_page.dart';

// 实现Bindings的接口
class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    // 懒初始化
    Get.lazyPut<SearchPage>(() => SearchPage());
    Get.lazyPut<FoodDataController>(() => FoodDataController());
  }
}
