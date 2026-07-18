import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('主题全局使用 Exo 并保持克制字重层级', () {
    final theme = CookTheme.light();

    expect(theme.appBarTheme.titleTextStyle?.fontFamily, 'Exo');
    expect(theme.appBarTheme.titleTextStyle?.fontWeight, FontWeight.w600);

    final expectations = <TextStyle?, FontWeight>{
      theme.textTheme.displayLarge: FontWeight.w700,
      theme.textTheme.headlineLarge: FontWeight.w700,
      theme.textTheme.headlineMedium: FontWeight.w700,
      theme.textTheme.headlineSmall: FontWeight.w600,
      theme.textTheme.titleLarge: FontWeight.w600,
      theme.textTheme.titleMedium: FontWeight.w600,
      theme.textTheme.titleSmall: FontWeight.w600,
      theme.textTheme.bodyLarge: FontWeight.w400,
      theme.textTheme.bodyMedium: FontWeight.w400,
      theme.textTheme.bodySmall: FontWeight.w400,
      theme.textTheme.labelLarge: FontWeight.w600,
      theme.textTheme.labelMedium: FontWeight.w600,
      theme.textTheme.labelSmall: FontWeight.w500,
    };

    for (final entry in expectations.entries) {
      expect(entry.key?.fontFamily, 'Exo');
      expect(entry.key?.fontWeight, entry.value);
    }
  });

  test('业务代码禁止使用过重字重', () {
    final forbiddenPatterns = [
      'FontWeight.w800',
      'FontWeight.w900',
      'FontWeight.bold',
    ];
    final violations = <String>[];

    for (final entity in Directory('lib').listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) {
        continue;
      }
      final source = entity.readAsStringSync();
      for (final pattern in forbiddenPatterns) {
        if (source.contains(pattern)) {
          violations.add('${entity.path}: $pattern');
        }
      }
    }

    expect(violations, isEmpty);
  });
}
