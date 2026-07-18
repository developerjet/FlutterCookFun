/// 项目全局常量管理文件
///
/// 用途：集中管理 API 配置、UI 常数、业务常数等
/// 避免硬编码，提高代码可维护性

// ============================================================
// API 配置常量
// ============================================================
abstract class ApiConstants {
  /// API 基础地址
  static const String baseUrl = 'http://api.izhangchu.com';

  /// 网络请求超时时间（毫秒）
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  /// API 端点
  static const String foodListEndpoint = '/food/list';
  static const String cookStepsEndpoint = '/cook/steps';
  static const String bookDetailEndpoint = '/book/detail';
  static const String searchEndpoint = '/search';
}

// ============================================================
// 本地存储 Key 常量
// ============================================================
abstract class StorageKeys {
  /// SharedPreferences 键名
  static const String searchHistory = 'search_history';
  static const String userPreferences = 'user_preferences';
  static const String appTheme = 'app_theme';
  static const String language = 'language';
  static const String favoritesList = 'favorites_list';
}

// ============================================================
// 路由名称常量
// ============================================================
abstract class RouteNames {
  static const String home = '/';
  static const String foodClass = '/foodClass';
  static const String cookSteps = '/cookSteps';
  static const String cookConfig = '/cookConfig';
  static const String bookDetail = '/bookDetail';
  static const String playerVideo = '/player';
  static const String setting = '/setting';
  static const String themeSetting = '/setting/theme';
  static const String languageSetting = '/setting/language';
  static const String favorites = '/favorite';
  static const String search = '/search';
  static const String web = '/webPage';
  static const String imageViewer = '/imageViewer';
}

// ============================================================
// UI 相关常量
// ============================================================
abstract class UiConstants {
  /// 间距/间隔常数
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;

  /// 最小触摸区域
  static const double minTouchSize = 48.0;

  /// 加载动画延迟
  static const Duration loadingDelay = Duration(milliseconds: 300);
}

// ============================================================
// 业务相关常量
// ============================================================
abstract class BusinessConstants {
  /// 每页数据数量
  static const int pageSize = 20;

  /// 搜索最多保存历史记录数
  static const int maxSearchHistory = 20;

  /// 轮播图默认间隔时间（毫秒）
  static const int carouselInterval = 5000;

  /// 视频播放缓冲时间（毫秒）
  static const int videoBufferTime = 3000;
}

// ============================================================
// 调试相关常量
// ============================================================
abstract class DebugConstants {
  /// 是否启用网络请求日志
  static const bool enableNetworkLog = true;

  /// 是否启用本地数据库日志
  static const bool enableDatabaseLog = true;

  /// 是否启用页面生命周期日志
  static const bool enableLifecycleLog = false;
}
