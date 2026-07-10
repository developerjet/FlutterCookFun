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
  final IconData fallbackIcon;

  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.fallbackIcon = Icons.image_not_supported_outlined,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final effectiveUrl = url?.trim() ?? '';
        final hasImage = effectiveUrl.isNotEmpty && effectiveUrl != 'null';
        final devicePixelRatio = MediaQuery.devicePixelRatioOf(context);
        final decodeWidth = _resolveLogicalSize(width, constraints.maxWidth);
        final decodeHeight = _resolveLogicalSize(height, constraints.maxHeight);
        final decodeHint = _resolveDecodeHint(
          decodeWidth,
          decodeHeight,
          devicePixelRatio,
        );

        Widget imageWidget;
        if (hasImage) {
          imageWidget = Image.network(
            effectiveUrl,
            fit: fit,
            width: width,
            height: height,
            cacheWidth: decodeHint.width,
            cacheHeight: decodeHint.height,
            gaplessPlayback: true,
            filterQuality: FilterQuality.low,
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
      },
    );
  }

  double? _resolveLogicalSize(double? explicitSize, double constrainedSize) {
    if (explicitSize != null) {
      return explicitSize;
    }
    if (constrainedSize.isFinite && constrainedSize > 0) {
      return constrainedSize;
    }
    return null;
  }

  _DecodeHint _resolveDecodeHint(
    double? logicalWidth,
    double? logicalHeight,
    double devicePixelRatio,
  ) {
    final width = _resolveDecodeSize(logicalWidth, devicePixelRatio);
    final height = _resolveDecodeSize(logicalHeight, devicePixelRatio);

    // 只传单轴解码提示，避免部分图片在预解码阶段被压成目标矩形比例。
    if (width != null) {
      return _DecodeHint(width: width);
    }
    return _DecodeHint(height: height);
  }

  int? _resolveDecodeSize(double? logicalSize, double devicePixelRatio) {
    if (logicalSize == null || !logicalSize.isFinite || logicalSize <= 0) {
      return null;
    }

    return (logicalSize * devicePixelRatio).ceil();
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
                fallbackIcon,
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

class _DecodeHint {
  final int? width;
  final int? height;

  const _DecodeHint({this.width, this.height});
}
