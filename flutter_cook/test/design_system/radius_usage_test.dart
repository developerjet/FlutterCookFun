import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('业务和基础组件不得硬编码数字圆角', () {
    const sourceRoots = [
      'lib/base',
      'lib/design_system',
      'lib/module',
      'lib/utils',
    ];
    final numericRadiusPattern = RegExp(
      r'(?:BorderRadius|Radius)\.circular\(\s*\d',
    );
    final duplicateRadiusTokenPattern = RegExp(
      r'static const double \w*[Rr]adius\w*\s*=\s*\d',
    );
    final violations = <String>[];

    for (final root in sourceRoots) {
      final files = Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'));

      for (final file in files) {
        final lines = file.readAsLinesSync();
        for (var index = 0; index < lines.length; index++) {
          if (numericRadiusPattern.hasMatch(lines[index])) {
            violations.add('${file.path}:${index + 1}: ${lines[index].trim()}');
          }
          if (!file.path.endsWith('cook_tokens.dart') &&
              duplicateRadiusTokenPattern.hasMatch(lines[index])) {
            violations.add('${file.path}:${index + 1}: ${lines[index].trim()}');
          }
        }
      }
    }

    expect(
      violations,
      isEmpty,
      reason: '圆角必须引用 CookTokens：\n${violations.join('\n')}',
    );
  });

  test('已选食材容器和关闭按钮保持胶囊语义', () {
    final source =
        File('lib/module/cook/cook_home_page.dart').readAsStringSync();
    final sectionStart = source.indexOf('Widget _buildSelectedItem');
    expect(sectionStart, greaterThanOrEqualTo(0));
    final selectedItemSection = source.substring(sectionStart);
    expect(
      RegExp(r'CookTokens\.pillRadius').allMatches(selectedItemSection).length,
      2,
    );
  });
}
