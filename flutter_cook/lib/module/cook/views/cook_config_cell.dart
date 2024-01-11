import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:flutter_cook/module/cook/model/cook_config_model.dart';
import 'package:getwidget/getwidget.dart';

class CookConfigCell extends StatelessWidget {
  final CookConfigListModel model;

  CookConfigCell({required this.model});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    final double leftWidth = 140;
    final double rightWidth = 30;
    final double centerWidth = (width - 8.0 * 2) - leftWidth - rightWidth;

    return Container(
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(8.0),
                      width: leftWidth,
                      height: 140,
                      child: GFImageOverlay(
                        image: NetworkImage(model.image ?? ''),
                        boxFit: BoxFit.cover, //填充模式
                        borderRadius: BorderRadius.circular(6), //圆角
                      )),
                  Container(
                    width: centerWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.title ?? "--",
                          style: TextStyle(
                              fontSize: 17.0,
                              color: CustomColors.textMainColor()),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "难度：${model.hardLevel ?? "--"}",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: CustomColors.redMainColor()),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "口味：${model.taste ?? "--"}",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: CustomColors.textMainColor()),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "烹饪时间：${model.cookingTime ?? "--"}",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: CustomColors.textMainColor()),
                        ),
                        SizedBox(height: 4),
                        Text(
                          model.description ?? "--",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: CustomColors.textMainColor()),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: rightWidth,
                    child: Image(
                      image: AssetImage('assets/images/arrow_right.png'),
                      width: 20,
                      height: 18,
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }
}
