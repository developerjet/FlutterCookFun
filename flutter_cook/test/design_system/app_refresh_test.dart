import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_refresh.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('统一刷新控件使用 Material 下拉和上拉指示器', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: Scaffold(
          body: AppRefresh(
            onRefresh: () async {},
            onLoad: () async {},
            child: ListView(children: const [SizedBox(height: 100)]),
          ),
        ),
      ),
    );

    final refresh = tester.widget<EasyRefresh>(find.byType(EasyRefresh));
    expect(refresh.header, isA<MaterialHeader>());
    expect(refresh.footer, isA<MaterialFooter>());

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(seconds: 1));
  });
}
