import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_bottom_sheet.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/cook/cook_route_args.dart';
import 'package:flutter_cook/module/cook/controller/cook_steps_controller.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/cook/views/cook_steps_cell.dart';
import 'package:flutter_cook/module/cook/views/cook_steps_header.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter_cook/utils/networking/networking.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
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
            return Semantics(
              label: 'semantics_favorite'.tr,
              button: true,
              child: IconButton(
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
              ),
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
              child: CookStepsHeader(
                model: loaded!,
                onTap: () {
                  _showPlaySheetBottom();
                },
              ),
            ),
            // 列表数据
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  return InkWell(
                    child: CookStepsCell(model: currentList[index]),
                    onTap: () {
                      _showImageViewer(imageUrls, initialIndex: index);
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
            return GestureDetector(
              onLongPress: () => _showImageActionSheet(
                  context, imageUrls[currentIndex]),
              child: Material(
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
                              horizontal: 4.0, vertical: 12.0),
                          color: Colors.black.withValues(alpha: 0.3),
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
                              IconButton(
                                icon: const Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                ),
                                onPressed: () => _showImageActionSheet(
                                    context, imageUrls[currentIndex]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  /// 长按/更多按钮 — 弹出操作菜单
  void _showImageActionSheet(BuildContext dialogContext, String imageUrl) {
    AppBottomSheet.show(dialogContext, children: [
      AppSheetAction(
        label: 'save_image'.tr,
        onTap: () {
          Navigator.pop(dialogContext);
          _saveImageToGallery(imageUrl);
        },
      ),
      const Divider(height: 1),
      AppSheetAction(
        label: 'cancel'.tr,
        onTap: () => Navigator.pop(dialogContext),
      ),
    ]);
  }

  /// 下载网络图片到临时目录，再保存到系统相册
  Future<void> _saveImageToGallery(String imageUrl) async {
    if (imageUrl.isEmpty) {
      ToastUtils.showShortToast('image_save_failed'.tr);
      return;
    }

    ToastUtils.showShortToast('saving'.tr);

    String? filePath;
    try {
      // 请求相册写入权限 (iOS: toAlbum=true 访问系统相册)
      final hasAccess = await Gal.hasAccess(toAlbum: true);
      if (!hasAccess) {
        final granted = await Gal.requestAccess(toAlbum: true);
        if (!granted) {
          ToastUtils.showShortToast('image_save_failed'.tr);
          return;
        }
      }

      // 下载图片到临时目录
      final dir = await getTemporaryDirectory();
      String ext;
      try {
        final uri = Uri.parse(imageUrl);
        final segments = uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
        ext = segments.contains('.') ? segments.split('.').last : '';
        if (!['jpg', 'jpeg', 'png', 'webp', 'gif'].contains(ext)) {
          ext = 'jpg';
        }
      } catch (_) {
        ext = 'jpg';
      }
      filePath = '${dir.path}/cook_save_${DateTime.now().millisecondsSinceEpoch}.$ext';
      final file = File(filePath);

      final response = await DioClient.dio.get<List<int>>(
        imageUrl,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.data == null) {
        ToastUtils.showShortToast('image_save_failed'.tr);
        return;
      }
      await file.writeAsBytes(response.data!);

      // 保存到系统相册
      await Gal.putImage(filePath, album: 'CookFun');

      ToastUtils.showShortToast('image_saved'.tr);
    } catch (e) {
      ToastUtils.showShortToast('image_save_failed'.tr);
    } finally {
      // 清理临时文件（失败不影响保存结果）
      if (filePath != null) {
        try {
          final f = File(filePath);
          if (await f.exists()) await f.delete();
        } catch (_) {}
      }
    }
  }

  void _beginPlayVideo(int index) {
    final loaded = cookController.cookStepsData.value;
    if (loaded == null) return;
    final videoList = [loaded.materialVideo, loaded.processVideo];
    Get.toNamed(RouteNames.playerVideo, arguments: {
      'urls': videoList,
      'index': index,
    });
  }

  _showPlaySheetBottom() {
    AppBottomSheet.show(context, children: [
      Padding(
        padding: const EdgeInsets.all(15),
        child: Text('choose_video'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color)),
      ),
      AppSheetAction(
        icon: Icons.video_call_sharp,
        label: 'video_one'.tr,
        onTap: () {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 300),
              () => _beginPlayVideo(0));
        },
      ),
      AppSheetAction(
        icon: Icons.video_call_sharp,
        label: 'video_two'.tr,
        onTap: () {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 300),
              () => _beginPlayVideo(1));
        },
      ),
    ]);
  }}
