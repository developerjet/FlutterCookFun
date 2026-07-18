import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/base/widgets/app_refresh.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter_cook/base/widgets/tab_scroll_padding.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/module/book/controller/book_controller.dart';
import 'package:flutter_cook/module/book/views/book_home_cell.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/toast.dart';
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
      appBar: AppNavBar(
        title: 'book_library_title'.tr,
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(() {
          final books = controller.bookList.toList();

          return AppRefresh(
            controller: _refreshController,
            onRefresh: () async {
              await controller.loadBookList(page: 1);
            },
            onLoad: controller.bookHasMore.value
                ? () async {
                    final nextPage = controller.pageIndex.value + 1;
                    final success =
                        await controller.loadBookList(page: nextPage);
                    if (!success) {
                      ToastUtils.showShortToast('load_failed_try_again'.tr);
                    }
                  }
                : null,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                if (books.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _buildEmptyState(),
                  )
                else ...[
                  SliverPadding(
                    padding: resolveTabScrollPadding(
                      context,
                      const EdgeInsets.fromLTRB(
                        CookTokens.pagePadding,
                        12,
                        CookTokens.pagePadding,
                        8,
                      ),
                    ),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.78,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
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
                        childCount: books.length,
                      ),
                    ),
                  ),
                ],
              ],
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
