/// 设置控制器 (GetX Controller)
///
/// 职责：
/// 1. 管理设置页面状态
/// 2. 处理主题和语言切换
/// 3. 持久化设置数据

import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/language/manager.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  static const String _tag = 'SettingController';

  // 响应式状态
  final selectedTheme = 0.obs;
  final selectedLanguage = 0.obs;
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);

  // 设置项列表
  final settingsItems = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    updateSettingsItems();
  }

  /// 加载设置数据
  void _loadSettings() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      selectedTheme.value = await ThemeManager.fetchLastTheme() ?? 0;
      selectedLanguage.value = await LanguageManager.fetchLastLanguage() ?? 0;

      AppLogger.info(_tag, 'Settings loaded successfully: theme=$selectedTheme, language=$selectedLanguage');
    } catch (e) {
      errorMessage.value = 'load_settings_failed'.tr;
      AppLogger.error(_tag, 'Failed to load settings data', e as Exception?);
    } finally {
      isLoading.value = false;
    }
  }

  /// 更新设置项列表（支持多语言）
  void updateSettingsItems() {
    settingsItems.assignAll([
      'change_theme'.tr,
      'setting_language'.tr,
    ]);
  }

  /// 切换主题
  Future<void> changeTheme(int themeIndex) async {
    try {
      selectedTheme.value = themeIndex;
      await ThemeManager.saveTheme(themeIndex);
      AppLogger.info(_tag, 'Theme changed successfully: $themeIndex');
    } catch (e) {
      errorMessage.value = 'change_theme_failed'.tr;
      AppLogger.error(_tag, 'Failed to change theme: $themeIndex', e as Exception?);
    }
  }

  /// 切换语言
  Future<void> changeLanguage(int languageIndex) async {
    try {
      selectedLanguage.value = languageIndex;
      LanguageManager.saveLanguage(languageIndex);

      // 更新语言
      final locale = languageIndex == 0
          ? const Locale('zh', 'CN')
          : const Locale('en', 'US');

      Get.updateLocale(locale);
      updateSettingsItems(); // 更新设置项文本

      AppLogger.info(_tag, 'Language changed successfully: $languageIndex');
    } catch (e) {
      errorMessage.value = 'change_language_failed'.tr;
      AppLogger.error(_tag, 'Failed to change language: $languageIndex', e as Exception?);
    }
  }

  /// 获取当前主题模式
  ThemeMode get currentThemeMode {
    return selectedTheme.value == 0 ? ThemeMode.light : ThemeMode.dark;
  }

  /// 获取当前语言
  Locale get currentLocale {
    return selectedLanguage.value == 0
        ? const Locale('zh', 'CN')
        : const Locale('en', 'US');
  }

  /// 重置设置
  Future<void> resetSettings() async {
    try {
      await changeTheme(0); // 默认亮色主题
      await changeLanguage(0); // 默认中文

      AppLogger.info(_tag, 'Settings reset successfully');
    } catch (e) {
      errorMessage.value = 'reset_settings_failed'.tr;
      AppLogger.error(_tag, 'Failed to reset settings', e as Exception?);
    }
  }

  /// 清除错误信息
  void clearError() {
    errorMessage.value = null;
  }

  @override
  void onClose() {
    AppLogger.info(_tag, 'SettingController disposed');
    super.onClose();
  }
}