import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/cook/cook_route_args.dart';
import 'package:flutter_cook/module/cook/controller/cook_steps_controller.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/cook/views/cook_steps_cell.dart';
import 'package:flutter_cook/module/cook/views/cook_steps_header.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class CookStepsPage extends StatefulWidget {
  const CookStepsPage({Key? key}) : super(key: key);

  @override
  State<CookStepsPage> createState() => _CookStepsPageState();
}

class _CookStepsPageState extends State<CookStepsPage> {
  late final CookStepsArguments arguments;
  final CookStepsController cookController = Get.isRegistered<CookStepsController>()
      ? Get.find<CookStepsController>()
      : Get.put(CookStepsController());
  final FavoritesController favoritesController =
      Get.isRegistered<FavoritesController>()
          ? Get.find<FavoritesController>()
          : Get.put(FavoritesController());

  /// 是否收藏
  final RxBool _isFavorite = false.obs;

  @override
  void initState() {
    super.initState();
    arguments = CookStepsArguments.fromMap(
      Get.arguments as Map<String, dynamic>?,
    );
    _fetchCookingSteps();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // 获取做菜步骤
  Future<void> _fetchCookingSteps({bool refresh = false}) async {
    if (!arguments.isValid) {
      return;
    }

    final success = await cookController.loadCookSteps(
      arguments.dishesId,
      refresh: refresh,
    );

    if (!success) {
      return;
    }

    await _queryConfigFavorite();
  }

  // 查询是否已收藏
  Future<void> _queryConfigFavorite() async {
    if (!arguments.isValid) {
      _isFavorite.value = false;
      return;
    }

    final isFav = await favoritesController.isFavorited(arguments.dishesId);
    _isFavorite.value = isFav;
  }

  // 收藏
  Future<void> _beginFavoriteCook() async {
    final loaded = cookController.cookStepsData.value;
    if (loaded == null) {
      return;
    }

    final cookConfig = CookConfigListModel(
      dishesId: loaded.dashesId,
      image: loaded.image,
      title: loaded.dashesName,
      hardLevel: loaded.hardLevel,
      taste: loaded.taste,
      cookingTime: loaded.cookingTime,
      description: loaded.materialDesc,
    );
    final success = await favoritesController.addToFavorites(cookConfig);
    if (success) {
      _isFavorite.value = true;
      if (arguments.pushPage == 'myFavorites') {
        favoritesController.refreshFavorites();
      }
    }
  }

  // 取消收藏
  Future<void> _clearFavoriteCook() async {
    final loaded = cookController.cookStepsData.value;
    if (loaded == null) {
      return;
    }

    final id = loaded.dashesId ?? '';
    final success = await favoritesController.removeFromFavorites(id);
    if (success) {
      _isFavorite.value = false;
      if (arguments.pushPage == 'myFavorites') {
        favoritesController.refreshFavorites();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cook_steps_title'.tr),
        actions: [
          Obx(() {
            final loaded = cookController.cookStepsData.value;
            return IconButton(
              icon: Icon(_isFavorite.value == true
                  ? Icons.favorite_outlined
                  : Icons.favorite_border),
              onPressed: loaded == null
                  ? null
                  : () {
                      if (_isFavorite.value) {
                        _clearFavoriteCook();
                      } else {
                        _beginFavoriteCook();
                      }
                    },
            );
          })
        ],
      ),
      body: Obx(() {
        if (!arguments.isValid) {
          return EmptyState.error(
            title: 'parameter_error'.tr,
            description: 'missing_dish_id'.tr,
            onRetry: () => _fetchCookingSteps(refresh: true),
          );
        }

        final isLoading = cookController.isLoading.value;
        final errorMessage = cookController.errorMessage.value;
        final loaded = cookController.cookStepsData.value;
        final currentList = loaded?.step ?? [];
        final imageUrls = loaded?.step
                ?.map((model) => model.dishesStepImage ?? '')
                .where((url) => url.isNotEmpty)
                .toList() ??
            [];

        if (isLoading && loaded == null) {
          return EmptyState.loading(
            title: 'loading'.tr,
            description: 'loading_recipe_steps'.tr,
          );
        }

        if (currentList.isEmpty) {
          if (errorMessage != null) {
            return EmptyState.error(
              title: 'load_failed'.tr,
              description: errorMessage,
              onRetry: () => _fetchCookingSteps(),
            );
          }
          return EmptyState.empty(
            title: 'no_steps_data'.tr,
            description: 'unable_get_recipe_steps'.tr,
            onRefresh: () => _fetchCookingSteps(),
          );
        }

        return CustomScrollView(
          slivers: [
            // 顶部Banner
            SliverToBoxAdapter(
              child: SizedBox(
                  height: 420,
                  child: CookStepsHeader(
                    model: loaded!,
                    onTap: () {
                      _showPlaySheetBottom();
                    },
                  )),
            ),
            // 列表数据
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return InkWell(
                    child: CookStepsCell(model: currentList[index]),
                    onTap: () {
                      _showImageViewer(imageUrls);
                    },
                  );
                },
                childCount: currentList.length,
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showImageViewer(List<String> imageUrls, {int initialIndex = 0}) {
    if (imageUrls.isEmpty) {
      return;
    }

    final PageController pageController = PageController(initialPage: initialIndex);
    int currentIndex = initialIndex;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Image Viewer',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext context, Animation<double> animation,
          Animation<double> secondaryAnimation) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Material(
              color: Colors.black,
              child: SafeArea(
                top: true,
                bottom: false,
                child: Stack(
                  children: [
                    PhotoViewGallery.builder(
                      itemCount: imageUrls.length,
                      builder: (context, index) {
                        return PhotoViewGalleryPageOptions(
                          imageProvider: NetworkImage(imageUrls[index]),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.covered * 2,
                        );
                      },
                      pageController: pageController,
                      onPageChanged: (index) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      scrollPhysics: const BouncingScrollPhysics(),
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 12.0),
                        color: Colors.black.withAlpha((0.3 * 255).round()),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            Expanded(
                              child: Center(
                                child: Text(
                                  '${currentIndex + 1}/${imageUrls.length}',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _beginPlayVideo(int index) {
    final loaded = cookController.cookStepsData.value;
    if (loaded == null) {
      return;
    }
    final videoList = [loaded.materialVideo, loaded.processVideo];
    Get.toNamed(RouteNames.playerVideo, arguments: {'url': videoList[index]});
  }

  _showPlaySheetBottom() {
    Get.bottomSheet(Container(
      color: Theme.of(context).bottomSheetTheme.backgroundColor,
      height: 200,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            child: Text('choose_video'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
          ),
          ListTile(
            leading: Icon(Icons.video_call_sharp,
                color: Theme.of(context).iconTheme.color),
            title: Text('video_one'.tr,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            onTap: () {
              Get.back();
              _beginPlayVideo(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.video_call_sharp,
                color: Theme.of(context).textTheme.bodyLarge?.color),
            title: Text('video_two'.tr,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
            onTap: () {
              Get.back();
              _beginPlayVideo(1);
            },
          ),
        ],
      ),
    ));
  }
}
