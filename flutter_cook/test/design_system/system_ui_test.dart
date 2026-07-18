import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android 启动主题不得使用灰色或突兀主色状态栏', () {
    final light =
        File('android/app/src/main/res/values/styles.xml').readAsStringSync();
    final dark = File('android/app/src/main/res/values-night/styles.xml')
        .readAsStringSync();

    expect(
        light, contains('<item name="android:statusBarColor">#F6F8F7</item>'));
    expect(light,
        contains('<item name="android:windowLightStatusBar">true</item>'));
    expect(
        dark, contains('<item name="android:statusBarColor">#101713</item>'));
    expect(dark,
        contains('<item name="android:windowLightStatusBar">false</item>'));
  });

  test('应用根节点必须统一控制系统状态栏样式', () {
    final source = File('lib/main.dart').readAsStringSync();

    expect(source, contains('AnnotatedRegion<SystemUiOverlayStyle>'));
    expect(source, contains("ValueKey('app_system_ui_style')"));
  });

  test('视频和媒体页面不得覆盖为主色导航栏', () {
    for (final path in const [
      'lib/module/player/player_page.dart',
      'lib/base/web.dart',
      'lib/base/image_viewer.dart',
    ]) {
      final source = File(path).readAsStringSync();
      expect(source, contains('AppNavBar('), reason: path);
      expect(
        source,
        isNot(
            contains('backgroundColor: Theme.of(context).colorScheme.primary')),
        reason: path,
      );
    }
  });
}
