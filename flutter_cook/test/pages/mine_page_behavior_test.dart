import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';
import 'package:flutter_cook/module/mine/mine_page.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/language/language.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() => Get.testMode = true);
  tearDown(Get.reset);

  testWidgets('个人页不得展示无效统计并且核心入口必须可点击', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: CookTheme.light(),
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        getPages: [
          GetPage(
            name: RouteNames.favorites,
            page: () => const Scaffold(body: Text('favorites-route')),
          ),
          GetPage(
            name: RouteNames.setting,
            page: () => const Scaffold(body: Text('settings-route')),
          ),
          GetPage(
            name: RouteNames.web,
            page: () => const Scaffold(body: Text('web-route')),
          ),
        ],
        home: const MinePage(),
      ),
    );

    expect(find.text('本地'), findsNothing);
    expect(find.text('同步'), findsNothing);
    expect(find.text('入口'), findsNothing);
    expect(find.text('我的'), findsOneWidget);
    expect(find.text('我的厨房'), findsNothing);
    expect(find.textContaining('Kitchen OS'), findsNothing);
    expect(find.text('v1.0.0'), findsOneWidget);

    const favoriteKey = ValueKey('mine_action_favorites');
    const settingsKey = ValueKey('mine_action_settings');
    const flutterKey = ValueKey('mine_action_flutter');
    const githubKey = ValueKey('mine_action_github');
    expect(find.byKey(favoriteKey), findsOneWidget);
    expect(find.byKey(settingsKey), findsOneWidget);
    expect(find.byKey(flutterKey), findsOneWidget);
    expect(find.byKey(githubKey), findsOneWidget);

    await tester.tap(find.byKey(favoriteKey));
    await tester.pumpAndSettle();
    expect(find.text('favorites-route'), findsOneWidget);
  });

  testWidgets('Flutter 中文网和作者 GitHub 必须使用独立入口及正确链接', (tester) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: CookTheme.light(),
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        getPages: [
          GetPage(
            name: RouteNames.web,
            page: () => const Scaffold(body: Text('web-route')),
          ),
        ],
        home: const MinePage(),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('mine_action_flutter')));
    await tester.pumpAndSettle();
    expect(Get.arguments['title'], 'Flutter 中文网');
    expect(Get.arguments['url'], 'https://flutter.cn');

    Get.back();
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('mine_action_github')));
    await tester.pumpAndSettle();
    expect(Get.arguments['title'], '作者 GitHub');
    expect(Get.arguments['url'], 'https://github.com/codertj93');
  });
}
