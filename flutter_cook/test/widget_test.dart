import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/base/tabs.dart';
import 'package:flutter_cook/base/widgets/tab_scroll_padding.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_config_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_steps_controller.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';
import 'package:flutter_cook/routers/routers.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/language/language.dart';
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

  testWidgets('iOS 平台使用浮动 TabBar 且保留页面切换能力', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
    try {
      await _pumpTabs(tester);

      expect(
          find.byKey(const ValueKey('ios26_floating_tab_bar')), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsNothing);

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final anchorBottom =
          tester.getBottomLeft(find.byKey(const ValueKey('bottom_anchor'))).dy;
      expect(anchorBottom, closeTo(screenHeight, 0.1));

      final tabBar = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey('ios26_floating_tab_bar')));
      final decoration = tabBar.decoration as BoxDecoration;
      expect(decoration.color?.a, greaterThan(0.80));

      final selectedPill = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey('ios26_tab_selection_pill')));
      final selectedDecoration = selectedPill.decoration as BoxDecoration;
      expect(selectedDecoration.color, isNot(Colors.transparent));

      final selectedPillSize = tester
          .getSize(find.byKey(const ValueKey('ios26_tab_selection_pill')));
      final tabItemSize =
          tester.getSize(find.byKey(const ValueKey('ios26_tab_0')));
      expect(selectedPillSize.width, lessThan(tabItemSize.width));
      expect(selectedPillSize.height, lessThan(tabItemSize.height));
      expect(selectedPillSize.height, closeTo(52, 0.1));

      final selectedLabel = tester.widget<Text>(find.text('首页').last);
      expect(selectedLabel.style?.color,
          Theme.of(tester.element(find.text('首页').last)).colorScheme.primary);

      final initialPillLeft = tester
          .getTopLeft(find.byKey(const ValueKey('ios26_tab_selection_pill')))
          .dx;
      final targetTabLeft =
          tester.getTopLeft(find.byKey(const ValueKey('ios26_tab_1'))).dx;
      final targetPillLeft = targetTabLeft + 3;

      await tester.tap(find.byKey(const ValueKey('ios26_tab_1')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));

      final movingPillLeft = tester
          .getTopLeft(find.byKey(const ValueKey('ios26_tab_selection_pill')))
          .dx;
      expect(movingPillLeft, greaterThan(initialPillLeft));
      expect(movingPillLeft, lessThan(targetPillLeft));

      await tester.pumpAndSettle();

      final settledPillLeft = tester
          .getTopLeft(find.byKey(const ValueKey('ios26_tab_selection_pill')))
          .dx;
      expect(settledPillLeft, closeTo(targetPillLeft, 0.1));
      expect(find.text('烹饪'), findsWidgets);
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  testWidgets('非 iOS 平台继续使用 Material BottomNavigationBar', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    try {
      await _pumpTabs(tester);

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(
          find.byKey(const ValueKey('ios26_floating_tab_bar')), findsNothing);
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
          .getTopLeft(find.byKey(const ValueKey('ios26_floating_tab_bar')))
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
