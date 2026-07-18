import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_nav_bar.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_cook/utils/constants.dart';
import 'package:get/get.dart';

class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  MinePageState createState() => MinePageState();
}

class MinePageState extends State<MinePage> {
  static const String _version = '1.0.0';
  static const List<_MineAction> _actions = [
    _MineAction(
      id: 'favorites',
      titleKey: 'favorite_title',
      subtitleKey: 'mine_favorites_subtitle',
      icon: Icons.favorite_rounded,
      color: CookTokens.danger,
      routeName: RouteNames.favorites,
    ),
    _MineAction(
      id: 'settings',
      titleKey: 'setting_title',
      subtitleKey: 'mine_settings_subtitle',
      icon: Icons.tune_rounded,
      color: CookTokens.primary,
      routeName: RouteNames.setting,
    ),
    _MineAction(
      id: 'flutter',
      titleKey: 'flutter_web',
      subtitleKey: 'mine_flutter_subtitle',
      icon: Icons.public_rounded,
      color: CookTokens.info,
      routeName: RouteNames.web,
      webUrl: 'https://flutter.cn',
    ),
    _MineAction(
      id: 'github',
      titleKey: 'my_github',
      subtitleKey: 'mine_github_subtitle',
      icon: Icons.code_rounded,
      color: CookTokens.warm,
      routeName: RouteNames.web,
      webUrl: 'https://github.com/codertj93',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppNavBar(
        title: 'mine_kitchen_title'.tr,
        automaticallyImplyLeading: false,
        centerTitle: false,
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                CookTokens.pagePadding,
                12,
                CookTokens.pagePadding,
                0,
              ),
              sliver: SliverToBoxAdapter(child: _buildProfileCard(context)),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: CookTokens.pagePadding,
              ),
              sliver: SliverList.separated(
                itemCount: _actions.length,
                itemBuilder: (context, index) {
                  return _MineActionTile(
                    action: _actions[index],
                    onTap: () => _handleActionTap(_actions[index]),
                  );
                },
                separatorBuilder: (_, __) => const SizedBox(height: 10),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 112)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDark ? colorScheme.primaryContainer : CookTokens.primaryDeep;
    final foregroundColor =
        isDark ? colorScheme.onPrimaryContainer : Colors.white;

    return CookCard(
      padding: const EdgeInsets.all(20),
      color: backgroundColor,
      borderRadius: CookTokens.heroCardRadius,
      border: Border.all(color: foregroundColor.withValues(alpha: 0.12)),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 72,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(CookTokens.cardRadius),
            ),
            child: Image.asset(CookAssets.appLogo, width: 56, height: 56),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'app_name_title'.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: foregroundColor,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'v$_version',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: foregroundColor.withValues(alpha: 0.72),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleActionTap(_MineAction action) {
    if (action.routeName == RouteNames.web) {
      final webUrl = action.webUrl;
      if (webUrl == null || webUrl.isEmpty) return;
      Get.toNamed(action.routeName, arguments: {
        'title': action.titleKey.tr,
        'url': webUrl,
      });
      return;
    }
    Get.toNamed(action.routeName);
  }
}

class _MineAction {
  final String id;
  final String titleKey;
  final String subtitleKey;
  final IconData icon;
  final Color color;
  final String routeName;
  final String? webUrl;

  const _MineAction({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.icon,
    required this.color,
    required this.routeName,
    this.webUrl,
  });
}

class _MineActionTile extends StatelessWidget {
  final _MineAction action;
  final VoidCallback onTap;

  const _MineActionTile({
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final actionColor = switch (action.color) {
      CookTokens.danger => colorScheme.error,
      CookTokens.primary => colorScheme.primary,
      CookTokens.info => colorScheme.tertiary,
      _ => colorScheme.secondary,
    };

    return CookCard(
      key: ValueKey('mine_action_${action.id}'),
      padding: const EdgeInsets.all(14),
      borderRadius: CookTokens.listCardRadius,
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: actionColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(CookTokens.controlRadius),
            ),
            child: Icon(action.icon, color: actionColor, size: 21),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  action.titleKey.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 3),
                Text(
                  action.subtitleKey.tr,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Image.asset(
            CookAssets.iconArrowRight,
            width: 18,
            height: 18,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
