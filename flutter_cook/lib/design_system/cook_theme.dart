import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';

/// CookFun V6 主题工厂。
///
/// ThemeManager 只负责主题模式存储，这里负责把 token 转换为 Flutter `ThemeData`。
class CookTheme {
  const CookTheme._();

  static const String _fontFamily = 'Exo';

  /// Returns: V6 浅色主题。
  static ThemeData light() => _build(Brightness.light);

  /// Returns: V6 深色主题。
  static ThemeData dark() => _build(Brightness.dark);

  /// 返回与应用主题一致的系统状态栏和底部导航栏样式。
  static SystemUiOverlayStyle systemUiOverlayStyle(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final page = isDark ? CookTokens.pageDark : CookTokens.page;
    return SystemUiOverlayStyle(
      statusBarColor: page,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
      systemStatusBarContrastEnforced: false,
      systemNavigationBarColor: page,
      systemNavigationBarIconBrightness:
          isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarContrastEnforced: false,
    );
  }

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final page = isDark ? CookTokens.pageDark : CookTokens.page;
    final surface = isDark ? CookTokens.surfaceDark : CookTokens.surface;
    final textPrimary =
        isDark ? const Color(0xFFF4FBF7) : CookTokens.textPrimary;
    final textSecondary =
        isDark ? const Color(0xFFB6C5BE) : CookTokens.textSecondary;
    final border = isDark ? const Color(0xFF2A3832) : CookTokens.border;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: CookTokens.primary,
      brightness: brightness,
    ).copyWith(
      primary: isDark ? const Color(0xFF56DDB8) : CookTokens.primary,
      onPrimary: isDark ? const Color(0xFF00382B) : Colors.white,
      primaryContainer:
          isDark ? const Color(0xFF0B4F40) : CookTokens.primarySoft,
      onPrimaryContainer:
          isDark ? const Color(0xFFA4F1D7) : CookTokens.primaryDeep,
      secondary: isDark ? const Color(0xFFFFB278) : CookTokens.warm,
      onSecondary: isDark ? const Color(0xFF4B2500) : CookTokens.textPrimary,
      secondaryContainer:
          isDark ? const Color(0xFF5E2F0B) : CookTokens.warmSoft,
      onSecondaryContainer:
          isDark ? const Color(0xFFFFDCC1) : const Color(0xFF783100),
      tertiary: isDark ? const Color(0xFFC9C1FF) : CookTokens.info,
      onTertiary: isDark ? const Color(0xFF31257F) : Colors.white,
      tertiaryContainer:
          isDark ? const Color(0xFF453A9B) : const Color(0xFFE8E4FF),
      onTertiaryContainer:
          isDark ? const Color(0xFFE6E0FF) : const Color(0xFF31257F),
      error: isDark ? const Color(0xFFFFB4AE) : CookTokens.danger,
      onError: isDark ? const Color(0xFF690005) : Colors.white,
      errorContainer: isDark ? const Color(0xFF852925) : CookTokens.dangerSoft,
      onErrorContainer:
          isDark ? const Color(0xFFFFDAD6) : const Color(0xFF7F1915),
      surface: surface,
      onSurface: textPrimary,
      outline: border,
      shadow: Colors.black,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      primaryColor: colorScheme.primary,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: page,
      canvasColor: page,
      cardColor: surface,
      dividerColor: border,
      colorScheme: colorScheme,
      appBarTheme: AppBarTheme(
        backgroundColor: page,
        foregroundColor: textPrimary,
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: 56,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: _fontFamily,
          height: 1.25,
        ),
        systemOverlayStyle: systemUiOverlayStyle(brightness),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: surface,
        modalBackgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(CookTokens.dialogRadius),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CookTokens.dialogRadius),
        ),
      ),
      dividerTheme: DividerThemeData(color: border, thickness: 0.5),
      iconTheme: IconThemeData(color: textPrimary),
      textTheme: _textTheme(textPrimary, textSecondary),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          elevation: 0,
          minimumSize: const Size(44, CookTokens.contextButtonHeight),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(CookTokens.controlRadius),
            ),
          ),
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          minimumSize: const Size(44, CookTokens.contextButtonHeight),
          side: BorderSide(color: border),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(CookTokens.controlRadius),
            ),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily,
          ),
        ),
      ),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        height: 1.18,
        color: primary,
      ),
      headlineLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        height: 1.22,
        color: primary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        height: 1.25,
        color: primary,
      ),
      headlineSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.3,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        color: primary,
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 1.35,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: secondary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 1.4,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: primary,
      ),
      labelMedium: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        height: 1.25,
        color: primary,
      ),
      labelSmall: TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        height: 1.2,
        color: secondary,
      ),
    ).apply(fontFamily: _fontFamily);
  }
}
