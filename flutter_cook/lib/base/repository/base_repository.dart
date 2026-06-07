/// 网络请求 Repository 基类
/// 
/// 职责：
/// 1. 集中管理所有网络请求
/// 2. 统一的错误处理和重试逻辑
/// 3. 数据转换和验证
/// 4. 缓存和离线支持

import 'package:flutter_cook/utils/error_handler.dart';
import 'package:get/get.dart';

/// Repository 基类
abstract class BaseRepository {
  /// 执行网络请求的通用方法（带重试机制）
  Future<T> execute<T>(
    Future<T> Function() request, {
    int maxRetries = 2,
    bool showErrorUI = true,
  }) async {
    int retryCount = 0;

    while (true) {
      try {
        return await request();
      } catch (e) {
        retryCount++;

        // 判断是否应该重试
        bool shouldRetry = _shouldRetry(e, retryCount, maxRetries);

        if (shouldRetry) {
          // 指数退避重试延迟 (1s, 2s, 4s...)
          await Future.delayed(
            Duration(seconds: (1 << retryCount).clamp(1, 8)),
          );
          continue;
        }

        // 无法重试，抛出异常
        if (e is AppException) {
          rethrow;
        } else {
          throw _handleUnknownException(e);
        }
      }
    }
  }

  /// 判断是否应该重试
  bool _shouldRetry(dynamic exception, int retryCount, int maxRetries) {
    // 如果已达到最大重试次数，不再重试
    if (retryCount > maxRetries) {
      return false;
    }

    // 网络异常才重试，业务异常不重试
    if (exception is NetworkException) {
      final code = exception.code;
      // 只重试网络连接类错误，不重试 HTTP 4xx 和 5xx
      return code != null &&
          (code.contains('TIMEOUT') ||
              code.contains('CONNECTION') ||
              code.contains('NETWORK'));
    }

    return false;
  }

  /// 处理未知异常
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
