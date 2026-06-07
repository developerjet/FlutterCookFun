import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/error_handler.dart';

/// Dio 网络客户端 - 单例模式
/// 
/// 功能：
/// 1. 集中管理所有 HTTP 请求
/// 2. 统一的拦截器配置
/// 3. 错误处理和日志记录
class DioClient {
  static Dio? _dio;
  static const String _tag = 'DioClient';

  static Dio get dio {
    if (_dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: ApiConstants.baseUrl,
        connectTimeout: const Duration(milliseconds: ApiConstants.connectTimeout),
        receiveTimeout: const Duration(milliseconds: ApiConstants.receiveTimeout),
      );

      _dio = Dio(options);

      // 添加统一的拦截器
      _dio!.interceptors.add(_LoggingInterceptor());
    }
    return _dio!;
  }

  /// GET 请求
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      AppLogger.logNetworkRequest(path, 'GET', queryParameters);
      final response = await dio.get(path, queryParameters: queryParameters);
      AppLogger.logNetworkResponse(path, response.statusCode, response.data);
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      _handleDioError(e, 'GET', path);
      rethrow;
    } catch (e) {
      AppLogger.error(_tag, 'Unknown error: $path', e as Exception?);
      rethrow;
    }
  }

  /// POST 请求
  static Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      AppLogger.logNetworkRequest(path, 'POST', data);
      final response = await dio.post(path, data: data);
      AppLogger.logNetworkResponse(path, response.statusCode, response.data);
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      _handleDioError(e, 'POST', path);
      rethrow;
    } catch (e) {
      AppLogger.error(_tag, 'Unknown error: $path', e as Exception?);
      rethrow;
    }
  }

  /// PUT 请求
  static Future<Response> put(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      AppLogger.logNetworkRequest(path, 'PUT', data);
      final response = await dio.put(path, data: data);
      AppLogger.logNetworkResponse(path, response.statusCode, response.data);
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      _handleDioError(e, 'PUT', path);
      rethrow;
    } catch (e) {
      AppLogger.error(_tag, 'Unknown error: $path', e as Exception?);
      rethrow;
    }
  }

  /// DELETE 请求
  static Future<Response> delete(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      AppLogger.logNetworkRequest(path, 'DELETE', queryParameters);
      final response = await dio.delete(path, queryParameters: queryParameters);
      AppLogger.logNetworkResponse(path, response.statusCode, response.data);
      _validateResponse(response);
      return response;
    } on DioException catch (e) {
      _handleDioError(e, 'DELETE', path);
      rethrow;
    } catch (e) {
      AppLogger.error(_tag, 'Unknown error: $path', e as Exception?);
      rethrow;
    }
  }

  /// 验证响应状态码
  static void _validateResponse(Response response) {
    final statusCode = response.statusCode;
    if (statusCode != null && statusCode >= 400) {
      throw NetworkException(
        message: 'server_error'.trArgs([statusCode.toString()]),
        code: statusCode.toString(),
      );
    }
  }

  /// 统一处理 Dio 错误
  static void _handleDioError(DioException e, String method, String path) {
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
      e as Exception?,
    );
  }

  /// 根据 HTTP 状态码获取错误信息
  static String _getHttpErrorMessage(int? statusCode) {
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
