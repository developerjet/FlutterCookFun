import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:getwidget/getwidget.dart';

class CookStepsHeader extends StatelessWidget {
  final CookStepDataModel model;
  final GestureTapCallback? onTap;

  const CookStepsHeader({super.key, required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 主图 + 播放按钮
        SizedBox(
          height: 220,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GFImageOverlay(
                height: 220,
                image: NetworkImage(model.image ?? ''),
                boxFit: BoxFit.cover,
              ),
              Center(
                child: IconButton(
                  icon: Image.asset('assets/images/video_play.png',
                      width: 80, height: 80),
                  onPressed: onTap,
                ),
              ),
            ],
          ),
        ),
        // 菜名 + 食材描述
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 12, 15, 0),
          child: Text(
            model.dashesName ?? '',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 6, 15, 0),
          child: Text(
            model.materialDesc ?? '',
            maxLines: 3,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium?.color,
            ),
          ),
        ),
        // 烹饪时间 / 难度 / 口味
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
          child: Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _buildTag(
                  context, '${'cooking_time_label'.tr}${model.cookeTime ?? ""}'),
              _buildTag(
                  context, '${'difficulty_label'.tr}${model.hardLevel ?? ""}'),
              _buildTag(
                  context, '${'taste_label'.tr}${model.taste ?? ""}'),
            ],
          ),
        ),
        // 大厨推荐
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 14, 15, 12),
          child: Text(
            'chef_recommendation'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.error,
            ),
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
        borderRadius: BorderRadius.circular(12),
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
