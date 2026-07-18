import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';

enum _CookChipVariant { neutral, selected, warning, danger }

/// CookFun V6 状态标签。
///
/// 用于食材类型、筛选分段、缺料提示和危险状态，固定高度避免列表布局跳动。
class CookChip extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final _CookChipVariant _variant;

  /// Parameters:
  /// - [label]: 标签文案。
  /// - [onTap]: 可选点击回调。
  /// - [icon]: 可选前置图标。
  const CookChip.neutral({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
  }) : _variant = _CookChipVariant.neutral;

  /// Parameters:
  /// - [label]: 标签文案。
  /// - [onTap]: 可选点击回调。
  /// - [icon]: 可选前置图标。
  const CookChip.selected({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
  }) : _variant = _CookChipVariant.selected;

  /// Parameters:
  /// - [label]: 标签文案。
  /// - [onTap]: 可选点击回调。
  /// - [icon]: 可选前置图标。
  const CookChip.warning({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
  }) : _variant = _CookChipVariant.warning;

  /// Parameters:
  /// - [label]: 标签文案。
  /// - [onTap]: 可选点击回调。
  /// - [icon]: 可选前置图标。
  const CookChip.danger({
    super.key,
    required this.label,
    this.onTap,
    this.icon,
  }) : _variant = _CookChipVariant.danger;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fillColor = _fillColor(theme);
    final foregroundColor = _foregroundColor(theme);

    return SizedBox(
      height: CookTokens.chipHeight,
      child: Container(
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(CookTokens.pillRadius),
          border: Border.all(color: _borderColor(theme)),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(CookTokens.pillRadius),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 15, color: foregroundColor),
                    const SizedBox(width: 6),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: foregroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color _fillColor(ThemeData theme) {
    return switch (_variant) {
      _CookChipVariant.neutral => theme.colorScheme.surface,
      _CookChipVariant.selected => theme.colorScheme.primaryContainer,
      _CookChipVariant.warning => theme.colorScheme.secondaryContainer,
      _CookChipVariant.danger => theme.colorScheme.errorContainer,
    };
  }

  Color _foregroundColor(ThemeData theme) {
    return switch (_variant) {
      _CookChipVariant.neutral => theme.colorScheme.onSurface,
      _CookChipVariant.selected => theme.colorScheme.onPrimaryContainer,
      _CookChipVariant.warning => theme.colorScheme.onSecondaryContainer,
      _CookChipVariant.danger => theme.colorScheme.onErrorContainer,
    };
  }

  Color _borderColor(ThemeData theme) {
    return switch (_variant) {
      _CookChipVariant.neutral => theme.colorScheme.outline,
      _CookChipVariant.selected =>
        theme.colorScheme.primary.withValues(alpha: 0.28),
      _CookChipVariant.warning =>
        theme.colorScheme.secondary.withValues(alpha: 0.28),
      _CookChipVariant.danger =>
        theme.colorScheme.error.withValues(alpha: 0.28),
    };
  }
}
