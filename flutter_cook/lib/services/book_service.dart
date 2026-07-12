import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';

/// 菜谱模块业务服务层
class BookService {
  final DioClient client;

  BookService({required this.client});

  Future<List<BookListModel>> fetchBookList({required int page}) async {
    try {
      final response = await client.get('', queryParameters: {
        'methodName': 'SceneList',
        'version': '4.3.2',
        'page': page,
        'size': BusinessConstants.pageSize.toString(),
      });

      final jsonData = response.data['data'] as Map<String, dynamic>?;
      final rawList = jsonData?['data'] as List<dynamic>? ?? [];
      return rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => BookListModel.fromJson(e))
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'BOOK_LIST_FAILED',
        originalException: e is Exception ? e : null,
      );
    }
  }

  Future<BookDetailModel> fetchBookDetail(int sceneId, {int? page}) async {
    try {
      final response = await client.get('', queryParameters: {
        'methodName': 'SceneInfo',
        'version': '4.3.2',
        'scene_id': sceneId,
        'page': page ?? 1,
        'size': '200',
      });

      return BookDetailModel.fromJson(response.data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw DataException(
        message: 'load_failed_try_again',
        code: 'BOOK_DETAIL_FAILED',
        originalException: e is Exception ? e : null,
      );
    }
  }
}
