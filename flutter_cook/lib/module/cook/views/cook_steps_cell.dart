import 'package:flutter/material.dart';
import 'package:flutter_cook/module/cook/model/cook_steps_model.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:getwidget/getwidget.dart';

class CookStepsCell extends StatelessWidget {
  final StepLitsModel model;

  CookStepsCell({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Wrap(
            children: [
              Column(
                children: [
                  SizedBox(width: 10.0),
                  Container(
                      padding: EdgeInsets.all(8.0),
                      height: 220,
                      child: GFImageOverlay(
                        image: NetworkImage(model.dishesStepImage ?? ''),
                        boxFit: BoxFit.cover, //填充模式
                      )),
                  SizedBox(width: 10),
                  Text(
                    model.dishesStepDesc ?? "--",
                    style: TextStyle(
                        fontSize: 14.0, color: ThemeManager.textMainColor()),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
