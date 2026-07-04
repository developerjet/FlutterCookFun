import 'package:get/get.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/repository/cook_repository.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class CookHomeController extends GetxController {
  final CookRepository _repository = CookRepository();

  final cookHomeList = <CookHomeListModel>[].obs;
  final selectedCookList = <CookListDataModel>[].obs;
  final selectedMaterialNames = ''.obs;

  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadCookHomeData();
  }

  Future<void> loadCookHomeData({bool forceRefresh = false}) async {
    if (isLoading.value && !forceRefresh) {
      return;
    }

    final selectedIds = selectedCookList.map((item) => item.id).toSet();
    final preserveSelection = selectedIds.isNotEmpty;

    try {
      isLoading.value = true;
      errorMessage.value = null;

      final list = await _repository.fetchCookHomeData();
      cookHomeList.assignAll(list);

      if (preserveSelection) {
        _restoreSelection(selectedIds);
      } else {
        clearSelectedFoods();
      }
      _updateSelectedMaterialNames();

      AppLogger.info('CookHomeController', 'Loaded cook home data successfully');
    } catch (e) {
      errorMessage.value =
          e is AppException ? e.message : 'load_failed_try_again'.tr;
      AppLogger.error(
        'CookHomeController',
        'Failed to load cook home data',
        e is Exception ? e : null,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool toggleFoodSelection(CookListDataModel model) {
    if (!model.isSelected.value && selectedCookList.length >= 5) {
      return false;
    }

    model.isSelected.value = !model.isSelected.value;

    if (model.isSelected.value) {
      selectedCookList.add(model);
    } else {
      selectedCookList.removeWhere((item) => item.id == model.id);
    }

    _updateSelectedMaterialNames();
    return true;
  }

  void clearSelectedFoods() {
    for (final group in cookHomeList) {
      group.data?.forEach((item) {
        item.isSelected.value = false;
      });
    }

    selectedCookList.clear();
    selectedMaterialNames.value = '';
  }

  void _restoreSelection(Set<dynamic> selectedIds) {
    selectedCookList.clear();
    for (final group in cookHomeList) {
      group.data?.forEach((item) {
        if (selectedIds.contains(item.id)) {
          item.isSelected.value = true;
          selectedCookList.add(item);
        }
      });
    }
  }

  void _updateSelectedMaterialNames() {
    selectedMaterialNames.value =
        selectedCookList.map((item) => item.text ?? '').join(', ');
  }

  void clearError() {
    errorMessage.value = null;
  }
}
