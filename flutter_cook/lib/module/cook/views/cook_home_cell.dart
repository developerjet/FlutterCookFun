import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:getwidget/getwidget.dart';

class CookHomeCell extends StatelessWidget {
  final CookListDataModel model;

  CookHomeCell({required this.model});

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
                      height: 100,
                      child: GFImageOverlay(
                        image: NetworkImage(model.image ?? ''),
                        boxFit: BoxFit.cover, //填充模式
                        borderRadius: BorderRadius.circular(6), //圆角
                      )),
                  SizedBox(width: 10),
                  Text(
                    model.text ?? "--",
                    style: TextStyle(
                        fontSize: 14.0, color: CustomColors.textMainColor()),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
