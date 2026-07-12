import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/language/manager.dart';
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
}

class _TabsState extends State<Tabs> {
  static const List<_TabItemData> _tabItems = [
    _TabItemData(
      labelKey: 'tab_home_title',
      iconPath: 'assets/images/tab_home_none.png',
      activeIconPath: 'assets/images/tab_home_selected.png',
      iconSize: 25,
    ),
    _TabItemData(
      labelKey: 'tab_cook_title',
      iconPath: 'assets/images/tab_cook_none.png',
      activeIconPath: 'assets/images/tab_cook_selected.png',
      iconSize: 24,
    ),
    _TabItemData(
      labelKey: 'tab_book_title',
      iconPath: 'assets/images/tab_book_none.png',
      activeIconPath: 'assets/images/tab_book_selected.png',
      iconSize: 20,
    ),
    _TabItemData(
      labelKey: 'tab_mine_title',
      iconPath: 'assets/images/tab_mine_none.png',
      activeIconPath: 'assets/images/tab_mine_selected.png',
      iconSize: 25,
    ),
  ];

  static const double _iosTabBarHeight = 74;

  late int _currentIndex;
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

    _currentIndex = widget.index;
    _handlerAppData();
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

  Future<void> _handlerAppData() async {
    // 主题/语言初始化已由 main.dart 中 AppBindings 和 ThemeManager.initialize() 处理
    final lastLanguage = await LanguageManager.fetchLastLanguage() ?? 0;
    LanguageManager.saveLanguage(lastLanguage);
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _buildIOSScaffold(context);
    }

    return Scaffold(
      bottomNavigationBar: _buildMaterialTabBar(context),
      body: _buildIndexedPages(),
    );
  }

  Widget _buildIOSScaffold(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final floatingBottom = bottomPadding > 0 ? bottomPadding : 12.0;
    final scrollBottomInset = _iosTabBarHeight + floatingBottom + 12;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          _IOS26TabContentInset(
            bottomInset: scrollBottomInset,
            child: _buildIndexedPages(),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: floatingBottom,
            child: _IOS26FloatingTabBar(
              items: _tabItems,
              currentIndex: _currentIndex,
              onTap: _handleTabTap,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaterialTabBar(BuildContext context) {
    return BottomNavigationBar(
      unselectedItemColor:
          Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
      selectedItemColor: Theme.of(context).colorScheme.primary,
      iconSize: 30,
      unselectedFontSize: 11,
      selectedFontSize: 11,
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _handleTabTap,
      items: _tabItems
          .map((item) => BottomNavigationBarItem(
                icon: Image.asset(
                  item.iconPath,
                  width: item.iconSize,
                  height: item.iconSize,
                ),
                activeIcon: Image.asset(
                  item.activeIconPath,
                  width: item.iconSize,
                  height: item.iconSize,
                ),
                label: item.labelKey.tr,
              ))
          .toList(),
    );
  }

  Widget _buildIndexedPages() {
    return IndexedStack(
      index: _currentIndex,
      children: _pages,
    );
  }

  void _handleTabTap(int index) {
    if (index == _currentIndex) {
      return;
    }

    setState(() {
      _currentIndex = index;
    });
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

class _IOS26FloatingTabBar extends StatelessWidget {
  static const double _maxWidth = 340;
  static const double _radius = 37;
  static const double _selectionHorizontalInset = 3;
  static const double _selectionVerticalInset = 6;

  final List<_TabItemData> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _IOS26FloatingTabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final backgroundColor = isDark
        ? theme.colorScheme.surface.withValues(alpha: 0.58)
        : Colors.white.withValues(alpha: 0.84);
    final borderColor =
        theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.18 : 0.08);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: _maxWidth),
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
                key: const ValueKey('ios26_floating_tab_bar'),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(_radius),
                  border: Border.all(color: borderColor),
                ),
                child: SizedBox(
                  height: _TabsState._iosTabBarHeight,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final itemWidth = constraints.maxWidth / items.length;
                        final selectionColor = isDark
                            ? Colors.white.withValues(alpha: 0.12)
                            : const Color(0xFFE9E9EB).withValues(alpha: 0.86);

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
                                  'ios26_tab_selection_pill',
                                ),
                                decoration: BoxDecoration(
                                  color: selectionColor,
                                  borderRadius: BorderRadius.circular(32),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                for (int index = 0;
                                    index < items.length;
                                    index++)
                                  Expanded(
                                    child: _IOS26TabButton(
                                      buttonKey: ValueKey('ios26_tab_$index'),
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

class _IOS26TabButton extends StatelessWidget {
  final Key buttonKey;
  final _TabItemData item;
  final bool selected;
  final VoidCallback onTap;

  const _IOS26TabButton({
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
        theme.colorScheme.onSurface.withValues(alpha: isDark ? 0.70 : 0.68);
    final iconColor = selected ? selectedColor : unselectedColor;

    return Semantics(
      selected: selected,
      button: true,
      label: item.labelKey.tr,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: buttonKey,
          borderRadius: BorderRadius.circular(32),
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
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
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
