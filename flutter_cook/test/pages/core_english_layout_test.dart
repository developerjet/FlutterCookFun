import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/module/book/book_home_page.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/module/cook/controller/cook_home_controller.dart';
import 'package:flutter_cook/module/cook/cook_home_page.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/home/controller/home_controller.dart';
import 'package:flutter_cook/module/home/home_data_page.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/module/mine/mine_page.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  testWidgets('首页英文模式在 320dp 窄屏不得发生布局溢出', (tester) async {
    final repository = MockHomeRepository();
    final categories = List.generate(
      6,
      (index) => HomeFoodListData(
        id: '$index',
        text: 'Everyday category ${index + 1}',
        data: [FoodSubData(id: '$index', text: 'Ingredient $index', type: 1)],
      ),
    );
    when(() => repository.fetchHomeListData()).thenAnswer(
      (_) async => HomeDataModel(data: categories),
    );
    when(() => repository.fetchBannerData()).thenAnswer(
      (_) async => HomeBannerModel(
        data: HomeBannerData(moduleList: const []),
      ),
    );
    Get.put(HomeController(repository: repository));

    final errors = await _captureFlutterErrors(tester, const HomePage());

    expect(errors, isEmpty, reason: _describeErrors(errors));
  });

  testWidgets('烹饪页英文模式在 320dp 窄屏不得发生布局溢出', (tester) async {
    final repository = MockCookRepository();
    final ingredients = List.generate(
      12,
      (index) => CookListDataModel(
        id: '$index',
        text: 'Long ingredient ${index + 1}',
      ),
    );
    when(() => repository.fetchCookHomeData()).thenAnswer(
      (_) async => [
        CookHomeListModel(
          id: 'vegetables',
          text: 'Vegetables',
          data: ingredients,
        ),
      ],
    );
    Get.put(CookHomeController(repository: repository));

    final errors = await _captureFlutterErrors(tester, const CookPage());

    expect(errors, isEmpty, reason: _describeErrors(errors));
  });

  testWidgets('菜谱和个人页英文模式在 320dp 窄屏不得发生布局溢出', (tester) async {
    final service = MockBookService();
    when(() => service.fetchBookList(page: any(named: 'page'))).thenAnswer(
      (_) async => BookListPage(
        items: List.generate(
          6,
          (index) => BookListModel(
            sceneId: index + 1,
            sceneTitle: 'Family dinner collection ${index + 1}',
            sceneDesc: 'Balanced recipes for busy weekday cooking',
            dishCount: 140 + index,
          ),
        ),
        page: 1,
        pageSize: 20,
        totalCount: 6,
      ),
    );
    Get.put(BookController(service: service));

    final bookErrors = await _captureFlutterErrors(tester, const BookPage());
    expect(bookErrors, isEmpty, reason: _describeErrors(bookErrors));

    Get.reset();
    final mineErrors = await _captureFlutterErrors(tester, const MinePage());
    expect(mineErrors, isEmpty, reason: _describeErrors(mineErrors));
  });
}

Future<List<FlutterErrorDetails>> _captureFlutterErrors(
  WidgetTester tester,
  Widget page,
) async {
  final errors = <FlutterErrorDetails>[];
  final previousHandler = FlutterError.onError;
  FlutterError.onError = errors.add;

  tester.view.physicalSize = const Size(320, 700);
  tester.view.devicePixelRatio = 1;
  try {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: CookTheme.light(),
        darkTheme: CookTheme.dark(),
        translations: Messages(),
        locale: const Locale('en', 'US'),
        home: page,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  } finally {
    FlutterError.onError = previousHandler;
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  }
  return errors;
}

String _describeErrors(List<FlutterErrorDetails> errors) {
  return errors.map((error) => error.exceptionAsString()).join('\n');
}
