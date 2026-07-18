import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/base/tabs.dart';
import 'package:flutter_cook/base/controller/tab_navigation_controller.dart';
import 'package:flutter_cook/base/widgets/tab_scroll_padding.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_config_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_steps_controller.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';
import 'package:flutter_cook/routers/routers.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_cook/utils/language/manager.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    SharedPreferences.setMockInitialValues({});
  });

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
    Get.reset();
  });

  test('路由名称必须保持唯一且覆盖首页入口', () {
    final routeNames = AppRouter.routers.map((route) => route.name).toList();

    expect(routeNames, contains(RouteNames.home));
    expect(routeNames.toSet(), hasLength(routeNames.length));
  });

  test('子路由必须自带页面依赖兜底', () {
    _runRouteBinding(RouteNames.cookConfig);
    expect(Get.find<CookConfigController>(), isA<CookConfigController>());

    Get.reset();
    _runRouteBinding(RouteNames.cookSteps);
    expect(Get.find<CookStepsController>(), isA<CookStepsController>());
    expect(Get.find<FavoritesController>(), isA<FavoritesController>());

    Get.reset();
    _runRouteBinding(RouteNames.bookDetail);
    expect(Get.find<BookController>(), isA<BookController>());

    Get.reset();
    _runRouteBinding(RouteNames.favorites);
    expect(Get.find<FavoritesController>(), isA<FavoritesController>());

    Get.reset();
    _runRouteBinding(RouteNames.setting);
    expect(Get.find<SettingController>(), isA<SettingController>());

    Get.reset();
    _runRouteBinding(RouteNames.search);
    expect(Get.find<DioClient>(), isA<DioClient>());
  });

  test('核心导航文案必须提供中英文翻译', () {
    final translations = Messages().keys;
    const requiredKeys = [
      'tab_home_title',
      'tab_cook_title',
      'tab_book_title',
      'tab_mine_title',
      'home_page_title',
      'home_search_placeholder',
      'cook_page_title',
      'cook_generate_recipes',
      'book_library_title',
      'book_filter_scene',
      'mine_kitchen_title',
      'mine_settings_subtitle',
      'search_history',
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

  test('英文窄控件使用简短且语义明确的产品文案', () {
    final english = Messages().keys['en_US'];

    expect(english, isNotNull);
    expect(english?['home_page_title'], 'What to cook');
    expect(english?['home_search_placeholder'], 'Search recipes or food');
    expect(english?['home_dinner_match'], 'Dinner · 20 min');
    expect(english?['home_replace'], 'Next');
    expect(english?['home_choose_ingredients'], 'Pick ingredients');
    expect(english?['home_quick_decision'], 'Quick picks');
    expect(english?['cook_page_title'], 'Ingredients');
    expect(english?['cook_generate_recipes'], 'Find recipes');
    expect(english?['book_library_title'], 'Recipes');
    expect(english?['book_enter_topic'], 'Open');
    expect(english?['setting_language'], 'Language');
    expect(english?['change_theme'], 'Theme');
    expect(english?['save_image'], 'Save');
    expect(english?['view_matching_recipes'], 'View recipes');
    expect(english?['start_cooking'], 'Start');
  });

  test('本地副标题文案必须保持短句以避免控件拥挤', () {
    final translations = Messages().keys;
    const subtitleKeys = [
      'home_dinner_description',
      'home_leftovers_desc',
      'home_low_calorie_desc',
      'book_insight_description',
      'mine_favorites_subtitle',
      'mine_settings_subtitle',
      'mine_flutter_subtitle',
      'mine_github_subtitle',
      'setting_theme_description',
      'setting_language_description',
      'light_theme_description',
      'dark_theme_description',
      'language_zh_description',
      'language_en_description',
      'favorite_data_empty_desc',
      'book_data_empty_desc',
    ];

    for (final entry in translations.entries) {
      final maxLength = entry.key == 'zh_CN' ? 14 : 28;
      for (final key in subtitleKeys) {
        final value = entry.value[key];
        expect(value, isNotNull, reason: '${entry.key}: $key');
        expect(
          value!.length,
          lessThanOrEqualTo(maxLength),
          reason: '${entry.key}: $key -> $value',
        );
      }
    }
  });

  test('多语言配置必须保持键集合和占位符一致', () {
    final translations = Messages().keys;
    final chinese = translations['zh_CN'];
    final english = translations['en_US'];

    expect(chinese, isNotNull);
    expect(english, isNotNull);
    expect(english!.keys.toSet(), chinese!.keys.toSet());

    for (final key in chinese.keys) {
      expect(
        _placeholderCount(english[key]!),
        _placeholderCount(chinese[key]!),
        reason: key,
      );
    }
  });

  test('英文多语言文案必须避免错译和冗长表达', () {
    final english = Messages().keys['en_US'];

    expect(english, isNotNull);
    expect(english?['app_name_title'], 'Cooking Fun');
    expect(english?['no_recipe_data'], 'No recipe data yet');

    for (final entry in english!.entries) {
      expect(
        entry.value.contains(RegExp(r'[\u4e00-\u9fff]')),
        isFalse,
        reason: '${entry.key} -> ${entry.value}',
      );
    }

    const compactKeys = [
      'enter_keyword_to_search',
      'image_save_failed',
      'invalid_cook_config_params',
      'unknown_error_try_again',
      'missing_dish_id',
      'missing_book_param',
      'unable_find_recipes',
      'toast_max_select',
      'not_selected_ingredients',
      'delete_selected_prompt',
      'network_check_retry',
      'network_connection_failed',
      'request_timeout',
      'unauthorized',
      'request_failed_try_again',
      'recipe_selection_failed',
      'video_load_failed',
    ];

    for (final key in compactKeys) {
      final value = english[key];
      expect(value, isNotNull, reason: key);
      expect(value!.length, lessThanOrEqualTo(34), reason: '$key -> $value');
    }
  });

  test('启动语言读取持久化偏好并对非法值回退', () async {
    SharedPreferences.setMockInitialValues({'Language': 1});
    expect(
      await LanguageManager.fetchLastLocale(),
      const Locale('en', 'US'),
    );

    SharedPreferences.setMockInitialValues({'Language': 99});
    expect(
      await LanguageManager.fetchLastLocale(),
      const Locale('zh', 'CN'),
    );
  });

  test('Tabs 必须消费路由参数并限制索引边界', () {
    expect(
      Tabs.resolveInitialIndex(
        widgetIndex: 0,
        routeArguments: 1,
        pageCount: 4,
      ),
      1,
    );
    expect(
      Tabs.resolveInitialIndex(
        widgetIndex: 0,
        routeArguments: 9,
        pageCount: 4,
      ),
      0,
    );
    expect(
      Tabs.resolveInitialIndex(
        widgetIndex: 2,
        routeArguments: null,
        pageCount: 4,
      ),
      2,
    );
  });

  testWidgets('显式滚动 padding 会叠加底部 Tab 安全区', (tester) async {
    late EdgeInsets resolvedPadding;

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(
          padding: EdgeInsets.only(bottom: 96),
        ),
        child: Builder(
          builder: (context) {
            resolvedPadding = resolveTabScrollPadding(
              context,
              const EdgeInsets.fromLTRB(8, 12, 8, 8),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolvedPadding, const EdgeInsets.fromLTRB(8, 12, 8, 104));
  });

  testWidgets('iOS 平台使用 V6 浮动 TabBar 且保留页面切换能力', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await _pumpTabs(tester);

      expect(
          find.byKey(const ValueKey('cook_floating_tab_bar')), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsNothing);

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final anchorBottom =
          tester.getBottomLeft(find.byKey(const ValueKey('bottom_anchor'))).dy;
      expect(anchorBottom, closeTo(screenHeight, 0.1));

      final tabBar = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey('cook_floating_tab_bar')));
      final decoration = tabBar.decoration as BoxDecoration;
      expect(decoration.color?.a, greaterThan(0.80));
      expect(
        decoration.borderRadius,
        BorderRadius.circular(CookTokens.tabBarHeight / 2),
      );

      final selectedPill = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey('cook_tab_selection_pill')));
      final selectedDecoration = selectedPill.decoration as BoxDecoration;
      expect(selectedDecoration.color, isNot(Colors.transparent));
      expect(
        selectedDecoration.borderRadius,
        BorderRadius.circular(CookTokens.pillRadius),
      );

      final selectedPillSize =
          tester.getSize(find.byKey(const ValueKey('cook_tab_selection_pill')));
      final tabItemSize =
          tester.getSize(find.byKey(const ValueKey('cook_tab_0')));
      expect(selectedPillSize.width, lessThan(tabItemSize.width));
      expect(selectedPillSize.height, lessThan(tabItemSize.height));
      expect(selectedPillSize.height, closeTo(50, 0.1));

      final selectedLabel = tester.widget<Text>(find.text('首页').last);
      expect(selectedLabel.style?.color,
          Theme.of(tester.element(find.text('首页').last)).colorScheme.primary);

      final initialPillLeft = tester
          .getTopLeft(find.byKey(const ValueKey('cook_tab_selection_pill')))
          .dx;
      final targetTabLeft =
          tester.getTopLeft(find.byKey(const ValueKey('cook_tab_1'))).dx;
      final targetPillLeft = targetTabLeft + 3;

      await tester.tap(find.byKey(const ValueKey('cook_tab_1')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));

      final movingPillLeft = tester
          .getTopLeft(find.byKey(const ValueKey('cook_tab_selection_pill')))
          .dx;
      expect(movingPillLeft, greaterThan(initialPillLeft));
      expect(movingPillLeft, lessThan(targetPillLeft));

      await tester.pumpAndSettle();

      final settledPillLeft = tester
          .getTopLeft(find.byKey(const ValueKey('cook_tab_selection_pill')))
          .dx;
      expect(settledPillLeft, closeTo(targetPillLeft, 0.1));
      expect(find.text('烹饪'), findsWidgets);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('非 iOS 平台使用同一套 V6 浮动 TabBar', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    try {
      await _pumpTabs(tester);

      expect(find.byType(BottomNavigationBar), findsNothing);
      expect(
          find.byKey(const ValueKey('cook_floating_tab_bar')), findsOneWidget);
      expect(
        tester
            .getSize(find.byKey(const ValueKey('cook_floating_tab_bar')))
            .height,
        CookTokens.tabBarHeight,
      );
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('Tabs 响应全局导航控制器切换页面', (tester) async {
    final controller = Get.put(TabNavigationController());
    await _pumpTabs(tester);

    expect(find.text('首页 页面'), findsOneWidget);

    controller.select(TabNavigationController.cookIndex);
    await tester.pumpAndSettle();

    expect(find.text('烹饪 页面'), findsOneWidget);
  });

  testWidgets('Material TabBar 图标使用统一视觉尺寸', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    try {
      await _pumpTabs(tester);

      for (final assetPath in _initialVisibleTabAssetPaths) {
        _expectAssetImageSize(tester, assetPath, 24);
      }
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('iOS 浮动 TabBar 图标使用统一视觉尺寸', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await _pumpTabs(tester);

      for (final assetPath in _initialVisibleTabAssetPaths) {
        _expectAssetImageSize(tester, assetPath, 24);
      }
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('iOS 浮动 TabBar 为滚动列表注入底部安全区', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    var didTapLastItem = false;

    try {
      await _pumpTabs(
        tester,
        pages: [
          _ScrollableTabPage(
            onLastItemTap: () => didTapLastItem = true,
          ),
          const _TestTabPage(title: '烹饪'),
          const _TestTabPage(title: '菜谱'),
          const _TestTabPage(title: '我的'),
        ],
      );

      final lastItemFinder = find.byKey(const ValueKey('scroll_item_29'));
      await tester.scrollUntilVisible(
        lastItemFinder,
        320,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();

      final tabBarTop = tester
          .getTopLeft(find.byKey(const ValueKey('cook_floating_tab_bar')))
          .dy;
      final lastItemBottom = tester.getBottomLeft(lastItemFinder).dy;
      expect(lastItemBottom, lessThanOrEqualTo(tabBarTop - 8));

      await tester.tap(lastItemFinder);
      await tester.pump();
      expect(didTapLastItem, true);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}

int _placeholderCount(String value) {
  return '%s'.allMatches(value).length;
}

Future<void> _pumpTabs(
  WidgetTester tester, {
  List<Widget> pages = const [
    _TestTabPage(title: '首页'),
    _TestTabPage(title: '烹饪'),
    _TestTabPage(title: '菜谱'),
    _TestTabPage(title: '我的'),
  ],
}) async {
  await tester.pumpWidget(
    GetMaterialApp(
      theme: CookTheme.light(),
      darkTheme: CookTheme.dark(),
      translations: Messages(),
      locale: const Locale('zh', 'CN'),
      home: Tabs(
        pages: pages,
      ),
    ),
  );
  await tester.pump();
}

void _runRouteBinding(String routeName) {
  final route = AppRouter.routers.singleWhere(
    (route) => route.name == routeName,
  );

  route.binding?.dependencies();
}

const _initialVisibleTabAssetPaths = <String>[
  CookAssets.tabHomeActive,
  CookAssets.tabCook,
  CookAssets.tabRecipe,
  CookAssets.tabMine,
];

void _expectAssetImageSize(
  WidgetTester tester,
  String assetPath,
  double expectedSize,
) {
  final finder = find.byWidgetPredicate((widget) {
    if (widget is! Image) {
      return false;
    }

    final provider = widget.image;
    return provider is AssetImage && provider.assetName == assetPath;
  });

  expect(finder, findsAtLeastNWidgets(1));

  final images = tester.widgetList<Image>(finder);
  for (final image in images) {
    expect(image.width, expectedSize);
    expect(image.height, expectedSize);
  }
}

class _TestTabPage extends StatelessWidget {
  final String title;

  const _TestTabPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Stack(
        children: [
          Center(child: Text('$title 页面')),
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SizedBox(
              key: ValueKey('bottom_anchor'),
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScrollableTabPage extends StatelessWidget {
  final VoidCallback onLastItemTap;

  const _ScrollableTabPage({required this.onLastItemTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('首页')),
      body: ListView.builder(
        itemCount: 30,
        itemBuilder: (context, index) {
          return ListTile(
            key: ValueKey('scroll_item_$index'),
            title: Text('第 $index 项'),
            onTap: index == 29 ? onLastItemTap : null,
          );
        },
      ),
    );
  }
}
