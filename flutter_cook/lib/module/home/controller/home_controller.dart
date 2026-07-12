import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/module/home/repository/home_repository.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static const String _tag = 'HomeController';

  final HomeRepository repository;

  final Rx<HomeBannerModel?> bannerData = Rx<HomeBannerModel?>(null);
  final Rx<HomeDataModel?> listData = Rx<HomeDataModel?>(null);
  final RxBool isLoading = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreData = true.obs;

  HomeController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _loadInitialData();
  }

  void _loadInitialData() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final results = await Future.wait([
        repository.fetchBannerData(),
        repository.fetchHomeListData(),
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

  Future<void> refreshData() async {
    isLoading.value = true;
    errorMessage.value = null;
    currentPage.value = 1;
    hasMoreData.value = true;

    try {
      final results = await Future.wait([
        repository.fetchBannerData(),
        repository.fetchHomeListData(),
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

  Future<void> loadMoreData() async {
    if (!hasMoreData.value || isLoading.value) return;

    currentPage.value++;
    isLoading.value = true;

    try {
      final moreData = await repository.fetchHomeListData();

      if (moreData.data.isEmpty) {
        hasMoreData.value = false;
      } else {
        final existingData = listData.value?.data ?? [];
        listData.value = HomeDataModel(
          data: [...existingData, ...moreData.data],
        );
      }

      AppLogger.info(_tag, 'Load more data: page ${currentPage.value}');
    } catch (e) {
      currentPage.value--;
      _handleError(e);
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(dynamic error) {
    String message;

    if (error is NetworkException) {
      message = error.message;
    } else if (error is DataException) {
      message = error.message;
    } else if (error is BusinessException) {
      message = error.message;
    } else {
      message = 'unknown_error_try_again'.tr;
    }

    AppLogger.error(
      _tag,
      'Error: $message',
      error is Exception ? error : null,
    );

    errorMessage.value = message;
  }

  void clearError() {
    errorMessage.value = null;
  }

  Future<void> retryLoadData() async {
    _loadInitialData();
  }

  @override
  void onClose() {
    AppLogger.info(_tag, 'HomeController disposed');
    super.onClose();
  }
}
