import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {

  /// 保存语言设置
  static Future<void> saveLanguage(int languageType) async {
    if (languageType == 0) {
      Get.updateLocale(const Locale('zh', 'CN'));
    } else {
      Get.updateLocale(const Locale('en', 'US'));
    }

    // 等待当前帧完成后强制刷新
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.forceAppUpdate();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt("Language", languageType);
  }

  /// 获取语言模式
  static Future<int?> fetchLastLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastLanguage = prefs.getInt("Language") ?? 0;
    return lastLanguage;
  }
}
