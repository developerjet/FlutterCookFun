import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('四个 Tab 首页必须使用固定导航栏且不得展示模块子标题', () {
    const paths = <String, String>{
      'lib/module/home/home_data_page.dart': 'home_page_title',
      'lib/module/cook/cook_home_page.dart': 'cook_page_title',
      'lib/module/book/book_home_page.dart': 'book_library_title',
      'lib/module/mine/mine_page.dart': 'mine_kitchen_title',
    };

    for (final entry in paths.entries) {
      final source = File(entry.key).readAsStringSync();
      expect(source, contains('appBar: AppNavBar('), reason: entry.key);
      expect(source, contains("'${entry.value}'.tr"), reason: entry.key);
      expect(source, contains('centerTitle: false'), reason: entry.key);
    }

    final combinedSource =
        paths.keys.map((path) => File(path).readAsStringSync()).join('\n');
    expect(combinedSource, isNot(contains("'home_page_subtitle'.tr")));
    expect(combinedSource, isNot(contains("'cook_page_subtitle'.tr")));
    expect(combinedSource, isNot(contains("'book_library_subtitle'.tr")));
    expect(combinedSource, isNot(contains("'mine_kitchen_subtitle'.tr")));
  });

  test('烹饪页必须保留选择台面并让删除操作随选择状态出现', () {
    final source =
        File('lib/module/cook/cook_home_page.dart').readAsStringSync();

    expect(source, contains('CookCard('));
    expect(source, contains("ValueKey('cook_delete_action')"));
    expect(source, contains('selectedCookList.isEmpty'));
  });

  test('菜谱页必须使用 V6 紧凑头部和卡片网格', () {
    final source =
        File('lib/module/book/book_home_page.dart').readAsStringSync();

    expect(source, isNot(contains('_filterKeys')));
    expect(source, contains('SliverGrid'));
    expect(source, contains('BookHomeCell'));
  });

  test('我的页必须使用 V6 厨房账户面板并保留旧 Logo', () {
    final source = File('lib/module/mine/mine_page.dart').readAsStringSync();

    expect(source, contains('CookAssets.appLogo'));
    expect(source, contains('CookCard'));
  });

  test('V6 核心页面固定界面文案不得硬编码中文', () {
    const paths = <String>[
      'lib/module/home/home_data_page.dart',
      'lib/module/cook/cook_home_page.dart',
      'lib/module/book/book_home_page.dart',
      'lib/module/book/views/book_home_cell.dart',
      'lib/module/mine/mine_page.dart',
      'lib/module/search/search_page.dart',
    ];
    final chineseLiteral = RegExp(r'''["'][^"'\r\n]*[一-龥][^"'\r\n]*["']''');

    for (final path in paths) {
      final source = File(path).readAsStringSync();
      expect(
        chineseLiteral.allMatches(source),
        isEmpty,
        reason: '$path 存在未接入多语言的固定中文文案',
      );
    }
  });

  test('应用启动语言必须读取持久化设置而不是固定中文', () {
    final source = File('lib/main.dart').readAsStringSync();

    expect(source, isNot(contains("locale: const Locale('zh', 'CN')")));
    expect(source, contains('LanguageManager.fetchLastLocale'));
    expect(source, contains('locale: Get.locale ?? initialLocale'));
  });

  test('全部路由业务页面必须使用全局固定 AppNavBar', () {
    const routePagePaths = [
      'lib/module/home/home_class_page.dart',
      'lib/module/cook/cook_steps_page.dart',
      'lib/module/cook/cook_config_page.dart',
      'lib/module/player/player_page.dart',
      'lib/module/book/book_detial_page.dart',
      'lib/module/setting/setting_page.dart',
      'lib/module/setting/theme_setting_page.dart',
      'lib/module/setting/language_setting_page.dart',
      'lib/module/mine/favorites_page.dart',
      'lib/module/search/search_page.dart',
      'lib/base/web.dart',
      'lib/base/image_viewer.dart',
    ];

    for (final path in routePagePaths) {
      final source = File(path).readAsStringSync();
      expect(source, contains('AppNavBar('), reason: path);
    }
  });

  test('多语言配置不得残留页面顶部子标题', () {
    final source = File('lib/utils/language/language.dart').readAsStringSync();
    const forbiddenKeys = [
      'home_page_subtitle',
      'cook_page_subtitle',
      'book_library_subtitle',
      'mine_kitchen_subtitle',
      'setting_page_subtitle',
      'theme_setting_page_subtitle',
      'language_setting_page_subtitle',
    ];

    for (final key in forbiddenKeys) {
      expect(source, isNot(contains("'$key'")), reason: key);
    }
  });
}
