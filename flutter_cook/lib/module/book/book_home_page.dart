import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/book/views/book_home_cell.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

class BookPage extends StatefulWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late final BookController controller;
  final EasyRefreshController _refreshController = EasyRefreshController();

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<BookController>()
        ? Get.find<BookController>()
        : Get.put(BookController());
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
        title: Text('tab_book_title'.tr),
      ),
      body: SafeArea(
        child: Obx(
          () => EasyRefresh(
            onRefresh: () async {
              await controller.loadBookList(refresh: true);
            },
            onLoad: () async {
              if (!controller.bookHasMore.value) return;
              final nextPage = controller.pageIndex.value + 1;
              final success = await controller.loadBookList(page: nextPage);
              if (!success) {
                ToastUtils.showShortToast('load_failed_try_again'.tr);
              }
            },
            controller: _refreshController,
            child: controller.bookList.isEmpty
                ? controller.isLoading.value
                    ? EmptyState.loading(title: 'loading'.tr)
                    : controller.errorMessage.value != null
                        ? EmptyState.error(
                            title: 'load_failed'.tr,
                            description: controller.errorMessage.value,
                            onRetry: () =>
                                controller.loadBookList(refresh: true),
                          )
                        : EmptyState.empty(
                            title: 'no_books'.tr,
                            description: 'book_data_empty_desc'.tr,
                            onRefresh: () =>
                                controller.loadBookList(refresh: true),
                          )
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: controller.bookList.length,
                    itemBuilder: (context, index) {
                      final item = controller.bookList[index];
                      return BookHomeCell(
                        model: item,
                        onTap: () {
                          Get.toNamed(RouteNames.bookDetail, arguments: {
                            'scene_id': item.sceneId,
                            'title': item.sceneTitle,
                          });
                        },
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
