import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_button.dart';

/// 统一弹窗组件，负责主题适配、操作布局和危险语义。
class AppDialog {
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CookTokens.dialogRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.headlineSmall,
              ),
              if (content.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 24),
              Row(
                children: [
                  if (cancelText != null) ...[
                    Expanded(
                      child: CookButton.context(
                        label: cancelText,
                        onPressed: () {
                          Navigator.pop(ctx, false);
                          onCancel?.call();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: isDestructive
                        ? CookButton.danger(
                            label: confirmText ?? 'OK',
                            onPressed: () {
                              Navigator.pop(ctx, true);
                              onConfirm?.call();
                            },
                          )
                        : CookButton.hero(
                            label: confirmText ?? 'OK',
                            onPressed: () {
                              Navigator.pop(ctx, true);
                              onConfirm?.call();
                            },
                          ),
                  ),
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CookTokens.dialogRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 30, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(ctx).textTheme.headlineSmall,
              ),
              if (content.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  content,
                  textAlign: TextAlign.center,
                  style: Theme.of(ctx).textTheme.bodyMedium,
                ),
              ],
              const SizedBox(height: 24),
              CookButton.hero(
                label: actionText ?? 'OK',
                onPressed: () {
                  Navigator.pop(ctx);
                  onAction?.call();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
