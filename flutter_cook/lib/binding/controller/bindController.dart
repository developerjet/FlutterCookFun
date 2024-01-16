import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_cook/module/home/model/home_list_model.dart';

typedef dataRefreshCallback = void Function();

class GetxDataController extends GetxController {
  /// 首页食材分类数据
  late HomeFoodListData foodData;

  /// 收藏数据刷新
  late dataRefreshCallback refreshFavoriteCallback;

  /// 设置数据刷新
  late dataRefreshCallback refreshSettingCallback;

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

  void refreshFavorite() {
    refreshFavoriteCallback();

    update();
  }

  void refreshSettings() {
    refreshSettingCallback();

    update();
  }
}
