import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:getwidget/getwidget.dart';

class CookConfigCell extends StatelessWidget {
  final CookConfigListModel model;

  CookConfigCell({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(10.0),
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
              SizedBox(width: 10.0),
              // 中间文字
              Expanded( //羊肉
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        model.title ?? "",
                        style: TextStyle(
                            fontSize: 17.0,
                            color: ThemeManager.textMainColor()),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "难度：${model.hardLevel ?? ""}",
                        style: TextStyle(
                            fontSize: 14.0, color: ThemeManager.redMainColor()),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "口味：${model.taste ?? ""}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: ThemeManager.textMainColor()),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "烹饪时间：${model.cookingTime ?? ""}",
                        style: TextStyle(
                            fontSize: 14.0,
                            color: ThemeManager.textMainColor()),
                      ),
                      SizedBox(height: 4),
                      Text(
                        model.description ?? "--",
                        maxLines: 1,
                        style: TextStyle(
                            fontSize: 14.0,
                            color: ThemeManager.textMainColor()),
                      ),
                    ],
                  ),
                ),
              ),
              // 右边箭头
              SizedBox(width: 10.0),
              Image(
                image: AssetImage('assets/images/arrow_right.png'),
                width: 20,
                height: 18,
              )
            ],
          )),
    );
  }
}
