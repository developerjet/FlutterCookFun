import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/module/search/search_page.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/mocks.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
    Get.put<DioClient>(MockDioClient());
  });

  tearDown(Get.reset);

  testWidgets('搜索输入框必须嵌入导航栏且正文不重复展示搜索头部', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: CookTheme.light(),
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        home: const SearchPage(),
      ),
    );
    await tester.pump();

    final appBar = find.byType(AppBar);
    final textFields = find.byType(TextField);
    final navTextField = find.descendant(
      of: appBar,
      matching: textFields,
    );

    expect(textFields, findsOneWidget);
    expect(navTextField, findsOneWidget);
    expect(tester.getSize(navTextField).height, lessThanOrEqualTo(40));
  });

  testWidgets('搜索输入框与返回按钮的视觉间距不超过4dp', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: CookTheme.light(),
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        home: const Scaffold(body: SizedBox.expand()),
      ),
    );

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.push(
      MaterialPageRoute<void>(builder: (_) => const SearchPage()),
    );
    await tester.pumpAndSettle();

    final backButton = find.byType(BackButton);
    final searchField = find.byKey(const ValueKey('search_nav_field'));
    final gap =
        tester.getTopLeft(searchField).dx - tester.getTopRight(backButton).dx;

    expect(backButton, findsOneWidget);
    expect(searchField, findsOneWidget);
    expect(gap, lessThanOrEqualTo(4));
  });

  testWidgets('导航栏搜索框保留右侧边距并按高度使用半圆圆角', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: CookTheme.light(),
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        home: const SearchPage(),
      ),
    );
    await tester.pump();

    final searchField = find.byKey(const ValueKey('search_nav_field'));
    final textField = tester.widget<TextField>(find.byType(TextField));
    final enabledBorder =
        textField.decoration?.enabledBorder as OutlineInputBorder;
    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final rightInset = screenWidth - tester.getTopRight(searchField).dx;

    expect(rightInset, greaterThanOrEqualTo(CookTokens.navContentInset));
    expect(
      enabledBorder.borderRadius,
      BorderRadius.circular(CookTokens.pillRadius),
    );
  });
}
