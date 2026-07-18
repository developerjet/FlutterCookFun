import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends GetxController {
  static const Color primaryColor = CookTokens.primary;
  static const Color themeColor = primaryColor;
  static const Color tabSelectedColor = CookTokens.primary;
  static const Color tabUnselectedColor = CookTokens.textTertiary;

  final Rx<ThemeMode> currentThemeMode = ThemeMode.light.obs;

  ThemeMode get themeMode => currentThemeMode.value;
  bool get isDarkMode => currentThemeMode.value == ThemeMode.dark;

  Color get surfaceColor =>
      isDarkMode ? CookTokens.surfaceDark : CookTokens.surface;
  Color get backgroundColor =>
      isDarkMode ? CookTokens.pageDark : CookTokens.page;
  Color get cardColor => surfaceColor;
  Color get textPrimaryColor =>
      isDarkMode ? const Color(0xFFF4FBF7) : CookTokens.textPrimary;
  Color get textSecondaryColor =>
      isDarkMode ? const Color(0xFFB6C5BE) : CookTokens.textSecondary;
  Color get dividerColor =>
      isDarkMode ? const Color(0xFF2A3832) : CookTokens.border;
  Color get bottomSheetBackground => surfaceColor;
  Color get maskBgColor => const Color(0x60000000);

  ThemeData? _cachedLightTheme;
  ThemeData? _cachedDarkTheme;

  ThemeData get lightTheme {
    _cachedLightTheme ??= _buildTheme(Brightness.light);
    return _cachedLightTheme!;
  }

  ThemeData get darkTheme {
    _cachedDarkTheme ??= _buildTheme(Brightness.dark);
    return _cachedDarkTheme!;
  }

  void invalidateThemeCache() {
    _cachedLightTheme = null;
    _cachedDarkTheme = null;
  }

  ThemeData _buildTheme(Brightness brightness) {
    return brightness == Brightness.dark ? CookTheme.dark() : CookTheme.light();
  }

  static MaterialColor createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = {};
    final int r = color.r.round(), g = color.g.round(), b = color.b.round();

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.toARGB32(), swatch);
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final int themeIndex = prefs.getInt('ThemeMode') ?? 0;
    currentThemeMode.value = themeIndex == 0 ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> saveTheme(int themeMode) async {
    currentThemeMode.value = themeMode == 0 ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(currentThemeMode.value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ThemeMode', themeMode);
  }

  Color textMainColor() => textPrimaryColor;
  Color textGrayColor() => textSecondaryColor;
  Color redMainColor() => CookTokens.danger;
  Color lineBoardColor() => dividerColor;
  Color bg1Color() => surfaceColor;
  Color bg2Color() => backgroundColor;
  Color bg3Color() => cardColor;
  Color bottomSheetColor() => bottomSheetBackground;

  static final Random _random = Random();
  Color generateRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1.0,
    );
  }
}
