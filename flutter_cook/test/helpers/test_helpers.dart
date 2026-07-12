import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

/// 注册测试模式
void registerTestDependencies() {
  Get.testMode = true;
}

/// 清理测试依赖
void clearTestDependencies() {
  Get.reset();
}

/// 注册并替换 mock 实例
T registerMock<T extends Object>(T mock) {
  Get.replace<T>(mock);
  return mock;
}
