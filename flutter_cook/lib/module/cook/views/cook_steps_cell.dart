import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:getwidget/getwidget.dart';

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
          // 步骤图片 — 全宽无内边距
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 220,
              width: double.infinity,
              child: GFImageOverlay(
                image: NetworkImage(model.dishesStepImage ?? ''),
                boxFit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 10),
          // 步骤描述
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              model.dishesStepDesc ?? '--',
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
