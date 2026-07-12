import 'package:flutter_cook/binding/binding.dart';
import 'package:flutter_cook/module/cook/controller/cook_config_controller.dart';
import 'package:flutter_cook/module/cook/controller/cook_steps_controller.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    AppBindings().dependencies();
  });

  tearDown(() {
    Get.reset();
  });

  test('全局 Controller 不应被普通路由生命周期删除', () async {
    expect(await Get.delete<CookConfigController>(), false);
    expect(Get.isRegistered<CookConfigController>(), true);

    expect(await Get.delete<CookStepsController>(), false);
    expect(Get.isRegistered<CookStepsController>(), true);

    expect(await Get.delete<FavoritesController>(), false);
    expect(Get.isRegistered<FavoritesController>(), true);
  });
}
