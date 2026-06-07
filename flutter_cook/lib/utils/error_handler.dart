/// 全局错误处理和日志系统
/// 
/// 功能：
/// 1. 统一的错误分类和处理
/// 2. 网络请求错误捕捉
/// 3. 日志记录和上报

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter_cook/utils/constants.dart';

/// 应用异常基类
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final Exception? originalException;

  AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => message;
}

/// 网络请求异常
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );

  factory NetworkException.fromDioException(dynamic error) {
    if (error.toString().contains('Connection')) {
      return NetworkException(
        message: 'network_connection_failed'.tr,
        code: 'NO_CONNECTION',
        originalException: error,
      );
    } else if (error.toString().contains('TimeOut')) {
      return NetworkException(
        message: 'request_timeout'.tr,
        code: 'TIMEOUT',
        originalException: error,
      );
    } else {
      return NetworkException(
        message: 'network_request_error'.trArgs([error.toString()]),
        code: 'NETWORK_ERROR',
        originalException: error,
      );
    }
  }
}

/// 本地数据异常
class DataException extends AppException {
  DataException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );
}

/// 业务逻辑异常
class BusinessException extends AppException {
  BusinessException({
    required String message,
    String? code,
    Exception? originalException,
  }) : super(
    message: message,
    code: code,
    originalException: originalException,
  );
}

/// 全局日志管理器
class AppLogger {
  // 私有构造函数 - 单例模式
  AppLogger._();

  // 单例实例
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
      // 在 Release 模式可以上报到远程
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
    // 在 Release 模式上报到远程
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

  /// 上报错误到远程服务（可实现 Sentry、Firebase 等）
  static void _reportToRemote(
    String tag,
    String message,
    String level, [
    Exception? exception,
  ]) {
    // TODO: 集成实际的远程服务，如 Sentry
    // 示例：
    // Sentry.captureException(exception, withScope: (scope) {
    //   scope.setTag('tag', tag);
    //   scope.setTag('level', level);
    // });
  }
}
