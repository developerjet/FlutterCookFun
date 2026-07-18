import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';

/// 设置首页导航卡。
class SettingNavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;
  final VoidCallback onTap;

  /// 参数：
  /// - [title]: 入口标题。
  /// - [subtitle]: 入口说明。
  /// - [icon]: 入口图标。
  /// - [foregroundColor]: 图标前景色。
  /// - [backgroundColor]: 图标背景色。
  /// - [onTap]: 导航回调。
  const SettingNavigationCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CookCard(
      padding: const EdgeInsets.all(16),
      borderRadius: CookTokens.listCardRadius,
      onTap: onTap,
      child: Row(
        children: [
          _SettingIcon(
            icon: icon,
            foregroundColor: foregroundColor,
            backgroundColor: backgroundColor,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _SettingText(title: title, subtitle: subtitle),
          ),
          const SizedBox(width: 10),
          Image.asset(
            CookAssets.iconArrowRight,
            width: 18,
            height: 18,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}

/// 设置项选择卡。
class SettingChoiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final Future<void> Function() onTap;

  /// 参数：
  /// - [title]: 选项标题。
  /// - [subtitle]: 选项说明。
  /// - [icon]: 选项图标。
  /// - [selected]: 是否为当前选择。
  /// - [onTap]: 选择回调。
  const SettingChoiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return CookCard(
      padding: const EdgeInsets.all(16),
      borderRadius: CookTokens.listCardRadius,
      color: selected ? colorScheme.primaryContainer : colorScheme.surface,
      border: Border.all(
        color: selected
            ? colorScheme.primary.withValues(alpha: 0.36)
            : colorScheme.outline,
      ),
      onTap: onTap,
      child: Row(
        children: [
          _SettingIcon(
            icon: icon,
            foregroundColor:
                selected ? colorScheme.primary : colorScheme.onSurfaceVariant,
            backgroundColor: selected
                ? colorScheme.surface.withValues(alpha: 0.72)
                : colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: _SettingText(title: title, subtitle: subtitle),
          ),
          const SizedBox(width: 10),
          if (selected)
            Image.asset(
              CookAssets.iconCheck,
              width: 24,
              height: 24,
            )
          else
            Icon(
              Icons.circle_outlined,
              size: 24,
              color: colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}

/// 设置操作错误提示。
class SettingErrorView extends StatelessWidget {
  final String message;

  /// 参数：
  /// - [message]: 可直接展示给用户的错误信息。
  const SettingErrorView({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(CookTokens.cardRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
        ),
      ),
    );
  }
}

class _SettingIcon extends StatelessWidget {
  final IconData icon;
  final Color foregroundColor;
  final Color backgroundColor;

  const _SettingIcon({
    required this.icon,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(CookTokens.controlRadius),
      ),
      child: Icon(icon, size: 22, color: foregroundColor),
    );
  }
}

class _SettingText extends StatelessWidget {
  final String title;
  final String subtitle;

  const _SettingText({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
