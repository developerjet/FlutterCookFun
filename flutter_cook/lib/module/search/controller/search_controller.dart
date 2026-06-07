import 'package:get/get.dart';
import 'package:flutter_cook/module/search/model/search_data_model.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/error_handler.dart';

class SearchController extends GetxController {
  // 搜索数据
  final searchData = Rx<SearchDataModel?>(null);

  // 搜索关键词
  final searchKeyword = ''.obs;

  // 加载状态
  final isLoading = false.obs;
  final isSearching = false.obs;

  // 错误信息
  final errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    loadSearchData();
  }

  /// 加载搜索数据
  Future<void> loadSearchData() async {
    try {
      isLoading.value = true;
      errorMessage.value = null;

      final response = await DioClient.get('/search/data');
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

  /// 执行搜索
  Future<void> performSearch(String keyword) async {
    if (keyword.trim().isEmpty) return;

    try {
      isSearching.value = true;
      searchKeyword.value = keyword;
      errorMessage.value = null;

      final response = await DioClient.get('/search', queryParameters: {
        'keyword': keyword,
      });

      // 处理搜索结果
      final data = response.data;
      if (data != null && data['data'] != null) {
        // 这里可以根据实际API返回的数据结构来处理
        AppLogger.info('SearchController', 'Search succeeded: $keyword');
      }

    } catch (e) {
      errorMessage.value = 'search_failed'.tr;
      AppLogger.error('SearchController', 'Search failed: $keyword', e is Exception ? e : null);
    } finally {
      isSearching.value = false;
    }
  }

  /// 清空搜索
  void clearSearch() {
    searchKeyword.value = '';
    errorMessage.value = null;
  }

  /// 刷新数据
  Future<void> refreshData() async {
    await loadSearchData();
  }

  /// 清空错误信息
  void clearError() {
    errorMessage.value = null;
  }
}