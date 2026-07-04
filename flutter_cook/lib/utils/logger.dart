/// 全局日志管理器
///
/// 功能：
/// 1. 统一日志输出（debug / info / warning / error）
/// 2. 网络请求/响应日志
/// 3. 页面生命周期日志
/// 4. Release 模式远程上报（预留）
///
/// 使用：`AppLogger.info('tag', 'message')`

import 'package:flutter/foundation.dart';
import 'package:flutter_cook/utils/constants.dart';

class AppLogger {
  AppLogger._();

  static final AppLogger _instance = AppLogger._();
  factory AppLogger() => _instance;

  /// 调试日志（仅在 Debug 模式输出）
  static void debug(String tag, String message) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toString().split('.')[0];
      print('[$timestamp] 🐛 [$tag] $message');
    }
  }

  /// 信息日志
  static void info(String tag, String message) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toString().split('.')[0];
      print('[$timestamp] ℹ️  [$tag] $message');
    }
  }

  /// 警告日志
  static void warning(String tag, String message) {
    final timestamp = DateTime.now().toString().split('.')[0];
    if (kDebugMode) {
      print('[$timestamp] ⚠️  [$tag] $message');
    } else {
      _reportToRemote(tag, message, 'WARNING');
    }
  }

  /// 错误日志
  static void error(String tag, String message, [Exception? exception]) {
    if (kDebugMode) {
      final timestamp = DateTime.now().toString().split('.')[0];
      debugPrint('[$timestamp] ❌ [$tag] $message');
      if (exception != null) {
        debugPrint('Exception: $exception');
      }
    }
    if (!kDebugMode) {
      _reportToRemote(tag, message, 'ERROR', exception);
    }
  }

  /// 网络请求日志
  static void logNetworkRequest(String url, String method, dynamic data) {
    if (DebugConstants.enableNetworkLog) {
      debug('Network', '📤 [$method] $url\nRequest body: $data');
    }
  }

  /// 网络响应日志
  static void logNetworkResponse(String url, int? statusCode, dynamic data) {
    if (DebugConstants.enableNetworkLog) {
      debug('Network', '📥 [$statusCode] $url\nResponse body: $data');
    }
  }

  /// 页面生命周期日志
  static void logPageLifecycle(String pageName, String lifecycle) {
    if (DebugConstants.enableLifecycleLog) {
      debug('PageLifecycle', '$pageName -> $lifecycle');
    }
  }

  /// 上报错误到远程服务（预留 Sentry / Firebase 等）
  static void _reportToRemote(
    String tag,
    String message,
    String level, [
    Exception? exception,
  ]) {
    // TODO: 集成远程服务
  }
}
