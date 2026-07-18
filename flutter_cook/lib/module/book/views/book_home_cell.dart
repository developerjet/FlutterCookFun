import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';
import 'package:flutter_cook/design_system/widgets/cook_card.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:get/get.dart';

class BookHomeCell extends StatelessWidget {
  final BookListModel model;
  final GestureTapCallback? onTap;

  const BookHomeCell({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = _displayTitle();
    final colorScheme = Theme.of(context).colorScheme;

    return CookCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      borderRadius: CookTokens.listCardRadius,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                AppNetworkImage(
                  url: model.sceneBackground ?? model.thumbnail,
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.44),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 8),
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(
                      CookTokens.controlRadius,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Text(
                      'book_enter_topic'.tr,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: colorScheme.onPrimaryContainer,
                          ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _displayTitle() {
    final candidates = [
      model.dishesName,
      model.sceneTitle,
      'book_scene_fallback'.tr,
    ];

    return candidates
        .map((value) => value?.trim() ?? '')
        .firstWhere((value) => value.isNotEmpty);
  }
}
