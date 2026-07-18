import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/base/widgets/app_bottom_sheet.dart';
import 'package:flutter_cook/base/widgets/app_dialog.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('主题底部弹层使用统一弹层圆角', () {
    final shape = CookTheme.light().bottomSheetTheme.shape;

    expect(shape, isA<RoundedRectangleBorder>());
    expect(
      (shape as RoundedRectangleBorder).borderRadius,
      const BorderRadius.vertical(
        top: Radius.circular(CookTokens.dialogRadius),
      ),
    );
  });

  testWidgets('destructive dialog uses V6 radius and danger button',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: Builder(
          builder: (context) {
            return TextButton(
              onPressed: () {
                AppDialog.show(
                  context,
                  title: '删除收藏？',
                  content: '删除后不可恢复',
                  cancelText: '取消',
                  confirmText: '删除',
                  isDestructive: true,
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    final dialog = tester.widget<Dialog>(find.byType(Dialog));
    final shape = dialog.shape as RoundedRectangleBorder;
    expect(shape.borderRadius, BorderRadius.circular(CookTokens.dialogRadius));

    final dangerButton = tester.widget<Material>(
      find.descendant(
        of: find.widgetWithText(CookButton, '删除'),
        matching: find.byType(Material),
      ),
    );
    expect(dangerButton.color, CookTokens.danger);
  });

  testWidgets('bottom sheet uses V6 radius and fixed action height',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          body: AppBottomSheet(
            children: [
              AppSheetAction(label: '浅色模式'),
            ],
          ),
        ),
      ),
    );

    final container = tester.widget<Container>(find.byType(Container).first);
    final decoration = container.decoration as BoxDecoration;
    expect(
      decoration.borderRadius,
      const BorderRadius.vertical(
        top: Radius.circular(CookTokens.dialogRadius),
      ),
    );
    expect(tester.getSize(find.byType(AppSheetAction)).height, 56);
  });

  testWidgets('error empty state uses danger semantic and V6 action',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: Scaffold(
          body: EmptyState.error(
            title: '加载失败',
            onRetry: () {},
          ),
        ),
      ),
    );

    final button = tester.widget<CookButton>(find.byType(CookButton));
    expect(button.label, 'retry');
    expect(tester.getSize(find.byType(CookButton)).height, 48);
  });
}
