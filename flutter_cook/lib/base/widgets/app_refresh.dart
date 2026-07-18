import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

/// 应用统一的下拉刷新与上拉加载容器。
class AppRefresh extends StatelessWidget {
  final Widget child;
  final EasyRefreshController? controller;
  final FutureOr<void> Function()? onRefresh;
  final FutureOr<void> Function()? onLoad;

  /// 创建统一刷新容器。
  ///
  /// 参数：
  /// - [child]: 可滚动内容。
  /// - [controller]: 可选的刷新控制器。
  /// - [onRefresh]: 下拉刷新任务，为空时禁用下拉刷新。
  /// - [onLoad]: 上拉加载任务，为空时禁用上拉加载。
  const AppRefresh({
    super.key,
    required this.child,
    this.controller,
    this.onRefresh,
    this.onLoad,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return EasyRefresh(
      key: const ValueKey('app_refresh'),
      controller: controller,
      header: onRefresh == null
          ? null
          : MaterialHeader(
              triggerOffset: 72,
              clamping: false,
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
            ),
      footer: onLoad == null
          ? null
          : MaterialFooter(
              triggerOffset: 72,
              clamping: false,
              color: colorScheme.primary,
              backgroundColor: colorScheme.surface,
            ),
      onRefresh: onRefresh,
      onLoad: onLoad,
      child: child,
    );
  }
}
