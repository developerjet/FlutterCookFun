/// 收藏控制器 (GetX Controller)
///
/// 职责：
/// 1. 管理收藏页面状态
/// 2. 处理收藏数据的增删改查
/// 3. 协调本地数据库操作

import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/utils/error_handler.dart';
import 'package:flutter_cook/utils/sqlite/db_manager.dart';
import 'package:get/get.dart';

class FavoritesController extends GetxController {
  static const String _tag = 'FavoritesController';

  // 响应式状态
  final favoritesList = RxList<CookConfigListModel>();
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  /// 加载收藏数据
  void _loadFavorites() async {
    isLoading.value = true;
    errorMessage.value = null;

    try {
      final data = await DBManager().findAll();
      favoritesList.assignAll(data?.reversed.toList() ?? []);

      AppLogger.info(
          _tag, 'Favorites loaded successfully: ${favoritesList.length} items');
    } catch (e) {
      errorMessage.value = 'load_favorites_failed'.tr;
      AppLogger.error(_tag, 'Failed to load favorites', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// 刷新收藏数据
  void refreshFavorites() {
    AppLogger.info(_tag, 'Refreshing favorites');
    _loadFavorites();
  }

  /// 添加收藏
  Future<bool> addToFavorites(CookConfigListModel item) async {
    try {
      await DBManager().saveData(item);
      favoritesList.insert(0, item); // 添加到列表开头

      AppLogger.info(_tag, 'Added favorite successfully: ${item.title}');
      return true;
    } catch (e) {
      errorMessage.value = 'add_favorite_failed'.tr;
      AppLogger.error(_tag, 'Failed to add favorite: ${item.title}', e);
      return false;
    }
  }

  /// 移除收藏
  Future<bool> removeFromFavorites(String id) async {
    try {
      await DBManager().delete(id);
      favoritesList.removeWhere((item) => item.dishesId == id);

      AppLogger.info(_tag, 'Removed favorite successfully: $id');
      return true;
    } catch (e) {
      errorMessage.value = 'remove_favorites_failed'.tr;
      AppLogger.error(_tag, 'Failed to remove favorite: $id', e);
      return false;
    }
  }

  /// 检查是否已收藏
  Future<bool> isFavorited(String id) async {
    if (id.isEmpty) {
      return false;
    }

    try {
      final item = await DBManager().find(id);
      return item != null && item.isNotEmpty;
    } catch (e) {
      AppLogger.error(_tag, 'Failed to check favorite status: $id', e);
      return false;
    }
  }

  /// 切换收藏状态
  Future<bool> toggleFavorite(CookConfigListModel item) async {
    final isFav = await isFavorited(item.dishesId ?? '');
    if (isFav) {
      return await removeFromFavorites(item.dishesId ?? '');
    } else {
      return await addToFavorites(item);
    }
  }

  /// 清空所有收藏
  Future<bool> clearAllFavorites() async {
    try {
      await DBManager().deleteAll();
      favoritesList.clear();

      AppLogger.info(_tag, 'Cleared all favorites successfully');
      return true;
    } catch (e) {
      errorMessage.value = 'clear_favorites_failed'.tr;
      AppLogger.error(_tag, 'Failed to clear all favorites', e);
      return false;
    }
  }

  /// 重试加载数据
  void retryLoadData() => _loadFavorites();

  @override
  void onClose() {
    AppLogger.info(_tag, 'FavoritesController disposed');
    super.onClose();
  }
}
