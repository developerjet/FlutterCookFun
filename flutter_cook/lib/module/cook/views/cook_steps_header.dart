import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/utils/toast.dart';
import 'package:getwidget/getwidget.dart';

class CookStepsHeader extends StatelessWidget {
  final CookStepDataModel model;
  final GestureTapCallback? onTap;

  CookStepsHeader({required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(children: [
          Container(
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
          SizedBox(height: 6.0),
          Text(
            model.dashesName ?? "",
            style:
                TextStyle(fontSize: 17.0, color: ThemeManager.textMainColor()),
          ),
          SizedBox(height: 6.0),
          Text(
            model.materialDesc ?? "",
            maxLines: 3,
            style:
                TextStyle(fontSize: 14.0, color: ThemeManager.textMainColor()),
          ),
          SizedBox(height: 6.0),
          Expanded(
              child: Row(
            children: [
              Text(
                "烹饪时间：${model.cookeTime ?? ""}",
                style: TextStyle(
                    fontSize: 14.0, color: ThemeManager.textMainColor()),
              ),
              SizedBox(width: 20),
              Text(
                "难度：${model.hardLevel ?? ""}",
                style: TextStyle(
                    fontSize: 14.0, color: ThemeManager.textMainColor()),
              ),
              SizedBox(width: 20),
              Text(
                "口味：${model.taste ?? ""}",
                style: TextStyle(
                    fontSize: 14.0, color: ThemeManager.textMainColor()),
              ),
            ],
          )),
          SizedBox(height: 20.0),
          Text(
            "大厨推荐做法",
            style:
                TextStyle(fontSize: 20.0, color: ThemeManager.redMainColor()),
          ),
        ]));
  }
}
