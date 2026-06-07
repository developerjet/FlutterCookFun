import 'package:get/get.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class CookStepsController extends GetxController {
  final CookRepository _repository = CookRepository();

  final cookStepsData = Rx<CookStepDataModel?>(null);
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);
  final currentDishId = ''.obs;

  Future<bool> loadCookSteps(String dishesId, {bool refresh = false}) async {
    if (isLoading.value) {
      return false;
    }

    if (dishesId.isEmpty) {
      errorMessage.value = 'missing_dish_id'.tr;
      return false;
    }

    if (refresh || currentDishId.value != dishesId) {
      currentDishId.value = dishesId;
      cookStepsData.value = null;
      errorMessage.value = null;
    }

    try {
      isLoading.value = true;
      cookStepsData.value = await _repository.fetchCookStepsData(dishesId);
      AppLogger.info('CookStepsController', 'Loaded cook steps data successfully');
      return true;
    } catch (e) {
      errorMessage.value =
          e is AppException ? e.message : 'load_failed_try_again'.tr;
      AppLogger.error(
        'CookStepsController',
        'Failed to load cook steps data',
        e is Exception ? e : null,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void clearError() {
    errorMessage.value = null;
  }
}
