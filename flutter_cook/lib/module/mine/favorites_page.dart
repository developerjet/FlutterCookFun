import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';

import '../cook/views/cook_config_cell.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoritesController controller = Get.isRegistered<FavoritesController>()
      ? Get.find<FavoritesController>()
      : Get.put(FavoritesController());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('favorite_title'.tr),
      ),
      body: SafeArea(child: Obx(() {
        if (controller.isLoading.value) {
          return EmptyState.loading(title: 'loading'.tr);
        }

        if (controller.errorMessage.value != null) {
          return EmptyState.error(
            title: 'load_failed'.tr,
            description: controller.errorMessage.value,
            onRetry: () => controller.refreshFavorites(),
          );
        }

        // 本地快照，防止 itemCount 和 itemBuilder 之间列表被修改导致越界
        final favorites = controller.favoritesList.toList();

        if (favorites.isEmpty) {
          return EmptyState.empty(
            title: 'no_favorites'.tr,
            description: 'favorite_data_empty_desc'.tr,
            onRefresh: () => controller.refreshFavorites(),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 6),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final item = favorites[index];
            return InkWell(
              borderRadius: BorderRadius.circular(10),
              child: CookConfigCell(model: item),
              onTap: () {
                Get.toNamed(RouteNames.cookSteps, arguments: {
                  'dishes_id': item.dishesId,
                  'pushPage': 'myFavorites'
                });
              },
            );
          },
        );
      })),
    );
  }
}
