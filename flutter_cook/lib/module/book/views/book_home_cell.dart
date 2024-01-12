import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/utils/colors.dart';
import 'package:getwidget/getwidget.dart';

class BookHomeCell extends StatelessWidget {
  final BookListModel model;
  final GestureTapCallback? onTap;

  BookHomeCell({required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Wrap(
              children: [
                Container(
                    padding: EdgeInsets.all(10.0),
                    color: CustomColors.bg2Color(),
                    child: Column(
                      children: [
                        SizedBox(height: 5.0),
                        Container(
                            height: 105,
                            child: GFImageOverlay(
                              image: NetworkImage(model.sceneBackground ?? ''),
                              boxFit: BoxFit.cover, //填充模式
                              borderRadius: BorderRadius.circular(6), //圆角
                            )),
                        SizedBox(height: 5.0),
                        Text(
                          model.sceneTitle ?? "",
                          style: TextStyle(
                              fontSize: 14.0,
                              color: CustomColors.textMainColor()),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          model.sceneDesc ?? "",
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 13.0,
                              color: CustomColors.textGrayColor()),
                        )
                      ],
                    ))
              ],
            )),
      ),
      onTap: onTap,
    );
  }
}
