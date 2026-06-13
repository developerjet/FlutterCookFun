import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:flutter_cook/module/home/model/home_list_model.dart';

class HomeDataCell extends StatelessWidget {
  final HomeFoodListData model;

  const HomeDataCell({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // 控制水平方向上的居中
        crossAxisAlignment: CrossAxisAlignment.center, // 控制垂直方向上的居中

        children: [
          const SizedBox(width: 8.0),
          GFImageOverlay(
            image: NetworkImage(model.image ?? ''),
            width: 90,
            height: 60,
            boxFit: BoxFit.cover, //填充模式
            borderRadius: BorderRadius.circular(8), //圆角
          ),
          const SizedBox(width: 15.0),
          // 右边文本
          Expanded(
              child: Text(
            model.text ?? "--",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Exo',
                ) ?? TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w900,
                  fontFamily: 'Exo',
                  color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black,
                ),
          )),
          const SizedBox(width: 15.0),
        ],
      ),
    );
  }
}
