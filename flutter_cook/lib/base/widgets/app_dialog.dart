import 'package:flutter/material.dart';

/// 统一弹窗组件 — 主题适配，按钮左右排列、半高圆角（胶囊形）
class AppDialog {
  static const double _buttonHeight = 44;
  static const double _buttonRadius = _buttonHeight / 2;

  /// 双按钮确认弹窗
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDestructive = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (content.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  if (cancelText != null) ...[
                    Expanded(child: _buildButton(ctx, text: cancelText, isPrimary: false,
                        onTap: () { Navigator.pop(ctx, false); onCancel?.call(); })),
                    const SizedBox(width: 12),
                  ],
                  Expanded(child: _buildButton(ctx, text: confirmText ?? 'OK', isPrimary: true,
                      onTap: () { Navigator.pop(ctx, true); onConfirm?.call(); })),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 单按钮提示弹窗
  static Future<void> alert(
    BuildContext context, {
    required String title,
    required String content,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return showDialog(
      context: context,
      builder: (ctx) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              if (content.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: _buildButton(ctx, text: actionText ?? 'OK', isPrimary: true,
                    onTap: () { Navigator.pop(ctx); onAction?.call(); }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildButton(
    BuildContext ctx, {
    required String text,
    required VoidCallback onTap,
    bool isPrimary = true,
  }) {
    return SizedBox(
      height: _buttonHeight,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              isPrimary ? Theme.of(ctx).colorScheme.primary : Colors.transparent,
          foregroundColor: isPrimary
              ? Colors.white
              : Theme.of(ctx).colorScheme.outline,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_buttonRadius),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(color: Theme.of(ctx).colorScheme.outline),
          ),
          padding: EdgeInsets.zero,
        ),
        child: Text(
          text,
          style: Theme.of(ctx).textTheme.labelLarge,
        ),
      ),
    );
  }
}
