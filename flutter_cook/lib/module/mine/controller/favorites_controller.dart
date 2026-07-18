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

class FavoritesDataStore {
  Future<List<CookConfigListModel>?> findAll() => DBManager().findAll();

  Future<dynamic> saveData(CookConfigListModel item) =>
      DBManager().saveData(item);

  Future<int> delete(String dishesId) => DBManager().delete(dishesId);

  Future<List<CookConfigListModel>?> find(String dishesId) =>
      DBManager().find(dishesId);

  Future<int> deleteAll() => DBManager().deleteAll();
}

class FavoritesController extends GetxController {
  static const String _tag = 'FavoritesController';

  final FavoritesDataStore dataStore;

  // 响应式状态
  final favoritesList = RxList<CookConfigListModel>();
  final isLoading = false.obs;
  final errorMessage = Rx<String?>(null);

  FavoritesController({FavoritesDataStore? dataStore})
      : dataStore = dataStore ?? FavoritesDataStore();

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
      final data = await dataStore.findAll();
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
      await dataStore.saveData(item);
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
      await dataStore.delete(id);
      favoritesList.removeWhere((item) => item.dishesId == id);

      AppLogger.info(_tag, 'Removed favorite successfully: $id');
      return true;
    } catch (e) {
      errorMessage.value = 'remove_favorites_failed'.tr;
      AppLogger.error(_tag, 'Failed to remove favorite: $id', e);
      return false;
    }
  }

  /// 批量移除收藏
  Future<bool> removeFavorites(Set<String> ids) async {
    final validIds = ids.where((id) => id.isNotEmpty).toSet();
    if (validIds.isEmpty) {
      return true;
    }

    final deletedIds = <String>{};
    try {
      for (final id in validIds) {
        await dataStore.delete(id);
        deletedIds.add(id);
      }
      favoritesList.removeWhere((item) => validIds.contains(item.dishesId));

      AppLogger.info(
        _tag,
        'Removed favorites successfully: ${validIds.length} items',
      );
      return true;
    } catch (e) {
      if (deletedIds.isNotEmpty) {
        favoritesList.removeWhere((item) => deletedIds.contains(item.dishesId));
      }
      AppLogger.error(_tag, 'Failed to remove favorites: $validIds', e);
      return false;
    }
  }

  /// 检查是否已收藏
  Future<bool> isFavorited(String id) async {
    if (id.isEmpty) {
      return false;
    }

    try {
      final item = await dataStore.find(id);
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
      await dataStore.deleteAll();
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
