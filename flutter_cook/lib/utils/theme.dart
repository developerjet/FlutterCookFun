import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeManager {
  // 应用主题色
  static const Color themeColor = Color(0xFF00CC99);

  // TabBarItem选中颜色
  static const Color tabSelectedColor = Color(0xFF00CC99);

  // TabBarItem未选中颜色
  static const Color tabUnselectedColor = Color(0xFFAAAAAA);

  // 主要文字颜色
  static Color textMainColor() {
    return Get.isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF152934);
  }

  // 红色
  static Color redMainColor() {
    return Get.isDarkMode ? Color(0xFFDC143C) : Color(0xFFDC143C);
  }

  // 辅助文字颜色
  static Color textGrayColor() {
    return Get.isDarkMode ? Color(0xFF6F777A) : Color(0xFF6F777A);
  }

  /// 描边颜色
  static Color lineBoardColor() {
    return Get.isDarkMode ? Color(0xFF2B2B2B) : Color(0xFFE5E5E5);
  }

  /// 一级背景颜色
  static Color bg1Color() {
    return Get.isDarkMode ? Color(0xFF1E1E1E) : Color(0xFFFFFFFF);
  }

  /// 二级背景颜色
  static Color bg2Color() {
    return Get.isDarkMode ? Color(0xFF2C2C2C) : Color(0xFFF5F6F7);
  }

  /// 三级背景颜色
  static Color bg3Color() {
    return Get.isDarkMode ? Color(0xFF000000) : Color(0xFFF6F6F6);
  }

  // bottomSheet背景颜色
  static Color bottomSheetColor() {
    return Get.isDarkMode ? Color(0xFF000000) : Color(0xFFF5F5F5);
  }

  // 蒙层颜色
  static Color maskBgColor() {
    return Get.isDarkMode ? Color(0xFF04050860) : Color(0xFF04050860);
  }

  // 随机颜色
  static Color generateRandomColor() {
    final random = Random();
    return Color.fromRGBO(
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
      1.0,
    );
  }

  static MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  static void changedTheme() {
    //使用Get 强制更新app状态
    Future.delayed(const Duration(milliseconds: 300), () {
      print("执行这里");
      Get.forceAppUpdate();
    });
  }
}
