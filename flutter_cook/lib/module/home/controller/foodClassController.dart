import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/module/home/model/home_model.dart';

class FoodClassController extends GetxController {
  // 首页食材分类数据
  late HomeFoodListData foodData;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  void updateData(HomeFoodListData data) {
    // 更新数据
    foodData = data;

    update();
  }
}
