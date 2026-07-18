import 'package:get/get.dart';

/// 管理应用四个主 Tab 的唯一导航状态。
class TabNavigationController extends GetxController {
  static const int homeIndex = 0;
  static const int cookIndex = 1;
  static const int recipeIndex = 2;
  static const int mineIndex = 3;
  static const int tabCount = 4;

  final RxInt currentIndex = homeIndex.obs;

  /// 切换到指定 Tab。
  ///
  /// 参数：
  /// - [index]: 目标 Tab 索引，合法范围为 0 到 3。
  ///
  /// 返回：索引合法并完成处理时返回 true，否则返回 false。
  bool select(int index) {
    if (index < 0 || index >= tabCount) {
      return false;
    }
    currentIndex.value = index;
    return true;
  }
}
