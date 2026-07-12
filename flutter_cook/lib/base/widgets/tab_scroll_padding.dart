import 'package:flutter/widgets.dart';

/// 为 Tab 内显式设置 padding 的滚动组件叠加底部安全区。
///
/// [context] 当前构建上下文。
/// [basePadding] 组件原有滚动内边距。
///
/// Returns: 合并浮动 TabBar / 系统安全区后的滚动内边距。
EdgeInsets resolveTabScrollPadding(
  BuildContext context,
  EdgeInsets basePadding,
) {
  final mediaQuery = MediaQuery.of(context);
  final bottomInset = mediaQuery.padding.bottom > mediaQuery.viewPadding.bottom
      ? mediaQuery.padding.bottom
      : mediaQuery.viewPadding.bottom;
  return basePadding.copyWith(bottom: basePadding.bottom + bottomInset);
}
