import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_cook/design_system/widgets/cook_chip.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';

class FoodClassPage extends StatefulWidget {
  const FoodClassPage({super.key});

  @override
  State<FoodClassPage> createState() => _FoodClassPageState();
}

class _FoodClassPageState extends State<FoodClassPage> {
  late final PageController _pageController = PageController();
  late final ScrollController _segmentScrollController = ScrollController();
  int _activeCategoryIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _segmentScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dynamic arguments = Get.arguments;
    final pageArguments = _resolveArguments(arguments);
    final categories = pageArguments.categories;
    final hasItems =
        categories.any((category) => category.data?.isNotEmpty == true);
    if (_activeCategoryIndex >= categories.length) {
      _activeCategoryIndex = 0;
    }

    return Scaffold(
      appBar: AppNavBar(title: pageArguments.title),
      body: SafeArea(
        top: false,
        bottom: false,
        child: hasItems
            ? Column(
                children: [
                  if (categories.length > 1)
                    _CategorySegmentBar(
                      categories: categories,
                      selectedIndex: _activeCategoryIndex,
                      controller: _segmentScrollController,
                      onSelected: _onSegmentTapped,
                    ),
                  Expanded(
                    child: PageView.builder(
                      key: const ValueKey('food_class_page_view'),
                      controller: _pageController,
                      onPageChanged: _onPageChanged,
                      itemCount: categories.length,
                      itemBuilder: (context, index) => _CategorySection(
                        category: categories[index],
                        onItemTap: _classConfigCook,
                      ),
                    ),
                  ),
                ],
              )
            : EmptyState.empty(
                title: 'no_data'.tr,
                description: 'no_ingredients'.tr,
              ),
      ),
    );
  }

  FoodClassPageArguments _resolveArguments(Object? arguments) {
    if (arguments is FoodClassPageArguments) {
      return arguments;
    }
    if (arguments is HomeFoodListData) {
      return FoodClassPageArguments(
        title: arguments.text ?? 'all_categories'.tr,
        categories: [arguments],
      );
    }
    return FoodClassPageArguments(
      title: 'all_categories'.tr,
      categories: [HomeFoodListData()],
    );
  }

  void _onPageChanged(int index) {
    if (index == _activeCategoryIndex) return;
    setState(() => _activeCategoryIndex = index);
    _scrollSegmentToVisible(index);
  }

  void _onSegmentTapped(int index) {
    if (index == _activeCategoryIndex) return;
    setState(() => _activeCategoryIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    _scrollSegmentToVisible(index);
  }

  void _scrollSegmentToVisible(int index) {
    if (!_segmentScrollController.hasClients) return;
    final estimatedOffset = (index * 88.0) - 50.0;
    final maxScroll = _segmentScrollController.position.maxScrollExtent;
    _segmentScrollController.animateTo(
      estimatedOffset.clamp(0.0, maxScroll < 0 ? 0.0 : maxScroll),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _classConfigCook(FoodSubData data) {
    Get.toNamed(RouteNames.cookConfig, arguments: {
      'methodName': 'CategorySearch',
      'version': '4.3.2',
      'cat_id': data.id,
      'type': data.type,
    });
  }
}

class _CategorySegmentBar extends StatelessWidget {
  final List<HomeFoodListData> categories;
  final int selectedIndex;
  final ScrollController controller;
  final ValueChanged<int> onSelected;

  const _CategorySegmentBar({
    required this.categories,
    required this.selectedIndex,
    required this.controller,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: const ValueKey('food_class_segment_bar'),
      height: 52,
      child: ListView.separated(
        controller: controller,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(
          CookTokens.pagePadding,
          8,
          CookTokens.pagePadding,
          8,
        ),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final label = category.text?.trim().isNotEmpty == true
              ? category.text!
              : 'all_categories'.tr;

          if (index == selectedIndex) {
            return CookChip.selected(
              key: ValueKey('food_class_segment_${index + 1}'),
              label: label,
              onTap: () => onSelected(index),
            );
          }

          return CookChip.neutral(
            key: ValueKey('food_class_segment_${index + 1}'),
            label: label,
            onTap: () => onSelected(index),
          );
        },
      ),
    );
  }
}

class _CategorySection extends StatelessWidget {
  final HomeFoodListData category;
  final ValueChanged<FoodSubData> onItemTap;

  const _CategorySection({
    required this.category,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = category.data ?? const <FoodSubData>[];
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        CookTokens.pagePadding,
        12,
        CookTokens.pagePadding,
        32,
      ),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                category.text ?? 'all_categories'.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            Text(
              'category_item_count'.trArgs([items.length.toString()]),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: 8),
        for (final item in items) ...[
          CookCard(
            padding: const EdgeInsets.all(10),
            borderRadius: CookTokens.listCardRadius,
            onTap: () => onItemTap(item),
            child: Row(
              children: [
                AppNetworkImage(
                  url: item.image,
                  width: 88,
                  height: 64,
                  borderRadius: BorderRadius.circular(CookTokens.radiusMd),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.text ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}
