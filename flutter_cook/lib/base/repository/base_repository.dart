import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:get/get.dart';

/// Repository 基类
///
/// 子类通过构造函数注入 DioClient：
///   class FooRepository extends BaseRepository {
///     FooRepository({required DioClient client}) : super(client: client);
///   }
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
