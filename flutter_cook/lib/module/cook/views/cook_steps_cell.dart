import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/base/widgets/app_network_image.dart';
import 'package:flutter_cook/design_system/cook_tokens.dart';

class CookStepsCell extends StatelessWidget {
  final StepLitsModel model;

  const CookStepsCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(CookTokens.radiusMd),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: AppNetworkImage(
                url: model.dishesStepImage,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              model.dishesStepDesc ?? '—',
              style:
                  Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
