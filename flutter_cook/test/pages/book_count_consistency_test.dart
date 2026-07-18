import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/module/book/book_detial_page.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/module/book/views/book_home_cell.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  testWidgets('菜谱专题卡片不承诺接口无法兑现的详情数量', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        theme: CookTheme.light(),
        home: const Scaffold(
          body: SizedBox(
            width: 220,
            height: 280,
            child: BookHomeCell(
              model: BookListModel(
                sceneTitle: '儿童长高食谱',
                sceneDesc: '成长营养搭配',
                dishCount: 92,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('进入专题'), findsOneWidget);
    expect(find.textContaining('道可浏览'), findsNothing);
    expect(find.textContaining('道菜谱'), findsNothing);
  });

  testWidgets('菜谱专题卡片只展示菜品名，不渲染副标题控件', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        theme: CookTheme.light(),
        home: const Scaffold(
          body: SizedBox(
            width: 220,
            height: 280,
            child: BookHomeCell(
              model: BookListModel(
                dishesName: '宫保鸡丁',
                sceneTitle: '下饭家常菜',
                sceneDesc: '快手家常下饭菜',
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('快手家常下饭菜'), findsNothing);
    expect(find.text('下饭家常菜'), findsNothing);
    expect(find.byType(Text), findsNWidgets(2));
    expect(find.text('进入专题'), findsOneWidget);

    final titleText = tester.widget<Text>(find.text('宫保鸡丁'));
    expect(
      titleText.style?.fontSize,
      CookTheme.light().textTheme.titleMedium?.fontSize,
    );
    expect(titleText.style?.color, CookTheme.light().colorScheme.onSurface);
  });

  testWidgets('菜谱详情数量严格等于实际返回列表长度', (tester) async {
    final service = MockBookService();
    final dishes = List.generate(
      45,
      (index) => BookDishesListModel(
        dishesId: index + 1,
        dishesName: '菜谱 ${index + 1}',
      ),
    );
    when(() => service.fetchBookDetail(1280, page: 1)).thenAnswer(
      (_) async => BookDetailModel(
        data: BookMoreData(
          sceneId: 1280,
          dishCount: 92,
          sceneTitle: '儿童长高食谱',
          dishesList: dishes,
        ),
      ),
    );
    Get.put<BookService>(service);

    await tester.pumpWidget(
      GetMaterialApp(
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        theme: CookTheme.light(),
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => Get.to(
                () => const BookDetailPage(),
                arguments: {'scene_id': 1280, 'title': '儿童长高食谱'},
              ),
              child: const Text('打开详情'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开详情'));
    await tester.pumpAndSettle();

    expect(find.text('共 45 道菜谱'), findsOneWidget);
    expect(find.textContaining('92'), findsNothing);
  });
}
