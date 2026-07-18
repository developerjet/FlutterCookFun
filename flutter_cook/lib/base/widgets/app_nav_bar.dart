import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_theme.dart';

/// 应用统一导航栏。
class AppNavBar extends StatelessWidget implements PreferredSizeWidget {
  static const double height = 56;
  static const double _centerTitleSideInset = 104;

  final String title;
  final Widget? titleWidget;
  final Widget? leading;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final double? titleSpacing;

  /// 创建统一导航栏。
  ///
  /// 参数：
  /// - [title]: 单行页面标题。
  /// - [titleWidget]: 可选的自定义标题控件，用于搜索等交互式导航栏。
  /// - [leading]: 可选的自定义返回控件。
  /// - [actions]: 页面操作控件。
  /// - [automaticallyImplyLeading]: 是否自动展示返回按钮。
  /// - [centerTitle]: 是否居中显示标题。
  /// - [titleSpacing]: 非居中标题与导航栏前导区域之间的额外间距。
  const AppNavBar({
    super.key,
    required this.title,
    this.titleWidget,
    this.leading,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.centerTitle = true,
    this.titleSpacing,
  });

  @override
  Size get preferredSize => const Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.scaffoldBackgroundColor;

    return AppBar(
      key: const ValueKey('app_nav_bar'),
      toolbarHeight: height,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading,
      centerTitle: false,
      titleSpacing: titleSpacing,
      backgroundColor: backgroundColor,
      foregroundColor: theme.colorScheme.onSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: CookTheme.systemUiOverlayStyle(theme.brightness),
      title: centerTitle ? null : _buildTitle(theme),
      flexibleSpace: centerTitle
          ? Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: height,
                child: IgnorePointer(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: _centerTitleSideInset,
                    ),
                    child: Center(child: _buildTitle(theme)),
                  ),
                ),
              ),
            )
          : null,
      actions: actions,
    );
  }

  Widget _buildTitle(ThemeData theme) {
    final customTitle = titleWidget;
    if (customTitle != null) {
      return customTitle;
    }

    return Semantics(
      header: true,
      namesRoute: true,
      child: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: centerTitle ? TextAlign.center : TextAlign.start,
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Exo',
          height: 1.25,
        ),
      ),
    );
  }
}
