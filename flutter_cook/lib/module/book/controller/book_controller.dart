import 'package:get/get.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class BookController extends GetxController {
  final BookService service;

  final RxList<BookListModel> bookList = <BookListModel>[].obs;
  final RxInt totalCount = 0.obs;
  final RxInt pageIndex = 1.obs;
  final RxBool bookHasMore = true.obs;

  final RxBool isLoading = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();

  BookController({required this.service});

  @override
  void onInit() {
    super.onInit();
    // BookPage 首屏依赖控制器初始化触发加载，避免进入页面后停留在空态。
    loadBookList(page: 1);
  }

  Future<bool> loadBookList({int? page}) async {
    final requestPage = page ?? 1;
    if (requestPage > 1 && !bookHasMore.value) return false;

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final result = await service.fetchBookList(page: requestPage);
      final items = result.items;
      totalCount.value = result.totalCount;
      bookHasMore.value = result.hasMore;

      if (requestPage == 1) {
        bookList.assignAll(items);
        pageIndex.value = 1;
      } else {
        bookList.addAll(items);
        pageIndex.value = requestPage;
      }

      AppLogger.info('BookController',
          'Loaded books: page $requestPage, ${items.length} items');
      return true;
    } catch (e) {
      errorMessage.value =
          e is AppException ? e.message : 'load_failed_try_again'.tr;
      AppLogger.error('BookController', 'Failed to load book list',
          e is Exception ? e : null);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = null;
  }
}
