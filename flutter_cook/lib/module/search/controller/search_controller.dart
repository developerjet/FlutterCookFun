import 'package:get/get.dart';
import 'package:flutter_cook/module/search/model/search_data_model.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class SearchController extends GetxController {
  final DioClient client;

  final Rx<SearchDataModel?> searchData = Rx<SearchDataModel?>(null);
  final RxString searchKeyword = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isSearching = false.obs;
  final Rxn<String> errorMessage = Rxn<String>();

  SearchController({required this.client});

  @override
  void onInit() {
    super.onInit();
    loadSearchData();
  }

  Future<void> loadSearchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await client.get('/search/data');
      final data = response.data;

      if (data != null && data['data'] != null) {
        searchData.value = SearchDataModel.fromJson(data['data']);
      }

      AppLogger.info('SearchController', 'Search data loaded successfully');
    } catch (e) {
      errorMessage.value = 'search_load_failed'.tr;
      AppLogger.error('SearchController', 'Failed to load search data', e is Exception ? e : null);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> performSearch(String keyword) async {
    if (keyword.trim().isEmpty) return;

    try {
      isSearching.value = true;
      searchKeyword.value = keyword;
      errorMessage.value = null;

      final response = await client.get('/search', queryParameters: {
        'keyword': keyword,
      });

      final data = response.data;
      if (data != null && data['data'] != null) {
        AppLogger.info('SearchController', 'Search succeeded: $keyword');
      }
    } catch (e) {
      errorMessage.value = 'search_failed'.tr;
      AppLogger.error('SearchController', 'Search failed: $keyword', e is Exception ? e : null);
    } finally {
      isSearching.value = false;
    }
  }

  void clearSearch() {
    searchKeyword.value = '';
    errorMessage.value = null;
  }

  Future<void> refreshData() async {
    await loadSearchData();
  }

  void clearError() {
    errorMessage.value = null;
  }
}
