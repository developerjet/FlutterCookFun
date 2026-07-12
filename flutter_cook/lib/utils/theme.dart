import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends GetxController {
  static const Color primaryColor = Color(0xFF00CC99);
  static const Color themeColor = primaryColor;
  static const Color tabSelectedColor = Color(0xFF00CC99);
  static const Color tabUnselectedColor = Color(0xFFAAAAAA);

  final Rx<ThemeMode> currentThemeMode = ThemeMode.light.obs;

  ThemeMode get themeMode => currentThemeMode.value;
  bool get isDarkMode => currentThemeMode.value == ThemeMode.dark;

  Color get surfaceColor =>
      isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F6F7);
  Color get cardColor =>
      isDarkMode ? const Color(0xFF202020) : const Color(0xFFFFFFFF);
  Color get textPrimaryColor =>
      isDarkMode ? const Color(0xFFFFFFFF) : Colors.black;
  Color get textSecondaryColor =>
      isDarkMode ? const Color(0xFFB5B5B5) : const Color(0xFF6F777A);
  Color get dividerColor =>
      isDarkMode ? const Color(0xFF383838) : const Color(0xFFE5E5E5);
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
    final isDark = brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF5F6F7);
    final surface = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
    final card = isDark ? const Color(0xFF202020) : const Color(0xFFFFFFFF);
    final textPrimary = isDark ? const Color(0xFFFFFFFF) : Colors.black;
    final textSecondary =
        isDark ? const Color(0xFFB5B5B5) : const Color(0xFF6F777A);
    final divider = isDark ? const Color(0xFF383838) : const Color(0xFFE5E5E5);

    return ThemeData(
      brightness: brightness,
      primaryColor: primaryColor,
      primarySwatch: createMaterialColor(primaryColor),
      scaffoldBackgroundColor: bg,
      canvasColor: surface,
      cardColor: card,
      dividerColor: divider,
      fontFamily: 'Exo',
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: primaryColor,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ),
      dividerTheme: DividerThemeData(color: divider, thickness: 0.5),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          side: const BorderSide(color: primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      iconTheme: IconThemeData(color: textPrimary),
      textTheme: TextTheme(
        displayLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, height: 1.3, color: textPrimary),
        displayMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, height: 1.3, color: textPrimary),
        headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, height: 1.35, color: textPrimary),
        headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, height: 1.35, color: textPrimary),
        headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.4, color: textPrimary),
        titleLarge: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, height: 1.4, color: textPrimary),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, height: 1.4, color: textPrimary),
        titleSmall: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, height: 1.4, color: textPrimary),
        bodyLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5, color: textPrimary),
        bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, height: 1.5, color: textSecondary),
        bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, height: 1.4, color: textSecondary),
        labelLarge: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, height: 1.4, color: textPrimary),
        labelMedium: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, height: 1.3, color: textPrimary),
        labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, height: 1.3, color: textSecondary),
      ),
      colorScheme: isDark
          ? ColorScheme.dark(
              primary: primaryColor,
              secondary: primaryColor,
              surface: surface,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: textPrimary,
            )
          : ColorScheme.light(
              primary: primaryColor,
              secondary: primaryColor,
              surface: surface,
              onPrimary: Colors.white,
              onSecondary: Colors.white,
              onSurface: textPrimary,
            ),
    );
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
  Color redMainColor() => const Color(0xFFFF4F4F);
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
