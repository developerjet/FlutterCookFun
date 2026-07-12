import 'package:get/get.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class BookController extends GetxController {
  final BookService service;

  final RxList<BookListModel> bookList = <BookListModel>[].obs;
  final RxInt pageIndex = 1.obs;
  final RxBool bookHasMore = true.obs;

  final Rx<BookDetailModel?> bookDetail = Rx<BookDetailModel?>(null);
  final RxList<BookDishesListModel> bookDetailList = <BookDishesListModel>[].obs;
  final RxInt detailPageIndex = 1.obs;
  final RxBool detailHasMore = true.obs;

  final RxBool isLoading = false.obs;
  final RxBool isDetailLoading = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();
  final Rxn<String> detailErrorMessage = Rxn<String>();

  BookController({required this.service});

  Future<bool> loadBookList({int? page}) async {
    final requestPage = page ?? 1;
    if (requestPage > 1 && !bookHasMore.value) return false;

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final items = await service.fetchBookList(page: requestPage);
      final hasMore = items.length >= BusinessConstants.pageSize;
      bookHasMore.value = hasMore;

      if (requestPage == 1) {
        bookList.assignAll(items);
        pageIndex.value = 1;
      } else {
        bookList.addAll(items);
        pageIndex.value = requestPage;
      }

      AppLogger.info('BookController', 'Loaded books: page $requestPage, ${items.length} items');
      return true;
    } catch (e) {
      errorMessage.value =
          e is AppException ? e.message : 'load_failed_try_again'.tr;
      AppLogger.error('BookController', 'Failed to load book list', e is Exception ? e : null);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loadBookDetail(int sceneId, {int? page}) async {
    final requestPage = page ?? 1;
    if (requestPage > 1 && !detailHasMore.value) return false;

    if (sceneId <= 0) {
      detailErrorMessage.value = 'Invalid scene ID';
      return false;
    }

    try {
      isDetailLoading.value = true;
      detailErrorMessage.value = null;

      final model = await service.fetchBookDetail(sceneId, page: requestPage);
      bookDetail.value = model;

      final newItems = model.data?.dishesList ?? [];
      // SceneInfo 不支持分页
      final hasMore = false;
      detailHasMore.value = hasMore;

      if (requestPage == 1) {
        bookDetailList.assignAll(newItems);
        detailPageIndex.value = 1;
      } else {
        bookDetailList.addAll(newItems);
        detailPageIndex.value = requestPage;
      }

      AppLogger.info('BookController', 'Loaded book detail: $sceneId, ${newItems.length} items');
      return true;
    } catch (e) {
      detailErrorMessage.value =
          e is AppException ? e.message : 'load_failed_try_again'.tr;
      AppLogger.error('BookController', 'Failed to load book detail', e is Exception ? e : null);
      return false;
    } finally {
      isDetailLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = null;
    detailErrorMessage.value = null;
  }
}
