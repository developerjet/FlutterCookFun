import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/cook/controller/cook_home_controller.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/views/cook_home_cell.dart';
import 'package:flutter_cook/base/widgets/app_dialog.dart';
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
  static const double _selectedItemHeight = 40.0;

  final CookHomeController controller = Get.isRegistered<CookHomeController>()
      ? Get.find<CookHomeController>()
      : Get.put(CookHomeController());

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
      appBar: AppBar(
        title: Text('tab_cook_title'.tr),
        actions: [
          const SizedBox(width: 15),
          Obx(() => Visibility(
              visible: controller.selectedMaterialNames.value.isNotEmpty,
              child: Semantics(
                label: 'semantics_delete'.tr,
                button: true,
                child: IconButton(
                  icon: Image.asset('assets/images/delete_white.png',
                      width: 25, height: 25),
                  onPressed: _showDeleteAlert,
                ),
              )))
        ],
      ),
      body: Obx(() {
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
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
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
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  /// 分类切换标签栏
  Widget _buildCategoryChips(
      BuildContext context, List<CookHomeListModel> dataList) {
    return Container(
      color: Theme.of(context).cardColor,
      height: 44,
      child: ListView.builder(
        controller: _chipScrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          final isActive = index == _activeGroupIndex;
          final group = dataList[index];
          final label = '${group.text ?? ''} ${group.data?.length ?? 0}';
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Material(
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _onChipTapped(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? Colors.white
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// 顶部已选食材面板（固定高度 + 横向滚动）
  Widget _buildSelectionPanel(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'select_ingredients_prompt'.tr,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              Obx(
                () => Text(
                  '${controller.selectedCookList.length}/$_maxFoodCount',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Obx(() {
            final items = controller.selectedCookList;
            return SizedBox(
              height: _selectedItemHeight,
              child: items.isEmpty
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'not_selected_ingredients'.tr,
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
          const SizedBox(height: 6),
          SizedBox(
            width: double.infinity,
            child: Obx(
              () {
                final selectedCount = controller.selectedCookList.length;
                return ElevatedButton(
                  onPressed: selectedCount == 0 ? null : _customConfigCook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    disabledBackgroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                  ),
                  child: Text(
                    selectedCount == 0
                        ? 'start_cooking'.tr
                        : '${'start_cooking'.tr} ($selectedCount)',
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 单个已选食材项
  Widget _buildSelectedItem(BuildContext context, CookListDataModel item) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 10),
            Text(
              item.text ?? '',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            InkWell(
              onTap: () => _removeFood(item),
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  Icons.close,
                  size: 16,
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
