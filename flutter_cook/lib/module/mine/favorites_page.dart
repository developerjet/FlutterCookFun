import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/base/widgets/app_refresh.dart';
import 'package:flutter_cook/base/empty_state_view.dart';
import 'package:flutter_cook/base/widgets/app_dialog.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/module/mine/controller/favorites_controller.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:get/get.dart';

import '../cook/views/cook_config_cell.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  final FavoritesController controller = Get.isRegistered<FavoritesController>()
      ? Get.find<FavoritesController>()
      : Get.put(FavoritesController());
  final Set<String> _selectedFavoriteIds = <String>{};
  Set<String> _pendingAvailableFavoriteIds = <String>{};
  bool _isManaging = false;
  bool _selectionSyncScheduled = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleManaging() {
    setState(() {
      _isManaging = !_isManaging;
      if (!_isManaging) {
        _selectedFavoriteIds.clear();
      }
    });
  }

  void _toggleSelection(String? dishesId) {
    final id = dishesId?.trim() ?? '';
    if (id.isEmpty) {
      return;
    }

    setState(() {
      if (!_selectedFavoriteIds.add(id)) {
        _selectedFavoriteIds.remove(id);
      }
    });
  }

  void _toggleSelectAll(List<String> availableIds) {
    setState(() {
      if (_selectedFavoriteIds.length == availableIds.length) {
        _selectedFavoriteIds.clear();
      } else {
        _selectedFavoriteIds
          ..clear()
          ..addAll(availableIds);
      }
    });
  }

  Future<void> _confirmDeleteSelected() async {
    final selectedIds = Set<String>.of(_selectedFavoriteIds);
    if (selectedIds.isEmpty) {
      return;
    }

    final confirmed = await AppDialog.show(
      context,
      title: 'warning_prompt'.tr,
      content:
          'delete_favorites_confirm'.trArgs([selectedIds.length.toString()]),
      confirmText: 'delete'.tr,
      cancelText: 'cancel'.tr,
      isDestructive: true,
    );
    if (confirmed != true) {
      return;
    }

    final success = await controller.removeFavorites(selectedIds);
    if (!mounted) {
      return;
    }

    if (!success) {
      ToastUtils.showShortToast('remove_favorites_failed'.tr);
      return;
    }

    setState(() {
      _selectedFavoriteIds.clear();
      if (controller.favoritesList.isEmpty) {
        _isManaging = false;
      }
    });
    ToastUtils.showShortToast(
      'delete_favorites_success'.trArgs([selectedIds.length.toString()]),
    );
  }

  void _syncSelectionWithFavorites(List<String> availableIds) {
    final availableIdSet = availableIds.toSet();
    final hasInvalidSelection =
        _selectedFavoriteIds.any((id) => !availableIdSet.contains(id));
    final shouldExitManaging = _isManaging && availableIdSet.isEmpty;
    if (!hasInvalidSelection && !shouldExitManaging) {
      return;
    }

    _pendingAvailableFavoriteIds = availableIdSet;
    if (_selectionSyncScheduled) {
      return;
    }
    _selectionSyncScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _selectionSyncScheduled = false;
      if (!mounted) {
        return;
      }
      setState(() {
        _selectedFavoriteIds
            .removeWhere((id) => !_pendingAvailableFavoriteIds.contains(id));
        if (_isManaging && _pendingAvailableFavoriteIds.isEmpty) {
          _isManaging = false;
          _selectedFavoriteIds.clear();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'favorite_title'.tr,
        actions: [
          Obx(() {
            final canManage = controller.favoritesList.isNotEmpty &&
                !controller.isLoading.value &&
                controller.errorMessage.value == null;
            if (!canManage) {
              return const SizedBox.shrink();
            }
            return TextButton(
              style: TextButton.styleFrom(
                foregroundColor:
                    Theme.of(context).appBarTheme.foregroundColor ??
                        Theme.of(context).colorScheme.onPrimary,
              ),
              onPressed: _toggleManaging,
              child: Text(_isManaging ? 'done'.tr : 'manage'.tr),
            );
          }),
        ],
      ),
      body: SafeArea(
        bottom: false,
        child: Obx(() {
          if (controller.isLoading.value) {
            return EmptyState.loading(title: 'loading'.tr);
          }

          if (controller.errorMessage.value != null) {
            return EmptyState.error(
              title: 'load_failed'.tr,
              description: controller.errorMessage.value,
              onRetry: () => controller.refreshFavorites(),
            );
          }

          // 本地快照，防止 itemCount 和 itemBuilder 之间列表被修改导致越界
          final favorites = controller.favoritesList.toList();
          final availableIds = _availableFavoriteIds(favorites);
          _syncSelectionWithFavorites(availableIds);

          if (favorites.isEmpty) {
            return EmptyState.empty(
              title: 'no_favorites'.tr,
              description: 'favorite_data_empty_desc'.tr,
              onRefresh: () => controller.refreshFavorites(),
            );
          }

          return AppRefresh(
            onRefresh: controller.refreshFavorites,
            child: ListView.builder(
              padding: EdgeInsets.fromLTRB(
                0,
                6,
                0,
                _isManaging ? 12 : 6,
              ),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final item = favorites[index];
                final dishesId = item.dishesId ?? '';
                final isSelected = _selectedFavoriteIds.contains(dishesId);
                return _FavoriteManageItem(
                  item: item,
                  isManaging: _isManaging,
                  isSelected: isSelected,
                  onTap: () {
                    if (_isManaging) {
                      _toggleSelection(dishesId);
                      return;
                    }
                    Get.toNamed(RouteNames.cookSteps, arguments: {
                      'dishes_id': item.dishesId,
                      'pushPage': 'myFavorites'
                    });
                  },
                );
              },
            ),
          );
        }),
      ),
      bottomNavigationBar: Obx(() {
        final favorites = controller.favoritesList.toList();
        final availableIds = _availableFavoriteIds(favorites);
        if (!_isManaging || availableIds.isEmpty) {
          return const SizedBox.shrink();
        }
        return _FavoriteManageBar(
          selectedCount: _selectedFavoriteIds.length,
          totalCount: availableIds.length,
          onToggleSelectAll: () => _toggleSelectAll(availableIds),
          onDelete: _selectedFavoriteIds.isEmpty
              ? null
              : () => _confirmDeleteSelected(),
        );
      }),
    );
  }

  List<String> _availableFavoriteIds(List<CookConfigListModel> favorites) {
    return favorites
        .map((item) => item.dishesId?.trim() ?? '')
        .where((id) => id.isNotEmpty)
        .toSet()
        .toList(growable: false);
  }
}

class _FavoriteManageItem extends StatelessWidget {
  final CookConfigListModel item;
  final bool isManaging;
  final bool isSelected;
  final VoidCallback onTap;

  const _FavoriteManageItem({
    required this.item,
    required this.isManaging,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: isManaging ? 'semantics_select_favorite'.tr : null,
      child: InkWell(
        borderRadius: BorderRadius.circular(CookTokens.listCardRadius),
        onTap: onTap,
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: isManaging ? 44 : 0,
              child: isManaging
                  ? Center(
                      child: _FavoriteSelectionIndicator(
                        isSelected: isSelected,
                      ),
                    )
                  : null,
            ),
            Expanded(child: CookConfigCell(model: item)),
          ],
        ),
      ),
    );
  }
}

class _FavoriteSelectionIndicator extends StatelessWidget {
  final bool isSelected;

  const _FavoriteSelectionIndicator({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      curve: Curves.easeOutCubic,
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected ? colorScheme.primary : Colors.transparent,
        border: Border.all(
          color: isSelected
              ? colorScheme.primary
              : Theme.of(context).dividerColor.withValues(alpha: 0.9),
          width: 1.5,
        ),
      ),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOutCubic,
        scale: isSelected ? 1 : 0,
        child: const Icon(
          Icons.check,
          size: 15,
          color: Colors.white,
        ),
      ),
    );
  }
}

class _FavoriteManageBar extends StatelessWidget {
  static const double _horizontalPadding = 16;
  static const double _topPadding = 10;
  static const double _bottomPadding = 10;
  static const double _buttonHeight = 40;

  final int selectedCount;
  final int totalCount;
  final VoidCallback onToggleSelectAll;
  final VoidCallback? onDelete;

  const _FavoriteManageBar({
    required this.selectedCount,
    required this.totalCount,
    required this.onToggleSelectAll,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isAllSelected = selectedCount == totalCount;
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return DecoratedBox(
      key: const ValueKey('favorite_manage_bar'),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.7),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          _horizontalPadding,
          _topPadding,
          _horizontalPadding,
          _bottomPadding + bottomInset,
        ),
        child: Row(
          children: [
            SizedBox(
              height: _buttonHeight,
              child: TextButton(
                style: TextButton.styleFrom(
                  minimumSize: const Size(0, _buttonHeight),
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                onPressed: onToggleSelectAll,
                child: Text(
                  isAllSelected ? 'deselect_all'.tr : 'select_all'.tr,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              height: _buttonHeight,
              child: ElevatedButton(
                onPressed: onDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  disabledBackgroundColor:
                      colorScheme.error.withValues(alpha: 0.28),
                  foregroundColor: colorScheme.onError,
                  disabledForegroundColor:
                      colorScheme.onError.withValues(alpha: 0.72),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      CookTokens.controlRadius,
                    ),
                  ),
                ),
                child: Text(
                  'delete_count'.trArgs([selectedCount.toString()]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
