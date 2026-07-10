import 'package:flutter_cook/routers/routers.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('路由名称必须保持唯一且覆盖首页入口', () {
    final routeNames = AppRouter.routers.map((route) => route.name).toList();

    expect(routeNames, contains(RouteNames.home));
    expect(routeNames.toSet(), hasLength(routeNames.length));
  });

  test('核心导航文案必须提供中英文翻译', () {
    final translations = Messages().keys;
    const requiredKeys = [
      'tab_home_title',
      'tab_cook_title',
      'tab_book_title',
      'tab_mine_title',
    ];

    for (final locale in const ['zh_CN', 'en_US']) {
      final localeMessages = translations[locale];
      expect(localeMessages, isNotNull);

      for (final key in requiredKeys) {
        expect(localeMessages?[key], isNotNull);
        expect(localeMessages?[key], isNotEmpty);
      }
    }
  });
}
