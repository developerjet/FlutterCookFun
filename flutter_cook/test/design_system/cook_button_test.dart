import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_button.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('hero button uses V6 height and primary fill', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: Scaffold(
          body: CookButton.hero(
            label: '开始跟做',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(CookButton)),
      const Size(800, CookTokens.heroButtonHeight),
    );

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(CookButton),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, CookTokens.primary);
    expect(material.shape, isA<RoundedRectangleBorder>());
    expect(
      (material.shape as RoundedRectangleBorder).borderRadius,
      BorderRadius.circular(CookTokens.controlRadius),
    );
  });

  testWidgets('danger button uses destructive color and compact height',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: Scaffold(
          body: CookButton.danger(
            label: '删除',
            onPressed: () {},
          ),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(CookButton)),
      const Size(800, CookTokens.dangerButtonHeight),
    );

    final material = tester.widget<Material>(
      find.descendant(
        of: find.byType(CookButton),
        matching: find.byType(Material),
      ),
    );
    expect(material.color, CookTokens.danger);
  });
}
