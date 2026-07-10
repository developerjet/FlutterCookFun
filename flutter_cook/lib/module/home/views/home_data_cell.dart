import 'package:flutter/material.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';

class HomeDataCell extends StatelessWidget {
  final HomeFoodListData model;

  const HomeDataCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.45),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              AppNetworkImage(
                url: model.image,
                width: 96,
                height: 64,
                borderRadius: BorderRadius.circular(8),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  model.text ?? '—',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
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
      ),
    );
  }
}
