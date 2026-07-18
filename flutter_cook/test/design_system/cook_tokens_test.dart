import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('defines V6 color responsibilities', () {
    expect(CookTokens.primary, const Color(0xFF13C89A));
    expect(CookTokens.primaryDeep, const Color(0xFF087C63));
    expect(CookTokens.danger, const Color(0xFFF05249));
    expect(CookTokens.warm, const Color(0xFFFF8A3D));
    expect(CookTokens.info, const Color(0xFF6B5BF5));
    expect(CookTokens.page, const Color(0xFFF7F6EE));
  });

  test('locks core control dimensions from V6 specs', () {
    expect(CookTokens.pagePadding, 20);
    expect(CookTokens.heroButtonHeight, 52);
    expect(CookTokens.contextButtonHeight, 44);
    expect(CookTokens.chipHeight, 36);
    expect(CookTokens.headerToolButtonSize, 44);
    expect(CookTokens.headerToolIconSize, 24);
    expect(CookTokens.tabBarHeight, 72);
    expect(CookTokens.radiusXs, 4);
    expect(CookTokens.radiusSm, 6);
    expect(CookTokens.radiusMd, 8);
    expect(CookTokens.heroCardRadius, 16);
    expect(CookTokens.cardRadius, 12);
    expect(CookTokens.listCardRadius, 10);
    expect(CookTokens.inputRadius, 10);
    expect(CookTokens.controlRadius, 10);
    expect(CookTokens.dialogRadius, 16);
    expect(CookTokens.navigationRadius, CookTokens.tabBarHeight / 2);
    expect(CookTokens.pillRadius, 999);
  });

  test('defines ingredient semantic colors', () {
    expect(CookTokens.vegetable, isA<Color>());
    expect(CookTokens.protein, isA<Color>());
    expect(CookTokens.staple, isA<Color>());
    expect(CookTokens.seasoning, isA<Color>());
    expect(
      {
        CookTokens.vegetable,
        CookTokens.protein,
        CookTokens.staple,
        CookTokens.seasoning,
      },
      hasLength(4),
    );
  });
}
