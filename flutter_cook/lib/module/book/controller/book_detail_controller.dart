import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/services/book_service.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:get/get.dart';

/// 单个菜谱专题详情页面的独立状态控制器。
///
/// 每次进入详情页都应创建新实例，避免不同专题之间共享列表、图片和加载状态。
class BookDetailController {
  final BookService service;
  final int sceneId;

  final Rx<BookDetailModel?> detail = Rx<BookDetailModel?>(null);
  final RxList<BookDishesListModel> dishes = <BookDishesListModel>[].obs;
  final RxBool isLoading = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();

  int _requestSerial = 0;
  bool _isDisposed = false;

  /// 创建页面独立的菜谱详情控制器。
  ///
  /// 参数：
  /// - [service]: 菜谱详情数据服务。
  /// - [sceneId]: 当前页面唯一的专题 ID。
  BookDetailController({
    required this.service,
    required this.sceneId,
  });

  /// 一次性加载当前专题的全部可用菜谱数据。
  ///
  /// 返回：当前页面仍存活且数据成功应用时返回 `true`。
  Future<bool> load() async {
    if (_isDisposed) {
      return false;
    }
    if (sceneId <= 0) {
      errorMessage.value = 'missing_book_param'.tr;
      return false;
    }

    final requestSerial = ++_requestSerial;
    detail.value = null;
    dishes.clear();
    errorMessage.value = null;
    isLoading.value = true;

    try {
      final model = await service.fetchBookDetail(sceneId, page: 1);
      if (!_canApply(requestSerial)) {
        return false;
      }

      detail.value = model;
      dishes.assignAll(model.data?.dishesList ?? const []);
      AppLogger.info(
        'BookDetailController',
        'Loaded book detail: $sceneId, ${dishes.length} items',
      );
      return true;
    } catch (error) {
      if (_canApply(requestSerial)) {
        errorMessage.value =
            error is AppException ? error.message : 'load_failed_try_again'.tr;
      }
      AppLogger.error(
        'BookDetailController',
        'Failed to load book detail: $sceneId',
        error is Exception ? error : null,
      );
      return false;
    } finally {
      if (_canApply(requestSerial)) {
        isLoading.value = false;
      }
    }
  }

  /// 使当前页面的未完成请求失效。
  void dispose() {
    _isDisposed = true;
    _requestSerial += 1;
    isLoading.value = false;
  }

  bool _canApply(int requestSerial) {
    return !_isDisposed && requestSerial == _requestSerial;
  }
}
