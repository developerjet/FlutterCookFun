import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/base/controller/tab_navigation_controller.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/base/widgets/app_refresh.dart';
import 'package:flutter_cook/base/widgets/tab_scroll_padding.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_button.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_cook/design_system/widgets/cook_chip.dart';
import 'package:flutter_cook/design_system/widgets/cook_icon_button.dart';
import 'package:flutter_cook/module/home/controller/home_controller.dart';
import 'package:flutter_cook/module/home/model/home_banner_model.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';
import 'package:flutter_cook/module/home/views/home_data_cell.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  static const Duration heroRotationInterval = Duration(seconds: 8);

  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final HomeController controller = Get.find<HomeController>();
  Timer? _heroRotationTimer;
  int _heroIndex = 0;
  int _heroRecommendationCount = 0;

  @override
  void initState() {
    super.initState();
    _heroRotationTimer = Timer.periodic(
      HomePage.heroRotationInterval,
      (_) => _advanceHero(),
    );
  }

  @override
  void dispose() {
    _heroRotationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'home_page_title'.tr,
        automaticallyImplyLeading: false,
        centerTitle: false,
        actions: [
          CookIconButton.asset(
            key: const ValueKey('home_nav_search'),
            tooltip: 'search'.tr,
            assetPath: CookAssets.iconSearch,
            foregroundColor: Theme.of(context).colorScheme.primary,
            onPressed: _openSearch,
          ),
          const SizedBox(width: CookTokens.pagePadding),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return EmptyState.loading(title: 'loading'.tr);
          }

          if (controller.errorMessage.value != null) {
            return EmptyState.error(
              title: 'load_failed'.tr,
              description: controller.errorMessage.value,
              onRetry: () => controller.retryLoadData(),
            );
          }

          final bannerList = _validBannerList();
          final dataList = controller.listData.value?.data ?? [];

          if (dataList.isEmpty) {
            return EmptyState.empty(
              title: 'no_recipes'.tr,
              description: 'no_recipe_data'.tr,
              onRefresh: () => controller.refreshData(),
              showRefreshButton: true,
            );
          }

          final recommendations = _buildHeroRecommendations(
            bannerList,
            dataList,
          );
          _heroRecommendationCount = recommendations.length;
          final recommendation =
              recommendations[_heroIndex % recommendations.length];
          final primaryCategory = dataList.firstOrNull;
          final secondaryCategory = dataList.length > 1 ? dataList[1] : null;
          return AppRefresh(
            onRefresh: controller.refreshData,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(
                    CookTokens.pagePadding,
                    12,
                    CookTokens.pagePadding,
                    0,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _SearchEntry(onTap: _openSearch),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CookTokens.pagePadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 420),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      child: _DecisionHeroCard(
                        key: ValueKey(recommendation.id),
                        recommendation: recommendation,
                        onPrimaryTap: _openCook,
                        onSecondaryTap: _advanceHero,
                        onBannerTap: () => _handleHeroTap(recommendation),
                      ),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CookTokens.pagePadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: _QuickDecisionGrid(
                      first: primaryCategory,
                      second: secondaryCategory,
                      onTap: _skipClassPage,
                      onAllTap: () => _openAllCategories(dataList),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 18)),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: CookTokens.pagePadding,
                  ),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: [
                        Text(
                          'home_inspiration_title'.tr,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        CookChip.neutral(
                          key: const ValueKey('home_inspiration_all'),
                          label: 'all'.tr,
                          onTap: () => _openAllCategories(dataList),
                        ),
                      ],
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 8)),
                SliverPadding(
                  padding: resolveTabScrollPadding(
                    context,
                    const EdgeInsets.only(bottom: 8),
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final item = dataList[index];
                        return HomeDataCell(
                          model: item,
                          onTap: () => _skipClassPage(item),
                        );
                      },
                      childCount: dataList.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<ModuleData> _validBannerList() {
    final rawBannerList = controller
            .bannerData.value?.data?.moduleList?.firstOrNull?.moduleData ??
        [];
    return rawBannerList.where((item) {
      final picture = item.bannerPicture?.trim();
      return picture != null && picture.isNotEmpty && picture != 'null';
    }).toList();
  }

  List<_HeroRecommendation> _buildHeroRecommendations(
    List<ModuleData> banners,
    List<HomeFoodListData> categories,
  ) {
    final recommendations = <_HeroRecommendation>[];

    for (final banner in banners) {
      final imageUrl = banner.bannerPicture?.trim();
      if (imageUrl == null ||
          imageUrl.isEmpty ||
          imageUrl == CookAssets.bannerPlaceholder) {
        continue;
      }
      recommendations.add(
        _HeroRecommendation(
          id: 'banner-${banner.id ?? imageUrl}',
          imageUrl: imageUrl,
          title: banner.bannerTitle?.trim().isNotEmpty == true
              ? banner.bannerTitle!
              : 'home_default_dinner'.tr,
          banner: banner,
        ),
      );
    }

    for (final category in categories) {
      final imageUrl = category.image?.trim();
      if (imageUrl == null || imageUrl.isEmpty) {
        continue;
      }
      recommendations.add(
        _HeroRecommendation(
          id: 'category-${category.id ?? imageUrl}',
          imageUrl: imageUrl,
          title: category.text?.trim().isNotEmpty == true
              ? category.text!
              : 'home_default_dinner'.tr,
          category: category,
        ),
      );
    }

    if (recommendations.isEmpty) {
      recommendations.add(
        _HeroRecommendation(
          id: 'fallback',
          imageUrl: CookAssets.bannerPlaceholder,
          title: 'home_default_dinner'.tr,
        ),
      );
    }
    return recommendations;
  }

  void _advanceHero() {
    if (!mounted || _heroRecommendationCount <= 1) {
      return;
    }
    setState(() {
      _heroIndex = (_heroIndex + 1) % _heroRecommendationCount;
    });
  }

  void _handleHeroTap(_HeroRecommendation recommendation) {
    final banner = recommendation.banner;
    if (banner != null) {
      _handleBannerTap(banner);
      return;
    }
    final category = recommendation.category;
    if (category != null) {
      _skipClassPage(category);
      return;
    }
    _openCook();
  }

  void _openSearch() {
    Get.toNamed(RouteNames.search);
  }

  void _openCook() {
    Get.find<TabNavigationController>().select(
      TabNavigationController.cookIndex,
    );
  }

  void _handleBannerTap(ModuleData? banner) {
    if (banner == null) {
      _openCook();
      return;
    }

    final link = banner.bannerLink ?? '';
    if (link.isEmpty) return;

    if (link.startsWith('app://dish')) {
      final dishesId = Uri.parse(link).queryParameters['id'] ?? '';
      if (dishesId.isEmpty) return;
      Get.toNamed(RouteNames.cookSteps, arguments: {
        'dishes_id': dishesId,
        'pushPage': 'home',
      });
    } else if (link.startsWith('app://series')) {
      final seriesId = Uri.parse(link).queryParameters['id'] ?? '';
      if (seriesId.isEmpty) return;
      Get.toNamed(RouteNames.bookDetail, arguments: {
        'scene_id': seriesId,
        'title': banner.bannerTitle,
      });
    } else if (link.startsWith('http')) {
      Get.toNamed(RouteNames.web, arguments: {
        'url': link,
        'title': banner.bannerTitle,
      });
    }
  }

  void _skipClassPage(HomeFoodListData data) {
    Get.toNamed(
      RouteNames.foodClass,
      arguments: FoodClassPageArguments(
        title: data.text ?? 'all_categories'.tr,
        categories: [data],
      ),
    );
  }

  void _openAllCategories(List<HomeFoodListData> categories) {
    if (categories.isEmpty) return;
    Get.toNamed(
      RouteNames.foodClass,
      arguments: FoodClassPageArguments(
        title: 'all_categories'.tr,
        categories: categories,
      ),
    );
  }
}

class _SearchEntry extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchEntry({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      key: const ValueKey('home_search_entry'),
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(CookTokens.pillRadius),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CookTokens.pillRadius),
            border: Border.all(color: Theme.of(context).colorScheme.outline),
          ),
          child: Row(
            children: [
              Image.asset(
                CookAssets.iconSearch,
                width: 20,
                height: 20,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'home_search_placeholder'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecisionHeroCard extends StatelessWidget {
  final _HeroRecommendation recommendation;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;
  final VoidCallback onBannerTap;

  const _DecisionHeroCard({
    super.key,
    required this.recommendation,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
    required this.onBannerTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrl = recommendation.imageUrl;

    return ClipRRect(
      borderRadius: BorderRadius.circular(CookTokens.heroCardRadius),
      child: SizedBox(
        height: 220,
        child: Stack(
          fit: StackFit.expand,
          children: [
            imageUrl.startsWith('assets/')
                ? Image.asset(imageUrl, fit: BoxFit.cover)
                : AppNetworkImage(url: imageUrl, fit: BoxFit.cover),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    CookTokens.primary.withValues(alpha: 0.86),
                    CookTokens.primaryDeep.withValues(alpha: 0.58),
                    CookTokens.warm.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(onTap: onBannerTap),
            ),
            Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  CookChip.neutral(label: 'home_dinner_match'.tr),
                  const SizedBox(height: 12),
                  Text(
                    recommendation.title,
                    key: const ValueKey('home_hero_title'),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CookButton.context(
                          label: 'home_replace'.tr,
                          onPressed: onSecondaryTap,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CookButton.hero(
                          label: 'home_choose_ingredients'.tr,
                          onPressed: onPrimaryTap,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroRecommendation {
  final String id;
  final String imageUrl;
  final String title;
  final ModuleData? banner;
  final HomeFoodListData? category;

  const _HeroRecommendation({
    required this.id,
    required this.imageUrl,
    required this.title,
    this.banner,
    this.category,
  });
}

class _QuickDecisionGrid extends StatelessWidget {
  final HomeFoodListData? first;
  final HomeFoodListData? second;
  final ValueChanged<HomeFoodListData> onTap;
  final VoidCallback onAllTap;

  const _QuickDecisionGrid({
    required this.first,
    required this.second,
    required this.onTap,
    required this.onAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _QuickDecisionItem(
        title: first?.text ?? 'home_leftovers'.tr,
        subtitle: 'home_leftovers_desc'.tr,
        count: first?.data?.length ?? 0,
        color: Theme.of(context).colorScheme.primaryContainer,
        source: first,
      ),
      _QuickDecisionItem(
        title: second?.text ?? 'home_low_calorie'.tr,
        subtitle: 'home_low_calorie_desc'.tr,
        count: second?.data?.length ?? 0,
        color: Theme.of(context).colorScheme.secondaryContainer,
        source: second,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'home_quick_decision'.tr,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(width: 8),
            CookChip.neutral(
              key: const ValueKey('home_quick_all'),
              label: 'all'.tr,
              onTap: onAllTap,
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            for (var index = 0; index < items.length; index++) ...[
              Expanded(
                child: _QuickDecisionCard(
                  item: items[index],
                  onTap: items[index].source == null
                      ? null
                      : () => onTap(items[index].source!),
                ),
              ),
              if (index != items.length - 1) const SizedBox(width: 12),
            ],
          ],
        ),
      ],
    );
  }
}

class _QuickDecisionItem {
  final String title;
  final String subtitle;
  final int count;
  final Color color;
  final HomeFoodListData? source;

  const _QuickDecisionItem({
    required this.title,
    required this.subtitle,
    required this.count,
    required this.color,
    required this.source,
  });
}

class _QuickDecisionCard extends StatelessWidget {
  final _QuickDecisionItem item;
  final VoidCallback? onTap;

  const _QuickDecisionCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CookCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 72,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  item.color,
                  Theme.of(context).colorScheme.primaryContainer,
                ],
              ),
            ),
            alignment: Alignment.bottomLeft,
            child: Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  item.count > 0
                      ? 'dish_count_short'.trArgs([item.count.toString()])
                      : 'quick_entry'.tr,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
