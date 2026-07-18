import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_chip.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('selected chip keeps fixed height and selected color',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          body: CookChip.selected(label: '已选'),
        ),
      ),
    );

    expect(
      tester.getSize(find.byType(CookChip)).height,
      CookTokens.chipHeight,
    );

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(CookChip),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, CookTokens.primarySoft);
    expect(
      decoration.borderRadius,
      BorderRadius.circular(CookTokens.pillRadius),
    );
  });

  testWidgets('danger chip uses danger semantic color', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          body: CookChip.danger(label: '删除'),
        ),
      ),
    );

    final container = tester.widget<Container>(
      find.descendant(
        of: find.byType(CookChip),
        matching: find.byType(Container),
      ),
    );
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, CookTokens.dangerSoft);
  });

  testWidgets('selected chip uses independent dark-mode container color',
      (tester) async {
    Future<Color?> pumpChip(ThemeData theme) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: const Scaffold(
            body: CookChip.selected(label: '已选'),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CookChip),
          matching: find.byType(Container),
        ),
      );
      return (container.decoration as BoxDecoration).color;
    }

    final lightColor = await pumpChip(CookTheme.light());
    final darkColor = await pumpChip(CookTheme.dark());

    expect(lightColor, isNot(darkColor));
    expect(darkColor, CookTheme.dark().colorScheme.primaryContainer);
  });
}
