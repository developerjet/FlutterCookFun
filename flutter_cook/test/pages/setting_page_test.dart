import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';
import 'package:flutter_cook/module/setting/language_setting_page.dart';
import 'package:flutter_cook/module/setting/setting_page.dart';
import 'package:flutter_cook/module/setting/theme_setting_page.dart';
import 'package:flutter_cook/module/setting/widgets/setting_widgets.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() async {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({
      'ThemeMode': 0,
      'Language': 0,
    });
    final themeManager = Get.put(ThemeManager());
    await themeManager.initialize();
    Get.put(SettingController());
  });

  tearDown(Get.reset);

  testWidgets('设置首页必须分别进入主题设置和语言设置页面', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        theme: CookTheme.light(),
        darkTheme: CookTheme.dark(),
        getPages: [
          GetPage(
            name: '/setting/theme',
            page: () => const Scaffold(body: Text('theme-setting-route')),
          ),
          GetPage(
            name: '/setting/language',
            page: () => const Scaffold(body: Text('language-setting-route')),
          ),
        ],
        home: const SettingPage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('设置'), findsOneWidget);
    expect(find.text('显示、语言与偏好'), findsNothing);
    expect(find.byKey(const ValueKey('setting_theme_entry')), findsOneWidget);
    expect(
        find.byKey(const ValueKey('setting_language_entry')), findsOneWidget);
    expect(find.byKey(const ValueKey('setting_theme_switch')), findsNothing);
    expect(find.byKey(const ValueKey('setting_language_en')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('setting_theme_entry')));
    await tester.pumpAndSettle();
    expect(find.text('theme-setting-route'), findsOneWidget);

    Get.back();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('setting_language_entry')));
    await tester.pumpAndSettle();
    expect(find.text('language-setting-route'), findsOneWidget);
  });

  testWidgets('主题设置页选择深色主题后更新状态并持久化', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        theme: CookTheme.light(),
        darkTheme: CookTheme.dark(),
        home: const ThemeSettingPage(),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('setting_theme_dark')));
    await tester.pumpAndSettle();

    final controller = Get.find<SettingController>();
    final preferences = await SharedPreferences.getInstance();
    expect(controller.selectedTheme.value, 1);
    expect(preferences.getInt('ThemeMode'), 1);
  });

  testWidgets('语言设置页选择英文后更新状态并持久化', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        theme: CookTheme.light(),
        darkTheme: CookTheme.dark(),
        home: const LanguageSettingPage(),
      ),
    );
    await tester.pumpAndSettle();

    final choice = tester.widget<SettingChoiceCard>(
      find.byKey(const ValueKey('setting_language_en')),
    );
    unawaited(choice.onTap());
    await tester.pumpAndSettle();

    final controller = Get.find<SettingController>();
    final preferences = await SharedPreferences.getInstance();
    expect(controller.selectedLanguage.value, 1);
    expect(preferences.getInt('Language'), 1);
    expect(Get.locale, const Locale('en', 'US'));
  });
}
