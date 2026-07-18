import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/base/controller/tab_navigation_controller.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/base/widgets/app_refresh.dart';
import 'package:flutter_cook/module/home/controller/home_controller.dart';
import 'package:flutter_cook/module/home/home_class_page.dart';
import 'package:flutter_cook/module/home/home_data_page.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  late MockHomeRepository repository;

  setUp(() {
    Get.testMode = true;
    repository = MockHomeRepository();
  });

  tearDown(Get.reset);

  testWidgets('首页必须允许浏览四项之后的全部分类', (tester) async {
    await _pumpHomePage(
      tester,
      repository: repository,
      viewportSize: const Size(393, 2600),
    );

    expect(find.text('Category 6'), findsOneWidget);
  });

  testWidgets('首页两个全部入口必须可点击并进入带 Segment 的分类页', (tester) async {
    await _pumpHomePage(tester, repository: repository);

    final quickAll = find.byKey(const ValueKey('home_quick_all'));
    final inspirationAll = find.byKey(const ValueKey('home_inspiration_all'));

    expect(quickAll, findsOneWidget);
    expect(inspirationAll, findsOneWidget);

    await tester.tap(inspirationAll);
    await tester.pumpAndSettle();

    expect(find.byType(FoodClassPage), findsOneWidget);
    expect(
        find.byKey(const ValueKey('food_class_segment_bar')), findsOneWidget);
    expect(find.text('Category 1'), findsWidgets);

    await tester.drag(
      find.byKey(const ValueKey('food_class_segment_bar')),
      const Offset(-600, 0),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('food_class_segment_6')));
    await tester.pumpAndSettle();

    expect(find.text('Category 6'), findsWidgets);
    expect(find.text('Item 6'), findsOneWidget);
    expect(find.text('Item 1'), findsNothing);
  });

  testWidgets('全部分类页支持左右滑动列表切换分类分页', (tester) async {
    await _pumpHomePage(tester, repository: repository);

    await tester.tap(find.byKey(const ValueKey('home_inspiration_all')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('food_class_page_view')), findsOneWidget);
    expect(find.text('Item 1'), findsOneWidget);

    await tester.drag(
      find.byKey(const ValueKey('food_class_page_view')),
      const Offset(-360, 0),
    );
    await tester.pumpAndSettle();

    expect(find.text('Item 2'), findsOneWidget);
    expect(find.text('Item 1'), findsNothing);
  });

  testWidgets('首页使用固定导航栏和统一刷新控件且不展示子标题', (tester) async {
    await _pumpHomePage(tester, repository: repository);

    expect(find.text('按场景、时间、库存快速决策'), findsNothing);
    expect(find.byType(AppNavBar), findsOneWidget);
    expect(find.byType(AppRefresh), findsOneWidget);
    expect(find.byType(RefreshIndicator), findsNothing);
  });

  testWidgets('首页主按钮文案必须准确描述进入选食材页的行为', (tester) async {
    final tabController = Get.put(TabNavigationController());
    await _pumpHomePage(tester, repository: repository);

    expect(find.text('加入晚餐计划'), findsNothing);
    expect(find.text('去选食材'), findsOneWidget);

    await tester.tap(find.text('去选食材'));
    await tester.pump();
    expect(tabController.currentIndex.value, 1);
  });

  testWidgets('首页工具搜索图标和输入入口图标使用正确视觉尺寸', (tester) async {
    await _pumpHomePage(tester, repository: repository);

    final searchImages = tester.widgetList<Image>(
      find.byWidgetPredicate((widget) {
        final provider = widget is Image ? widget.image : null;
        return provider is AssetImage &&
            provider.assetName == CookAssets.iconSearch;
      }),
    );

    expect(searchImages.map((image) => image.width), containsAll([24, 20]));
  });

  testWidgets('首页顶部搜索按钮与屏幕右侧保持导航安全间距', (tester) async {
    await _pumpHomePage(tester, repository: repository);

    final searchButton = find.byKey(const ValueKey('home_nav_search'));
    expect(searchButton, findsOneWidget);

    final screenWidth =
        tester.view.physicalSize.width / tester.view.devicePixelRatio;
    final rightInset = screenWidth - tester.getTopRight(searchButton).dx;
    expect(rightInset, greaterThanOrEqualTo(CookTokens.pagePadding));
  });

  testWidgets('首页搜索入口按控件高度使用半圆圆角', (tester) async {
    await _pumpHomePage(tester, repository: repository);

    final searchEntry = find.byKey(const ValueKey('home_search_entry'));
    expect(searchEntry, findsOneWidget);

    final material = tester.widget<Material>(searchEntry);
    expect(tester.getSize(searchEntry).height, 48);
    expect(
      material.borderRadius,
      BorderRadius.circular(CookTokens.pillRadius),
    );
  });

  testWidgets('一日三餐推荐内容和背景按固定周期自动轮换', (tester) async {
    await _pumpHomePage(tester, repository: repository);

    Text heroTitle() => tester.widget<Text>(
          find.byKey(const ValueKey('home_hero_title')),
        );

    expect(heroTitle().data, 'Category 1');

    await tester.pump(HomePage.heroRotationInterval);
    await tester.pump(const Duration(milliseconds: 500));

    expect(heroTitle().data, 'Category 2');
  });
}

Future<void> _pumpHomePage(
  WidgetTester tester, {
  required MockHomeRepository repository,
  Size viewportSize = const Size(393, 852),
}) async {
  final categories = List.generate(
    6,
    (index) => HomeFoodListData(
      id: '${index + 1}',
      text: 'Category ${index + 1}',
      image: 'https://example.com/category-${index + 1}.png',
      data: [
        FoodSubData(
          id: 'sub-${index + 1}',
          text: 'Item ${index + 1}',
          type: 1,
        ),
      ],
    ),
  );
  final homeData = HomeDataModel(data: categories);
  final bannerData = HomeBannerModel(
    data: HomeBannerData(moduleList: const []),
  );

  when(() => repository.fetchHomeListData()).thenAnswer((_) async => homeData);
  when(() => repository.fetchBannerData()).thenAnswer((_) async => bannerData);

  Get.put(HomeController(repository: repository));

  tester.view.physicalSize = viewportSize;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    GetMaterialApp(
      theme: CookTheme.light(),
      translations: Messages(),
      locale: const Locale('zh', 'CN'),
      getPages: [
        GetPage(
          name: RouteNames.foodClass,
          page: () => const FoodClassPage(),
        ),
      ],
      home: const HomePage(),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 20));
}
