import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:getwidget/getwidget.dart';

class BookDetialCell extends StatelessWidget {
  final BookDishesListModel model;

  BookDetialCell({required this.model});

  @override
  Widget build(BuildContext context) {
    final double padding = 10.0;
    final double width = MediaQuery.of(context).size.width;

    final double leftWidth = 100;
    final double rightWidth = 30;
    final double centerWidth = width - leftWidth - rightWidth - padding * 5;

    return Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start, // 控制水平方向上的居中
              crossAxisAlignment: CrossAxisAlignment.center, // 控制垂直方向上的居中
              children: [
                Container(
                    width: leftWidth,
                    height: 90,
                    child: GFImageOverlay(
                      image: NetworkImage(model.image ?? ''),
                      boxFit: BoxFit.cover, //填充模式
                      borderRadius: BorderRadius.circular(6), //圆角
                    )),
                SizedBox(width: padding),
                Container(
                    width: centerWidth,
                    child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,
                      children: [
                        Text(model.dishesName ?? "",
                            maxLines: 1,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 15,
                                color: CustomColors.textMainColor())),
                        SizedBox(height: padding),
                        Text(model.dishesDesc ?? "",
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 13,
                                color: CustomColors.textGrayColor())),
                      ],
                    )),
                SizedBox(width: padding),
                Container(
                  width: rightWidth,
                  child: Image(
                    image: AssetImage('assets/images/play_count.png'),
                    width: 20,
                    height: 18,
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
