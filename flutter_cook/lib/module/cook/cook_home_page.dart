import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/module/cook/controller/cook_home_controller.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:flutter_cook/module/cook/views/cook_home_cell.dart';
import 'package:flutter_cook/base/widgets/app_dialog.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:get/get.dart';

class CookPage extends StatefulWidget {
  const CookPage({Key? key}) : super(key: key);

  @override
  State<CookPage> createState() => _CookPageState();
}

class _CookPageState extends State<CookPage> {
  static const int _maxFoodCount = 5;

  final CookHomeController controller = Get.isRegistered<CookHomeController>()
      ? Get.find<CookHomeController>()
      : Get.put(CookHomeController());

  final ScrollController _listScrollController = ScrollController();
  final List<GlobalKey> _groupKeys = [];
  final List<GlobalKey> _chipKeys = [];
  int _activeGroupIndex = 0;

  void _scrollToGroup(int index) {
    if (index >= _groupKeys.length) return;
    setState(() => _activeGroupIndex = index);

    // 标签栏自动滚动
    final chipCtx = _chipKeys[index].currentContext;
    if (chipCtx != null) {
      Scrollable.ensureVisible(
        chipCtx,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        alignment: 0.5,
      );
    }

    // 列表跳转到对应分组
    final groupCtx = _groupKeys[index].currentContext;
    if (groupCtx != null) {
      Scrollable.ensureVisible(
        groupCtx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.05,
      );
    }
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
      ToastUtils.showSnackbar('warning_prompt'.tr, 'not_selected_ingredients'.tr);
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
      ToastUtils.showSnackbar('warning_prompt'.tr, 'not_selected_ingredients'.tr);
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
    _listScrollController.dispose();
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

        final dataList = controller.cookHomeList;
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

        // 初始化 key 列表
        _groupKeys.clear();
        _chipKeys.clear();
        for (int i = 0; i < dataList.length; i++) {
          _groupKeys.add(GlobalKey());
          _chipKeys.add(GlobalKey());
        }

        return Column(
          children: [
            _buildSelectionPanel(context),
            _buildCategoryChips(context, dataList),
            Expanded(
              child: CustomScrollView(
                controller: _listScrollController,
                slivers: [
                  ...dataList.asMap().entries.map((entry) {
                    final groupIndex = entry.key;
                    final group = entry.value;
                    final items = group.data ?? [];
                    return SliverStickyHeader(
                      key: _groupKeys[groupIndex],
                      header: _buildGroupHeader(
                          context, group.text ?? '', items.length),
                      sliver: SliverPadding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 8),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.78,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => CookHomeCell(
                              model: items[index],
                              onTap: () => _handlerSelectFood(items[index]),
                            ),
                            childCount: items.length,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
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
              key: _chipKeys[index],
              color: isActive
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => _scrollToGroup(index),
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

  Widget _buildSelectionPanel(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        children: [
          Text(
            'select_ingredients_prompt'.tr,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 4),
          Obx(() {
            final items = controller.selectedCookList;
            if (items.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 6,
                children: items.map((item) => Chip(
                  label: Text(item.text ?? '',
                      style: const TextStyle(fontSize: 13)),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => _removeFood(item),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  visualDensity: VisualDensity.compact,
                )).toList(),
              ),
            );
          }),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: controller.selectedCookList.isEmpty
                  ? null
                  : _customConfigCook,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                disabledBackgroundColor: Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 10),
              ),
              child: Text('start_cooking'.tr),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupHeader(BuildContext context, String title, int count) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '$count',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
