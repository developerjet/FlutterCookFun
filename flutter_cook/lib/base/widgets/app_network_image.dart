import 'package:flutter/material.dart';

/// 统一网络图片组件 — 内置 loading/error 状态、主题适配
///
/// 替代项目中的 Image.network 和 GFImageOverlay + NetworkImage，
/// 提供一致的加载中占位和加载失败兜底。
class AppNetworkImage extends StatelessWidget {
  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveUrl = url?.trim() ?? '';
    final hasImage = effectiveUrl.isNotEmpty && effectiveUrl != 'null';

    Widget imageWidget;
    if (hasImage) {
      imageWidget = Image.network(
        effectiveUrl,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return _buildPlaceholder(context, showLoading: true);
        },
        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
      );
    } else {
      imageWidget = _buildPlaceholder(context);
    }

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }
    return imageWidget;
  }

  Widget _buildPlaceholder(BuildContext context, {bool showLoading = false}) {
    return Container(
      width: width,
      height: height,
      color: Theme.of(context).cardColor,
      child: Center(
        child: showLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
              )
            : Icon(
                Icons.image_not_supported_outlined,
                size: 28,
                color: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.color
                    ?.withValues(alpha: 0.5),
              ),
      ),
    );
  }
}
