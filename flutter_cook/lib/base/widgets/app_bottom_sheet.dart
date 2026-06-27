import 'package:flutter/material.dart';

/// 统一底部弹窗 — 顶部圆角 + 底部安全区适配
class AppBottomSheet extends StatelessWidget {
  final List<Widget> children;

  const AppBottomSheet({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).bottomSheetTheme.backgroundColor ??
            Theme.of(context).cardColor,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          ...children,
          SizedBox(height: bottom > 0 ? bottom : 16),
        ],
      ),
    );
  }

  /// 弹出底部弹窗
  static Future<T?> show<T>(BuildContext context,
      {required List<Widget> children}) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => AppBottomSheet(children: children),
    );
  }
}

/// 底部弹窗操作项
class AppSheetAction extends StatelessWidget {
  final IconData? icon;
  final String label;
  final VoidCallback? onTap;
  final bool isDestructive;
  final Widget? trailing;

  const AppSheetAction({
    super.key,
    this.icon,
    required this.label,
    this.onTap,
    this.isDestructive = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final fgColor = isDestructive
        ? Theme.of(context).colorScheme.error
        : Theme.of(context).textTheme.bodyLarge?.color;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22, color: fgColor),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(label,
                  textAlign: icon == null && trailing == null
                      ? TextAlign.center
                      : TextAlign.start,
                  style: TextStyle(fontSize: 16, color: fgColor)),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
