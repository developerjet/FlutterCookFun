import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:flutter_cook/module/cook/model/cook_data_model.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
                      child: Stack(
                        children: [
                          GFImageOverlay(
                            height: 100,
                            image: NetworkImage(model.image ?? ''),
                            boxFit: BoxFit.cover, //填充模式
                            borderRadius: BorderRadius.circular(6), //圆角
                            child: Visibility(
                                visible: model.isSelected ?? false,
                                child: Image.asset('assets/images/checked.png',
                                    width: 15, height: 15)),
                          ),
                        ],
                      )),
                  SizedBox(width: 10),
                  Text(
                    model.text ?? "--",
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
