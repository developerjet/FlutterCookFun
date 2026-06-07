import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/book/book_route_args.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/module/book/views/book_detial_cell.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

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
            onLoad: () async {
              final nextPage = controller.detailPageIndex.value + 1;
              final success = await controller.loadBookDetail(
                arguments.sceneId,
                page: nextPage,
              );
              if (!success) {
                controller.detailPageIndex.value -= 1;
              }
            },
            controller: _refreshController,
            child: controller.bookDetail.value == null && controller.bookDetailList.isEmpty
                ? controller.isDetailLoading.value
                    ? EmptyState.loading(title: 'loading'.tr)
                    : EmptyState.error(
                        title: 'load_failed'.tr,
                        description:
                            controller.detailErrorMessage.value ?? 'unable_get_recipe_steps'.tr,
                        onRetry: () async {
                          await controller.loadBookDetail(arguments.sceneId, refresh: true);
                        },
                      )
                : CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  GFImageOverlay(
                                    height: 200,
                                    image: NetworkImage(controller.bookDetail.value?.data?.sceneBackground ?? ''),
                                    boxFit: BoxFit.fill,
                                  ),
                                  Center(
                                    heightFactor: 5,
                                    child: Text(
                                      controller.bookDetail.value?.data?.sceneDesc ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: Colors.white, fontSize: 16),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            final item = controller.bookDetailList[index];
                            return InkWell(
                              child: Column(
                                children: [
                                  BookDetialCell(model: item),
                                  Divider(
                                    height: 0.5,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ],
                              ),
                              onTap: () {
                                _showPlaySheetBottom(item);
                              },
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

  void _playCookVideo(BookDishesListModel data, int playIndex) {
    final List videoList = [data.materialVideo, data.processVideo];
    Get.toNamed(RouteNames.playerVideo, arguments: {'url': videoList[playIndex]});
  }

  void _showPlaySheetBottom(BookDishesListModel data) {
    Get.bottomSheet(
      Container(
        color: Theme.of(context).bottomSheetTheme.backgroundColor,
        height: 200,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: Text(
                'choose_video'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ),
            ListTile(
              leading: Icon(Icons.video_call_sharp, color: Theme.of(context).textTheme.bodyLarge?.color),
              title: Text('video_one'.tr, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Get.back();
                _playCookVideo(data, 0);
              },
            ),
            ListTile(
              leading: Icon(Icons.video_call_sharp, color: Theme.of(context).textTheme.bodyLarge?.color),
              title: Text('video_two'.tr, style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color)),
              onTap: () {
                Get.back();
                _playCookVideo(data, 1);
              },
            ),
          ],
        ),
      ),
    );
  }
}
