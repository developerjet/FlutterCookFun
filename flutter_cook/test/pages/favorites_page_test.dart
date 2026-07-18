import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/module/mine/favorites_page.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class MockFavoritesDataStore extends Mock implements FavoritesDataStore {}

void main() {
  late MockFavoritesDataStore dataStore;

  setUp(() {
    Get.testMode = true;
    dataStore = MockFavoritesDataStore();
  });

  tearDown(Get.reset);

  testWidgets('收藏页管理模式支持选择并删除收藏后刷新列表', (tester) async {
    const favorites = [
      CookConfigListModel(dishesId: '1', title: '菜谱 1'),
      CookConfigListModel(dishesId: '2', title: '菜谱 2'),
    ];
    when(() => dataStore.findAll()).thenAnswer((_) async => favorites);
    when(() => dataStore.delete('2')).thenAnswer((_) async => 1);

    Get.put(FavoritesController(dataStore: dataStore));

    await tester.pumpWidget(
      GetMaterialApp(
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        builder: EasyLoading.init(),
        home: const FavoritePage(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('菜谱 1'), findsOneWidget);
    expect(find.text('菜谱 2'), findsOneWidget);

    final manageButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, '管理'),
    );
    final foregroundColor = manageButton.style?.foregroundColor?.resolve({});
    expect(foregroundColor, Colors.white);

    tester
        .widget<TextButton>(find.widgetWithText(TextButton, '管理'))
        .onPressed
        ?.call();
    await tester.pumpAndSettle();

    await tester.tap(find.text('菜谱 2'));
    await tester.pumpAndSettle();

    expect(find.text('删除(1)'), findsOneWidget);

    await tester.tap(find.text('删除(1)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除').last);
    await tester.pumpAndSettle();

    expect(find.text('菜谱 1'), findsOneWidget);
    expect(find.text('菜谱 2'), findsNothing);
    expect(find.text('删除(1)'), findsNothing);
    verify(() => dataStore.delete('2')).called(1);

    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('收藏页底部管理栏不避让系统底部安全区', (tester) async {
    const favorites = [
      CookConfigListModel(dishesId: '1', title: '菜谱 1'),
    ];
    when(() => dataStore.findAll()).thenAnswer((_) async => favorites);

    Get.put(FavoritesController(dataStore: dataStore));

    await tester.pumpWidget(
      GetMaterialApp(
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        builder: EasyLoading.init(),
        home: const MediaQuery(
          data: MediaQueryData(
            padding: EdgeInsets.only(bottom: 34),
            viewPadding: EdgeInsets.only(bottom: 34),
          ),
          child: FavoritePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    tester
        .widget<TextButton>(find.widgetWithText(TextButton, '管理'))
        .onPressed
        ?.call();
    await tester.pumpAndSettle();

    final screenHeight =
        tester.view.physicalSize.height / tester.view.devicePixelRatio;
    final manageBarBottom = tester
        .getBottomLeft(find.byKey(const ValueKey('favorite_manage_bar')))
        .dy;
    final manageBarSize =
        tester.getSize(find.byKey(const ValueKey('favorite_manage_bar')));
    final deleteButtonBottom =
        tester.getBottomLeft(find.widgetWithText(ElevatedButton, '删除(0)')).dy;

    expect(manageBarBottom, closeTo(screenHeight, 0.1));
    expect(manageBarSize.height, closeTo(94, 0.1));
    expect(deleteButtonBottom, lessThanOrEqualTo(screenHeight - 34));
  });
}
