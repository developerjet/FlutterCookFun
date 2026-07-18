import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/design_system/cook_assets.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';

class CookStepsHeader extends StatelessWidget {
  final CookStepDataModel model;
  final GestureTapCallback? onTap;

  const CookStepsHeader({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppNetworkImage(
                url: model.image,
                height: 220,
              ),
              Center(
                child: IconButton(
                  icon: Image.asset(CookAssets.iconVideoPlay,
                      width: 80, height: 80),
                  onPressed: onTap,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
          child: Text(
            model.dashesName ?? '',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 6, 15, 0),
          child: Text(
            model.materialDesc ?? '',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _buildTag(context,
                  '${'cooking_time_label'.tr}${model.cookeTime ?? ""}'),
              _buildTag(
                  context, '${'difficulty_label'.tr}${model.hardLevel ?? ""}'),
              _buildTag(context, '${'taste_label'.tr}${model.taste ?? ""}'),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 14, 15, 12),
          child: Text(
            'chef_recommendation'.tr,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
      ],
    );
  }

  Widget _buildTag(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(CookTokens.pillRadius),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
