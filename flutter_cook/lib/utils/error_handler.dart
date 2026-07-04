/// 全局错误分类体系
///
/// 异常层次：
///   AppException (基类)
///   ├─ NetworkException   — 网络/连接错误（可重试）
///   ├─ DataException      — 数据解析/格式错误
///   └─ BusinessException  — 业务逻辑错误
///
/// 向后兼容：`import 'error_handler.dart'` 仍可获得 AppLogger。

export 'logger.dart';

import 'package:get/get.dart';

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

/// 网络请求异常（可重试类错误）
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
