import 'package:get/get.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class BookController extends GetxController {
  // 书籍列表数据
  final bookList = <BookListModel>[].obs;
  final pageIndex = 1.obs;

  // 书籍详情数据
  final bookDetail = Rx<BookDetailModel?>(null);
  final bookDetailList = <BookDishesListModel>[].obs;
  final detailPageIndex = 1.obs;

  // 加载状态
  final isLoading = false.obs;
  final isDetailLoading = false.obs;

  // 错误信息
  final errorMessage = Rx<String?>(null);
  final detailErrorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadBookList(refresh: true);
  }

  /// 加载书籍列表
  Future<bool> loadBookList({int? page, bool refresh = false}) async {
    final requestPage = refresh ? 1 : (page ?? pageIndex.value);
    if (refresh) {
      bookList.clear();
      errorMessage.value = null;
    }

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await DioClient.get('', queryParameters: {
        'methodName': 'SceneList',
        'version': '4.3.2',
        'page': requestPage,
        'size': BusinessConstants.pageSize.toString(),
      });

      final jsonData = response.data['data'] as Map<String, dynamic>?;
      final rawList = jsonData?['data'] as List<dynamic>? ?? [];
      final items = rawList
          .map((item) => BookListModel.fromJson(item as Map<String, dynamic>))
          .toList();

      if (refresh) {
        bookList.assignAll(items);
      } else {
        bookList.addAll(items);
      }

      pageIndex.value = requestPage;
      AppLogger.info('BookController', 'Book list loaded successfully');
      return true;
    } catch (e) {
      errorMessage.value = 'load_book_list_failed'.tr;
      AppLogger.error(
        'BookController',
        'Failed to load book list',
        e is Exception ? e : null,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载书籍详情
  Future<bool> loadBookDetail(int sceneId, {int? page, bool refresh = false}) async {
    final requestPage = refresh ? 1 : (page ?? detailPageIndex.value);
    if (refresh) {
      bookDetail.value = null;
      bookDetailList.clear();
      detailErrorMessage.value = null;
    }

    try {
      isDetailLoading.value = true;
      detailErrorMessage.value = null;

      final response = await DioClient.get('', queryParameters: {
        'methodName': 'SceneInfo',
        'version': '4.3.2',
        'scene_id': sceneId,
        'page': requestPage,
        'size': BusinessConstants.pageSize.toString(),
      });

      final model = BookDetailModel.fromJson(response.data);
      bookDetail.value = model;

      final dishes = model.data?.dishesList ?? [];
      if (refresh) {
        bookDetailList.assignAll(dishes);
      } else {
        bookDetailList.addAll(dishes);
      }

      detailPageIndex.value = requestPage;
      AppLogger.info('BookController', 'Book details loaded successfully');
      return true;
    } catch (e) {
      detailErrorMessage.value = 'load_book_detail_failed'.tr;
      AppLogger.error(
        'BookController',
        'Failed to load book details',
        e is Exception ? e : null,
      );
      return false;
    } finally {
      isDetailLoading.value = false;
    }
  }

  /// 刷新数据
  Future<void> refreshData() async {
    await loadBookList(refresh: true);
  }

  /// 清空错误信息
  void clearError() {
    errorMessage.value = null;
    detailErrorMessage.value = null;
  }
}
