import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 应用语言偏好管理器。
///
/// 语言索引只允许 0（简体中文）和 1（英文），非法持久化值会回退到简体中文。
class LanguageManager {
  static const String _preferenceKey = 'Language';
  static const int _chineseIndex = 0;
  static const int _englishIndex = 1;

  /// 保存并立即应用语言设置。
  ///
  /// 参数：
  /// - [languageType]: 0 表示简体中文，1 表示英文。
  ///
  /// 返回：实际保存并应用的合法语言索引。
  static Future<int> saveLanguage(int languageType) async {
    final normalizedIndex = _normalizeIndex(languageType);
    final prefs = await SharedPreferences.getInstance();
    final didSave = await prefs.setInt(_preferenceKey, normalizedIndex);
    if (!didSave) {
      throw StateError('Failed to persist language preference');
    }

    await Get.updateLocale(localeFor(normalizedIndex));
    return normalizedIndex;
  }

  /// 返回：上次保存的合法语言索引。
  static Future<int> fetchLastLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return _normalizeIndex(prefs.getInt(_preferenceKey) ?? _chineseIndex);
  }

  /// 返回：上次保存的语言环境，用于应用启动前初始化。
  static Future<Locale> fetchLastLocale() async {
    return localeFor(await fetchLastLanguage());
  }

  /// 参数：
  /// - [languageType]: 语言索引。
  ///
  /// 返回：与合法语言索引对应的 Locale。
  static Locale localeFor(int languageType) {
    return _normalizeIndex(languageType) == _englishIndex
        ? const Locale('en', 'US')
        : const Locale('zh', 'CN');
  }

  static int _normalizeIndex(int languageType) =>
      languageType == _englishIndex ? _englishIndex : _chineseIndex;
}
