import 'package:get/get.dart';

import 'package:flutter_cook/binding/controller/bind_controller.dart';
import 'package:flutter_cook/module/home/controller/home_controller.dart';
import 'package:flutter_cook/module/search/controller/search_controller.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';

// 实现Bindings的接口
class AllControllerBinding implements Bindings {
  @override
  void dependencies() {
    // 核心控制器 - 懒初始化
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchController>(() => SearchController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<SettingController>(() => SettingController());

    // TODO: 逐步淘汰全局控制器，迁移完成后删除
    Get.lazyPut<GetxDataController>(() => GetxDataController());
  }
}
