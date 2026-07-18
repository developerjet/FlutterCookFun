import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/module/book/views/book_home_cell.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/views/cook_home_cell.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/module/home/views/home_data_cell.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  tearDown(Get.reset);

  testWidgets('home data cell uses V6 card container', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: Scaffold(
          body: HomeDataCell(
            model: HomeFoodListData(text: '快手菜'),
          ),
        ),
      ),
    );

    expect(find.byType(CookCard), findsOneWidget);
  });

  testWidgets('cook ingredient cell uses V6 card container', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: CookTheme.light(),
        home: Scaffold(
          body: SizedBox(
            width: 140,
            height: 180,
            child: CookHomeCell(
              model: CookListDataModel(text: '番茄'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(CookCard), findsOneWidget);
    expect(
      tester.widget<CookCard>(find.byType(CookCard)).borderRadius,
      CookTokens.listCardRadius,
    );
  });

  testWidgets('book collection cell uses compact list radius', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          body: SizedBox(
            width: 180,
            height: 240,
            child: BookHomeCell(
              model: BookListModel(sceneTitle: '家常菜'),
            ),
          ),
        ),
      ),
    );

    expect(
      tester.widget<CookCard>(find.byType(CookCard)).borderRadius,
      CookTokens.listCardRadius,
    );
  });

  testWidgets('菜谱专题卡片不展示 NEW 状态标签', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CookTheme.light(),
        home: const Scaffold(
          body: SizedBox(
            width: 180,
            height: 240,
            child: BookHomeCell(
              model: BookListModel(sceneTitle: '家常菜', isNew: 1),
            ),
          ),
        ),
      ),
    );

    expect(find.text('NEW'), findsNothing);
    expect(
      tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .map((widget) => widget.decoration)
          .whereType<BoxDecoration>()
          .where((decoration) => decoration.color == CookTokens.warm),
      isEmpty,
    );
  });
}
