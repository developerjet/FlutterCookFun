import 'package:flutter/material.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';

/// CookFun V6 标准图标按钮。
///
/// 统一头部工具按钮的点击区域、图标尺寸、边框、阴影、禁用态和无障碍语义。
class CookIconButton extends StatelessWidget {
  final String tooltip;
  final VoidCallback? onPressed;
  final String? assetPath;
  final IconData? iconData;
  final Color? foregroundColor;

  /// 创建使用 PNG 资源的标准图标按钮。
  ///
  /// Parameters:
  /// - [tooltip]: 无障碍标签和悬停提示。
  /// - [assetPath]: PNG 资源路径。
  /// - [onPressed]: 点击回调，`null` 时进入禁用态。
  /// - [foregroundColor]: 启用态语义色，默认使用页面正文色。
  const CookIconButton.asset({
    Key? key,
    required String tooltip,
    required String assetPath,
    required VoidCallback? onPressed,
    Color? foregroundColor,
  }) : this._(
          key: key,
          tooltip: tooltip,
          onPressed: onPressed,
          assetPath: assetPath,
          foregroundColor: foregroundColor,
        );

  /// 创建使用 Flutter 图标的标准图标按钮。
  ///
  /// Parameters:
  /// - [tooltip]: 无障碍标签和悬停提示。
  /// - [iconData]: Flutter 图标数据。
  /// - [onPressed]: 点击回调，`null` 时进入禁用态。
  /// - [foregroundColor]: 启用态语义色，默认使用页面正文色。
  const CookIconButton.icon({
    Key? key,
    required String tooltip,
    required IconData iconData,
    required VoidCallback? onPressed,
    Color? foregroundColor,
  }) : this._(
          key: key,
          tooltip: tooltip,
          onPressed: onPressed,
          iconData: iconData,
          foregroundColor: foregroundColor,
        );

  const CookIconButton._({
    super.key,
    required this.tooltip,
    required this.onPressed,
    this.assetPath,
    this.iconData,
    this.foregroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onPressed != null;
    final iconColor = enabled
        ? foregroundColor ?? theme.colorScheme.onSurface
        : theme.colorScheme.onSurface.withValues(alpha: 0.36);

    return Semantics(
      label: tooltip,
      button: true,
      enabled: enabled,
      child: Tooltip(
        message: tooltip,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: CookTokens.cardShadow(theme.brightness),
          ),
          child: SizedBox(
            width: CookTokens.headerToolButtonSize,
            height: CookTokens.headerToolButtonSize,
            child: Material(
              color: theme.colorScheme.surface,
              shape: CircleBorder(
                side: BorderSide(color: theme.colorScheme.outline),
              ),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: onPressed,
                child: Center(child: _buildIcon(iconColor)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIcon(Color color) {
    final path = assetPath;
    if (path != null) {
      return Image.asset(
        path,
        width: CookTokens.headerToolIconSize,
        height: CookTokens.headerToolIconSize,
        color: color,
      );
    }
    return Icon(
      iconData,
      size: CookTokens.headerToolIconSize,
      color: color,
    );
  }
}
