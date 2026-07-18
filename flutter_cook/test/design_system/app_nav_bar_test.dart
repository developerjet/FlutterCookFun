import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('统一导航栏固定高度、标题字号和页面背景色', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          appBar: AppNavBar(title: '设置'),
        ),
      ),
    );

    final navBar = tester.widget<AppNavBar>(find.byType(AppNavBar));
    final title = tester.widget<Text>(find.text('设置'));
    final appBar = tester.widget<AppBar>(find.byType(AppBar));

    expect(navBar.preferredSize.height, 56);
    expect(title.style?.fontSize, 18);
    expect(title.style?.fontWeight, FontWeight.w600);
    expect(appBar.backgroundColor,
        Theme.of(tester.element(find.text('设置'))).scaffoldBackgroundColor);
  });

  testWidgets('左右操作区宽度不一致时标题仍按屏幕中心展示', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          appBar: AppNavBar(
            title: '菜谱详情',
            leading: SizedBox(width: 48),
            actions: [
              SizedBox(width: 48),
              SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );

    final titleCenter = tester.getCenter(find.text('菜谱详情')).dx;
    expect(titleCenter, closeTo(200, 0.5));
  });
}
