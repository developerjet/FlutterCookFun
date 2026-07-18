import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';

/// CookFun V6 基础卡片。
///
/// 统一圆角、描边、阴影和内边距，业务页面只组合内容，不重复定义容器样式。
class CookCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;
  final double borderRadius;

  /// Parameters:
  /// - [child]: 卡片内容。
  /// - [padding]: 内容内边距。
  /// - [onTap]: 可选点击回调。
  /// - [color]: 可覆盖的背景色。
  /// - [border]: 可覆盖的边框。
  /// - [borderRadius]: 卡片圆角，列表项应使用紧凑圆角 token。
  const CookCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(CookTokens.cardPadding),
    this.onTap,
    this.color,
    this.border,
    this.borderRadius = CookTokens.cardRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final decoration = BoxDecoration(
      color: color ?? theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      border: border ?? Border.all(color: theme.colorScheme.outline),
      boxShadow: CookTokens.cardShadow(theme.brightness),
    );

    return DecoratedBox(
      decoration: decoration,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }
}
