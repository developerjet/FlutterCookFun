import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_icon_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('设计系统图标按钮固定为 44dp 点击区和 24dp 图标', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: Scaffold(
          body: CookIconButton.asset(
            tooltip: '搜索',
            assetPath: CookAssets.iconSearch,
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(CookIconButton)),
      const Size(
        CookTokens.headerToolButtonSize,
        CookTokens.headerToolButtonSize,
      ),
    );
    final image = tester.widget<Image>(find.byType(Image));
    expect(image.width, CookTokens.headerToolIconSize);
    expect(image.height, CookTokens.headerToolIconSize);
  });

  testWidgets('禁用态图标按钮不会触发回调', (tester) async {
    var tapCount = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          body: CookIconButton.icon(
            tooltip: '删除',
            iconData: Icons.delete_outline_rounded,
            onPressed: null,
          ),
        ),
      ),
    );

    await tester.tap(find.byType(CookIconButton));
    await tester.pump();

    expect(tapCount, 0);
  });
}
