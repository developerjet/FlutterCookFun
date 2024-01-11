import 'package:flutter/material.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_cook/module/home/model/home_model.dart';

class HomeDataCell extends StatelessWidget {
  final HomeFoodListData model;

  HomeDataCell({required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // 控制水平方向上的居中
        crossAxisAlignment: CrossAxisAlignment.center, // 控制垂直方向上的居中

        children: [
          SizedBox(width: 5),
          GFImageOverlay(
            image: NetworkImage(model.image ?? ''),
            width: 80,
            height: 60,
            boxFit: BoxFit.fill, //填充模式
            borderRadius: BorderRadius.circular(8), //圆角
          ),
          SizedBox(width: 15),
          // 右边文本
          Container(
            padding: EdgeInsets.all(8.0),
            child: Text(
              model.text ?? "--",
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ],
      ),
    );
  }
}
