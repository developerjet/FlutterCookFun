import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_bottom_sheet.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/book/book_route_args.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/module/book/views/book_detial_cell.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:get/get.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({Key? key}) : super(key: key);

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late final BookController controller;
  late final BookDetailArguments arguments;
  final EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    controller = Get.find<BookController>();

    arguments = BookDetailArguments.fromMap(
      Get.arguments as Map<String, dynamic>?,
    );

    if (arguments.isValid) {
      controller.loadBookDetail(arguments.sceneId, refresh: true);
    } else {
      controller.detailErrorMessage.value = 'missing_book_param'.tr;
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(arguments.title),
      ),
      body: Obx(
        () {
          if (!arguments.isValid) {
            return EmptyState.error(
              title: 'parameter_error'.tr,
              description: 'missing_book_param'.tr,
              onRetry: () {
                Get.back();
              },
            );
          }

          return EasyRefresh(
            onRefresh: () async {
              await controller.loadBookDetail(arguments.sceneId, refresh: true);
            },
            controller: _refreshController,
            child: controller.isDetailLoading.value && controller.bookDetailList.isEmpty
                ? EmptyState.loading(title: 'loading'.tr)
                : controller.bookDetail.value == null && controller.bookDetailList.isEmpty
                    ? EmptyState.error(
                        title: 'load_failed'.tr,
                        description:
                            controller.detailErrorMessage.value ?? 'unable_get_recipe_steps'.tr,
                        onRetry: () async {
                          await controller.loadBookDetail(arguments.sceneId, refresh: true);
                        },
                      )
                    : controller.bookDetailList.isEmpty
                        ? EmptyState.empty(
                            title: 'no_data'.tr,
                            description: 'no_recipe_data'.tr,
                          )
                        : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              AppNetworkImage(
                                url: controller.bookDetail.value?.data?.sceneBackground,
                                height: 200,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.45),
                                    ],
                                  ),
                                ),
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Text(
                                    controller.bookDetail.value?.data?.sceneDesc ?? '',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = controller.bookDetailList[index];
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BookDetialCell(
                                  model: item,
                                  onTap: () => _goToCookSteps(item),
                                  onPlayTap: () => _showPlaySheetBottom(item),
                                ),
                                Divider(
                                  height: 0.5,
                                  color: Theme.of(context).dividerColor,
                                ),
                              ],
                            );
                          },
                          childCount: controller.bookDetailList.length,
                        ),
                      ),
                    ],
                  ),
          );
        },
      ),
    );
  }

  void _goToCookSteps(BookDishesListModel item) {
    if (item.dishesId == null) return;
    Get.toNamed(RouteNames.cookSteps, arguments: {
      'dishes_id': item.dishesId.toString(),
      'pushPage': 'bookDetail',
    });
  }

  void _playCookVideo(BookDishesListModel data, int playIndex) {
    final List videoList = [data.materialVideo, data.processVideo];
    Get.toNamed(RouteNames.playerVideo, arguments: {
      'urls': videoList,
      'index': playIndex,
    });
  }

  void _showPlaySheetBottom(BookDishesListModel data) {
    AppBottomSheet.show(context, children: [
      Container(
        padding: const EdgeInsets.all(15),
        child: Text(
          'choose_video'.tr,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),
      AppSheetAction(
        icon: Icons.video_call_sharp,
        label: 'video_one'.tr,
        onTap: () {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 300),
              () => _playCookVideo(data, 0));
        },
      ),
      AppSheetAction(
        icon: Icons.video_call_sharp,
        label: 'video_two'.tr,
        onTap: () {
          Navigator.pop(context);
          Future.delayed(const Duration(milliseconds: 300),
              () => _playCookVideo(data, 1));
        },
      ),
    ]);
  }
}
