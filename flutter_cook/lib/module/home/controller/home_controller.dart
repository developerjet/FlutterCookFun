/// 首页控制器 (GetX Controller)
/// 
/// 职责：
/// 1. 管理首页页面状态
/// 2. 协调数据加载和业务逻辑
/// 3. 处理用户交互事件
/// 4. 统一的错误处理

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/module/home/repository/home_repository.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static const String _tag = 'HomeController';

  // Repository 依赖
  final HomeRepository _repository = HomeRepository();

  // 响应式状态
  final bannerData = Rx<HomeBannerModel?>(null);
  final listData = Rx<HomeDataModel?>(null);
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);
  final currentPage = 1.obs;
  final hasMoreData = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  /// 加载初始数据
  void _loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      // 并行加载 Banner 和列表数据
      final results = await Future.wait([
        _repository.fetchBannerData(),
        _repository.fetchHomeListData(),
      ]);

      if (results[0] is HomeBannerModel && results[1] is HomeDataModel) {
        bannerData.value = results[0] as HomeBannerModel;
        listData.value = results[1] as HomeDataModel;
      } else {
        throw DataException(
          message: 'unexpected_response_format'.tr,
          code: 'PARSE_ERROR',
        );
      }

      AppLogger.info(_tag, 'Home data loaded');
    } catch (e) {
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// 刷新首页数据
  Future<void> refreshData() async {
    isLoading.value = true;
    errorMessage.value = null;
    currentPage.value = 1;
    hasMoreData.value = true;

    try {
      // 并行加载 Banner 和列表数据
      final results = await Future.wait([
        _repository.fetchBannerData(),
        _repository.fetchHomeListData(),
      ]);

      if (results[0] is HomeBannerModel && results[1] is HomeDataModel) {
        bannerData.value = results[0] as HomeBannerModel;
        listData.value = results[1] as HomeDataModel;
      } else {
        throw DataException(
          message: 'unexpected_response_format'.tr,
          code: 'PARSE_ERROR',
        );
      }

      AppLogger.info(_tag, 'Home data refreshed');
      EasyLoading.showSuccess('refresh_success'.tr);
    } catch (e) {
      _handleError(e);
      EasyLoading.showError('refresh_failed'.tr);
    } finally {
      isLoading.value = false;
    }
  }

  /// 加载更多数据 (分页)
  Future<void> loadMoreData() async {
    if (!hasMoreData.value || isLoading.value) {
      return;
    }

    currentPage.value++;
    isLoading.value = true;

    try {
      final moreData = await _repository.fetchHomeListData();

      if (moreData.data.isEmpty) {
        hasMoreData.value = false;
      } else {
        // 追加新数据到列表
        final existingData = listData.value?.data ?? [];
        listData.value = HomeDataModel(
          data: [...existingData, ...moreData.data],
        );
      }

      AppLogger.info(_tag, 'Load more data: page ${currentPage.value}');
    } catch (e) {
      currentPage.value--; // 恢复页码
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  /// 统一的错误处理
  void _handleError(dynamic error) {
    String message;
    String code;

    if (error is NetworkException) {
      message = error.message;
      code = error.code ?? 'NETWORK_ERROR';
    } else if (error is DataException) {
      message = error.message;
      code = error.code ?? 'DATA_ERROR';
    } else if (error is BusinessException) {
      message = error.message;
      code = error.code ?? 'BUSINESS_ERROR';
    } else {
      message = 'unknown_error_try_again'.tr;
      code = 'UNKNOWN_ERROR';
    }

    AppLogger.error(
      _tag,
      'Error [$code]: $message',
      error is Exception ? error : null,
    );

    errorMessage.value = message;
  }

  /// 清除错误信息
  void clearError() {
    errorMessage.value = null;
  }

  /// 重试加载数据
  Future<void> retryLoadData() async {
    _loadInitialData();
  }

  @override
  void onClose() {
    AppLogger.info(_tag, 'HomeController disposed');
    super.onClose();
  }
}
