import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BookPage 不应消费底部 Tab 安全区', () {
    final source =
        File('lib/module/book/book_home_page.dart').readAsStringSync();

    expect(
      source,
      contains(
        RegExp(
          r'body:\s*SafeArea\(\s*top:\s*false,\s*bottom:\s*false,',
        ),
      ),
    );
  });

  test('BookPage 不得保留只改变视觉状态但不筛选数据的伪筛选控件', () {
    final source =
        File('lib/module/book/book_home_page.dart').readAsStringSync();

    expect(source, isNot(contains('_filterKeys')));
    expect(source, isNot(contains('_activeFilterIndex')));
    expect(source, isNot(contains('_buildFilterBar')));
  });
}
