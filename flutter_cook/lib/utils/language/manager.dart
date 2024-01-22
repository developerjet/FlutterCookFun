import 'dart:ui';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager {
  
  /// 保存语言设置
  static void saveLanguage(int languageType) async {
    if (languageType == 0) {
      Get.updateLocale(Locale('zh', 'CN'));
    } else {
      Get.updateLocale(Locale('en', 'US'));
    }

    //使用Getx强制更新app状态
    Future.delayed(const Duration(milliseconds: 300), () {
      Get.forceAppUpdate();
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    //保存主题模式
    prefs.setInt("Language", languageType);
  }

  /// 获取语言模式
  static Future<int?> fetchLastLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int lastTheme = prefs.getInt("Language") ?? 0;
    return lastTheme;
  }
}
