import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';

class HomeDataCell extends StatelessWidget {
  final HomeFoodListData model;
  final GestureTapCallback? onTap;

  const HomeDataCell({
    super.key,
    required this.model,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CookTokens.pagePadding,
        vertical: 6,
      ),
      child: CookCard(
        onTap: onTap,
        padding: const EdgeInsets.all(12),
        borderRadius: CookTokens.listCardRadius,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AppNetworkImage(
              url: model.image,
              width: 96,
              height: 68,
              borderRadius: BorderRadius.circular(CookTokens.radiusMd),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                model.text ?? '—',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.color
                  ?.withValues(alpha: 0.55),
            ),
          ],
        ),
      ),
    );
  }
}
