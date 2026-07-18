import 'dart:math' as math;

import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/networking/networking.dart';

/// 菜谱模块业务服务层
class BookService {
  static const int _maxConcurrentDetailRequests = 4;

  final DioClient client;

  BookService({required this.client});

  Future<BookListPage> fetchBookList({required int page}) async {
    try {
      final response = await client.get('', queryParameters: {
        'methodName': 'SceneList',
        'version': '4.3.2',
        'page': page,
        'size': BusinessConstants.pageSize.toString(),
      });

      final responseData = response.data;
      if (responseData is! Map<String, dynamic>) {
        throw const FormatException('菜谱列表响应不是有效对象');
      }
      final jsonData = responseData['data'] as Map<String, dynamic>?;
      if (jsonData == null) {
        throw const FormatException('菜谱列表响应缺少 data');
      }
      final rawList = jsonData['data'] as List<dynamic>? ?? [];
      final items = rawList
          .whereType<Map<String, dynamic>>()
          .map((e) => BookListModel.fromJson(e))
          .toList();
      final responsePage = _readPositiveInt(jsonData['page'], fallback: page);
      final pageSize = _readPositiveInt(
        jsonData['size'],
        fallback: BusinessConstants.pageSize,
      );
      final totalCount = _readNonNegativeInt(
        jsonData['total'],
        fallback: items.length,
      );

      return BookListPage(
        items: items,
        page: responsePage,
        pageSize: pageSize,
        totalCount: totalCount,
      );
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

  int _readPositiveInt(Object? value, {required int fallback}) {
    final parsed = value is num ? value.toInt() : int.tryParse('$value');
    return parsed != null && parsed > 0 ? parsed : fallback;
  }

  int _readNonNegativeInt(Object? value, {required int fallback}) {
    final parsed = value is num ? value.toInt() : int.tryParse('$value');
    return parsed != null && parsed >= 0 ? parsed : fallback;
  }

  /// 获取专题元数据并加载接口可访问的全部菜谱分页。
  ///
  /// 参数：
  /// - [sceneId]: 有效的专题 ID。
  /// - [page]: 兼容旧调用签名，完整加载始终从第 1 页开始。
  ///
  /// 返回：合并专题元数据并完成跨页去重的菜谱详情。
  ///
  /// 抛出：接口响应非法或任一分页请求失败时抛出 [DataException]。
  Future<BookDetailModel> fetchBookDetail(int sceneId, {int? page}) async {
    try {
      final metadataFuture = client.get('', queryParameters: {
        'methodName': 'SceneInfo',
        'version': '4.3.2',
        'scene_id': sceneId,
        'page': 1,
        'size': BusinessConstants.pageSize.toString(),
      });
      final firstPageFuture = _fetchSceneDishesPage(sceneId, 1);

      final metadataResponse = await metadataFuture;
      final metadata = BookDetailModel.fromJson(metadataResponse.data);
      final firstPage = await firstPageFuture;
      final pages = <_SceneDishesPage>[firstPage];
      final totalPages = firstPage.totalCount == 0
          ? 1
          : (firstPage.totalCount / firstPage.pageSize).ceil();

      for (var startPage = 2;
          startPage <= totalPages;
          startPage += _maxConcurrentDetailRequests) {
        final endPage = math.min(
          totalPages,
          startPage + _maxConcurrentDetailRequests - 1,
        );
        final batch = await Future.wait([
          for (var requestPage = startPage;
              requestPage <= endPage;
              requestPage += 1)
            _fetchSceneDishesPage(sceneId, requestPage),
        ]);
        pages.addAll(batch);
      }

      pages.sort((left, right) => left.page.compareTo(right.page));
      final dishes = _deduplicateDishes(pages);

      return _replaceDishes(metadata, dishes);
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

  Future<_SceneDishesPage> _fetchSceneDishesPage(
    int sceneId,
    int page,
  ) async {
    final response = await client.get('', queryParameters: {
      'methodName': 'SceneDishes',
      'version': '4.2',
      'scene_id': sceneId,
      'page': page,
      'size': BusinessConstants.pageSize.toString(),
    });
    final responseData = response.data;
    if (responseData is! Map<String, dynamic>) {
      throw const FormatException('专题菜谱响应不是有效对象');
    }
    final data = responseData['data'];
    if (data is! Map<String, dynamic>) {
      throw const FormatException('专题菜谱响应缺少 data');
    }
    final rawItems = data['data'];
    if (rawItems is! List<dynamic>) {
      throw const FormatException('专题菜谱响应缺少列表数据');
    }

    return _SceneDishesPage(
      page: _readPositiveInt(data['page'], fallback: page),
      pageSize: _readPositiveInt(
        data['size'],
        fallback: BusinessConstants.pageSize,
      ),
      totalCount: _readNonNegativeInt(
        data['total'],
        fallback: rawItems.length,
      ),
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(BookDishesListModel.fromJson)
          .toList(growable: false),
    );
  }

  List<BookDishesListModel> _deduplicateDishes(
    List<_SceneDishesPage> pages,
  ) {
    final dishes = <BookDishesListModel>[];
    final seenIds = <int>{};

    for (final page in pages) {
      for (final dish in page.items) {
        final dishId = dish.dishesId;
        if (dishId != null && !seenIds.add(dishId)) {
          continue;
        }
        dishes.add(dish);
      }
    }
    return List.unmodifiable(dishes);
  }

  BookDetailModel _replaceDishes(
    BookDetailModel metadata,
    List<BookDishesListModel> dishes,
  ) {
    final data = metadata.data;
    if (data == null) {
      throw const FormatException('专题详情响应缺少 data');
    }

    return BookDetailModel(
      code: metadata.code,
      msg: metadata.msg,
      version: metadata.version,
      timestamp: metadata.timestamp,
      data: BookMoreData(
        dishCount: data.dishCount,
        isNew: data.isNew,
        sceneBackground: data.sceneBackground,
        sceneDesc: data.sceneDesc,
        sceneId: data.sceneId,
        sceneTitle: data.sceneTitle,
        sceneType: data.sceneType,
        thumbnail: data.thumbnail,
        dishesList: dishes,
        shareUrl: data.shareUrl,
        relates: data.relates,
      ),
    );
  }
}

class _SceneDishesPage {
  final int page;
  final int pageSize;
  final int totalCount;
  final List<BookDishesListModel> items;

  const _SceneDishesPage({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.items,
  });
}
