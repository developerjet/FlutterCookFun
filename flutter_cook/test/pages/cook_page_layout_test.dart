import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_chip.dart';
import 'package:flutter_cook/module/cook/controller/cook_home_controller.dart';
import 'package:flutter_cook/module/cook/cook_home_page.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/mocks.dart';

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  testWidgets('厨房台面必须移除重复指标并控制首屏高度', (tester) async {
    final repository = MockCookRepository();
    final ingredient = CookListDataModel(id: '1', text: '番茄');
    when(() => repository.fetchCookHomeData()).thenAnswer(
      (_) async => [
        CookHomeListModel(
          id: 'vegetable',
          text: '蔬菜',
          data: [ingredient],
        ),
      ],
    );
    final controller = Get.put(CookHomeController(repository: repository));

    tester.view.physicalSize = const Size(393, 852);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      GetMaterialApp(
        theme: CookTheme.light(),
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        home: const CookPage(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 20));

    final panel = find.byKey(const ValueKey('cook_selection_panel'));
    expect(panel, findsOneWidget);
    expect(find.byType(AppNavBar), findsOneWidget);
    expect(find.byKey(const ValueKey('cook_delete_action')), findsNothing);
    expect(tester.getSize(panel).height, lessThanOrEqualTo(170));
    expect(find.text('模式'), findsNothing);
    expect(find.text('上限'), findsNothing);

    controller.toggleFoodSelection(ingredient);
    await tester.pump();

    expect(tester.getSize(panel).height, lessThanOrEqualTo(170));
    expect(find.text('番茄'), findsWidgets);
    expect(find.byKey(const ValueKey('cook_delete_action')), findsOneWidget);

    final categoryChip = find.byType(CookChip).first;
    final chipContainer = tester.widget<Container>(
      find.descendant(of: categoryChip, matching: find.byType(Container)),
    );
    final chipDecoration = chipContainer.decoration as BoxDecoration;
    expect(tester.getSize(categoryChip).height, CookTokens.chipHeight);
    expect(
      chipDecoration.borderRadius,
      BorderRadius.circular(CookTokens.pillRadius),
    );
  });
}
