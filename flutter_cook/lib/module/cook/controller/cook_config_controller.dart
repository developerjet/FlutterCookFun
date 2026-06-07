import 'package:get/get.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';
import 'package:flutter_cook/module/cook/cook_route_args.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class CookConfigController extends GetxController {
  final CookRepository _repository = CookRepository();

  final cookConfigList = <CookConfigListModel>[].obs;
  final isLoading = false.obs;
  final configErrorMessage = Rx<String?>(null);
  final configHasMore = true.obs;
  final pageIndex = 1.obs;

  Future<bool> loadCookConfigData(
    CookConfigArguments arguments, {
    bool refresh = false,
  }) async {
    if (isLoading.value) {
      return false;
    }

    if (!arguments.isValid) {
      configErrorMessage.value = 'invalid_cook_config_params'.tr;
      return false;
    }

    final requestedPage = refresh ? 1 : pageIndex.value;

    if (refresh) {
      cookConfigList.clear();
      configHasMore.value = true;
      configErrorMessage.value = null;
    }

    try {
      isLoading.value = true;

      final params = arguments.toQueryParams(
        requestedPage,
        BusinessConstants.pageSize,
      );
      final list = await _repository.fetchCookConfigData(params);

      configHasMore.value = list.length >= BusinessConstants.pageSize;
      if (refresh) {
        cookConfigList.assignAll(list);
      } else {
        cookConfigList.addAll(list);
      }

      pageIndex.value = requestedPage;
      AppLogger.info('CookConfigController', 'Loaded cook config data successfully');
      return true;
    } catch (e) {
      configErrorMessage.value =
          e is AppException ? e.message : 'load_failed_try_again'.tr;
      AppLogger.error(
        'CookConfigController',
        'Failed to load cook config data',
        e is Exception ? e : null,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> loadNextPage(CookConfigArguments arguments) async {
    if (!configHasMore.value || isLoading.value) {
      return false;
    }

    pageIndex.value += 1;
    final success = await loadCookConfigData(arguments);
    if (!success) {
      pageIndex.value -= 1;
    }
    return success;
  }

  void clearError() {
    configErrorMessage.value = null;
  }
}
