import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:getwidget/getwidget.dart';

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
              // 图片
              GFImageOverlay(
                height: 115,
                width: 140,
                image: NetworkImage(model.image ?? ''),
                boxFit: BoxFit.cover, //填充模式
                borderRadius: BorderRadius.circular(6), //圆角
              ),
              const SizedBox(width: 10.0),
              // 中间文字
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                      Text(
                        model.title ?? "",
                        style: TextStyle(
                            fontSize: 17.0,
                            color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${'difficulty_label'.tr}${model.hardLevel ?? ""}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).colorScheme.error),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${'taste_label'.tr}${model.taste ?? ""}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${'cooking_time_label'.tr}${model.cookingTime ?? ""}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        model.description ?? "--",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: Theme.of(context).textTheme.bodyLarge?.color),
                      ),
                    ],
                  ),
                ),
              // 右边箭头
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
