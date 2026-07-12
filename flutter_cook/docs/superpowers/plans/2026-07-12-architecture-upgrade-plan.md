# Flutter Cook Fun — 架构升级实施计划

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 渐进式重构 Flutter Cook Fun 项目架构，达到依赖可注入、职责分层清晰、代码可测试，不改变功能行为。

**Architecture:** Controller → Service → Repository → DioClient/DB 四层依赖倒置。GetX 实例 DI 替代静态单例。业务逻辑从 Repository/Controller 抽入 Service。

**Tech Stack:** Flutter SDK >=3.2.3 <4.0.0, GetX ^4.6.6, Dio ^5.4.0, sqflite ^2.3.2, mocktail ^1.0.4

**Spec:** `docs/superpowers/specs/2026-07-12-architecture-upgrade-design.md`

---

## Phase 1：基础设施层

### Task 1.1: DioClient 实例化

**Files:**
- Modify: `lib/utils/networking/networking.dart`
- Modify: `lib/module/home/repository/home_repository.dart`
- Modify: `lib/module/cook/repository/cook_repository.dart`
- Modify: `lib/base/repository/base_repository.dart`

- [ ] **Step 1: 改造 DioClient 为实例类**

**`lib/utils/networking/networking.dart`** — 将静态类改为实例类：

```dart
import 'package:dio/dio.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/error_handler.dart';

/// Dio 网络客户端
///
/// 通过 GetX DI 注册为单例：Get.lazyPut<DioClient>(() => DioClient())
class DioClient {
  final Dio dio;
  static const String _tag = 'DioClient';

  DioClient({Dio? dio})
      : dio = dio ?? _createDefaultDio();

  static Dio _createDefaultDio() {
    final options = BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout:
          const Duration(milliseconds: ApiConstants.connectTimeout),
      sendTimeout:
          const Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout:
          const Duration(milliseconds: ApiConstants.receiveTimeout),
    );

    final d = Dio(options);
    d.interceptors.add(_LoggingInterceptor());
    return d;
  }

  /// GET 请求
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      AppLogger.logNetworkRequest(path, 'GET', queryParameters);
      final response =
          await dio.get<T>(path, queryParameters: queryParameters);
      AppLogger.logNetworkResponse(path, response.statusCode, response.data);
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _toNetworkException(e, 'GET', path);
    } catch (e) {
      AppLogger.error(_tag, 'Unknown error: $path', e is Exception ? e : null);
      rethrow;
    }
  }

  /// POST 请求
  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      AppLogger.logNetworkRequest(path, 'POST', data);
      final response = await dio.post<T>(path, data: data);
      AppLogger.logNetworkResponse(path, response.statusCode, response.data);
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _toNetworkException(e, 'POST', path);
    } catch (e) {
      AppLogger.error(_tag, 'Unknown error: $path', e is Exception ? e : null);
      rethrow;
    }
  }

  /// PUT 请求
  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      AppLogger.logNetworkRequest(path, 'PUT', data);
      final response = await dio.put<T>(path, data: data);
      AppLogger.logNetworkResponse(path, response.statusCode, response.data);
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _toNetworkException(e, 'PUT', path);
    } catch (e) {
      AppLogger.error(_tag, 'Unknown error: $path', e is Exception ? e : null);
      rethrow;
    }
  }

  /// DELETE 请求
  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      AppLogger.logNetworkRequest(path, 'DELETE', queryParameters);
      final response =
          await dio.delete<T>(path, queryParameters: queryParameters);
      AppLogger.logNetworkResponse(path, response.statusCode, response.data);
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      throw _toNetworkException(e, 'DELETE', path);
    } catch (e) {
      AppLogger.error(_tag, 'Unknown error: $path', e is Exception ? e : null);
      rethrow;
    }
  }

  /// 验证响应状态码
  void _validateResponse(Response response) {
    final statusCode = response.statusCode;
    if (statusCode != null && statusCode >= 400) {
      throw NetworkException(
        message: 'server_error'.trArgs([statusCode.toString()]),
        code: statusCode.toString(),
      );
    }
  }

  /// 将 DioException 转换为 NetworkException
  NetworkException _toNetworkException(
      DioException e, String method, String path) {
    String message;
    String code;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'request_timeout'.tr;
        code = 'CONNECTION_TIMEOUT';
      case DioExceptionType.sendTimeout:
        message = 'request_timeout'.tr;
        code = 'SEND_TIMEOUT';
      case DioExceptionType.receiveTimeout:
        message = 'request_timeout'.tr;
        code = 'RECEIVE_TIMEOUT';
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        message = _getHttpErrorMessage(statusCode);
        code = 'HTTP_ERROR_$statusCode';
      case DioExceptionType.connectionError:
        message = 'network_connection_failed'.tr;
        code = 'CONNECTION_ERROR';
      case DioExceptionType.badCertificate:
        message = 'certificate_verification_failed'.tr;
        code = 'BAD_CERTIFICATE';
      case DioExceptionType.unknown:
        message = 'network_request_error'.trArgs([e.message ?? '']);
        code = 'UNKNOWN_ERROR';
      case DioExceptionType.cancel:
        message = 'request_canceled'.tr;
        code = 'REQUEST_CANCELLED';
    }

    AppLogger.error(
      _tag,
      '[$method] $path - $message (Code: $code)',
      e,
    );

    return NetworkException(message: message, code: code);
  }

  String _getHttpErrorMessage(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'request_param_error'.tr;
      case 401:
        return 'unauthorized'.tr;
      case 403:
        return 'forbidden'.tr;
      case 404:
        return 'not_found'.tr;
      case 500:
        return 'internal_server_error'.tr;
      case 502:
        return 'bad_gateway'.tr;
      case 503:
        return 'service_unavailable'.tr;
      default:
        return 'request_failed_try_again'.tr;
    }
  }
}

/// 日志拦截器
class _LoggingInterceptor extends Interceptor {
  static const String _tag = 'HttpLog';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.info(
      _tag,
      'Request: ${options.method} ${options.path}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info(
      _tag,
      'Response: ${response.statusCode} ${response.requestOptions.path}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error(
      _tag,
      'Error: ${err.type} - ${err.requestOptions.path}',
      err,
    );
    super.onError(err, handler);
  }
}
```

- [ ] **Step 2: Repository 注入 DioClient**

**`lib/base/repository/base_repository.dart`**：

```dart
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:get/get.dart';

/// Repository 基类
///
/// 子类通过构造函数注入 DioClient
class BaseRepository {
  final DioClient client;

  BaseRepository({required this.client});

  /// 执行网络请求（带重试机制）
  Future<T> execute<T>(
    Future<T> Function() request, {
    int maxRetries = 2,
  }) async {
    int retryCount = 0;

    while (true) {
      try {
        return await request();
      } catch (e) {
        retryCount++;

        if (_shouldRetry(e, retryCount, maxRetries)) {
          await Future.delayed(
            Duration(seconds: (1 << retryCount).clamp(1, 8)),
          );
          continue;
        }

        if (e is AppException) {
          rethrow;
        } else {
          throw _handleUnknownException(e);
        }
      }
    }
  }

  bool _shouldRetry(dynamic exception, int retryCount, int maxRetries) {
    if (retryCount > maxRetries) return false;

    if (exception is NetworkException) {
      final code = exception.code;
      return code != null &&
          (code.contains('TIMEOUT') ||
              code.contains('CONNECTION') ||
              code.contains('NETWORK'));
    }

    return false;
  }

  AppException _handleUnknownException(dynamic exception) {
    AppLogger.error(
      'BaseRepository',
      'Unknown exception: $exception',
      exception is Exception ? exception : null,
    );

    return DataException(
      message: 'unknown_error_try_again'.tr,
      code: 'UNKNOWN_ERROR',
      originalException: exception is Exception ? exception : null,
    );
  }
}
```

**`lib/module/home/repository/home_repository.dart`** — 修改构造函数和调用：

```dart
import 'dart:math';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/base/repository/base_repository.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:get/get.dart';

class HomeRepository extends BaseRepository {
  static const String _tag = 'HomeRepository';

  // ... (keep all _moduleWeights, _skipModuleIds, etc. unchanged)

  HomeRepository({required DioClient client}) : super(client: client);

  Future<HomeBannerModel> fetchBannerData({
    String? deviceModel,
    String? systemVersion,
    String? appVersion,
  }) async {
    // ... (same logic, replace DioClient.get with client.get)
  }

  Future<HomeBannerModel> _fetchBannerData({...}) async {
    return execute(() async {
      // ... (replace DioClient.get('', queryParameters: params)
      //      with client.get('', queryParameters: params))
    }, maxRetries: 2);
  }

  Future<HomeDataModel> fetchHomeListData({...}) async {
    return execute(() async {
      // ... (replace DioClient.get with client.get)
    }, maxRetries: 2);
  }
  // ... (keep rest of methods unchanged)
}
```

**`lib/module/cook/repository/cook_repository.dart`** — 同理修改：

```dart
class CookRepository extends BaseRepository {
  CookRepository({required DioClient client}) : super(client: client);
  // ... (replace DioClient.get → client.get, DioClient.post → client.post)
}
```

- [ ] **Step 3: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 4: Commit**

```bash
git add lib/utils/networking/networking.dart lib/base/repository/base_repository.dart lib/module/home/repository/home_repository.dart lib/module/cook/repository/cook_repository.dart
git commit -m "refactor: convert DioClient to instance class with DI injection"
```

---

### Task 1.2: ThemeManager 实例化

**Files:**
- Modify: `lib/utils/theme.dart`
- Modify: `lib/main.dart`
- Modify: `lib/module/setting/controller/setting_controller.dart`
- Modify: `lib/base/tabs.dart`

- [ ] **Step 1: ThemeManager 改为 GetxController**

**`lib/utils/theme.dart`**：

```dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends GetxController {
  static const Color primaryColor = Color(0xFF00CC99);
  static const Color themeColor = primaryColor;
  static const Color tabSelectedColor = Color(0xFF00CC99);
  static const Color tabUnselectedColor = Color(0xFFAAAAAA);

  final Rx<ThemeMode> currentThemeMode = ThemeMode.light.obs;

  ThemeMode get themeMode => currentThemeMode.value;
  bool get isDarkMode => currentThemeMode.value == ThemeMode.dark;

  // Color getters (same as before)
  Color get surfaceColor =>
      isDarkMode ? const Color(0xFF1E1E1E) : const Color(0xFFFFFFFF);
  Color get backgroundColor =>
      isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F6F7);
  Color get cardColor =>
      isDarkMode ? const Color(0xFF202020) : const Color(0xFFFFFFFF);
  Color get textPrimaryColor =>
      isDarkMode ? const Color(0xFFFFFFFF) : Colors.black;
  Color get textSecondaryColor =>
      isDarkMode ? const Color(0xFFB5B5B5) : const Color(0xFF6F777A);
  Color get dividerColor =>
      isDarkMode ? const Color(0xFF383838) : const Color(0xFFE5E5E5);
  Color get bottomSheetBackground => surfaceColor;
  Color get maskBgColor => const Color(0x60000000);

  // Theme cache
  ThemeData? _cachedLightTheme;
  ThemeData? _cachedDarkTheme;

  ThemeData get lightTheme {
    _cachedLightTheme ??= _buildTheme(Brightness.light);
    return _cachedLightTheme!;
  }

  ThemeData get darkTheme {
    _cachedDarkTheme ??= _buildTheme(Brightness.dark);
    return _cachedDarkTheme!;
  }

  void invalidateThemeCache() {
    _cachedLightTheme = null;
    _cachedDarkTheme = null;
  }

  ThemeData _buildTheme(Brightness brightness) {
    // ... (identical to current _buildTheme implementation)
  }

  static MaterialColor createMaterialColor(Color color) {
    // ... (identical to current implementation)
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final int themeIndex = prefs.getInt('ThemeMode') ?? 0;
    currentThemeMode.value =
        themeIndex == 0 ? ThemeMode.light : ThemeMode.dark;
  }

  Future<void> saveTheme(int themeMode) async {
    currentThemeMode.value =
        themeMode == 0 ? ThemeMode.light : ThemeMode.dark;
    Get.changeThemeMode(currentThemeMode.value);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ThemeMode', themeMode);
  }

  Color textMainColor() => textPrimaryColor;
  Color textGrayColor() => textSecondaryColor;
  Color redMainColor() => const Color(0xFFFF4F4F);
  Color lineBoardColor() => dividerColor;
  Color bg1Color() => surfaceColor;
  Color bg2Color() => backgroundColor;
  Color bg3Color() => cardColor;
  Color bottomSheetColor() => bottomSheetBackground;

  static final Random _random = Random();
  Color generateRandomColor() {
    return Color.fromRGBO(
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
      1.0,
    );
  }
}
```

- [ ] **Step 2: 更新 main.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_cook/binding/app_bindings.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import './routers/routers.dart';
import 'utils/language/language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI
  AppBindings().dependencies();

  // Initialize ThemeManager
  final themeManager = Get.find<ThemeManager>();
  await themeManager.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeManager = Get.find<ThemeManager>();
    return Obx(
      () => GetMaterialApp(
        defaultGlobalState: true,
        debugShowCheckedModeBanner: false,
        title: "Cook Fun",
        translations: Messages(),
        locale: const Locale('zh', 'CN'),
        fallbackLocale: const Locale('en', 'US'),
        theme: themeManager.lightTheme,
        darkTheme: themeManager.darkTheme,
        themeMode: themeManager.currentThemeMode.value,
        initialRoute: "/",
        getPages: AppRouter.routers,
        builder: EasyLoading.init(),
      ),
    );
  }
}
```

- [ ] **Step 3: 更新引用**

**`lib/module/setting/controller/setting_controller.dart`** — 将 `ThemeManager.saveTheme()` 替换为 `Get.find<ThemeManager>().saveTheme()`，删除 `ThemeManager.fetchLastTheme()` 引用（逻辑已在 initialize 中处理）。

**`lib/base/tabs.dart`** — 将 `ThemeManager.tabSelectedColor` / `ThemeManager.tabUnselectedColor` 保留（static const 仍可用），颜色 getter 改为：`Get.find<ThemeManager>().textPrimaryColor`。

- [ ] **Step 4: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/utils/theme.dart lib/main.dart lib/module/setting/controller/setting_controller.dart lib/base/tabs.dart
git commit -m "refactor: convert ThemeManager to GetxController with DI"
```

---

### Task 1.3: 常量规范化 + 移除 fluttertoast

**Files:**
- Create: `lib/core/constants/api.dart`
- Create: `lib/core/constants/routes.dart`
- Create: `lib/core/constants/ui.dart`
- Create: `lib/core/constants/storage.dart`
- Modify: `lib/utils/constants.dart` (re-export from new files, add deprecation)
- Modify: `lib/utils/toast.dart`
- Modify: `pubspec.yaml`

- [ ] **Step 1: 创建分拆后的常量文件**

**`lib/core/constants/api.dart`**：

```dart
/// API 配置常量

const String kBaseUrl = 'http://api.izhangchu.com';
const int kConnectTimeout = 30000;
const int kReceiveTimeout = 30000;

const String kFoodListEndpoint = '/food/list';
const String kCookStepsEndpoint = '/cook/steps';
const String kBookDetailEndpoint = '/book/detail';
const String kSearchEndpoint = '/search';
```

**`lib/core/constants/routes.dart`**：

```dart
/// 路由名称常量

const String routeHome = '/';
const String routeFoodClass = '/foodClass';
const String routeCookSteps = '/cookSteps';
const String routeCookConfig = '/cookConfig';
const String routeBookDetail = '/bookDetail';
const String routePlayerVideo = '/player';
const String routeSetting = '/setting';
const String routeFavorites = '/favorite';
const String routeSearch = '/search';
const String routeWeb = '/webPage';
const String routeImageViewer = '/imageViewer';
```

**`lib/core/constants/ui.dart`**：

```dart
/// UI 相关常量

const double kSpacingSmall = 8.0;
const double kSpacingMedium = 16.0;
const double kSpacingLarge = 24.0;
const double kRadiusSmall = 4.0;
const double kRadiusMedium = 8.0;
const double kRadiusLarge = 16.0;
const double kMinTouchSize = 48.0;
```

**`lib/core/constants/storage.dart`**：

```dart
/// 本地存储 Key 常量

const String kSearchHistory = 'search_history';
const String kUserPreferences = 'user_preferences';
const String kAppTheme = 'app_theme';
const String kLanguage = 'language';
const String kFavoritesList = 'favorites_list';
```

- [ ] **Step 2: 更新 constants.dart 为兼容性 re-export**

```dart
/// 向后兼容性 re-export
/// 新代码请直接导入 lib/core/constants/ 下的对应文件

export '../core/constants/api.dart';
export '../core/constants/routes.dart';
export '../core/constants/ui.dart';
export '../core/constants/storage.dart';

import '../core/constants/api.dart';
import '../core/constants/routes.dart';
import '../core/constants/ui.dart';
import '../core/constants/storage.dart';

// 保留旧类名继续有效（别名）
typedef ApiConstants = _ApiConstants;
class _ApiConstants {
  static const String baseUrl = kBaseUrl;
  static const int connectTimeout = kConnectTimeout;
  static const int receiveTimeout = kReceiveTimeout;
  static const String foodListEndpoint = kFoodListEndpoint;
  static const String cookStepsEndpoint = kCookStepsEndpoint;
  static const String bookDetailEndpoint = kBookDetailEndpoint;
  static const String searchEndpoint = kSearchEndpoint;
}

typedef RouteNames = _RouteNames;
class _RouteNames {
  static const String home = routeHome;
  static const String foodClass = routeFoodClass;
  static const String cookSteps = routeCookSteps;
  static const String cookConfig = routeCookConfig;
  static const String bookDetail = routeBookDetail;
  static const String playerVideo = routePlayerVideo;
  static const String setting = routeSetting;
  static const String favorites = routeFavorites;
  static const String search = routeSearch;
  static const String web = routeWeb;
  static const String imageViewer = routeImageViewer;
}

typedef UiConstants = _UiConstants;
class _UiConstants {
  static const double spacingSmall = kSpacingSmall;
  static const double spacingMedium = kSpacingMedium;
  static const double spacingLarge = kSpacingLarge;
  static const double radiusSmall = kRadiusSmall;
  static const double radiusMedium = kRadiusMedium;
  static const double radiusLarge = kRadiusLarge;
  static const double minTouchSize = kMinTouchSize;
}

typedef StorageKeys = _StorageKeys;
class _StorageKeys {
  static const String searchHistory = kSearchHistory;
  static const String userPreferences = kUserPreferences;
  static const String appTheme = kAppTheme;
  static const String language = kLanguage;
  static const String favoritesList = kFavoritesList;
}

// BusinessConstants/DebugConstants 原地保留，后续逐步迁移
abstract class BusinessConstants {
  static const int pageSize = 20;
  static const int maxSearchHistory = 20;
  static const int carouselInterval = 5000;
  static const int videoBufferTime = 3000;
}

abstract class DebugConstants {
  static const bool enableNetworkLog = true;
  static const bool enableDatabaseLog = true;
  static const bool enableLifecycleLog = false;
}
```

- [ ] **Step 3: ToastUtils 改用 EasyLoading，移除 fluttertoast**

**`lib/utils/toast.dart`**：

```dart
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class ToastUtils {
  static void showShortToast(String message) {
    EasyLoading.showToast(message,
        duration: const Duration(seconds: 2), toastPosition: EasyLoadingToastPosition.center);
  }

  static void showLongToast(String message) {
    EasyLoading.showToast(message,
        duration: const Duration(seconds: 4), toastPosition: EasyLoadingToastPosition.center);
  }

  static void showColoredToast(
      String message, Color backgroundColor, Color textColor) {
    EasyLoading.showToast(message,
        duration: const Duration(seconds: 2),
        toastPosition: EasyLoadingToastPosition.center,
        maskColor: backgroundColor.withOpacity(0.8));
  }

  static void showCustomDurationToast(String message, int durationInSeconds) {
    EasyLoading.showToast(message,
        duration: Duration(seconds: durationInSeconds),
        toastPosition: EasyLoadingToastPosition.center);
  }

  static void showSnackbar(String title, String message) {
    Get.snackbar(title, message, duration: const Duration(seconds: 2));
  }
}
```

- [ ] **Step 4: 移除 fluttertoast 依赖**

```bash
flutter pub remove fluttertoast
```

- [ ] **Step 5: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 6: Commit**

```bash
git add lib/core/ lib/utils/constants.dart lib/utils/toast.dart pubspec.yaml pubspec.lock
git commit -m "refactor: split constants into focused files, replace fluttertoast with EasyLoading"
```

---

### Task 1.4: 统一依赖注入 (AppBindings)

**Files:**
- Create: `lib/bindings/app_bindings.dart`
- Modify: `lib/binding/binding.dart`
- Modify: `lib/main.dart`

- [ ] **Step 1: 创建统一 AppBindings**

**`lib/bindings/app_bindings.dart`**：

```dart
import 'package:get/get.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/base/repository/base_repository.dart';
import 'package:flutter_cook/module/home/repository/home_repository.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';
import 'package:flutter_cook/module/home/controller/home_controller.dart';
import 'package:flutter_cook/module/search/controller/search_controller.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/module/setting/controller/setting_controller.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ── 基础设施 ──
    Get.lazyPut<DioClient>(() => DioClient(), fenix: true);
    Get.lazyPut<ThemeManager>(() => ThemeManager(), fenix: true);

    // ── Repository ──
    Get.lazyPut<HomeRepository>(
        () => HomeRepository(client: Get.find<DioClient>()));
    Get.lazyPut<CookRepository>(
        () => CookRepository(client: Get.find<DioClient>()));

    // ── Controller ──
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<SearchController>(() => SearchController());
    Get.lazyPut<FavoritesController>(() => FavoritesController());
    Get.lazyPut<SettingController>(() => SettingController());
  }
}
```

- [ ] **Step 2: 更新 main.dart**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_cook/bindings/app_bindings.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import './routers/routers.dart';
import 'utils/language/language.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // DI 注册
  AppBindings().dependencies();

  // 初始化 ThemeManager
  await Get.find<ThemeManager>().initialize();

  runApp(const MyApp());
}
```

- [ ] **Step 3: 更新 Tabs 中的 Controller 获取**

核查 `lib/base/tabs.dart` 中 Controller 的获取方式，确认使用 `Get.find<T>()`。

- [ ] **Step 4: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/bindings/app_bindings.dart lib/binding/binding.dart lib/main.dart lib/base/tabs.dart
git commit -m "refactor: centralize DI with AppBindings, all controllers via Get.lazyPut"
```

---

## Phase 2：架构分层

### Task 2.1: 抽取 BannerService（业务逻辑层）

**Files:**
- Create: `lib/services/banner_service.dart`
- Modify: `lib/module/home/repository/home_repository.dart`
- Modify: `lib/bindings/app_bindings.dart`

- [ ] **Step 1: 创建 BannerService**

从 `HomeRepository` 抽出 Banner 推荐逻辑到 `lib/services/banner_service.dart`：

```dart
import 'dart:math';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';

/// Banner 跨模块推荐服务
///
/// 从首页多模块数据中智能提取轮播图候选项
class BannerService {
  static const Map<String, double> _moduleWeights = {
    '14': 0.80,
    '15': 0.90,
    '16': 0.80,
    '17': 0.70,
    '18': 0.95,
    '22': 0.85,
  };

  static const Set<String> _skipModuleIds = {'12', '13', '19', '20'};
  static const int _maxBannerItems = 6;
  static const int _maxItemsPerModule = 2;

  /// 跨模块推荐 Banner
  /// 返回 null 表示无可用候选项
  HomeBannerModel? buildCrossModuleBanner(HomeBannerModel model) {
    final modules = model.data?.moduleList;
    if (modules == null || modules.isEmpty) return null;

    final candidates = <_RecommendationCandidate>[];

    for (final module in modules) {
      final moduleId = module.moduleId;
      if (moduleId == null || _skipModuleIds.contains(moduleId)) continue;

      final items = module.moduleData;
      if (items == null || items.isEmpty) continue;

      for (final item in items) {
        final candidate = _extractCandidate(item, moduleId);
        if (candidate != null) candidates.add(candidate);
      }
    }

    if (candidates.isEmpty) return null;

    candidates.sort((a, b) => b.score.compareTo(a.score));

    final selected = <_RecommendationCandidate>[];
    final moduleCounts = <String, int>{};

    for (final candidate in candidates) {
      final count = moduleCounts[candidate.moduleId] ?? 0;
      if (count >= _maxItemsPerModule) continue;
      selected.add(candidate);
      moduleCounts[candidate.moduleId] = count + 1;
      if (selected.length >= _maxBannerItems) break;
    }

    if (selected.isEmpty) return null;

    final moduleDataList = selected
        .map((c) => ModuleData(
              bannerTitle: c.title,
              bannerPicture: c.image,
              bannerLink: c.link,
            ))
        .toList();

    return HomeBannerModel(
      data: HomeBannerData(
        moduleList: [
          ModuleList(
            moduleId: '999',
            moduleName: '智能推荐',
            moduleData: moduleDataList,
          ),
        ],
      ),
    );
  }

  /// 本地兜底 Banner
  HomeBannerModel buildLocalFallbackBanner() {
    return HomeBannerModel(
      data: HomeBannerData(
        moduleList: [
          ModuleList(
            moduleData: [
              ModuleData(
                bannerTitle: '精选菜谱',
                bannerPicture: 'assets/images/banner_placeholder.png',
                bannerLink: 'https://flutter.cn',
              ),
              ModuleData(
                bannerTitle: '热门推荐',
                bannerPicture: 'assets/images/banner_placeholder.png',
                bannerLink: 'https://flutter.cn',
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 检查 Banner 数据有效性
  bool hasValidBannerData(HomeBannerModel model) {
    return model.data?.moduleList?.any((module) {
          return module.moduleData?.any((item) {
                final picture = item.bannerPicture?.trim();
                return picture != null &&
                    picture.isNotEmpty &&
                    picture != 'null';
              }) ==
              true;
        }) ==
        true;
  }

  _RecommendationCandidate? _extractCandidate(
      ModuleData item, String moduleId) {
    String? image;
    String? title;
    String? link;

    switch (moduleId) {
      case '14':
        image = item.dishesImage;
        title = item.dishesName;
        link = _buildAppLink('dish', item.dishesId);
        break;
      case '15':
        image = item.seriesImage;
        title = item.seriesName ?? item.description;
        link = _buildAppLink('series', item.seriesId);
        break;
      case '16':
        image = item.dishesImage;
        title = item.dishesName;
        link = _buildAppLink('dish', item.dishesId);
        break;
      case '17':
        image = item.imgUrl;
        title = item.title;
        link = item.linkUrl;
        break;
      case '18':
        image = item.topicPicture;
        title = item.title;
        link = item.link;
        break;
      case '22':
        image = item.seriesImage;
        title = item.seriesTitle ?? item.seriesName;
        link = _buildAppLink('series', item.seriesId);
        break;
      default:
        return null;
    }

    final trimmedImage = image?.trim();
    if (trimmedImage == null ||
        trimmedImage.isEmpty ||
        trimmedImage == 'null') return null;

    final hasTitle = title != null && title.isNotEmpty && title != 'null';
    final hasLink = link != null && link.isNotEmpty && link != 'null';

    final score = _calculateScore(
      moduleId: moduleId,
      hasImage: true,
      hasTitle: hasTitle,
      hasLink: hasLink,
      imageUrl: trimmedImage,
    );

    return _RecommendationCandidate(
      moduleId: moduleId,
      image: trimmedImage,
      title: hasTitle ? title : null,
      link: hasLink ? link : null,
      score: score,
    );
  }

  String? _buildAppLink(String type, String? id) {
    if (id == null || id.isEmpty || id == 'null') return null;
    return 'app://$type?id=$id';
  }

  double _calculateScore({
    required String moduleId,
    required bool hasImage,
    required bool hasTitle,
    required bool hasLink,
    required String imageUrl,
  }) {
    final weight = _moduleWeights[moduleId] ?? 0.5;
    double score = weight *
        (0.5 +
            (hasImage ? 0.30 : 0.0) +
            (hasTitle ? 0.10 : 0.0) +
            (hasLink ? 0.10 : 0.0));
    if (_hasGoodImageQuality(imageUrl)) score += 0.03;
    score += Random().nextDouble() * 0.06;
    return score;
  }

  bool _hasGoodImageQuality(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return false;
    }
    final lower = url.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.webp');
  }
}

class _RecommendationCandidate {
  final String moduleId;
  final String image;
  final String? title;
  final String? link;
  final double score;

  const _RecommendationCandidate({
    required this.moduleId,
    required this.image,
    this.title,
    this.link,
    required this.score,
  });
}
```

- [ ] **Step 2: 精简 HomeRepository**

从 `home_repository.dart` 删除 `_buildCrossModuleBanner`、`_extractCandidate`、`_buildAppLink`、`_calculateRecommendationScore`、`_hasGoodImageQuality`、`_hasValidBannerData`、`_buildLocalFallbackBanner` 及 `_RecommendationCandidate` 类。

注入 `BannerService`：

```dart
class HomeRepository extends BaseRepository {
  final BannerService bannerService;

  HomeRepository({
    required DioClient client,
    BannerService? bannerService,
  })  : bannerService = bannerService ?? BannerService(),
      super(client: client);

  Future<HomeBannerModel> fetchBannerData({...}) async {
    HomeBannerModel model = await _fetchBannerData(page: '4', ...);

    final recommended = bannerService.buildCrossModuleBanner(model);
    if (recommended != null) return recommended;

    if (bannerService.hasValidBannerData(model)) return model;

    // fallback page=1
    model = await _fetchBannerData(page: '1', ...);
    final recommended2 = bannerService.buildCrossModuleBanner(model);
    if (recommended2 != null) return recommended2;

    if (bannerService.hasValidBannerData(model)) return model;

    return bannerService.buildLocalFallbackBanner();
  }

  // _fetchBannerData, fetchHomeListData 保持不变，client.get 替代 DioClient.get
}
```

- [ ] **Step 3: 更新 AppBindings**

```dart
Get.lazyPut<BannerService>(() => BannerService());
```

- [ ] **Step 4: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/services/banner_service.dart lib/module/home/repository/home_repository.dart lib/bindings/app_bindings.dart
git commit -m "refactor: extract BannerService from HomeRepository"
```

---

### Task 2.2: 抽取 CookService 和 BookService

**Files:**
- Create: `lib/services/cook_service.dart`
- Create: `lib/services/book_service.dart`
- Modify: `lib/module/cook/controller/cook_home_controller.dart`
- Modify: `lib/module/cook/controller/cook_config_controller.dart`
- Modify: `lib/module/cook/controller/cook_steps_controller.dart`
- Modify: `lib/module/book/controller/book_controller.dart`
- Modify: `lib/bindings/app_bindings.dart`

- [ ] **Step 1: 创建 CookService**

**`lib/services/cook_service.dart`**：

```dart
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class CookService {
  final CookRepository repository;

  CookService({required this.repository});

  /// 获取做菜首页数据
  Future<List<CookHomeListModel>> fetchCookHomeData() async {
    try {
      return await repository.fetchCookHomeData();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'COOK_HOME_FAILED',
        originalException: e is Exception ? e : null,
      );
    }
  }

  /// 获取配菜数据
  Future<CookConfigModel> fetchCookConfigData(
    String dishesId, {
    String pushPage = 'home',
  }) async {
    try {
      return await repository.fetchCookConfigData(dishesId, pushPage: pushPage);
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'COOK_CONFIG_FAILED',
        originalException: e is Exception ? e : null,
      );
    }
  }

  /// 获取做菜步骤
  Future<CookStepsModel> fetchCookSteps(Map<String, dynamic> params) async {
    try {
      return await repository.fetchCookStepsData(params);
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'COOK_STEPS_FAILED',
      );
    }
  }
}
```

- [ ] **Step 2: 创建 BookService**

**`lib/services/book_service.dart`**：

```dart
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';

class BookService {
  final DioClient client;

  BookService({required this.client});

  Future<List<BookSceneModel>> fetchBookList({
    required int page,
    required int size,
  }) async {
    // 从 CookRepository 迁移菜谱列表逻辑
    // SceneInfo 接口：不支持分页，size: 200 一次拉全量
    try {
      final response = await client.get('', queryParameters: {
        'methodName': 'SceneInfo',
        'version': '4.3.2',
        'size': 200,
        'page': page,
      });

      if (response.data == null || response.data['data'] == null) {
        throw DataException(message: 'load_failed_try_again', code: 'EMPTY');
      }

      return (response.data['data'] as List)
          .map((e) => BookSceneModel.fromJson(e))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'BOOK_LIST_FAILED',
      );
    }
  }

  Future<List<BookDetailModel>> fetchBookDetail({
    required String sceneId,
  }) async {
    try {
      final response = await client.get('', queryParameters: {
        'methodName': 'SceneDetail',
        'version': '4.3.2',
        'scene_id': sceneId,
      });

      if (response.data == null || response.data['data'] == null) {
        throw DataException(message: 'load_failed_try_again', code: 'EMPTY');
      }

      return (response.data['data'] as List)
          .map((e) => BookDetailModel.fromJson(e))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'BOOK_DETAIL_FAILED',
      );
    }
  }
}
```

- [ ] **Step 3: 更新 Controller 使用 Service**

**`lib/module/cook/controller/cook_home_controller.dart`**：

```dart
class CookHomeController extends GetxController {
  final CookService service;

  CookHomeController({required this.service});

  // ... (其余保持不变，_repository 替换为 service)
}
```

同理更新 `cook_config_controller.dart`、`cook_steps_controller.dart`、`book_controller.dart`，注入对应 Service。

- [ ] **Step 4: 更新 AppBindings**

```dart
Get.lazyPut<CookService>(
    () => CookService(repository: Get.find<CookRepository>()));
Get.lazyPut<BookService>(
    () => BookService(client: Get.find<DioClient>()));

Get.lazyPut<CookHomeController>(
    () => CookHomeController(service: Get.find<CookService>()));
Get.lazyPut<CookConfigController>(
    () => CookConfigController(service: Get.find<CookService>()));
Get.lazyPut<CookStepsController>(
    () => CookStepsController(service: Get.find<CookService>()));
```

- [ ] **Step 5: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 6: Commit**

```bash
git add lib/services/ lib/module/cook/controller/ lib/module/book/controller/ lib/bindings/app_bindings.dart
git commit -m "refactor: extract CookService and BookService, wire through DI"
```

---

### Task 2.3: Controller 统一模式重构

**Files:**
- Modify: `lib/module/home/controller/home_controller.dart`
- Modify: `lib/module/cook/controller/cook_home_controller.dart`
- Modify: `lib/module/cook/controller/cook_config_controller.dart`
- Modify: `lib/module/cook/controller/cook_steps_controller.dart`
- Modify: `lib/module/book/controller/book_controller.dart`
- Modify: `lib/module/search/controller/search_controller.dart`
- Modify: `lib/module/mine/controller/favorites_controller.dart`
- Modify: `lib/module/setting/controller/setting_controller.dart`

- [ ] **Step 1: 定义 Controller 标准模板**

所有 Controller 遵循：

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

- [ ] **Step 2: 逐个重构 Controller**

以 `HomeController` 为例：

```dart
import 'package:get/get.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/module/home/repository/home_repository.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class HomeController extends GetxController {
  final HomeRepository repository;

  final Rx<HomeBannerModel?> bannerData = Rx<HomeBannerModel?>(null);
  final Rx<HomeDataModel?> listData = Rx<HomeDataModel?>(null);
  final RxBool isLoading = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();

  HomeController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    if (isLoading.value) return;
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final banner = await repository.fetchBannerData();
      final list = await repository.fetchHomeListData();

      bannerData.value = banner;
      listData.value = list;
    } on AppException catch (e) {
      errorMessage.value = e.message;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await _loadInitialData();
  }

  void retryLoadData() {
    _loadInitialData();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
```

- [ ] **Step 3: 更新页面中的 Controller 引用**

所有页面通过 `Get.find<XxxController>()` 获取，不再手动 `Get.put()`。

- [ ] **Step 4: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 5: Commit**

```bash
git add lib/module/home/controller/ lib/module/cook/controller/ lib/module/book/controller/ lib/module/search/controller/ lib/module/mine/controller/ lib/module/setting/controller/
git commit -m "refactor: standardize all controllers with service injection and unified error handling"
```

---

## Phase 3：代码规范化

### Task 3.1: 大文件拆分 — search_page.dart

**Files:**
- Create: `lib/module/search/views/search_bar_widget.dart`
- Create: `lib/module/search/views/search_results_widget.dart`
- Create: `lib/module/search/views/search_history_widget.dart`
- Modify: `lib/module/search/search_page.dart`

- [ ] **Step 1: 抽取 SearchBarWidget**

`search_page.dart` 中的搜索框部分 → `views/search_bar_widget.dart`：

```dart
import 'package:flutter/material.dart';

class SearchBarWidget extends StatelessWidget {
  final TextEditingController textController;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final VoidCallback onCancel;

  const SearchBarWidget({
    required this.textController,
    required this.focusNode,
    required this.onChanged,
    required this.onClear,
    required this.onCancel,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              focusNode: focusNode,
              onChanged: onChanged,
              decoration: InputDecoration(
                hintText: 'search_hint'.tr,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: textController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: onClear,
                      )
                    : null,
              ),
            ),
          ),
          TextButton(
            onPressed: onCancel,
            child: Text('cancel'.tr),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: 抽取 SearchResultsWidget**

搜索结果列表逻辑 → `views/search_results_widget.dart`

- [ ] **Step 3: 抽取 SearchHistoryWidget**

搜索历史逻辑 → `views/search_history_widget.dart`

- [ ] **Step 4: 精简 SearchPage**

`search_page.dart` 保留页面骨架，组合三个 Widget，目标 ≤250 行。

- [ ] **Step 5: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 6: Commit**

```bash
git add lib/module/search/
git commit -m "refactor: split search_page.dart (600→250 lines) into focused widgets"
```

---

### Task 3.2: 大文件拆分 — cook_steps_page.dart

**Files:**
- Create: `lib/module/cook/views/cook_step_item.dart`
- Modify: `lib/module/cook/cook_steps_page.dart`

- [ ] **Step 1: 抽取 CookStepItem**

做菜步骤中的单步组件 → `views/cook_step_item.dart`

- [ ] **Step 2: 精简 CookStepsPage**

`cook_steps_page.dart` 目标 ≤300 行。

- [ ] **Step 3: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 4: Commit**

```bash
git add lib/module/cook/
git commit -m "refactor: split cook_steps_page.dart (448→300 lines)"
```

---

### Task 3.3: 目录重组

**Files:**
- Create: `lib/core/` — 新增 network/ theme/ error/ storage/ language/ constants/ 子目录
- Move: `lib/utils/` → `lib/core/`（map: networking → network, theme → theme, error_handler → error, sqlite → storage, language → language, constants → constants, logger → logger, hud_loading → hud_loading）
- Move: `lib/base/widgets/` → `lib/widgets/`
- Move: `lib/base/` 其他 → `lib/widgets/`（empty_state_view, image_viewer, tabs, web）
- Modify: 全局更新所有 import 路径

- [ ] **Step 1: 创建新目录结构并移动文件**

```bash
mkdir -p lib/core/network lib/core/theme lib/core/error lib/core/storage lib/core/language lib/widgets lib/services lib/models lib/views lib/controllers

# 移动 core 文件
mv lib/utils/networking/networking.dart lib/core/network/dio_client.dart
mv lib/utils/theme.dart lib/core/theme/theme_manager.dart
mv lib/utils/error_handler.dart lib/core/error/app_exception.dart
mv lib/utils/logger.dart lib/core/logger.dart
mv lib/utils/sqlite/db_manager.dart lib/core/storage/db_manager.dart
mv lib/utils/language/language.dart lib/core/language/language.dart
mv lib/utils/language/manager.dart lib/core/language/manager.dart
mv lib/utils/toast.dart lib/core/toast_utils.dart
mv lib/utils/hud_loading.dart lib/core/hud_loading.dart

# 移动 widgets
mv lib/base/widgets/app_network_image.dart lib/widgets/
mv lib/base/widgets/app_dialog.dart lib/widgets/
mv lib/base/widgets/app_bottom_sheet.dart lib/widgets/
mv lib/base/empty_state_view.dart lib/widgets/
mv lib/base/image_viewer.dart lib/widgets/
mv lib/base/tabs.dart lib/widgets/
mv lib/base/web.dart lib/widgets/

# 移动 repository
mv lib/base/repository/base_repository.dart lib/repositories/
mv lib/module/home/repository/home_repository.dart lib/repositories/
mv lib/module/cook/repository/cook_repository.dart lib/repositories/

# 移动 controllers
mv lib/module/home/controller/home_controller.dart lib/controllers/
mv lib/module/cook/controller/cook_home_controller.dart lib/controllers/
mv lib/module/cook/controller/cook_config_controller.dart lib/controllers/
mv lib/module/cook/controller/cook_steps_controller.dart lib/controllers/
mv lib/module/book/controller/book_controller.dart lib/controllers/
mv lib/module/search/controller/search_controller.dart lib/controllers/
mv lib/module/mine/controller/favorites_controller.dart lib/controllers/
mv lib/module/setting/controller/setting_controller.dart lib/controllers/

# 移动 models（保留 .g.dart 配对）
mv lib/module/home/model/ lib/models/home/
mv lib/module/cook/model/ lib/models/cook/
mv lib/module/book/model/ lib/models/book/
mv lib/module/search/model/ lib/models/search/

# 移动 views（页面 + 子组件）
mv lib/module/home/ lib/views/home/
mv lib/module/cook/ lib/views/cook/
mv lib/module/book/ lib/views/book/
mv lib/module/search/ lib/views/search/
mv lib/module/player/ lib/views/player/
mv lib/module/mine/ lib/views/mine/
mv lib/module/setting/ lib/views/setting/

# 清理空目录
find lib/module -type d -empty -delete
find lib/base -type d -empty -delete
find lib/utils -type d -empty -delete
```

- [ ] **Step 2: 全局更新 import 路径**

使用 IDE 的全局替换功能或 `sed`。所有 import 从旧路径改为新路径（如 `package:flutter_cook/utils/networking/networking.dart` → `package:flutter_cook/core/network/dio_client.dart`）。

关键映射表：
| 旧 import | 新 import |
|-----------|----------|
| `utils/networking/networking.dart` | `core/network/dio_client.dart` |
| `utils/theme.dart` | `core/theme/theme_manager.dart` |
| `utils/error_handler.dart` | `core/error/app_exception.dart` |
| `base/repository/base_repository.dart` | `repositories/base_repository.dart` |
| `module/home/controller/home_controller.dart` | `controllers/home_controller.dart` |
| `module/home/model/...` | `models/home/...` |

- [ ] **Step 3: 更新 bindings 中 import**

修改 `lib/bindings/app_bindings.dart` 使用新路径。

- [ ] **Step 4: 更新 routers.dart 中 import**

修改 `lib/routers/routers.dart` 使用新路径。

- [ ] **Step 5: 验证编译**

Run: `flutter analyze`
Expected: No issues found (需要迭代修正遗漏的 import)。

- [ ] **Step 6: 验证 build_runner（models 移动后 .g.dart 可能受影响）**

Run: `flutter pub run build_runner build --delete-conflicting-outputs`
Expected: No errors.

- [ ] **Step 7: Commit**

```bash
git add -A lib/
git commit -m "refactor: reorganize directory structure — core/ widgets/ services/ repositories/ controllers/ models/ views/"
```

---

### Task 3.4: 模式一致性检查与修正

**Files:**
- Modify: 全局扫描需要修正的文件

- [ ] **Step 1: 检查并修复所有 `late` 变量**

Run: `grep -r "late " lib/ --include="*.dart" | grep -v ".g.dart"`
修正为声明时赋默认值或使用 `Rxn<T>()`。

- [ ] **Step 2: 检查并修复所有 `!` 强制解包**

Run: `grep -r "!" lib/ --include="*.dart" | grep -v ".g.dart" | grep -v "//" | grep -v "assert"`
将不安全的 `!` 替换为 `?.` 或 null check。

- [ ] **Step 3: 验证所有页面有三态处理**

确认每个数据列表页面都有 loading/empty/error 三态。使用 `EmptyState` 组件。

- [ ] **Step 4: 验证编译**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 5: Commit**

```bash
git add -A lib/
git commit -m "refactor: remove late/null-asserts, ensure consistent three-state UI pattern"
```

---

## Phase 4：测试体系

### Task 4.1: 配置测试框架

**Files:**
- Modify: `pubspec.yaml`
- Create: `test/helpers/test_helpers.dart`

- [ ] **Step 1: 添加 mocktail 依赖**

```bash
flutter pub add --dev mocktail
```

- [ ] **Step 2: 创建测试 Helpers**

**`test/helpers/test_helpers.dart`**：

```dart
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

/// 注册测试用依赖
void registerTestDependencies() {
  Get.testMode = true;
}

/// 清理测试依赖
void clearTestDependencies() {
  Get.reset();
}

/// 注册特定 mock 实例
T registerMock<T extends Object>(T mock) {
  Get.replace<T>(mock);
  return mock;
}
```

- [ ] **Step 3: 创建 Mock 类**

```dart
// test/helpers/mocks.dart
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cook/core/network/dio_client.dart';
import 'package:flutter_cook/services/cook_service.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/services/banner_service.dart';
import 'package:flutter_cook/repositories/home_repository.dart';
import 'package:flutter_cook/repositories/cook_repository.dart';

class MockDioClient extends Mock implements DioClient {}
class MockHomeRepository extends Mock implements HomeRepository {}
class MockCookRepository extends Mock implements CookRepository {}
class MockBannerService extends Mock implements BannerService {}
class MockCookService extends Mock implements CookService {}
class MockBookService extends Mock implements BookService {}
```

- [ ] **Step 4: Commit**

```bash
git add pubspec.yaml pubspec.lock test/helpers/
git commit -m "test: add mocktail framework and test helpers"
```

---

### Task 4.2: Controller 测试

**Files:**
- Create: `test/controllers/home_controller_test.dart`
- Create: `test/controllers/cook_home_controller_test.dart`

- [ ] **Step 1: HomeController 测试**

**`test/controllers/home_controller_test.dart`**：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cook/controllers/home_controller.dart';
import 'package:flutter_cook/repositories/home_repository.dart';
import 'package:flutter_cook/core/error/app_exception.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';

import '../helpers/mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  late MockHomeRepository mockRepo;
  late HomeController controller;

  setUp(() {
    registerTestDependencies();
    mockRepo = MockHomeRepository();
    controller = HomeController(repository: mockRepo);
  });

  tearDown(() {
    clearTestDependencies();
  });

  group('HomeController', () {
    test('initial state is loading', () {
      expect(controller.isLoading.value, true);
    });

    test('loads banner and list data on success', () async {
      final mockBanner = HomeBannerModel(data: null);
      final mockList = HomeDataModel(data: []);

      when(() => mockRepo.fetchBannerData()).thenAnswer((_) async => mockBanner);
      when(() => mockRepo.fetchHomeListData()).thenAnswer((_) async => mockList);

      await controller.refreshData();

      expect(controller.isLoading.value, false);
      expect(controller.bannerData.value, mockBanner);
      expect(controller.listData.value, mockList);
      expect(controller.errorMessage.value, isNull);
    });

    test('sets errorMessage on failure', () async {
      when(() => mockRepo.fetchBannerData())
          .thenThrow(NetworkException(message: 'test error', code: 'TEST'));

      await controller.refreshData();

      expect(controller.isLoading.value, false);
      expect(controller.errorMessage.value, isNotNull);
    });
  });
}
```

- [ ] **Step 2: CookHomeController 测试**

**`test/controllers/cook_home_controller_test.dart`**：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:flutter_cook/controllers/cook_home_controller.dart';
import 'package:flutter_cook/services/cook_service.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';

import '../helpers/mocks.dart';
import '../helpers/test_helpers.dart';

void main() {
  late MockCookService mockService;
  late CookHomeController controller;

  setUp(() {
    registerTestDependencies();
    mockService = MockCookService();
    controller = CookHomeController(service: mockService);
  });

  tearDown(() {
    clearTestDependencies();
  });

  group('CookHomeController', () {
    test('toggleFoodSelection enforces max 5 items', () {
      // setup: simulate list with 10 items
      final items = List.generate(10, (i) => CookListDataModel(
            id: '$i', text: 'item$i', image: '', isSelected: false.obs,
          ));

      // select 5
      for (int i = 0; i < 5; i++) {
        final result = controller.toggleFoodSelection(items[i]);
        expect(result, true);
      }

      // 6th should fail
      final result = controller.toggleFoodSelection(items[5]);
      expect(result, false);
      expect(controller.selectedCookList.length, 5);
    });

    test('toggleFoodSelection toggles selection', () {
      final item = CookListDataModel(
        id: '1', text: 'test', image: '', isSelected: false.obs,
      );

      // select
      final result1 = controller.toggleFoodSelection(item);
      expect(result1, true);
      expect(item.isSelected.value, true);

      // deselect
      final result2 = controller.toggleFoodSelection(item);
      expect(result2, true);
      expect(item.isSelected.value, false);
    });
  });
}
```

- [ ] **Step 3: 运行测试**

Run: `flutter test`
Expected: All tests pass.

- [ ] **Step 4: Commit**

```bash
git add test/controllers/
git commit -m "test: add HomeController and CookHomeController unit tests"
```

---

### Task 4.3: Repository 测试

**Files:**
- Create: `test/repositories/home_repository_test.dart`

- [ ] **Step 1: HomeRepository 测试**

**`test/repositories/home_repository_test.dart`**：

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_cook/repositories/home_repository.dart';
import 'package:flutter_cook/core/network/dio_client.dart';
import 'package:flutter_cook/services/banner_service.dart';
import 'package:flutter_cook/utils/error_handler.dart';

import '../helpers/mocks.dart';

void main() {
  late MockDioClient mockClient;
  late MockBannerService mockBannerService;
  late HomeRepository repository;

  setUp(() {
    mockClient = MockDioClient();
    mockBannerService = MockBannerService();
    repository = HomeRepository(
      client: mockClient,
      bannerService: mockBannerService,
    );
  });

  group('fetchBannerData', () {
    test('returns banner from cross-module recommendation', () async {
      final rawData = {
        'data': {
          'module_list': [],
        },
      };

      when(() => mockClient.get<Map<String, dynamic>>(
            '',
            queryParameters: any(named: 'queryParameters'),
          )).thenAnswer((_) async => Response(
            data: rawData,
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final mockBanner = HomeBannerModel(data: HomeBannerData(moduleList: []));
      when(() => mockBannerService.buildCrossModuleBanner(any()))
          .thenReturn(mockBanner);

      final result = await repository.fetchBannerData();

      expect(result, mockBanner);
    });

    test('throws NetworkException on Dio error', () async {
      when(() => mockClient.get<Map<String, dynamic>>(
            '',
            queryParameters: any(named: 'queryParameters'),
          )).thenThrow(
        NetworkException(message: 'no connection', code: 'CONNECTION_ERROR'),
      );

      expect(
        () => repository.fetchBannerData(),
        throwsA(isA<NetworkException>()),
      );
    });
  });
}
```

- [ ] **Step 2: 运行测试**

Run: `flutter test test/repositories/`
Expected: All tests pass.

- [ ] **Step 3: Commit**

```bash
git add test/repositories/
git commit -m "test: add HomeRepository unit tests"
```

---

### Task 4.4: Service 测试

**Files:**
- Create: `test/services/banner_service_test.dart`

- [ ] **Step 1: BannerService 测试**

**`test/services/banner_service_test.dart`**：

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_cook/services/banner_service.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';

void main() {
  group('BannerService', () {
    late BannerService service;

    setUp(() {
      service = BannerService();
    });

    test('buildCrossModuleBanner returns null for empty model', () {
      final model = HomeBannerModel(data: null);
      expect(service.buildCrossModuleBanner(model), isNull);
    });

    test('hasValidBannerData returns false for empty modules', () {
      final model = HomeBannerModel(
        data: HomeBannerData(moduleList: []),
      );
      expect(service.hasValidBannerData(model), false);
    });

    test('buildLocalFallbackBanner returns placeholder banner', () {
      final banner = service.buildLocalFallbackBanner();
      final modules = banner.data?.moduleList;
      expect(modules, isNotNull);
      expect(modules!.length, 1);
      expect(modules.first.moduleData?.length, 2);
    });
  });
}
```

- [ ] **Step 2: 运行全部测试**

Run: `flutter test`
Expected: All tests pass. Total ≥ 10 tests.

- [ ] **Step 3: 最终验证**

Run: `flutter analyze`
Expected: No issues found.

- [ ] **Step 4: Commit**

```bash
git add test/services/
git commit -m "test: add BannerService unit tests"
```

---

## 验收清单

- [ ] `flutter analyze` — No issues found
- [ ] `flutter test` — All tests pass (≥ 10 tests)
- [ ] App 启动正常，首页 Banner 加载
- [ ] 做菜流程：食材选择 → 配菜 → 步骤正常
- [ ] 菜谱浏览：场景列表 → 详情 → 做菜正常
- [ ] 搜索：关键字搜索 + 历史记录正常
- [ ] 收藏：添加/删除正常
- [ ] 设置：主题切换（亮/暗）正常
- [ ] 视频播放：不卡死
- [ ] 图片浏览：缩放正常
