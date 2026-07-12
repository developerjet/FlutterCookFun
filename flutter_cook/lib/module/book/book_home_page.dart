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
    controller = Get.find<BookController>();
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
        child: Obx(() {
          // 本地快照，避免 itemCount 和 itemBuilder 之间列表被修改导致越界
          final books = controller.bookList.toList();

          return EasyRefresh(
            onRefresh: () async {
              await controller.loadBookList(page: 1);
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
            child: books.isEmpty
                ? _buildEmptyState()
                : GridView.builder(
                    padding: const EdgeInsets.all(8.0),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                    ),
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      final item = books[index];
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
          );
        }),
      ),
    );
  }

  Widget _buildEmptyState() {
    if (controller.isLoading.value) {
      return EmptyState.loading(title: 'loading'.tr);
    }
    if (controller.errorMessage.value != null) {
      return EmptyState.error(
        title: 'load_failed'.tr,
        description: controller.errorMessage.value,
        onRetry: () => controller.loadBookList(page: 1),
      );
    }
    return EmptyState.empty(
      title: 'no_books'.tr,
      description: 'book_data_empty_desc'.tr,
      onRefresh: () => controller.loadBookList(page: 1),
    );
  }
}
