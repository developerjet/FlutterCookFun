import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_cook/base/controller/tab_navigation_controller.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:get/get.dart';

import '../module/home/home_data_page.dart';
import '../module/cook/cook_home_page.dart';
import '../module/book/book_home_page.dart';
import '../module/mine/mine_page.dart';

class Tabs extends StatefulWidget {
  final int index;
  final List<Widget>? pages;

  const Tabs({
    super.key,
    this.index = 0,
    this.pages,
  }) : assert(pages == null || pages.length == 4);

  @override
  State<Tabs> createState() => _TabsState();

  static int resolveInitialIndex({
    required int widgetIndex,
    required Object? routeArguments,
    required int pageCount,
  }) {
    final requestedIndex = routeArguments is int ? routeArguments : widgetIndex;
    if (requestedIndex < 0 || requestedIndex >= pageCount) {
      return widgetIndex.clamp(0, pageCount - 1);
    }
    return requestedIndex;
  }
}

class _TabsState extends State<Tabs> {
  static const double _tabIconSize = 24;
  static const List<_TabItemData> _tabItems = [
    _TabItemData(
      labelKey: 'tab_home_title',
      iconPath: CookAssets.tabHome,
      activeIconPath: CookAssets.tabHomeActive,
      iconSize: _tabIconSize,
    ),
    _TabItemData(
      labelKey: 'tab_cook_title',
      iconPath: CookAssets.tabCook,
      activeIconPath: CookAssets.tabCookActive,
      iconSize: _tabIconSize,
    ),
    _TabItemData(
      labelKey: 'tab_book_title',
      iconPath: CookAssets.tabRecipe,
      activeIconPath: CookAssets.tabRecipeActive,
      iconSize: _tabIconSize,
    ),
    _TabItemData(
      labelKey: 'tab_mine_title',
      iconPath: CookAssets.tabMine,
      activeIconPath: CookAssets.tabMineActive,
      iconSize: _tabIconSize,
    ),
  ];

  static const double _tabBarHeight = CookTokens.tabBarHeight;

  late final TabNavigationController _navigationController;
  bool _didPrecacheTabIcons = false;

  late final List<Widget> _pages = widget.pages ??
      [
        const HomePage(),
        const CookPage(),
        const BookPage(),
        const MinePage(),
      ];

  @override
  void initState() {
    super.initState();

    _navigationController = Get.isRegistered<TabNavigationController>()
        ? Get.find<TabNavigationController>()
        : Get.put(TabNavigationController());
    final initialIndex = Tabs.resolveInitialIndex(
      widgetIndex: widget.index,
      routeArguments: Get.arguments,
      pageCount: _tabItems.length,
    );
    if (Get.arguments is int ||
        widget.index != TabNavigationController.homeIndex) {
      _navigationController.select(initialIndex);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_didPrecacheTabIcons) {
      return;
    }
    _didPrecacheTabIcons = true;
    for (final item in _tabItems) {
      precacheImage(AssetImage(item.iconPath), context);
      precacheImage(AssetImage(item.activeIconPath), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => _buildScaffold(
        context,
        _navigationController.currentIndex.value,
      ),
    );
  }

  Widget _buildScaffold(BuildContext context, int currentIndex) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final floatingBottom = bottomPadding > 0 ? bottomPadding : 12.0;
    final scrollBottomInset = _tabBarHeight + floatingBottom + 12;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _IOS26TabContentInset(
            bottomInset: scrollBottomInset,
            child: _buildIndexedPages(currentIndex),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: floatingBottom,
            child: _CookFloatingTabBar(
              items: _tabItems,
              currentIndex: currentIndex,
              onTap: _handleTabTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndexedPages(int currentIndex) {
    return IndexedStack(
      index: currentIndex,
      children: _pages,
    );
  }

  void _handleTabTap(int index) {
    _navigationController.select(index);
  }
}

class _IOS26TabContentInset extends StatelessWidget {
  final double bottomInset;
  final Widget child;

  const _IOS26TabContentInset({
    required this.bottomInset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final currentPadding = mediaQuery.padding;
    final currentViewPadding = mediaQuery.viewPadding;
    final effectiveBottomPadding = currentPadding.bottom > bottomInset
        ? currentPadding.bottom
        : bottomInset;
    final effectiveBottomViewPadding = currentViewPadding.bottom > bottomInset
        ? currentViewPadding.bottom
        : bottomInset;

    return MediaQuery(
      data: mediaQuery.copyWith(
        padding: currentPadding.copyWith(bottom: effectiveBottomPadding),
        viewPadding:
            currentViewPadding.copyWith(bottom: effectiveBottomViewPadding),
      ),
      child: child,
    );
  }
}

class _TabItemData {
  final String labelKey;
  final String iconPath;
  final String activeIconPath;
  final double iconSize;

  const _TabItemData({
    required this.labelKey,
    required this.iconPath,
    required this.activeIconPath,
    required this.iconSize,
  });
}

class _CookFloatingTabBar extends StatelessWidget {
  static const double _maxWidth = 340;
  static const double _radius = CookTokens.navigationRadius;
  static const double _selectionHorizontalInset = 3;
  static const double _selectionVerticalInset = 6;

  final List<_TabItemData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _CookFloatingTabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? theme.colorScheme.surface.withValues(alpha: 0.76)
        : Colors.white.withValues(alpha: 0.92);
    final borderColor =
        theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.16 : 0.08);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: _maxWidth,
          minHeight: CookTokens.tabBarHeight,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(_radius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.10),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(_radius),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 26, sigmaY: 26),
              child: DecoratedBox(
                key: const ValueKey('cook_floating_tab_bar'),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(_radius),
                  border: Border.all(color: borderColor),
                ),
                child: SizedBox(
                  height: _TabsState._tabBarHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = constraints.maxWidth / items.length;
                        final selectionColor =
                            theme.colorScheme.primaryContainer;

                        return Stack(
                          children: [
                            AnimatedPositioned(
                              duration: const Duration(milliseconds: 280),
                              curve: Curves.easeInOutSine,
                              left: itemWidth * currentIndex +
                                  _selectionHorizontalInset,
                              top: _selectionVerticalInset,
                              bottom: _selectionVerticalInset,
                              width: itemWidth - _selectionHorizontalInset * 2,
                              child: DecoratedBox(
                                key: const ValueKey(
                                  'cook_tab_selection_pill',
                                ),
                                decoration: BoxDecoration(
                                  color: selectionColor,
                                  borderRadius: BorderRadius.circular(
                                    CookTokens.pillRadius,
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                for (int index = 0;
                                    index < items.length;
                                    index++)
                                  Expanded(
                                    child: _CookTabButton(
                                      buttonKey: ValueKey('cook_tab_$index'),
                                      item: items[index],
                                      selected: index == currentIndex,
                                      onTap: () => onTap(index),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CookTabButton extends StatelessWidget {
  final Key buttonKey;
  final _TabItemData item;
  final bool selected;
  final VoidCallback onTap;

  const _CookTabButton({
    required this.buttonKey,
    required this.item,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final selectedColor = theme.colorScheme.primary;
    final unselectedColor =
        theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.66 : 0.58);
    final iconColor = selected ? selectedColor : unselectedColor;

    return Semantics(
      selected: selected,
      button: true,
      label: item.labelKey.tr,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: buttonKey,
          borderRadius: BorderRadius.circular(CookTokens.pillRadius),
          splashColor: selectedColor.withValues(alpha: 0.10),
          highlightColor: selectedColor.withValues(alpha: 0.06),
          onTap: onTap,
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  selected ? item.activeIconPath : item.iconPath,
                  width: item.iconSize,
                  height: item.iconSize,
                  color: iconColor,
                ),
                const SizedBox(height: 4),
                Text(
                  item.labelKey.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? selectedColor : unselectedColor,
                    fontSize: 10.5,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
