import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_button.dart';
import 'package:get/get.dart';

/// 空状态视图类型枚举
enum EmptyStateType {
  /// 数据为空
  empty,

  /// 加载中
  loading,

  /// 加载失败
  error,
}

/// 统一的占位符/空状态视图组件
///
/// 用于显示以下场景：
/// - 数据为空时的占位图
/// - 加载中的进度指示器
/// - 加载失败的错误提示
class EmptyStateView extends StatelessWidget {
  /// 空状态类型
  final EmptyStateType type;

  /// 自定义图标 (仅在 type=empty 时有效)
  final IconData? icon;

  /// 标题文本
  final String? title;

  /// 描述文本
  final String? description;

  /// 主按钮文案 (默认"重试" / "刷新")
  final String? actionButtonText;

  /// 主按钮回调
  final VoidCallback? onAction;

  /// 自定义主按钮样式
  final ButtonStyle? actionButtonStyle;

  /// 副按钮文案
  final String? secondaryButtonText;

  /// 副按钮回调
  final VoidCallback? onSecondaryAction;

  /// 是否显示副按钮
  final bool showSecondaryButton;

  /// 自定义内容部件（可完全替代默认布局）
  final Widget? customContent;

  /// 背景颜色
  final Color? backgroundColor;

  /// 顶部间距
  final double topPadding;

  /// 底部间距
  final double bottomPadding;

  const EmptyStateView({
    Key? key,
    this.type = EmptyStateType.empty,
    this.icon,
    this.title,
    this.description,
    this.actionButtonText,
    this.onAction,
    this.actionButtonStyle,
    this.secondaryButtonText,
    this.onSecondaryAction,
    this.showSecondaryButton = false,
    this.customContent,
    this.backgroundColor,
    this.topPadding = 60,
    this.bottomPadding = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 如果提供了自定义内容，直接使用
    if (customContent != null) {
      return customContent!;
    }

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            top: topPadding,
            bottom: bottomPadding,
            left: CookTokens.pagePadding,
            right: CookTokens.pagePadding,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 图标或加载指示器
              _buildIconOrLoading(context),
              const SizedBox(height: 18),

              // 标题
              if (title != null)
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),

              if (title != null && description != null)
                const SizedBox(height: 8),

              // 描述
              if (description != null)
                Text(
                  description!,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
                  textAlign: TextAlign.center,
                ),

              const SizedBox(height: 24),

              // 按钮组
              if (onAction != null || onSecondaryAction != null)
                _buildButtonGroup(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建图标或加载指示器
  Widget _buildIconOrLoading(BuildContext context) {
    final Color accentColor = switch (type) {
      EmptyStateType.loading => Theme.of(context).colorScheme.primary,
      EmptyStateType.error => Theme.of(context).colorScheme.error,
      EmptyStateType.empty => Theme.of(context).colorScheme.primary,
    };

    return Container(
      width: 84,
      height: 84,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accentColor.withValues(alpha: 0.10),
      ),
      alignment: Alignment.center,
      child: _buildIconContent(context, accentColor),
    );
  }

  Widget _buildIconContent(BuildContext context, Color accentColor) {
    switch (type) {
      case EmptyStateType.loading:
        return SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(accentColor),
            strokeWidth: 3,
          ),
        );
      case EmptyStateType.error:
        return Icon(
          Icons.error_outline,
          size: 34,
          color: accentColor,
        );
      case EmptyStateType.empty:
        return Icon(
          icon ?? Icons.inbox_outlined,
          size: 34,
          color: accentColor,
        );
    }
  }

  /// 构建按钮组
  Widget _buildButtonGroup(BuildContext context) {
    final mainButtonText = actionButtonText ??
        (type == EmptyStateType.error ? 'retry'.tr : 'refresh'.tr);

    if (showSecondaryButton && onSecondaryAction != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildPrimaryAction(context, mainButtonText)),
          const SizedBox(width: 12),
          Expanded(
            child: CookButton.context(
              label: secondaryButtonText ?? 'cancel'.tr,
              onPressed: onSecondaryAction,
            ),
          ),
        ],
      );
    }

    return _buildPrimaryAction(context, mainButtonText);
  }

  Widget _buildPrimaryAction(BuildContext context, String mainButtonText) {
    if (actionButtonStyle != null) {
      return SizedBox(
        width: double.infinity,
        height: type == EmptyStateType.error
            ? CookTokens.dangerButtonHeight
            : CookTokens.contextButtonHeight,
        child: ElevatedButton(
          style: actionButtonStyle,
          onPressed: onAction,
          child: Text(mainButtonText),
        ),
      );
    }

    if (type == EmptyStateType.error) {
      return CookButton.danger(
        label: mainButtonText,
        onPressed: onAction,
      );
    }

    return CookButton.context(
      label: mainButtonText,
      onPressed: onAction,
    );
  }
}

/// 便捷工厂方法 - 空状态
class EmptyState {
  static Widget empty({
    String? title,
    String? description,
    IconData? icon,
    VoidCallback? onRefresh,
    String? refreshButtonText,
    bool showRefreshButton = false,
  }) {
    return EmptyStateView(
      type: EmptyStateType.empty,
      icon: icon,
      title: title ?? 'no_data'.tr,
      description: description,
      actionButtonText: showRefreshButton && onRefresh != null
          ? (refreshButtonText ?? 'refresh'.tr)
          : null,
      onAction: showRefreshButton ? onRefresh : null,
    );
  }

  static Widget loading({
    String? title,
    String? description,
  }) {
    return EmptyStateView(
      type: EmptyStateType.loading,
      title: title ?? 'loading'.tr,
      description: description,
    );
  }

  static Widget error({
    String? title,
    String? description,
    VoidCallback? onRetry,
    String? retryButtonText,
  }) {
    return EmptyStateView(
      type: EmptyStateType.error,
      title: title ?? 'load_failed'.tr,
      description: description ?? 'network_check_retry'.tr,
      actionButtonText: retryButtonText ?? 'retry'.tr,
      onAction: onRetry,
    );
  }
}
