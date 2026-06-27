import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';

class CookConfigCell extends StatelessWidget {
  final CookConfigListModel model;

  const CookConfigCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AppNetworkImage(
            url: model.image,
            height: 115,
            width: 140,
            borderRadius: BorderRadius.circular(6),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.title ?? "",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  "${'difficulty_label'.tr}${model.hardLevel ?? ""}",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${'taste_label'.tr}${model.taste ?? ""}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  "${'cooking_time_label'.tr}${model.cookingTime ?? ""}",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 4),
                Text(
                  model.description ?? "—",
                  maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10.0),
          const Image(
            image: AssetImage('assets/images/arrow_right.png'),
            width: 20,
            height: 18,
          )
        ],
      ),
    );
  }
}
