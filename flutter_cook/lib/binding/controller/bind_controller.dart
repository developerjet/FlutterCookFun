import 'package:get/get.dart';

import 'package:flutter_cook/module/home/model/home_list_model.dart';

typedef DataRefreshCallback = void Function();

/// @Deprecated 此控制器已废弃，计划移除。
/// 所有 late 字段均无初始化，调用 refreshFavorite/refreshSettings 会静默失败。
class GetxDataController extends GetxController {
  /// 首页食材分类数据
  HomeFoodListData? foodData;

  /// 收藏数据刷新
  DataRefreshCallback? refreshFavoriteCallback;

  /// 设置数据刷新
  DataRefreshCallback? refreshSettingCallback;

  void updateData(HomeFoodListData data) {
    foodData = data;
    update();
  }

  void refreshFavorite() {
    refreshFavoriteCallback?.call();
    update();
  }

  void refreshSettings() {
    refreshSettingCallback?.call();
    update();
  }
}
