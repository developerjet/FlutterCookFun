import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';

enum _CookButtonVariant { hero, context, danger, ghost }

/// CookFun V6 标准按钮。
///
/// 高优先级、上下文、危险和幽灵按钮必须使用固定高度，防止不同页面按钮比例漂移。
class CookButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final _CookButtonVariant _variant;

  /// 参数：
  /// - [label]: 按钮文案。
  /// - [onPressed]: 点击回调，null 时进入禁用态。
  /// - [icon]: 可选前置图标。
  const CookButton.hero({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _variant = _CookButtonVariant.hero;

  /// 参数：
  /// - [label]: 按钮文案。
  /// - [onPressed]: 点击回调，null 时进入禁用态。
  /// - [icon]: 可选前置图标。
  const CookButton.context({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _variant = _CookButtonVariant.context;

  /// 参数：
  /// - [label]: 按钮文案。
  /// - [onPressed]: 点击回调，null 时进入禁用态。
  /// - [icon]: 可选前置图标。
  const CookButton.danger({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _variant = _CookButtonVariant.danger;

  /// 参数：
  /// - [label]: 按钮文案。
  /// - [onPressed]: 点击回调，null 时进入禁用态。
  /// - [icon]: 可选前置图标。
  const CookButton.ghost({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  }) : _variant = _CookButtonVariant.ghost;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;
    final height = switch (_variant) {
      _CookButtonVariant.hero => CookTokens.heroButtonHeight,
      _CookButtonVariant.context => CookTokens.contextButtonHeight,
      _CookButtonVariant.danger => CookTokens.dangerButtonHeight,
      _CookButtonVariant.ghost => CookTokens.contextButtonHeight,
    };
    final fillColor = _fillColor(theme, enabled);
    final textColor = _textColor(theme, enabled);

    return SizedBox(
      width: double.infinity,
      height: height,
      child: Material(
        color: fillColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(CookTokens.controlRadius),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          splashColor: textColor.withValues(alpha: 0.10),
          highlightColor: textColor.withValues(alpha: 0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18, color: textColor),
                  const SizedBox(width: 8),
                ],
                Flexible(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _fillColor(ThemeData theme, bool enabled) {
    if (!enabled) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.08);
    }

    return switch (_variant) {
      _CookButtonVariant.hero => theme.colorScheme.primary,
      _CookButtonVariant.context => theme.colorScheme.primaryContainer,
      _CookButtonVariant.danger => theme.colorScheme.error,
      _CookButtonVariant.ghost => Colors.transparent,
    };
  }

  Color _textColor(ThemeData theme, bool enabled) {
    if (!enabled) {
      return theme.colorScheme.onSurface.withValues(alpha: 0.36);
    }

    return switch (_variant) {
      _CookButtonVariant.hero => theme.colorScheme.onPrimary,
      _CookButtonVariant.context => theme.colorScheme.onPrimaryContainer,
      _CookButtonVariant.danger => theme.colorScheme.onError,
      _CookButtonVariant.ghost => theme.colorScheme.primary,
    };
  }
}
