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
    return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(children: [
          SizedBox(
              height: 220,
              child: Stack(
                children: [
                  GFImageOverlay(
                    height: 220,
                    image: NetworkImage(model.image ?? ''),
                    boxFit: BoxFit.cover, //填充模式
                  ),
                  Center(
                      child: IconButton(
                          icon: Image.asset('assets/images/video_play.png',
                              width: 80, height: 80),
                          onPressed: onTap))
                ],
              )),
          const SizedBox(height: 6.0),
          Text(
            model.dashesName ?? "",
            style:
                TextStyle(fontSize: 17.0, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          const SizedBox(height: 6.0),
          Text(
            model.materialDesc ?? "",
            maxLines: 3,
            style:
                TextStyle(fontSize: 14.0, color: Theme.of(context).textTheme.bodyLarge?.color),
          ),
          const SizedBox(height: 6.0),
          Expanded(
              child: Row(
            children: [
              Text(
                '${'cooking_time_label'.tr}${model.cookeTime ?? ""}',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(width: 20),
              Text(
                '${'difficulty_label'.tr}${model.hardLevel ?? ""}',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
              const SizedBox(width: 20),
              Text(
                '${'taste_label'.tr}${model.taste ?? ""}',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ],
          )),
          const SizedBox(height: 20.0),
          Text(
            'chef_recommendation'.tr,
            style:
                TextStyle(fontSize: 20.0, color: Theme.of(context).colorScheme.error),
          ),
        ]));
  }
}
