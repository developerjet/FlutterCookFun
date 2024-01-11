import 'package:dio/dio.dart';

class DioClient {
  static Dio? _dio;

  static Dio get dio {
    if (_dio == null) {
      BaseOptions options = BaseOptions(
        baseUrl: 'http://api.izhangchu.com', // 设置请求的基础URL
        connectTimeout: Duration(seconds: 10), // 连接超时时间，单位是毫秒
        receiveTimeout: Duration(seconds: 10), // 接收超时时间，单位是毫秒
      );
      
      _dio = Dio(options);

      // 添加拦截器
      _dio!.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) {
          // 在请求被发送之前做一些事情
          return handler.next(options); // 必须调用 next 方法
        },
        onResponse: (response, handler) {
          // 在响应被接收之前做一些事情
          return handler.next(response); // 必须调用 next 方法
        },
        onError: (DioError e, handler) {
          // 在错误响应被接收之前做一些事情
          return handler.next(e); // 必须调用 next 方法
        },
      ));
    }
    return _dio!;
  }

  static Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) async {
    try {
      final response = await dio.get(path, queryParameters: queryParameters);
      return response;
    } catch (error) {
      throw _handleError(error);
    }
  }

  static Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await dio.post(path, data: data);
      return response;
    } catch (error) {
      throw _handleError(error);
    }
  }

  // 添加其他 HTTP 方法的封装，如 put、delete 等

  static DioError _handleError(dynamic error) {
    if (error is DioError) {
      // 处理 Dio 错误
      print('Dio error: $error');
    } else {
      // 处理其他类型的错误
      print('Error: $error');
    }
    return error;
  }
}
