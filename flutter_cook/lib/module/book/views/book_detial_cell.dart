import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_detail_model.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:getwidget/getwidget.dart';

class BookDetialCell extends StatelessWidget {
  final BookDishesListModel model;

  BookDetialCell({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            GFImageOverlay(
              width: 120,
              height: 90,
              image: NetworkImage(model.image ?? ''),
              boxFit: BoxFit.cover, //填充模式
              borderRadius: BorderRadius.circular(6), //圆角
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
                child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.dishesName ?? "",
                    maxLines: 1,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 15, color: ThemeManager.textMainColor())),
                SizedBox(height: 6.0),
                Text(model.dishesDesc ?? "",
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 13, color: ThemeManager.textGrayColor())),
              ],
            ))),
            SizedBox(width: 8.0),
            Image(
              image: AssetImage('assets/images/play_count.png'),
              width: 20,
              height: 20,
            ),
          ],
        ));
  }
}
