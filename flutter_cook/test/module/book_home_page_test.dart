import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('BookPage 不应消费底部 Tab 安全区', () {
    final source =
        File('lib/module/book/book_home_page.dart').readAsStringSync();

    expect(
      source,
      contains(RegExp(r'body:\s*SafeArea\(\s*bottom:\s*false,')),
    );
  });
}
