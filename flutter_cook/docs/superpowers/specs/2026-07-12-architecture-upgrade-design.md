# Flutter Cook Fun — 架构升级设计

> 日期：2026-07-12 | 策略：方案 A — 渐进式 GetX 优化

## 目标

在不改变功能行为的前提下，通过 4 个阶段逐步提升架构质量，最终达到：依赖可注入、职责分层清晰、代码可测试。

## 核心原则

1. **不改功能行为** — 每个阶段结束后 App 行为不变
2. **依赖倒置** — Controller → Service → Repository → DioClient/DB，每层依赖抽象
3. **单一职责** — Repository 只做数据存取，Service 只做业务逻辑，Controller 只做 UI 状态
4. **可测试** — 每层可通过 mock 隔离测试

---

## Phase 1：基础设施层

### 1.1 DioClient 实例化

**Before:**
```dart
// static 单例，不可测试
class DioClient {
  static Dio? _dio;
  static Future<Response> get(...) async { ... }
}
```

**After:**
```dart
class DioClient {
  final Dio dio;
  DioClient({Dio? dio}) : dio = dio ?? _createDefaultDio();
  Future<Response<T>> get<T>(...) async { ... }
}
```

- 通过 `Get.lazyPut<DioClient>(() => DioClient())` 注册
- Repository 构造函数注入 `DioClient`
- 测试时传入 mock `Dio`

### 1.2 ThemeManager 实例化

**Before:**
```dart
class ThemeManager {
  static final Rx<ThemeMode> currentThemeMode = ThemeMode.light.obs;
  static ThemeMode get themeMode => currentThemeMode.value;
}
```

**After:**
```dart
class ThemeManager extends GetxController {
  final Rx<ThemeMode> currentThemeMode = ThemeMode.light.obs;
  ThemeMode get themeMode => currentThemeMode.value;
  Future<void> initialize() async { ... }
  Future<void> toggleTheme() async { ... }
}
```

- 注册为 `Get.lazyPut<ThemeManager>(() => ThemeManager())`，`fenix: true`
- main.dart 中 `Get.find<ThemeManager>().initialize()`

### 1.3 常量规范化

**Before:** `abstract class ApiConstants { static const ... }`

**After:** 顶层常量，按文件拆分：
- `lib/core/constants/api.dart` — API 常量
- `lib/core/constants/storage.dart` — 存储 key
- `lib/core/constants/routes.dart` — 路由名
- `lib/core/constants/ui.dart` — UI 常量

### 1.4 依赖注入统一

创建 `lib/bindings/app_bindings.dart`，集中注册所有依赖：

```dart
class AppBindings extends Bindings {
  @override
  void dependencies() {
    // 基础设施
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    Get.lazyPut<ThemeManager>(() => ThemeManager(), fenix: true);

    // Repository
    Get.lazyPut<HomeRepository>(() => HomeRepository(dio: Get.find()));
    Get.lazyPut<CookRepository>(() => CookRepository(dio: Get.find()));

    // Service
    Get.lazyPut<HomeService>(() => HomeService(repo: Get.find()));
    Get.lazyPut<CookService>(() => CookService(repo: Get.find()));

    // Controller
    Get.lazyPut<HomeController>(() => HomeController(service: Get.find()));
    // ...
  }
}
```

### 1.5 移除 fluttertoast

统一使用 `flutter_easyloading`，创建 `ToastUtils` 封装。

---

## Phase 2：架构分层

### 2.1 Service 层

新增 `lib/services/`，从 Repository 和 Controller 中抽离业务逻辑：

| Service | 抽离来源 | 业务逻辑 |
|---------|---------|---------|
| `BannerService` | `HomeRepository._buildCrossModuleBanner`、`_extractCandidate`、`_calculateRecommendationScore` | Banner 推荐算法 |
| `CookService` | `CookRepository` + `CookHomeController` | 食材选择、状态管理 |
| `BookService` | `BookRepository` + `BookController` | 菜谱分页、场景过滤 |
| `SearchService` | `SearchController` + `SearchRepository` | 搜索防抖、历史管理 |

### 2.2 Repository 纯化

Repository 只保留：
- 调用 `DioClient` 发起 HTTP 请求
- 调用 `DBManager` 读写数据库
- JSON → Model 转换
- 异常捕获并转换为 `AppException`

**不再包含：** 业务判断、评分算法、数据组合、兜底策略。

### 2.3 异常体系统一

```dart
sealed class AppException implements Exception {
  final String message;
  final String code;
}

class NetworkException extends AppException { ... }
class DataException extends AppException { ... }
class StorageException extends AppException { ... }
```

- Repository 抛出 `AppException`
- Service 决定重试/兜底/传递
- Controller 映射为 UI 状态

### 2.4 Controller 重构

每个 Controller 遵循统一模式：

```dart
class XxxController extends GetxController {
  final XxxService service;

  XxxController({required this.service});

  final RxList<Model> dataList = <Model>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData({bool refresh = false}) async {
    if (isLoading.value && !refresh) return;
    try {
      isLoading.value = true;
      errorMessage.value = null;
      dataList.assignAll(await service.fetchData());
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }
}
```

---

## Phase 3：代码规范化

### 3.1 大文件拆分

| 文件 | 行数 | 拆分为 |
|------|------|--------|
| `search_page.dart` | 600 | `search_page.dart` + `views/search_bar_widget.dart` + `views/search_results_widget.dart` + `views/search_history_widget.dart` |
| `cook_steps_page.dart` | 448 | `cook_steps_page.dart` + `views/cook_step_item.dart` + `views/cook_step_player.dart` |
| `home_repository.dart` | 431 | `home_repository.dart`（~100 行）+ `services/banner_service.dart`（~250 行） |
| `home_data_page.dart` | ~400 | 拆出 `views/home_banner.dart`（已存在）中的 Banner link 解析逻辑 |

### 3.2 目录重组

**Before:**
```
lib/module/home/ → controller/ + model/ + views/ + repository/ + page.dart
```

**After:**
```
lib/controllers/home_controller.dart
lib/services/home_service.dart
lib/repositories/home_repository.dart
lib/views/home/ → home_page.dart + widgets/ + banner.dart
lib/models/home/  → home_banner_model.dart + home_list_model.dart
```

### 3.3 Toast 统一

- 删除 `fluttertoast` 依赖
- 所有 Toast 调用统一走 `ToastUtils.show()`
- `ToastUtils` 内部使用 `flutter_easyloading`

### 3.4 模式一致性

- 所有页面：`StatefulWidget` + loading/empty/error 三态
- 所有 Controller：`GetxController` + `.obs` + `onInit` 加载
- 所有 Binding：`Get.lazyPut`（不由 `Get.put` 散落在 widget 中）
- 禁止 `late` 变量，声明时赋默认值
- 禁止 `!` 强制解包，使用 `?.` 或 null check

---

## Phase 4：测试体系

### 4.1 测试框架

```yaml
dev_dependencies:
  mocktail: ^1.0.4
  flutter_test:
    sdk: flutter
```

`mocktail` 优势：无需代码生成，纯 Dart，社区活跃。

### 4.2 测试 Helpers

```dart
// test/helpers/test_helpers.dart
void registerTestDependencies() {
  Get.testMode = true;
  Get.put<DioClient>(MockDioClient());
  Get.put<HomeService>(MockHomeService());
}

void clearTestDependencies() {
  Get.reset();
}
```

### 4.3 测试清单

| 层 | 测试内容 |
|----|---------|
| Controller | 状态转换正确（loading → data/error），refresh 重置状态，分页 hasMore |
| Service | 业务逻辑正确（推荐算法、数据组合、兜底策略） |
| Repository | API 调用参数正确，错误转换为 AppException |
| Widget（可选） | 三态渲染、用户交互 |

### 4.4 Controller 测试示例

```dart
test('loadData sets loading then data on success', () async {
  final mockService = MockHomeService();
  when(() => mockService.fetchData()).thenAnswer((_) async => mockData);

  final controller = HomeController(service: mockService);
  await controller.loadData(refresh: true);

  expect(controller.isLoading.value, false);
  expect(controller.dataList.length, greaterThan(0));
  expect(controller.errorMessage.value, isNull);
});
```

---

## 风险评估

| 风险 | 影响 | 缓解措施 |
|------|------|---------|
| 重构引入 bug | 功能回退 | 每阶段结束手动回归测试运行 App |
| 目录重组后 import 断裂 | 编译失败 | IDE 全局替换 + `flutter analyze` 验证 |
| GetX 路由变更 | 页面跳转异常 | 路由路径和参数格式不变 |
| 大文件拆分漏逻辑 | UI 功能缺失 | 逐文件 diff 对比 |

---

## 验收标准

1. `flutter analyze` 零错误
2. App 所有页面：首页/Banner/做菜/菜谱/搜索/收藏/设置均可正常操作
3. 主题切换正常
4. 网络请求正常（真实 API）
5. Controller/Service/Repository 至少各有一个测试通过
