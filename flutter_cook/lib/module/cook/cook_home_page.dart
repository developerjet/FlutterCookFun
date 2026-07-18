import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/base/widgets/app_refresh.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_button.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_cook/design_system/widgets/cook_chip.dart';
import 'package:flutter_cook/design_system/widgets/cook_icon_button.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/module/cook/controller/cook_home_controller.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/views/cook_home_cell.dart';
import 'package:flutter_cook/base/widgets/app_dialog.dart';
import 'package:flutter_cook/base/widgets/tab_scroll_padding.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:get/get.dart';

class CookPage extends StatefulWidget {
  const CookPage({Key? key}) : super(key: key);

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  static const int _maxFoodCount = 5;
  static const double _selectedItemHeight = 34.0;

  final CookHomeController controller = Get.find<CookHomeController>();

  late final PageController _pageController = PageController();
  late final ScrollController _chipScrollController = ScrollController();
  int _activeGroupIndex = 0;

  void _onPageChanged(int index) {
    if (index == _activeGroupIndex) return;
    setState(() => _activeGroupIndex = index);
    _scrollChipToVisible(index);
  }

  void _onChipTapped(int index) {
    if (index == _activeGroupIndex) return;
    setState(() => _activeGroupIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollChipToVisible(index);
  }

  void _scrollChipToVisible(int index) {
    if (!_chipScrollController.hasClients) return;
    // 估算每个 chip 约 80px 宽 + 8px 间距 = 88px
    final estimatedOffset = (index * 88.0) - 50.0;
    final maxScroll = _chipScrollController.position.maxScrollExtent;
    _chipScrollController.animateTo(
      estimatedOffset.clamp(0.0, maxScroll < 0 ? 0.0 : maxScroll),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _handlerSelectFood(CookListDataModel model) {
    final selected = controller.toggleFoodSelection(model);
    if (!selected) {
      ToastUtils.showShortToast(
          'toast_max_select'.trArgs([_maxFoodCount.toString()]));
    }
  }

  void _removeFood(CookListDataModel model) {
    controller.toggleFoodSelection(model);
  }

  void _showDeleteAlert() {
    if (controller.selectedCookList.isEmpty) {
      ToastUtils.showSnackbar(
          'warning_prompt'.tr, 'not_selected_ingredients'.tr);
      return;
    }
    AppDialog.show(
      context,
      title: 'warning_prompt'.tr,
      content: 'delete_selected_prompt'.tr,
      confirmText: 'confirm'.tr,
      cancelText: 'cancel'.tr,
      isDestructive: true,
      onConfirm: () => controller.clearSelectedFoods(),
    );
  }

  void _customConfigCook() {
    if (controller.selectedCookList.isEmpty) {
      ToastUtils.showSnackbar(
          'warning_prompt'.tr, 'not_selected_ingredients'.tr);
      return;
    }
    final materialIds =
        controller.selectedCookList.map((val) => val.id.toString()).join(', ');
    Get.toNamed(RouteNames.cookConfig, arguments: {
      'methodName': 'SearchMix',
      'version': '4.3.2',
      'material_ids': materialIds,
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _chipScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'cook_page_title'.tr,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          Obx(() {
            if (controller.selectedCookList.isEmpty) {
              return const SizedBox.shrink();
            }
            return CookIconButton.asset(
              key: const ValueKey('cook_delete_action'),
              tooltip: 'semantics_delete'.tr,
              assetPath: CookAssets.iconDelete,
              foregroundColor: Theme.of(context).colorScheme.error,
              onPressed: _showDeleteAlert,
            );
          }),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return EmptyState.loading(
              title: 'loading'.tr,
              description: 'loading_ingredients'.tr,
            );
          }

          final dataList = controller.cookHomeList.toList();
          if (dataList.isEmpty) {
            if (controller.errorMessage.value != null) {
              return EmptyState.error(
                title: 'load_failed'.tr,
                description: controller.errorMessage.value,
                onRetry: () => controller.loadCookHomeData(),
              );
            }
            return EmptyState.empty(
              title: 'no_ingredients'.tr,
              description: 'unable_load_ingredients'.tr,
              onRefresh: () => controller.loadCookHomeData(),
            );
          }

          if (_activeGroupIndex >= dataList.length) {
            _activeGroupIndex = 0;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSelectionPanel(context),
              _buildCategoryChips(context, dataList),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: dataList.length,
                  itemBuilder: (context, pageIndex) {
                    final items = dataList[pageIndex].data ?? [];
                    return AppRefresh(
                      onRefresh: () async {
                        await controller.loadCookHomeData();
                      },
                      child: GridView.builder(
                        padding: resolveTabScrollPadding(
                          context,
                          const EdgeInsets.fromLTRB(
                            CookTokens.pagePadding,
                            12,
                            CookTokens.pagePadding,
                            8,
                          ),
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.78,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) => CookHomeCell(
                          model: items[index],
                          onTap: () => _handlerSelectFood(items[index]),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  /// 分类切换标签栏
  Widget _buildCategoryChips(
      BuildContext context, List<CookHomeListModel> dataList) {
    return SizedBox(
      height: 52,
      child: ListView.builder(
        controller: _chipScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          CookTokens.pagePadding,
          8,
          CookTokens.pagePadding,
          8,
        ),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final isActive = index == _activeGroupIndex;
          final group = dataList[index];
          final label = '${group.text ?? ''} ${group.data?.length ?? 0}';
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: isActive
                ? CookChip.selected(
                    label: label,
                    onTap: () => _onChipTapped(index),
                  )
                : CookChip.neutral(
                    label: label,
                    onTap: () => _onChipTapped(index),
                  ),
          );
        },
      ),
    );
  }

  /// 顶部已选食材面板。
  Widget _buildSelectionPanel(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        CookTokens.pagePadding,
        4,
        CookTokens.pagePadding,
        8,
      ),
      child: CookCard(
        key: const ValueKey('cook_selection_panel'),
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'cook_countertop'.tr,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Obx(
                  () => Text(
                    '${controller.selectedCookList.length}/$_maxFoodCount',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Obx(() {
              final items = controller.selectedCookList;
              return SizedBox(
                height: _selectedItemHeight,
                child: items.isEmpty
                    ? Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'not_selected_ingredients'.tr,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: items.length,
                        itemBuilder: (context, index) =>
                            _buildSelectedItem(context, items[index]),
                      ),
              );
            }),
            const SizedBox(height: 8),
            Obx(
              () {
                final selectedCount = controller.selectedCookList.length;
                return CookButton.hero(
                  label: selectedCount == 0
                      ? 'cook_generate_recipes'.tr
                      : 'cook_generate_recipes_count'
                          .trArgs([selectedCount.toString()]),
                  onPressed: selectedCount == 0 ? null : _customConfigCook,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  /// 单个已选食材项
  Widget _buildSelectedItem(BuildContext context, CookListDataModel item) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(CookTokens.pillRadius),
          border: Border.all(
            color:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.24),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            Text(
              item.text ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            InkWell(
              onTap: () => _removeFood(item),
              borderRadius: BorderRadius.circular(CookTokens.pillRadius),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Image.asset(
                  CookAssets.iconClose,
                  width: 16,
                  height: 16,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 2),
          ],
        ),
      ),
    );
  }
}
