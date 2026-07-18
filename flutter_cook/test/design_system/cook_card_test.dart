import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('标准卡片默认使用 12dp 圆角', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          body: CookCard(child: Text('内容')),
        ),
      ),
    );

    final card = tester.widget<CookCard>(find.byType(CookCard));
    expect(card.borderRadius, CookTokens.cardRadius);
    expect(card.borderRadius, 12);
  });
}
