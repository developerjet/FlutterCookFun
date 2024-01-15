import 'package:flutter/material.dart';
import 'package:flutter_cook/module/book/model/book_home_model.dart';
import 'package:flutter_cook/utils/theme.dart';
import 'package:getwidget/getwidget.dart';

class BookHomeCell extends StatelessWidget {
  final BookListModel model;
  final GestureTapCallback? onTap;

  BookHomeCell({required this.model, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
          // color: Colors.red,
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6.0),
                color: ThemeManager.bg2Color(), // 设置容器背景色
              ),
              child: Column(
                children: [
                  Container(
                      padding: EdgeInsets.all(8.0),
                      height: 110,
                      child: GFImageOverlay(
                        image: NetworkImage(model.sceneBackground ?? ''),
                        boxFit: BoxFit.cover, //填充模式
                      )),
                  SizedBox(height: 5.0),
                  Text(
                    maxLines: 1,
                    model.sceneTitle ?? "",
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Exo",
                        color: ThemeManager.textMainColor()),
                  ),
                  SizedBox(height: 5.0),
                  Text(
                    maxLines: 1,
                    model.sceneDesc ?? "",
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Exo",
                        color: ThemeManager.textGrayColor()),
                  )
                ],
              ))),
      onTap: onTap,
    );
  }
}
