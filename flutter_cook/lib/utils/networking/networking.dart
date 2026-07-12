import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response;
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/error_handler.dart';

/// Dio 网络客户端
///
/// 通过 GetX DI 注册：Get.lazyPut<DioClient>(() => DioClient(), fenix: true)
/// 注入到 Repository 构造函数中使用。
class DioClient {
  final Dio dio;
  static const String _tag = 'DioClient';

  DioClient({Dio? dio}) : dio = dio ?? _createDefaultDio();

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
